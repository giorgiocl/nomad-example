job "backend" {
  datacenters = ["dc1"]
//  type = "service"

  group "back" {    
      count = 5
      /*scaling {
          enabled = true
          min = 3
          max = 5
          policy {} 
      }*/

      task "server" {
          driver = "docker"

          config {
              image = "iacsquad/backend-java:local"
              ports = ["http"]
          }

          env {
              PORT = "${NOMAD_PORT_http}"
          }

          service {
              name = "backend"
              port = "http"

              tags = [
                  "mackook",
                  "urlprefix-/api"
              ]

              check {
                  type = "http"
                  path = "/api/actuator/health"
                  interval = "5s"
                  timeout = "2s"
              }
          }
      }

    network {
      port "http" {
       // static = 8080
      }
    }
  }
}