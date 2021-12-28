output "ip_du_container"  {
  #value=docker_container.stack_directus[for s in docker_container.stack_directus: s].name 
  #value=docker_container.stack_directus.
value=[for s in docker_container.stack_directus: format("name: %s ip: %s env %#v ports %#v", s.name,s.ip_address,s.env,s.ports)  ] 
#value=docker_container.stack_directus[1].ports
}

data "template_file" "example" {
  count = length(docker_container.stack_directus)
  template = "${file("templates/greeting.tpl")}"
  vars={
    name = docker_container.stack_directus[count.index].name
    ip = docker_container.stack_directus[count.index].ip_address
    #ports= lookup(docker_container.stack_directus[count.index],ports,[]) == [] ? [] : docker_container.stack_directus[count.index].ports[0] 
    ports= "" 
  }
}


output "rendered" {
  value = data.template_file.example.*.rendered
}