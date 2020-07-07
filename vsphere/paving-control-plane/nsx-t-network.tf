#### T0 destination network address translation rule to facilitate communication between Ops Manager
resource "nsxt_nat_rule" "control-plane-dnat-om" {
  display_name = "control-plane-dnat-om"
  action       = "DNAT"

  logical_router_id = "${data.nsxt_logical_tier0_router.rtr0.id}"
  description       = "DNAT Rule for Control Plane Ops Manager"
  enabled           = true
  logging           = false
  nat_pass          = true

  match_destination_network = "${var.cp_om_ipv4_address}"
  translated_network        = "${var.cp_om_internal_ipv4_address}"
}

### T0 source network address translation rule to facilitate communication to Ops Manager.
resource "nsxt_nat_rule" "control-plane-snat" {
  display_name = "control-plane-snat"
  action       = "SNAT"

  logical_router_id = "${data.nsxt_logical_tier0_router.rtr0.id}"
  description       = "SNAT Rule for Control Plane network"
  enabled           = true
  logging           = false
  nat_pass          = true

  match_source_network = "${var.control_plane_cidr}"
  translated_network   = "${var.control_plane_snat_ip}"
}

resource "nsxt_logical_switch" "control-plane" {
  display_name = "control-plane"

  transport_zone_id = "${data.nsxt_transport_zone.transport-zone.id}"
  admin_state       = "UP"

  description      = "Control Plane Logical Switch provisioned by Terraform"
  replication_mode = "MTEP"
}

#### The logical port for the control plane network.
resource "nsxt_logical_port" "control-plane-port" {
  display_name = "control-plane-port"

  admin_state       = "UP"
  description       = "Control Plane Logical Port provisioned by Terraform"
  logical_switch_id = "${nsxt_logical_switch.control-plane.id}"
}

#### The downlink port connecting the control plane logical port to the tier1 router.
resource "nsxt_logical_router_downlink_port" "control-plane-dp" {
  display_name = "control-plane-dp"

  description                   = "Control Plane downlink port provisioned by Terraform"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-Router-control-plane.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.control-plane-port.id}"
  ip_address                    = "${var.control_plane_gateway}"
}

resource "nsxt_logical_tier1_router" "T1-Router-control-plane" {
  display_name = "control-plane-t1"

  description     = "Control Plane Tier 1 Router provisioned by Terraform"
  failover_mode   = "PREEMPTIVE"
  edge_cluster_id = "${data.nsxt_edge_cluster.edge-cluster.id}"

  enable_router_advertisement = true
  advertise_connected_routes  = true
  advertise_lb_vip_routes     = true
  advertise_lb_snat_ip_routes = true
}

resource "nsxt_logical_router_link_port_on_tier0" "t0-to-control-plane-t1" {
  display_name = "t0-to-control-plane-t1"

  description       = "Link Port on Logical Tier 0 Router connecting to Control Plane Tier 1 Router. Provisioned by Terraform."
  logical_router_id = "${data.nsxt_logical_tier0_router.rtr0.id}"
}

resource "nsxt_logical_router_link_port_on_tier1" "control-plane-t1-to-t0" {
  display_name = "control-plane-t1-to-t0"

  description                   = "Link Port on Control Plane 1 Router connecting to Logical Tier 0 Router. Provisioned by Terraform."
  logical_router_id             = "${nsxt_logical_tier1_router.T1-Router-control-plane.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.t0-to-control-plane-t1.id}"
}
