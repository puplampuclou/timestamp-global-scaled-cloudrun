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

■ Description of repo folders/structure:  This is a single folder respository with two terraform files, the main.tf and the provider.tf files, which are all you need to deploy the storage bucket and server to Google Cloud.

■ deployment instructions and dependencies
Prerequisite:
1. Github Oauth Integration with Terraform Cloud Workspace:  https://developer.hashicorp.com/terraform/tutorials/cloud/github-oauth
2. Terraform Cloud Integration with Google Cloud API: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference

■ Files:

■ main.tf

The main.tf file whenever updated or changed, when configured with Terraform cloud kicks off a plan staging run to look for errors and issues.  This particular file builds the CKEM keyring, key, storage bucket and vm-instance web server.

■ provider.tf

The provider.tf file tells terraform cloud to use the Google Terraform API provider module.

■ timestamps.sh

The timestamps.sh file is to be uploaded or created in the web server and be the trigger point for a crontab entry to execute every 10 minuites.

It executes the actual updates every 10 minuites it does the following:
1.	Runs the date command.
2.	Writes that value to the local timestamps.html file.  
3.	Copies over that file to the /var/www/html/ directory.
4.	Pushes said update to the custom-time.txt object in the storage bucket.


■ Tear-down instructions

In order to tear everything down, you simply delete the main.tf files and run the pipeline apply to complete the removal of all devices this particular tf file created.


○ Why the services/components were chosen over alternatives:  I chose Google Cloud because I know it better and I believe it is more secure and has better quality services.

○ How the cost of the implementation scales as traffic increases:  The cost will vary between these two main factors:

1. Dedicated infrastructure, gke or instance groups will have a higher cost regardless of how much traffic, and when deployed at scale in different regions, will be a significant fixed monthly cost.  However, this increased fixed monthly costs has lower usage, traffic and peak volume cost.

2.  Serverless event driven architected solutions have a low fixed monthly cost, and most of your infrastructure is not running when there is no traffic.  However, when there are occasional peaks, this solution shines.  However, when you have a consistently high levels of daily traffic and usage, you pay a premium.
I believe the answer to this question will depend on your traffic and usage patturns.  Consistently guaranteed amount of traffic should be deployed on dedicated infrastructure and for excess and occasional peak traffic, this sould be leveraged on event-driven traffic.

○ How to monitor the implementation for availability and performance:  Google Cloud Monitoring, Splunk, Dynatrace, and Elastistach are all options that depending on how you use them, negotiate licensing costs and architect it, can all be provide good value at good pricepoints.

○ How to recover from a regional disaster and impact to end users:  Both the event-driven and gke based solutions can be deployed and designed with strong site reliability and security in mind.  With that architecture in place, by designing solutions in more than one region, with global load balancing, intelligent cdn caching, regular backups, properly planned upgrade/maintenance and traffic/utilization optimization planning, a regional disaster recovery should bed as easy as a click of a few pre-configured fail-over automation tools.

○ How the implementation complies with best practices (AWS Well Architected
Framework or Google Cloud Architecture Framework.):  

■ My solution recommendation addresses all 11 of both Amazon and Google pillars of architecture best practices.  

■ Amazon 5 pillars: Security, Reliability, Performance, Efficiency, Cost Optimization	

■ Google 6 pillars: System design, Security, Privacy & Compliance, Reliability, Performance, Cost Optimization

