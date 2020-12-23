data "nsxt_transport_zone" "transport-zone" {
  display_name = var.nsxt_transport_zone
}

data "nsxt_logical_tier0_router" "rtr0" {
  display_name = var.nsxt_t0_router
}

data "nsxt_edge_cluster" "edge-cluster" {
  display_name = var.nsxt_edge_cluster
}
