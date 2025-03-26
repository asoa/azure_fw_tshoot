
.PHONY: init validate plan apply destroy

init:
	@echo "Initializing Terraform..."
	terraform init

validate:
	@echo "Validating Terraform configuration..."
	terraform fmt -recursive
	terraform fmt -recursive ./modules/
	terraform validate
	
plan:
	@echo "Planning Terraform changes..."
	if [ -f tfplan ]; then rm tfplan; fi
	terraform plan -out=tfplan

apply:
	@echo "Applying Terraform changes..."
	terraform apply --auto-approve tfplan

destroy:
	@echo "Destroying Terraform resources..."
	terraform destroy -auto-approve