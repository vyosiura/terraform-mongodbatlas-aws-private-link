locals {
    provider_name           = "AWS"
    vpc_endpoint_type       = "Interface"
    project_id              = var.project_id
    region                  = var.region != null ? var.region : "US_EAST_1"
    vpc_id                  = var.vpc_id
    tags                    = var.tags

    security_group_name     = (var.security_group_name == null ? "vpc-endpoint-sg-mongodbatlas-${local.project_id}" : var.security_group_name)

    rules                   = merge({
        "egress_all"    = {
            type                = "egress"
            from_port           = "0"
            to_port             = "0"
            protocol            = "-1"
            description         = "Default egress rule"
            cidr_blocks         = ["0.0.0.0/0"]
        },
        "ephemeral_ports" = {
            type        = "ingress"
            from_port   = "1024"
            to_port     = "65535"
            protocol    = "tcp"
            description = "Port range used for Atlas Endpoint Service"
        }
    }, var.rules)
}

/*
    To Do(REMOVE IT RIGHT AFTER I FINISH SOME OF THESE TASKS TO MAKE MY LIFE EASIER FOR MYSELF):
        - Finish outputs.tf
        - Create a test directory with a Makefile to test
        - Test if the dns_options should be declared as I did
        - Read more about the VPC Endpoint Interface type and how it provides high availability by spamming multiple availability zones 
        - Review all variables descriptions and if they make sense


    Some considerations:

        MongoDB strongly recommends using the DNS seedlist private endpoint-aware connection string, 
        so that DNS automatically updates the ports that AWS PrivateLink uses if they change. 
        For the same reason, MongoDB also strongly recommends allow-listing the entire port range, instead of specific ports.

*/
resource "mongodbatlas_privatelink_endpoint" "this" {
    project_id          = local.project_id
    provider_name       = local.provider_name
    region              = local.region
}


resource "aws_security_group" "this" {
    count                   = var.create_security_group ? 1 : 0
    name                    = local.security_group_name
    description             = var.security_group_description
    vpc_id                  = local.vpc_id 
    tags                    = local.tags 
}

resource "aws_vpc_endpoint" "this" {
    vpc_id                  = local.vpc_id
    service_name            = mongodbatlas_privatelink_endpoint.this.endpoint_service_name
    policy                  = var.policy 
    private_dns_enabled     = var.private_dns_enabled 
    dns_options {
        dns_record_ip_type     = var.dns_record_type
    }
    ip_address_type         = var.ip_address_type
    subnet_ids              = var.subnet_ids 
    security_group_ids      = concat(var.security_group_ids, aws_security_group.this[*].id)
    vpc_endpoint_type       = local.vpc_endpoint_type
    tags                    = local.tags 
}


resource "mongodbatlas_privatelink_endpoint_service" "this" {
    project_id              = local.project_id
    private_link_id         = mongodbatlas_privatelink_endpoint.this.id
    endpoint_service_id     = aws_vpc_endpoint.this.id 
    provider_name           = local.provider_name
}



resource "aws_security_group_rule" "this" {
    for_each                = local.rules

    security_group_id       = join("", aws_security_group.this[*].id)
    type                    = each.value["type"]
    from_port               = each.value["from_port"]
    to_port                 = each.value["to_port"] 
    
    protocol                = lookup(each.value, "protocol", "tcp")
    cidr_blocks             = lookup(each.value, "cidr_blocks", null)
    ipv6_cidr_blocks        = lookup(each.value, "ipv6_cidr_blocks", null)
    prefix_list_ids         = lookup(each.value, "prefix_list_ids", null)
    self                    = lookup(each.value, "self", null)
    description             = lookup(each.value, "description", "Managed by Terraform")
}

