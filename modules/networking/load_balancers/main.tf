resource "oci_load_balancer_load_balancer" "openshift_api_lb" {
  compartment_id             = var.compartment_ocid
  display_name               = "${var.cluster_name}-openshift_api_lb"
  shape                      = "flexible"
  subnet_ids                 = [var.private_subnet_id]
  is_private                 = true
  network_security_group_ids = [var.nsg_ids["cluster_lb_nsg"]]

  shape_details {
    maximum_bandwidth_in_mbps = var.load_balancer_shape_details_maximum_bandwidth_in_mbps
    minimum_bandwidth_in_mbps = var.load_balancer_shape_details_minimum_bandwidth_in_mbps
  }
}

resource "oci_load_balancer_load_balancer" "openshift_apps_lb" {
  compartment_id             = var.compartment_ocid
  display_name               = "${var.cluster_name}-openshift_apps_lb"
  shape                      = "flexible"
  subnet_ids                 = [var.private_subnet_id]
  is_private                 = true
  network_security_group_ids = [var.nsg_ids["cluster_lb_nsg"]]

  shape_details {
    maximum_bandwidth_in_mbps = var.load_balancer_shape_details_maximum_bandwidth_in_mbps
    minimum_bandwidth_in_mbps = var.load_balancer_shape_details_minimum_bandwidth_in_mbps
  }
}

resource "oci_load_balancer_backend_set" "api_backend" {
  health_checker {
    protocol          = "HTTP"
    port              = 6080
    return_code       = 200
    url_path          = "/readyz"
    interval_ms       = 10000
    timeout_in_millis = 3000
    retries           = 3
  }
  name             = "api_backend"
  load_balancer_id = oci_load_balancer_load_balancer.openshift_api_lb.id
  policy           = "LEAST_CONNECTIONS"
}

resource "oci_load_balancer_listener" "api_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.api_backend.name
  name                     = "api_listener"
  load_balancer_id         = oci_load_balancer_load_balancer.openshift_api_lb.id
  port                     = 6443
  protocol                 = "TCP"
}

resource "oci_load_balancer_backend_set" "api_mcs_ignition_backend" {
  health_checker {
    protocol          = "HTTP"
    port              = 22624
    return_code       = 200
    url_path          = "/healthz"
    interval_ms       = 10000
    timeout_in_millis = 3000
    retries           = 3
  }
  name             = "api_mcs_ignition_backend"
  load_balancer_id = oci_load_balancer_load_balancer.openshift_api_lb.id
  policy           = "LEAST_CONNECTIONS"
}

resource "oci_load_balancer_listener" "api_mcs_ignition_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.api_mcs_ignition_backend.name
  name                     = "api_mcs_ignition_listener"
  load_balancer_id         = oci_load_balancer_load_balancer.openshift_api_lb.id
  port                     = 22623
  protocol                 = "TCP"
}

resource "oci_load_balancer_backend_set" "api_mcs_update_backend" {
  health_checker {
    protocol          = "HTTP"
    port              = 22624
    return_code       = 200
    url_path          = "/healthz"
    interval_ms       = 10000
    timeout_in_millis = 3000
    retries           = 3
  }
  name             = "api_mcs_update_backend"
  load_balancer_id = oci_load_balancer_load_balancer.openshift_api_lb.id
  policy           = "LEAST_CONNECTIONS"
}

resource "oci_load_balancer_listener" "api_mcs_update_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.api_mcs_update_backend.name
  name                     = "api_mcs_update_listener"
  load_balancer_id         = oci_load_balancer_load_balancer.openshift_api_lb.id
  port                     = 22624
  protocol                 = "TCP"
}

resource "oci_load_balancer_backend_set" "ingress_http_backend" {
  health_checker {
    protocol          = "TCP"
    port              = 80
    interval_ms       = 10000
    timeout_in_millis = 3000
    retries           = 3
  }
  name             = "ingress_http_backend"
  load_balancer_id = oci_load_balancer_load_balancer.openshift_apps_lb.id
  policy           = "LEAST_CONNECTIONS"
}

resource "oci_load_balancer_listener" "ingress_http_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.ingress_http_backend.name
  name                     = "ingress_http_listener"
  load_balancer_id         = oci_load_balancer_load_balancer.openshift_apps_lb.id
  port                     = 80
  protocol                 = "TCP"
}

resource "oci_load_balancer_backend_set" "ingress_https_backend" {
  health_checker {
    protocol          = "TCP"
    port              = 443
    interval_ms       = 10000
    timeout_in_millis = 3000
    retries           = 3
  }
  name             = "ingress_https_backend"
  load_balancer_id = oci_load_balancer_load_balancer.openshift_apps_lb.id
  policy           = "LEAST_CONNECTIONS"
}

resource "oci_load_balancer_listener" "ingress_https_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.ingress_https_backend.name
  name                     = "ingress_https_listener"
  load_balancer_id         = oci_load_balancer_load_balancer.openshift_apps_lb.id
  port                     = 443
  protocol                 = "TCP"
}