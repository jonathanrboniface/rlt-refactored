resource "google_compute_vpn_tunnel" "tunnel1" {
  provider      = google-beta
  name          = "tunnel1"
  peer_ip       = "176.24.244.238"
  shared_secret = "a secret message"

  target_vpn_gateway = google_compute_vpn_gateway.target_gateway.id

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
    ]

  labels = {
    foo = "bar"
  }
}

resource "google_compute_vpn_gateway" "target_gateway" {
  provider = google-beta
  name     = "vpn1"
  network  = google_compute_network.network1.id
}

resource "google_compute_network" "network1" {
  provider = google-beta
  name     = "vpn-gcp"
}

resource "google_compute_address" "vpn_static_ip" {
  provider = google-beta
  name     = "vpn-static-ip"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  provider    = google-beta
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  provider    = google-beta
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  provider    = google-beta
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_route" "route1" {
  provider   = google-beta
  name       = "route1"
  network    = google_compute_network.network1.name
  dest_range = "176.24.244.238"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
}