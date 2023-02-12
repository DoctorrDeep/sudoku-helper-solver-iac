.PHONY: build

# One time only. To be run upon first setup of repo in machine.
init:
	@terraform init

plan:
	@terraform plan

deploy:
	@terraform apply -auto-approve

destroy:
	@terraform destroy -auto-approve
