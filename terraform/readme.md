The purpose of this project was to design and deploy a timestamp generator that updates a storage object in a storage bucket, every 10 minutes, and that timestamp 

be available to the web for your viewing.

HTTP PORT 80 URL:  http://34.147.3.6/

HTTPS/TLS/SSL PORT 443 URL: https://timestamps.puplampu.me/

HTTP PORT 80 URL:  http://34.147.3.6/timestamps.html

HTTPS/TLS/SSL PORT 443 URL: https://timestamps.puplampu.me/timestamps.html

GitHub Repo of Terraform Code:  https://github.com/puplampuclou/timestamp-global-scaled-cloudrun/edit/main/terraform/

STATUS:  COMPLETE

Provide a diagram of the above implementation:

This README contains:

■ Description of repo folders/structure:  This is a single folder respository with two terraform files, the main.tf and the provider.tf files, which are all you need to deploy the storage bucket and server to Google Cloud.

■ deployment instructions and dependencies
Prerequisite:
1. Github Oauth Integration with Terraform Cloud Workspace:  https://developer.hashicorp.com/terraform/tutorials/cloud/github-oauth
2. Terraform Cloud Integration with Google Cloud API: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference

Files:

main.tf

The main.tf file whenever updated or changed, when configured with Terraform cloud kicks off a plan staging run to look for errors and issues.  This particular file builds the CKEM keyring, key, storage bucket and vm-instance web server.

provider.tf

The provider.tf file tells terraform cloud to use the Google Terraform API provider module.

timestamps.sh

The timestamps.sh file is to be uploaded or created in the web server and be the trigger point for a crontab entry to execute every 10 minuites.

It executes the actual updates, all in one stroke, every 10 minuites it does the following:
1.	Runs the date command.
2.	Writes that value to the local timestamps.html file.  
3.	Copies over that file to the /var/www/html/ directory.
4.	Pushes said update to the custom-time.txt object in the storage bucket.


■ Tear-down instructions

○ Why the services/components were chosen over alternatives.

○ How the cost of the implementation scales as traffic increases.

○ How to monitor the implementation for availability and performance.

○ How to recover from a regional disaster and impact to end users.

○ How the implementation complies with best practices (AWS Well Architected
Framework or Google Cloud Architecture Framework.)
