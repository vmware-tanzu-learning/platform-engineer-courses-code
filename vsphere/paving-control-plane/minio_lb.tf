resource "nsxt_ns_group" "minio_ns_group" {
  display_name = "minio_ns_group"
}

resource "nsxt_lb_tcp_monitor" "minio_lb_tcp_monitor" {
  display_name = "minio_lb_tcp_monitor"
  interval     = 5
  monitor_port  = 9000
  rise_count    = 3
  fall_count    = 3
  timeout      = 15
}

resource "nsxt_lb_pool" "minio_lb_pool" {
  description              = "minio_lb_pool provisioned by Terraform"
  display_name             = "minio_lb_pool"
  algorithm                = "WEIGHTED_ROUND_ROBIN"
  min_active_members       = 1
  tcp_multiplexing_enabled = false
  tcp_multiplexing_number  = 3
  active_monitor_id        = "${nsxt_lb_tcp_monitor.minio_lb_tcp_monitor.id}"
  snat_translation {
    type          = "SNAT_AUTO_MAP"
  }
  member_group {
    grouping_object {
      target_type = "NSGroup"
      target_id   = "${nsxt_ns_group.minio_ns_group.id}"
    }
  }
}

resource "nsxt_lb_fast_tcp_application_profile" "minio_fast_tcp_profile" {
  display_name = "minio_fast_tcp_profile"
}

resource "nsxt_lb_tcp_virtual_server" "minio_lb_virtual_server" {
  description                = "minio lb_virtual_server provisioned by terraform"
  display_name               = "minio virtual server"
  application_profile_id     = "${nsxt_lb_fast_tcp_application_profile.minio_fast_tcp_profile.id}"
  ip_address                 = "${var.minio_vip_server}"
  ports                       = ["9000"]
  pool_id                    = "${nsxt_lb_pool.minio_lb_pool.id}"
}
