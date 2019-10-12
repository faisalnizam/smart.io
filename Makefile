ROLE:= $(word 2,$(MAKECMDGOALS))
ENV:= $(word 3,$(MAKECMDGOALS))
PREFIX:= $(word 4,$(MAKECMDGOALS))
ENV_VARIABLES="environments/${ENV}/tfvars/${ROLE}.tfvars"
PREFIX_ENV_VARIABLES="environments/${ENV}/tfvars/${ROLE}.tfvars"
GLOBAL_VARIABLES="environments/${ENV}.tfvars"
ENV_STATE = "environments/${ENV}/state/${ROLE}.tfstate"
PREFIX_ENV_STATE = "environments/${ENV}/state/${PREFIX}_${ROLE}.tfstate"
ROLE_DIR="roles/${ROLE}/${ENV}"

help:
	@echo "Usage make <action> <role> <env>"
	@echo "\taction : plan, apply, destroy, destroy-plan"
	@echo "\trole: roles like network, rds, jenkins, "
	@echo "\tenv: one of the environment in prod, qa, etc"

plan: init
ifndef PREFIX
	@echo "THe PREFIX IS NOT DEFINED"
	@terraform plan -out=.plans/${ROLE}_${ENV}.tfplan -state=${ENV_STATE} -var-file=${GLOBAL_VARIABLES} -var-file=${ENV_VARIABLES} ${ROLE_DIR}
else
	@echo "THe PREFIX is : ${PREFIX}"
	@echo "The VAR FILE is : ${PREFIX_ENV_VARIABLES}"
	@echo "The state file to be used is : ${PREFIX_ENV_STATE}"
	@terraform --version
	@terraform plan -out=.plans/${PREFIX}_${ROLE}_${ENV}.tfplan -state=${PREFIX_ENV_STATE} -var-file=${GLOBAL_VARIABLES} -var-file=${ENV_VARIABLES} -var='env=${PREFIX}' ${ROLE_DIR}
endif

apply:
ifndef PREFIX
	@echo "THe PREFIX IS NOT DEFINED"
	@terraform apply -parallelism=20 -state-out=${ENV_STATE} .plans/${ROLE}_${ENV}.tfplan 
else
	@echo "THe PREFIX is : ${PREFIX}"
	@terraform apply -parallelism=20 -state-out=${PREFIX_ENV_STATE} .plans/${PREFIX}_${ROLE}_${ENV}.tfplan
endif

output:
ifndef PREFIX
	@echo "THe PREFIX IS NOT DEFINED"
	@echo "The state file trying to read ${ENV_STATE}" 
	@terraform output -state=${ENV_STATE}
	@echo "ENV_STATE: ${ENV_STATE}"
else
	@echo "THe PREFIX is : ${PREFIX}"
	@echo "The state file trying to read ${PREFIX_ENV_STATE}"
	@terraform output -state=${PREFIX_ENV_STATE}
endif

destroy-plan:
	@echo "Writting Destroy Plan"
ifndef PREFIX
	@echo "THe PREFIX IS NOT DEFINED"
	@terraform plan -destroy -out=.plans/${ROLE}_${ENV}_destroy.tfplan -state=${ENV_STATE} -var-file=${GLOBAL_VARIABLES} -var-file=${ENV_VARIABLES} ${ROLE_DIR}
	@echo "terraform apply -state-out=${PREFIX_ENV_STATE} .plans/${ROLE}_${ENV}_destroy.tfplan"
else
	@echo "THe PREFIX is : ${PREFIX}"
	@terraform plan -destroy -out=.plans/${PREFIX}_${ROLE}_${ENV}_destroy.tfplan -state=${PREFIX_ENV_STATE} -var-file=${GLOBAL_VARIABLES} -var-file=${ENV_VARIABLES} -var='env=${PREFIX}' ${ROLE_DIR}
	@echo "terraform apply -state-out=${PREFIX_ENV_STATE} .plans/${PREFIX}_${ROLE}_${ENV}_destroy.tfplan"
endif

destroy:
	@echo "Make file does not support auto destruction, Please run the following comand manually to destory: terraform apply  -parallelism=20 -state-out=${ENV_STATE} .plans/${ROLE}_${ENV}_destroy.tfplan"

init: | .plans
	#@rm -rf .terraform
	@terraform init ${ROLE_DIR}
	@terraform fmt ${ROLE_DIR}

.plans/%:
	@ echo "Need to run \"make plan ${ROLE} ${ENV}\""

.plans:
	@mkdir .plans

clean:
	rm -rf .plans .terraform

%:
	@:

