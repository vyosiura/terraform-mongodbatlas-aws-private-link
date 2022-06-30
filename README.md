## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.1.2,<1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>4.20.1 |
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | ~>1.3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>4.20.1 |
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | ~>1.3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [mongodbatlas_privatelink_endpoint.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/privatelink_endpoint) | resource |
| [mongodbatlas_privatelink_endpoint_service.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/privatelink_endpoint_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | (optional)By default, a ingress inboud rule is created to allow port 1024 ~ 65535, which can be used to access Atlas databases.  A list of CIDR blocks to allow the VPC Endpoint's security group | `list(string)` | n/a | yes |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | (optional) Whether or not create a security group for VPC Endpoint | `bool` | `true` | no |
| <a name="input_dns_record_ip_type"></a> [dns\_record\_ip\_type](#input\_dns\_record\_ip\_type) | (optional) The DNS records created for the endpoint. Valid values are ipv4, dualstack, service-defined, and ipv6 | `string` | `"ipv4"` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | (optional) The IP address type for the endpoint. Valid values are ipv4, dualstack, and ipv6. | `string` | `"ipv4"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (optional)  policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access. All Gateway and some Interface endpoints support policies - see the relevant AWS documentation for more details. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide | `string` | `null` | no |
| <a name="input_private_dns_enabled"></a> [private\_dns\_enabled](#input\_private\_dns\_enabled) | (optional) (Optional; AWS services and AWS Marketplace partner services only) Whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type Interface. Defaults to true. | `bool` | `false` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | (Required) Atlas MongoDB Project where the load balancer endpoint will be created. The Atlas MongoDB acts as the service provider | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | (optional) Region where the load balancer endpoint will be created. Both endpoints must be at the same region. Default: US\_EAST\_1 | `string` | `"US_EAST_1"` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | List of objects to create the rules. Between `cidr_blocks`, `ipv6_cidr_blocks`, `prefix_list_ids` and `security_groups`, one must be specified. Its properties:<br>        type                -> (Required) Rule type. Whether is a `egress` or `ingress` rule<br>        from\_port           -> (Required) Starting port range<br>        to\_port             -> (Required) Ending port range<br>        protocol            -> (optional) Protocol type. Possible values: `tcp`, `udp` or `-1`. If `-1` then it is both `tcp` and `udp`<br>        description         -> (optional) A brief rule description.<br>        cidr\_blocks         -> (optional) A list of cidrs blocks<br>        ipv6\_cidr\_blocks    -> (optional) List of ipv6\_cidr\_blocks<br>        prefix\_list\_ids     -> (optional) List of Prefix List IDs.<br>        security\_groups     -> (optional) List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC.<br>        self                -> (Optional) Whether the security group itself will be added as a source to this ingress rule.<br>    A default egress all rule is created by default | `any` | `{}` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | (optional) Security Group Description to help identify it | `string` | `"Managed by Terraform"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | (optional)  The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type Interface. If no security groups are specified, the VPC's default security group is associated with the endpoint. | `list(string)` | `[]` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | (optional) Must be specified without the prefix `sg-XXXX`. If `create_security_group` is true and `security_group_name` is not specified then a default name `vpc-endpoint-sg-mongodbatlas-project_id` will be created | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | (required) The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (optional) A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (required) The ID of the VPC in which the endpoint will be used. | `string` | n/a | yes |

## Outputs

No outputs.
