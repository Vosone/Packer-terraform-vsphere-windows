# Learn Terraform vSphere

Replace the vsphere vars with yours. Also the passwords in the autounattend.xml and vsphere...hcl file.

Create the image:
```
packer build .
```
In the packer folder.

Create new vm:
```
terraform init
terrafrom apply
```
