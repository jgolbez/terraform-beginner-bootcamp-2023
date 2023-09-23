# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:
This project will use semantic versioning

The format:
**MAJOR.MINOR.PATCH**  eg `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes1_semantic_versioning

### Terraform CLI Changes
Terraform CLI install has changed so we needed to fix the Gitpod YML([.gitpod.yml](.gitpod.yml))

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Refactoring into Bash Scripts

Fixed TF CLI install steps and condensed into new bash script for gitpod YML to keep Gitpod working and install TF CLI easier
Bash Script: [./bin/install_terraform_cli](./bin/install_terraform_cli)

### Linux Distribution
This project is built using Ubuntu 22.
Changed permissions for the script to be user executable so taht Gitpod launch would execute the bash script
```
chmod u+x ./bin/install_terraform_cli
```
### Gitpod Consideration
If the workspace is not new it will not run the Init including the script, it only runs when a new workspace is created



