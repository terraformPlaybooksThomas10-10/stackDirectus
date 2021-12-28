terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}
 
provider "docker" {
  host = "unix:///var/run/docker.sock"
}


variable "DB" {
  default={
  user="directus"
  pass="directus"
  db="directus"
  serviceDatabaseName="database"
  serviceRedisName="redis"
  }
}
variable "DIRECTUS" {
  default={
  ADMIN_EMAIL="admin@example.com"
  ADMIN_PASSWORD="directus"
  } 
}

locals {
  cont=[{
    image="redis:6"
    name="${var.DB.serviceRedisName}"
    },{
    image="directus/directus:latest"
    ports={
      internal=8055
      external=8055
      }

    environment=[
      "KEY='255d861b-5ea1-5996-9aa3-922530ec40b1'",
      "SECRET='6116487b-cda1-52c2-b5b5-c8022c45e263'",
      "DB_CLIENT=pg",
      "DB_HOST=${var.DB.serviceDatabaseName}",
      "DB_PORT=5432",
      "DB_DATABASE=${var.DB.db}",
      "DB_USER=${var.DB.user}",
      "DB_PASSWORD=${var.DB.pass}",
      "CACHE_ENABLED=true",
      "CACHE_STORE=redis",
      "CACHE_REDIS=redis://${var.DB.serviceRedisName}:6379",
      "ADMIN_EMAIL=${var.DIRECTUS.ADMIN_EMAIL}",
      "ADMIN_PASSWORD=${var.DIRECTUS.ADMIN_PASSWORD}"
    ]
    volumes=[
      {
        host_path="/volumes/directus_upload"
        container_path="/directus/uploads"
      }
    ]
  },{
    image="postgis/postgis:13-master"
    name="${var.DB.serviceDatabaseName}"
    environment=[
      "POSTGRES_USER=${var.DB.user}",
      "POSTGRES_DB=${var.DB.db}",
      "POSTGRES_PASSWORD=${var.DB.pass}"
    ]
    volumes=[
      {
        host_path="/volumes/db_data"
        container_path="/var/lib/postgresql/data"
      }
    ]
  }]
}


# Pulls the image
resource "docker_image" "image" {
  count = length(local.cont)
  name =  local.cont[count.index].image
}

resource "docker_network" "private_network" {
  name="directus"
}

# Create a container
resource "docker_container" "stack_directus" {
  count = length(local.cont)
  image = docker_image.image[count.index].name
  #name = format("%s%s","test",count.index)
  name = (lookup(local.cont[count.index], "name", "") == "" ? split(":",split("/",local.cont[count.index].image)[0])[0] : local.cont[count.index].name)
  #command = ["tail","-f","/dev/null"]
  networks_advanced {
    name=docker_network.private_network.name
  }
  env=(lookup(local.cont[count.index], "environment", []) == [] ? [] : local.cont[count.index].environment)
  dynamic "ports" {
    for_each=(lookup(local.cont[count.index], "ports", []) == [] ? [] : [1])
    content {
      internal=local.cont[count.index].ports.internal
      external=local.cont[count.index].ports.external
    }
  } 
  dynamic "volumes" {
    for_each=(lookup(local.cont[count.index], "volumes", []) == [] ? [] : local.cont[count.index].volumes)
    content{
      host_path=volumes.value.host_path
      container_path=volumes.value.container_path
    } 
  }
}