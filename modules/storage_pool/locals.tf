locals {
  raw_instance_data = split(" - ", data.external.get_instance_ids.result.instance_data)

  instance_data = [
    for instance in local.raw_instance_data : {
      instance_name = replace(element(split(",", instance), 1), "instance_name:", "")
      id            = replace(element(split(",", instance), 0), "id:", "")
    }
  ]
}
