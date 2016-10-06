job "nginx" {
  region      = "europe"
  datacenters = ["dc2"]
  type        = "service"

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "nginx" {
    count = 3

    task "frontend" {
      driver = "docker"

      config {
        image = "nginx:latest"
      }

      service {
        port = "http"
      }

      resources {
        cpu    = 500
        memory = 128

        network {
          mbits = 10

          # Request for a dynamic port
          port "http" {
            static = 80
          }
        }
      }
    }
  }
}
