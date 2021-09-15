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
         vault {
        namespace = "default"
        policies  = ["nomad-server"]
         }
          driver = "docker"

          config {
              image = "giorgiocl/backend:local"
              ports = ["http"]
          }

          template {
              data        = <<EOF
                  {{ with secret "secret/data/engineering" }}
                     DB_HOST = {{.Data.data.DB_HOST}}
                      DB_NAME = {{.Data.data.DB_NAME}}
                      DB_PORT = {{.Data.data.DB_PORT}}
                      DB_USER = {{.Data.data.DB_USER}}
                      DB_PASSWORD = {{.Data.data.DB_PASSWORD}}
                  {{ end }}
                  EOF
                  destination = "local/config.env"
                  env = true
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
       to = 8080
      }
    }
  }
}