terraform {
    required_providers {
        mongodbatlas = {
            source  = "mongodb/mongodbatas"
            version = "~>1.3.1"
        }
        aws = {
            source  = "hashicorp/aws"
            version = "~>4.20.1"
        }
    }
    required_version = ">=1.1.2,<1.3.0"
}