output "open_shift_api_lb_address" {
  value = oci_load_balancer_load_balancer.openshift_api_lb.ip_address_details[0].ip_address
}

output "open_shift_apps_lb_address" {
  value = oci_load_balancer_load_balancer.openshift_apps_lb.ip_address_details[0].ip_address
}

output "api_lb_id" {
  value = oci_load_balancer_load_balancer.openshift_api_lb.id
}

output "apps_lb_id" {
  value = oci_load_balancer_load_balancer.openshift_apps_lb.id
}

output "api_backend_name" {
  value = oci_load_balancer_backend_set.api_backend.name
}

output "api_mcs_ignition_backend_name" {
  value = oci_load_balancer_backend_set.api_mcs_ignition_backend.name
}

output "api_mcs_update_backend" {
  value = oci_load_balancer_backend_set.api_mcs_update_backend.name
}

output "ingress_https_backend_name" {
  value = oci_load_balancer_backend_set.ingress_https_backend.name
}

output "ingress_http_backend_name" {
  value = oci_load_balancer_backend_set.ingress_http_backend.name
}