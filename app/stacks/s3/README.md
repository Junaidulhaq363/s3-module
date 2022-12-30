# terraform-s3

Terraform modules:

- s3

## Requirements (and Tested on)

- aws terraform provider >= [3.52.0](https://registry.terraform.io/providers/hashicorp/aws/3.52.0)
- terraform >= [1.0.4](https://www.terraform.io/downloads.html)

## File Hierarchy

```
.
└── terraform-s3
   ├── main.tf
   ├── output.tf
   ├── variable.tf
   ├── README.md
   ├── example
   │   └── complete.txt
   └── modules
       └── s3
           ├── main.tf
           ├── output.tf
           └── variable.tf


```

## Dependencies

The following should be installed, so that files can run :

- terraform
- internet connection

## Example Run

```
#(optional) to format the files
terraform fmt
```

```
#to validate the files
terraform validate
```

```
#to download the dependencies
terraform init
```

```
#it creates an execution plan
terraform plan
```

```
#use it to apply to the
terraform apply
```
