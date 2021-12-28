<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_docker"></a> [docker](#provider\_docker) | 2.15.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [docker_container.stack_directus](https://registry.terraform.io/providers/kreuzwerker/docker/2.15.0/docs/resources/container) | resource |
| [docker_image.image](https://registry.terraform.io/providers/kreuzwerker/docker/2.15.0/docs/resources/image) | resource |
| [docker_network.private_network](https://registry.terraform.io/providers/kreuzwerker/docker/2.15.0/docs/resources/network) | resource |
| [template_file.example](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_DB"></a> [DB](#input\_DB) | n/a | `map` | <pre>{<br>  "db": "directus",<br>  "pass": "directus",<br>  "serviceDatabaseName": "database",<br>  "serviceRedisName": "redis",<br>  "user": "directus"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_du_container"></a> [ip\_du\_container](#output\_ip\_du\_container) | n/a |
| <a name="output_rendered"></a> [rendered](#output\_rendered) | n/a |
<!-- END_TF_DOCS -->