terraform {
    required_providers {
        source  = "mongodb/mongodbatas"
        version = "~>1.3.1"
    }
    required_providers {
        source  = "hashicorp/aws"
        version = "~>4.20.1"
    }
    required_version = ">=1.1.3,<1.3.0"
}