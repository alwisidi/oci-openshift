import ipaddress
import sys
import subprocess
import json

def get_all_compartments(tenancy_id):
    result = subprocess.run([
        "oci", "iam", "compartment", "list",
        "--compartment-id", tenancy_id,
        "--compartment-id-in-subtree", "true",
        "--all"
    ], capture_output=True, text=True)
    compartments = json.loads(result.stdout)
    compartment_ids = [compartment['id'] for compartment in compartments['data']]
    return compartment_ids

def get_existing_subnets(vcn_id, tenancy_id):
    compartment_ids = get_all_compartments(tenancy_id)
    all_subnets = []
    for compartment_id in compartment_ids:
        result = subprocess.run([
            "oci", "network", "subnet", "list",
            "--vcn-id", vcn_id,
            "--compartment-id", compartment_id,
            "--all"
        ], capture_output=True, text=True)
        if result.stdout.strip() == "":
            continue
        try:
            subnets = json.loads(result.stdout)
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON for compartment {compartment_id}: {e}")
            continue
        existing_cidrs = [subnet['cidr-block'] for subnet in subnets['data']]
        all_subnets.extend(existing_cidrs)
    return all_subnets

def find_available_cidrs(vcn_cidr, existing_cidrs, new_prefix, num_subnets=2):
    vcn = ipaddress.IPv4Network(vcn_cidr)
    if new_prefix < vcn.prefixlen:
        raise ValueError(f"New prefix length {new_prefix} is shorter than the VCN prefix length {vcn.prefixlen}")
    existing_networks = [ipaddress.IPv4Network(cidr) for cidr in existing_cidrs]
    available_subnets = []
    for subnet in vcn.subnets(new_prefix=new_prefix):
        subnet_id = subnet.network_address.packed[-2]
        if subnet_id == 0 or subnet_id == 255:
            continue
        if not any(subnet.overlaps(existing) for existing in existing_networks):
            available_subnets.append(str(subnet))
            if len(available_subnets) == num_subnets:
                return available_subnets
    raise Exception("No available subnets found")

if __name__ == "__main__":
    vcn_cidr = sys.argv[1]
    vcn_id = sys.argv[2]
    tenancy_id = sys.argv[3]
    existing_cidrs = get_existing_subnets(vcn_id, tenancy_id)
    available_subnets = find_available_cidrs(vcn_cidr, existing_cidrs, new_prefix=24, num_subnets=2)
    result = {
        "private_cidr": available_subnets[0],
        "public_cidr": available_subnets[1]
    }
    print(json.dumps(result))
