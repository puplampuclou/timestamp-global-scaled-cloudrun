<h1><b>Google Cloud Platform, GitHub, and Terraform Cloud CI/CD Pipeline Timestamp Exercise Deployment ReadMe</b></h1>

The purpose of this exercise was to design and deploy a timestamp generator that updates a storage object in a storage bucket, every 10 minutes, and that timestamp be available via curl and browser.

The following web links are available for your viewing.

<b>HTTP PORT 80 URL:</b>  http://34.147.3.6/

<b>HTTPS/TLS/SSL PORT 443 URL:</b> https://timestamps.puplampu.me/

<b>HTTP PORT 80 URL:</b>  http://34.147.3.6/timestamps.html

<b>HTTPS/TLS/SSL PORT 443 URL:</b> https://timestamps.puplampu.me/timestamps.html

<b>GitHub Repo of Terraform Code:</b>  https://github.com/puplampuclou/timestamp-global-scaled-cloudrun/edit/main/terraform/

<b>GitHub Repo of the Cloud Run Global Scaled Deployment Timestamp Solution:</b>  https://github.com/puplampuclou/timestamp-global-scaled-cloudrun/tree/main

<b>STATUS:</b>  COMPLETE

■ Diagram of the above implementation:

                                +-----------------+
                                |  Internet       |
                                +-----------------+
                                           |
                                           |
                                           v
                                +-----------------+
                                | Firewall and    |
                                | NAT             |
                                +-----------------+
                                           |
                                           |
                                           v
                                +-----------------+
                                | Compute Engine  |
                                |     VM          |
                                | (Web Server)    |
                                +-----------------+
                                           |
                                           |
                                           v
                                +-----------------+
                                | Cloud Storage   |
                                |      Bucket     |
                                +-----------------+
<b>This README contains:</b>

■ <b>Description of repo folders/structure:</b>  This is a single folder respository with two terraform files, the main.tf and the provider.tf files, which are all you need to deploy the storage bucket and server to Google Cloud.  This is not the folder or repo that I have integrated with Terraform Cloud Workspaces.  This is a copy of the files in the private gcp-puplampu repository https://github.com/puplampuclou/gcp-puplampu that I have authenticated and directly integrated with Terraoform Cloud CI/CD pipeline.  All of the otherwise local dependencies and versioning is not necessary or allowed in this directory, as its all managed remotely by TFC.  This decision was made as its easier to maintain, is more stable and more aligned with how an enterprise repository CI/CD Pipeline would be setup.  Access granted upon request.

■ <b>Deployment instructions and dependencies
Prerequisite:</b>
1. Github Oauth Integration with Terraform Cloud Workspace:  https://developer.hashicorp.com/terraform/tutorials/cloud/github-oauth
2. Terraform Cloud Integration with Google Cloud API: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference

■ <b>Files:</b>

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

■ <b>Tear-down instructions</b>

In order to tear everything down, you simply delete the content in the main.tf file (NOTE:  NOT THE FILE ITSELF) and run the pipeline apply to complete the removal of all devices this particular tf file created.

<b>○ Why the services/components were chosen over alternatives:</b>  I chose Google Cloud because I know it well and I believe it is more secure and has better quality services.  I chose to use Terraform Cloud because it is very secure, you don't have to save any credentials, key variables, or variable files locally in the repo (ssl, certs and service account json keys) are all stored in a TFC variable secured key vault) 

<b>○ How the cost of the implementation scales as traffic increases:</b>  The cost will vary between these two main factors:

1. Dedicated infrastructure, gke or instance groups will have a higher cost regardless of how much traffic, and when deployed at scale in different regions, will be a significant fixed monthly cost.  However, this increased fixed monthly costs has lower usage, traffic and peak volume cost.

2.  Serverless event driven architected solutions have a low fixed monthly cost, and most of your infrastructure is not running when there is no traffic.  However, when there are occasional peaks, this solution shines.  Its when you have a consistently high levels of daily traffic and usage that you will pay a premium.
  
4.  I believe the answer to this question will depend on your traffic and usage patturns.  Consistently guaranteed amount of traffic should be deployed on dedicated infrastructure and for excess and occasional peak traffic, you sould leverage serverless event-driven infrastructure.

<b>○ How to monitor the implementation for availability and performance:</b>  Google Cloud Monitoring, Promethius, Splunk, Dynatrace, Elastistach and many other such solution choices all boil down to cost.  Which solution can we deploy and maintain at the lowest cost.  In my opinion, they are all options that depending on how you use them, negotiate licensing costs and architect it, can all be provide good value at good pricepoints.  Some have pretier and are more user friendly than others, but the most important thing is logging events, metrics and data and processing and storing it at minimum cost.  Observability is best leveraged at all API proxy/gateway interfaces/flows, mobile app interfaces, public facing edge, kubernetes api, and back-end data access points. 

<b>○ How to recover from a regional disaster and impact to end users:</b>  Both the event-driven, gke and in some cases regular instance gorups (depending on usecase) or a combination of both gke and event-driven, they can be deployed and designed with multi-region redundancy, strong site reliability and security best practices can ensure a high level or resiliance and fast recovery of service.  With good SRE/Security best practices architecture in place, global load balancing, intelligent cdn caching, regular backups, monitoring, properly planned upgrade/maintenance SOPs and traffic/utilization optimization planning, a disaster recovery process should be as easy as a click of a few pre-configured fail-over automation tools.  I am also a believer in not putting all your eggs in one gasket.  I believe in a flexible multi-cloud/on-prem/hybrid cost-basis architecture strategy.

<b>○ How the implementation complies with best practices (AWS Well Architected
Framework or Google Cloud Architecture Framework.):</b>  

■ My solution recommendation addresses all 11 of both Amazon and Google pillars of architecture best practices.  The flexible multi-cloud/on-prem/hybrid cost-basis architecture strategy is similar to the Bruce Lee quote, "“Empty your mind, be formless. Shapeless, like water. If you put water into a cup, it becomes the cup. You put water into a bottle and it becomes the bottle. You put it in a teapot, it becomes the teapot. Now, water can flow or it can crash. Be water, my friend.”  

I am a minimalist.  Like Bruce Lee, I believe in being flexible and agile.  I have seen first hands what happens if you don't (or do) implement real SRE, Secure and API first Foucsed soluitons.  It is critical to test, validate, monitor, and repeat that through out the entire SDLC of applications.  I know first hand from years of trial and error how important feedback from security, bussiness, developers, and consumers is to the success of an application.  And ultimately, the endgame is a good experience and product for the customers that pay us.  Everything else should support the success of that!

■ <b>Amazon 5 pillars:</b> Security, Reliability, Performance, Efficiency, Cost Optimization	

■ <b>Google 6 pillars:</b> System design, Security, Privacy & Compliance, Reliability, Performance, Cost Optimization

