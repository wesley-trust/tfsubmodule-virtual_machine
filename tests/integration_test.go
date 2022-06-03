package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"

	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestApplySingleInstance_Windows(t *testing.T) {
	t.Parallel()

	// Root folder where Terraform files should be (relative to the test folder)
	rootFolder := "../"

	// Path to Terraform example files being tested (relative to the root folder)
	terraformFolderRelativeToRoot := "./examples/"

	// Copy the terraform folder to a temp folder to prevent conflicts from parallel runs
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	// Generate a random deployment name for the test to prevent a naming conflict
	uniqueID := random.UniqueId()
	testREF := "SingleInstance_Windows"
	serviceDeployment := testREF + "-" + uniqueID
	operatingSystemPlatform := "Windows"
	resourceVmSku := "2022-datacenter-smalldisk-g2"

	// Define variables
	locations := []string{"UK South"}

	// Enable retryable error
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		// The path to where the Terraform code is located
		TerraformDir: tempTestFolder,

		// Variables to pass to the Terraform code using -var options
		Vars: map[string]interface{}{
			"service_deployment":        serviceDeployment,
			"resource_instance_count":   1,
			"service_location":          locations,
			"operating_system_platform": operatingSystemPlatform,
			"resource_vm_sku":           resourceVmSku,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)
}

func TestApplySingleInstance_Linux(t *testing.T) {
	t.Parallel()

	// Root folder where Terraform files should be (relative to the test folder)
	rootFolder := "../"

	// Path to Terraform example files being tested (relative to the root folder)
	terraformFolderRelativeToRoot := "./examples/"

	// Copy the terraform folder to a temp folder to prevent conflicts from parallel runs
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	// Generate a random deployment name for the test to prevent a naming conflict
	uniqueID := random.UniqueId()
	testREF := "SingleInstance_Linux"
	serviceDeployment := testREF + "-" + uniqueID

	// Define variables
	locations := []string{"UK South"}

	// Enable retryable error
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		// The path to where the Terraform code is located
		TerraformDir: tempTestFolder,

		// Variables to pass to the Terraform code using -var options
		Vars: map[string]interface{}{
			"service_deployment":      serviceDeployment,
			"resource_instance_count": 1,
			"service_location":        locations,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)
}
