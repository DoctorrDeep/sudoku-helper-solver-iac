.PHONY: build

build:
	@bash build-images.sh ~/Documents/Codesko/Personal/sudoku-helper-solver-backend ~/Documents/Codesko/Personal/sudoku-helper-solver-frontend


# One time only. To be run upon first setup of repo in machine.
init:
	@terraform init

plan:
	@terraform plan

deploy:
	@terraform apply -auto-approve

destroy:
	@terraform destroy -auto-approve