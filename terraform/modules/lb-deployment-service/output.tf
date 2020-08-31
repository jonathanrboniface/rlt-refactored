output "lb_ip" {
  value = kubernetes_service.rlt-test.load_balancer_ingress[0].ip
}
