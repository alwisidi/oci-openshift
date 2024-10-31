# Terraform Deployed Resources for OpenShift on OCI

This fork of the official Oracle Terraform OpenShift repository has been restructured and enhanced to provide a more complete OpenShift cluster setup, including support for OpenShift Data Foundation (ODF), with production-grade readiness.

Licensing: This project is released under the GNU General Public License (GPL), ensuring that modifications and enhancements are available to the community under the same terms.

---

This Terraform code is specifically designed for the OpenShift on Oracle Cloud Infrastructure (OCI). It provisions resources for an OpenShift cluster running on Oracle Cloud Infrastructure.

See the following for installation instructions:

**Redhat OpenShift latest version on Oracle Cloud Infrastructure (OCI)**
- OCI documentation - https://docs.oracle.com/en-us/iaas/Content/openshift-on-oci/overview.htm
- Connected deployments using Assisted Installer: https://docs.openshift.com/container-platform/latest/installing/installing_oci/installing-oci-assisted-installer.html
- Disconnected or air gapped deployments using Agent-based Installer: https://docs.openshift.com/container-platform/latest/installing/installing_oci/installing-oci-agent-based-installer.html

## Resources Created:

- **Tag Namespace and Tags**:
    - Namespace: "openshift"
    - Tag values: "control-plane" and "compute"
- **Image Capabilities**:
    - Global Image Capability Schemas
    - Image Capability Schema for Openshift
    - Openshift Image Configuration
- **Shape Management**: Compute shapes for the Openshift image.
- **Network Configuration**:
    - Subnets:
        - Private Subnet
- **Network Security Groups (NSGs) and Rules**:
    - NSGs:
        - Load balancers NSG
        - Cluster control plane NSG
        - Infra nodes NSG
        - Storage nodes NSG
        - Compute nodes NSG
- **Application Load Balancers**:
    - API
        - serves "api" and "api-int"
    - Apps
        - serves "*.apps"
- **OCI Identity Resources**:
    - Dynamic groups
    - Policies
- **DNS Resources**:
    - oci_dns_rrset (Three entries)
        - api
        - api-int
        - *.apps
- **Compute Configurations**:
    - Control Plane Instance Configuration
    - Infra Instance Configuration
    - Storage Instance Configuration
    - Compute Instance Configuration
- **Compute Pools**:
    - Control Plane nodes
    - Infra nodes
    - Storage nodes
    - Compute nodes
