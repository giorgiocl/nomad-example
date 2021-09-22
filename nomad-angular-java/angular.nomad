job "frontend" {
  datacenters = ["dc1"]
  type = "service"

  group "frontend" {    
       count = 1
      /*scaling {
          enabled = true
          min = 1
          max = 3
          policy {} 
      }*/

      task "frontend" {
          driver = "docker"

          config {
              // image = "iacsquad/frontend-angular:local"
              // image = "dilsontw/iac-front:latest"
              image = "716635345492.dkr.ecr.us-east-2.amazonaws.com/frontend-angular"
              ports = ["http"]
          }

          env {
              PORT = "${NOMAD_PORT_http}"
          }

          service {
              name = "frontend"
              port = "http"

              tags = [
                  "frontend",
                  "urlprefix-/"
              ]

              check {
                  type = "http"
                  path = "/"
                  interval = "5s"
                  timeout = "2s"
              }
          }
      }

    network {
      port "http" {
        //static = 8090
        to = 80
      }
    }
  }
}