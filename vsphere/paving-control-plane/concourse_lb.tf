resource "nsxt_ns_group" "concourse_ns_group" {
  display_name = "concourse_ns_group"
}

resource "nsxt_lb_tcp_monitor" "concourse_lb_tcp_monitor" {
  display_name = "concourse_lb_tcp_monitor"
  interval     = 5
  monitor_port  = 443
  rise_count    = 3
  fall_count    = 3
  timeout      = 15
}

resource "nsxt_lb_pool" "concourse_lb_pool" {
  description              = "concourse_lb_pool provisioned by Terraform"
  display_name             = "concourse_lb_pool"
  algorithm                = "WEIGHTED_ROUND_ROBIN"
  min_active_members       = 1
  tcp_multiplexing_enabled = false
  tcp_multiplexing_number  = 3
  active_monitor_id        = nsxt_lb_tcp_monitor.concourse_lb_tcp_monitor.id
  snat_translation {
    type          = "SNAT_AUTO_MAP"
  }
  member_group {
    grouping_object {
      target_type = "NSGroup"
      target_id   = nsxt_ns_group.concourse_ns_group.id
    }
  }

}

resource "nsxt_lb_fast_tcp_application_profile" "tcp_profile" {
  display_name = "concourse_fast_tcp_profile"
}

resource "nsxt_lb_tcp_virtual_server" "concourse_lb_virtual_server" {
  description                = "concourse lb_virtual_server provisioned by terraform"
  display_name               = "concourse virtual server"
  application_profile_id     = nsxt_lb_fast_tcp_application_profile.tcp_profile.id
  ip_address                 = var.concourse_vip_server
  ports                       = ["443", "8443", "8844"]
  pool_id                    = nsxt_lb_pool.concourse_lb_pool.id
}

