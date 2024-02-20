The purpose of this project was to design and deploy a timestamp generator that updates a storage object in a storage bucket, every 10 minutes, and that timestamp 

be available to the web for your viewing.

HTTP PORT 80 URL:  http://34.147.3.6/

HTTPS/TLS/SSL PORT 443 URL: https://timestamps.puplampu.me/

HTTP PORT 80 URL:  http://34.147.3.6/timestamps.html

HTTPS/TLS/SSL PORT 443 URL: https://timestamps.puplampu.me/timestamps.html

GitHub Repo of Terraform Code:  https://github.com/puplampuclou/timestamp-global-scaled-cloudrun/edit/main/terraform/

GitHub Repo of the Cloud Run Global Scaled Deployment Timestamp Solution:  https://github.com/puplampuclou/timestamp-global-scaled-cloudrun/tree/main

STATUS:  COMPLETE

■ Provide a diagram of the above implementation:

This README contains:

■ Description of repo folders/structure:  This is a single folder respository with two terraform files, the main.tf and the provider.tf files, which are all you need to deploy the storage bucket and server to Google Cloud.  This is not the folder or repo that I have integrated with Terraform Cloud Workspaces.  This is a copy of the files in the private gcp-puplampu repository https://github.com/puplampuclou/gcp-puplampu that I have authenticated and directly integrated with Terraoform Cloud CI/CD pipeline.  All of the otherwise local dependencies and versioning is not necessary or allowed in this directory, as its all managed remotely by TFC.  This decision was made as its easier to maintain, is more table and more aligned with how an enterprise repository CI/CD Pipeline would be setup.  Access granted upon request.

■ deployment instructions and dependencies
Prerequisite:
1. Github Oauth Integration with Terraform Cloud Workspace:  https://developer.hashicorp.com/terraform/tutorials/cloud/github-oauth
2. Terraform Cloud Integration with Google Cloud API: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference

■ Files:

■ main.tf

The main.tf file whenever updated or changed, when configured with Terraform cloud kicks off a plan staging run to look for errors and issues.  This particular file builds the CKEM keyring, key, storage bucket and vm-instance web server.  Imlemented remotely by TCF.

■ provider.tf

The provider.tf file tells terraform cloud to use the Google Terraform API provider module, managed remotely by TCF.

■ timestamps.sh

The timestamps.sh file is NOT USED BY TCF, just in the directory to deploy to target http server post deployment. It is to be uploaded or created in the web server and be the trigger point for a crontab entry to execute every 10 minuites once the server is built.

It executes the actual updates every 10 minuites it does the following:
1.	Runs the date command.
2.	Writes that value to the local timestamps.html file.  
3.	Copies over that file to the /var/www/html/ directory.
4.	Pushes said update to the custom-time.txt object in the storage bucket.

■ Tear-down instructions

In order to tear everything down, you simply delete the content in the main.tf file (NOTE:  NOT THE FILE ITSELF) and run the pipeline apply to complete the removal of all devices this particular tf file created.

○ Why the services/components were chosen over alternatives:  I chose Google Cloud because I know it them well and I believe it is more secure and has better quality services.  I chose to use Terraform Cloud because it is very secure, you don't have to save any credentials, or key variables, or variable files locally in the repo (ssl, certs and service account json keys are all stored in a TFC variable secured key vault) 

○ How the cost of the implementation scales as traffic increases:  The cost will vary between these two main factors:

1. Dedicated infrastructure, gke or instance groups will have a higher cost regardless of how much traffic, and when deployed at scale in different regions, will be a significant fixed monthly cost.  However, this increased fixed monthly costs has lower usage, traffic and peak volume cost.

2.  Serverless event driven architected solutions have a low fixed monthly cost, and most of your infrastructure is not running when there is no traffic.  However, when there are occasional peaks, this solution shines.  However, when you have a consistently high levels of daily traffic and usage, you pay a premium.
I believe the answer to this question will depend on your traffic and usage patturns.  Consistently guaranteed amount of traffic should be deployed on dedicated infrastructure and for excess and occasional peak traffic, this sould be leveraged on event-driven traffic.

○ How to monitor the implementation for availability and performance:  Google Cloud Monitoring, Splunk, Dynatrace, and Elastistach are all options that depending on how you use them, negotiate licensing costs and architect it, can all be provide good value at good pricepoints.

○ How to recover from a regional disaster and impact to end users:  Both the event-driven, gke or a combination of both, they can be deployed and designed with multi-region redundancy, strong site reliability and security best practices will ensure a high level or resiliance.  With SRE/Security best practices architecture in place, with global load balancing, intelligent cdn caching, regular backups, monitoring, properly planned upgrade/maintenance SOPs and traffic/utilization optimization planning, a disaster recovery process should be as easy as a click of a few pre-configured fail-over automation tools.

○ How the implementation complies with best practices (AWS Well Architected
Framework or Google Cloud Architecture Framework.):  

■ My solution recommendation addresses all 11 of both Amazon and Google pillars of architecture best practices.  

■ Amazon 5 pillars: Security, Reliability, Performance, Efficiency, Cost Optimization	

■ Google 6 pillars: System design, Security, Privacy & Compliance, Reliability, Performance, Cost Optimization

