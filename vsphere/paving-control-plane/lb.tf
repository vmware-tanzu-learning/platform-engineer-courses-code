resource "nsxt_lb_service" "control_plane_lb_service" {
  description  = "control plane lb_service"
  display_name = "control_plane_lb_service"

  enabled           = true
  logical_router_id = nsxt_logical_tier1_router.T1-Router-control-plane.id
  virtual_server_ids = [nsxt_lb_tcp_virtual_server.concourse_lb_virtual_server.id,nsxt_lb_tcp_virtual_server.minio_lb_virtual_server.id]
  error_log_level   = "INFO"
  size              = "SMALL"

  depends_on        = [nsxt_logical_router_link_port_on_tier1.control-plane-t1-to-t0]
}
