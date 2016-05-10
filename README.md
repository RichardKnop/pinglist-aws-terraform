[1]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair
[2]: http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html

# Pinglist AWS Terraform

Terraform manifests to build Pinglist AWS infrastructure.

# Index

* [Pinglist AWS Terraform](#pinglist-aws-terraform)
* [Index](#index)
* [Requirements](#requirements)
  * [Git Submodules](#git-submodules)
  * [Requirements For AWS Provisioning](#requirements-for-aws-provisioning)
    * [Hosted DNS Zone](#hosted-dns-zone)
    * [S3 Bucket For Releases](#s3-bucket-for-releases)
    * [Environment Variables](#environment-variables)
    * [SSL Certificate](#ssl-certificate)
    * [Register Your Mobile App With AWS](#register-your-mobile-app-with-aws)
      * [iOS](#ios)
* [Provisioning](#provisioning)
  * [Variables](#variables)
  * [Apply Execution Plan](#apply-execution-plan)
  * [Connecting To Instances](#connecting-to-instances)
  * [Debugging](#debugging)
  * [Recreate Database](#recreate-database)
* [Resources](#resources)

# Requirements

You need Terraform >= 0.6.9, e.g.:

```
brew install terraform
```

You need an SSH key. The private key needs to be chmod to 600.

You need the cloud provider credentials. These will be entered on the command line.

## Git Submodules

Some resources created by Terraform are provisioned using Ansible. The `github.com/RichardKnop/pinglist-ansible` repository has been added as a git submodule. Make sure to initialise git submodiles.

```
git submodule init
git submodule update
```

## Requirements For AWS Provisioning

### Hosted DNS Zone

A hosted DNS zone on AWS has been manually created and its ID stored in `variables.tf`.

### S3 Bucket For Releases

An S3 bucket has been manually created to store releases (Docker builds). This bucket is common for all environments and is configurable via `release_bucket` variable.

### Environment Variables

The terraform provider for AWS will read the standard AWS credentials environment variables. You must have these variables exported:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`

You can get the credentials from the AWS console.

Terraform will look for a deployment key in `~/.ssh` directory when creating a NAT instance. Add the deployment key to the ssh-agent, e.g.:

```
ssh-add ~/.ssh/stage-pinglist-deployer
```

### SSL Certificate

An SSL certificate for `*.pingli.st` has been purchased from [Comodo](https://www.comodo.com/).

Richard Knop has the private key. Keep it secure, only transfer GPG encrypted if needed.

Comodo has then provided the certificate itself in a ZIP file which consists of:

- certificate (`STAR_pingli_st.crt`)
- intermediate and root Comodo certificates

AWS only supports PEM format of certificates so first, we needed to convert the private key and all certificates to the correct format:

```
openssl x509 -inform PEM -in pinglist.key > pinglist-key.pem
openssl x509 -inform PEM -in STAR_pingli_st.crt > STAR_pingli_st.pem
openssl x509 -inform PEM -in COMODORSADomainValidationSecureServerCA.crt > COMODORSADomainValidationSecureServerCA.pem
openssl x509 -inform PEM -in COMODORSAAddTrustCA.crt > COMODORSAAddTrustCA.pem
openssl x509 -inform PEM -in AddTrustExternalCARoot.crt > AddTrustExternalCARoot.pem
```

Secondly, we generated a certificate chain from intermediate and root certificates one by one using `cat` command:

```
cat COMODORSADomainValidationSecureServerCA.pem COMODORSAAddTrustCA.pem AddTrustExternalCARoot.pem > pinglist-certificate-chain.pem
```

Finally, we uploaded the certificate to AWS IAM:

```
aws iam upload-server-certificate --server-certificate-name pinglist-certificate \
--certificate-body file://STAR_pingli_st.pem --private-key file://pinglist-key.pem \
--certificate-chain file://pinglist-certificate-chain.pem
```

Result:

```json
{
  "ServerCertificateMetadata": {
    "ServerCertificateId": "ASCAIRNGM2AA5Z4HA5TUQ",
    "ServerCertificateName": "pinglist-certificate",
    "Expiration": "2017-04-23T23:59:59Z",
    "Path": "/",
    "Arn": "arn:aws:iam::800222191807:server-certificate/pinglist-certificate",
    "UploadDate": "2016-04-23T17:58:23.272Z"
  }
}
```

`Arn` attribute is used as `ssl_certificate_id` for HTTPS listener in the ELB.

### Register Your Mobile App With AWS

For Amazon `SNS` to send notification messages to mobile endpoints, whether it is direct or with subscriptions to a topic, you first need to [register the app with AWS](http://docs.aws.amazon.com/sns/latest/dg/mobile-push-send-register.html).

#### iOS

For iOS, you will need:

- APNS SSL certificate
- app private key

To convert the APNS SSL certificate from `.cer` format to `.pem` format, type the following command. Replace `myapnsappcert.cer` with the name of the certificate you downloaded from the Apple Developer web site.

```
openssl x509 -in myapnsappcert.cer -inform DER -out myapnsappcert.pem
```

To convert the app private key from `.p12` format to `.pem` format, type the following command. Replace `myapnsappprivatekey.p12` with the name of the private key you exported from Keychain Access.

```
openssl pkcs12 -in myapnsappprivatekey.p12 -out myapnsappprivatekey.pem -nodes -clcerts
```

OpenSSL will ask you for a passphrase.

Then, you can go to AWS console, navigate to SNS home and create a new platform application for Apple. You will need both the APNS certificate and private key created above as well as the original `.p12` private key and the passphrase.

Save the application ARN, for example:

```
arn:aws:sns:us-west-2:800222191807:app/APNS_SANDBOX/pinglist-ios-stage
```

Or:

```
arn:aws:sns:us-west-2:800222191807:app/APNS/pinglist-ios-prod
```

The ARN is needed to create endpoints.

# Provisioning

Make sure submodules are up-to-date:

```
git submodule update --remote
```

Render an SSH configuration file, i.e.:

```
./render-ssh-config.sh <env-name-prefix>
```

Create virtual Python environment for `pinglist-ansible` submodule:

```
virtualenv .venv
source .venv/bin/activate
pip install -r ansible/requirements.txt
```

## Variables

You will need to export couple of needed environment variables.

Most importantly, define an environment name, e.g.:

```
export TF_VAR_env=stage
```

Or:

```
export TF_VAR_env=prod
```

Setup ETCD discovery URL:

```
export TF_VAR_etcd_discovery_url=$(./get-etcd-discovery-url-from-state-file.sh $TF_VAR_env)
```

Or if you are deploying for the first time, generate a new ETCD discovery URL:

```
export TF_VAR_etcd_discovery_url=`curl https://discovery.etcd.io/new?size=1`
```

Setup APNS platform application ARN:

```
export TF_VAR_apns_platform_application_arn=$(cd ansible ; ./get-vault-variable.sh $TF_VAR_env apns_platform_application_arn)
```

For test environments, it's useful to disable final DB snapshot:

```
export TF_VAR_rds_skip_final_snapshot=true
```

Export the main DB password from the `ansible-vault`:

```
export TF_VAR_db_password=$(cd ansible ; ./get-vault-variable.sh $TF_VAR_env api_database_password)
```

Define which API release you want to use:

```
export TF_VAR_api_release=v0.0.0
```

Define which web app release you want to use:

```
export TF_VAR_app_release=v0.0.0
```

See `variables.tf` for the full list of variables you can set.

## State Files

We need to support multiple environments (`stage`, `prod` etc) and share state files across the team. Therefor state files include environment suffix and their encrypted versions are stored in git.

First, decrypt a state file you want to use:

```
./decrypt-state-file.sh $TF_VAR_env
```

The above script would decrypt `$TF_VAR_env.tfstate.gpg` to `$TF_VAR_env.tfstate`.

After running Terraform, don't forget to update the encrypted state file:

```
./encrypt-state-file.sh $TF_VAR_env
```

## Apply Execution Plan


First, check the Terraform execution plan:

```
terraform plan -state=$TF_VAR_env.tfstate
```

Now you can provision the environment:

```
terraform apply -state=$TF_VAR_env.tfstate
```

**IMPORTANT**: The option `-var force_destroy=true` will mark all the resources, including S3 buckets to be deleted when destroying the environment. This is fine in test environments, but dangerous in production.

So, you could provision a test environment like this:

```
terraform apply -state=$TF_VAR_env.tfstate -var force_destroy=true
```

## Connecting To Instances

Now you can SSH to instances in a private subnet of the VPS via the NAT instance, e.g.:

```
ssh -F ssh.config <private_ip>
```

## Debugging

Once you have connected to a CoreOS node, you can use `systemctl` to check status of services:

```
systemctl pinglist-api.service
```

To view logs specific to a service running as a Docker container, use `journalctl`:

```
journalctl -u pinglist-api.service -n 100 -f
```

## Recreate Database

NEVER do this against production environment.

Sometimes during development it is useful or needed to destroy and recreate the database. You can use `taint` command to mark the database instance for destruction. Next time you run the `apply` command the database will be destroyed and a new once created:

```
terraform taint -module=rds -state=$TF_VAR_env.tfstate aws_db_instance.rds
```

# Resources

- [Creating EC2 Key Pairs][1]
- [Create a Public Hosted Zone][2]
