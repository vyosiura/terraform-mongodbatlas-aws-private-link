variable "project_id" {
    type = string
    description = "(Required) Atlas MongoDB Project where the load balancer endpoint will be created. The Atlas MongoDB acts as the service provider"
}

variable "region" {
    type = string
    description = "(optional) Region where the load balancer endpoint will be created. Both endpoints must be at the same region. Default: US_EAST_1"
    default = "US_EAST_1"
}

variable "vpc_id" {
    type = string
    description = "(required) The ID of the VPC in which the endpoint will be used."
}

variable "policy" {
    type = string
    description = "(optional)  policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access. All Gateway and some Interface endpoints support policies - see the relevant AWS documentation for more details. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide"
    default = null
}

variable "private_dns_enabled" {
    type = bool
    description = "(optional) (Optional; AWS services and AWS Marketplace partner services only) Whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type Interface. Defaults to true."
    default = true
}

variable "dns_record_type" {
    type = string
    description = "(optional) The DNS records created for the endpoint. Valid values are ipv4, dualstack, service-defined, and ipv6"
    default = "ipv4"
}

variable "ip_address_type" {
    type = string
    description = "(optional) The IP address type for the endpoint. Valid values are ipv4, dualstack, and ipv6."
    default = "ipv4"
}

variable "subnet_ids" {
    type = list(string)
    description = "(required) The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface."
    validation {
        condition       = length(var.subnet_ids) > 0
        error_message   = "Please specify at least 1 subnet id."
    }
}

variable "security_group_ids" {
    type = list(string)
    description = "(optional)  The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type Interface. If no security groups are specified, the VPC's default security group is associated with the endpoint."
    default = []
}

variable "tags" {
    type = map(string)
    description = "(optional) A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}

// SG variables
variable "create_security_group" {
    type        = bool
    description = "(optional) Whether or not create a security group for VPC Endpoint"
    default     = true
}

variable "security_group_name" {
    type = string
    description = "(optional) Must be specified without the prefix `sg-XXXX`. If `create_security_group` is true and `security_group_name` is not specified then a default name `vpc-endpoint-sg-mongodbatlas-project_id` will be created"
    default = null
}

variable "security_group_description" {
    type = string
    description = "(optional) Security Group Description to help identify it"
    default = "Managed by Terraform"
}

variable "rules" {
    type = any
    description =<<EOF
    List of objects to create the rules. Between `cidr_blocks`, `ipv6_cidr_blocks`, `prefix_list_ids` and `security_groups`, one must be specified. Its properties:
        type                -> (Required) Rule type. Whether is a `egress` or `ingress` rule
        from_port           -> (Required) Starting port range
        to_port             -> (Required) Ending port range
        protocol            -> (optional) Protocol type. Possible values: `tcp`, `udp` or `-1`. If `-1` then it is both `tcp` and `udp`
        description         -> (optional) A brief rule description.
        cidr_blocks         -> (optional) A list of cidrs blocks
        ipv6_cidr_blocks    -> (optional) List of ipv6_cidr_blocks
        prefix_list_ids     -> (optional) List of Prefix List IDs.
        security_groups     -> (optional) List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC.
        self                -> (Optional) Whether the security group itself will be added as a source to this ingress rule.
    A default egress all rule is created by default 
EOF
    default = {
        "ephemeral_ports" = {
            type        = "ingress"
            from_port   = "1024"
            to_port     = "65535"
            protocol    = "tcp"
            description = "Port range used for Atlas Endpoint Service"
        }
    }
}