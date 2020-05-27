# AWS DNS Transfer

Scripts to transfer AWS Route53 Domains and DNS Zones between AWS accounts.

## Setup

Install `aws-okta` as it is needed to interact between source and destination AWS accounts.

## Usage

```bash
make help
```

`example.com` domain is used in the examples below.

### Transfer Domain

1. Get domain details:

   ```bash
   aws-okta exec account_a -- make get-domain DOMAIN_NAME=example.com
   ```

1. (Optional) Inspect the resulting `example.com.json` file. Copy the `AdminContact` details into the `contact.json` file.
1. (Optional) Update the contact details if needed.
1. Initiate the transfer on the source AWS account:

   ```bash
   aws-okta exec account_a -- make initiate-domain-transfer DESTINATION_ACCOUNT_ID=<ACCOUNT_ID> DOMAIN_NAME=example.com
   ```

1. Copy the password in the output.
1. Accept the transfer on the destination AWS account:

   ```bash
   aws-okta exec account_b -- make accept-domain-transfer DOMAIN_NAME=example.com PASSWORD='<PASSWORD>'
   ```

1. (Optional) Update domain contact information on the destination AWS account:

   ```bash
   aws-okta exec account_b -- make update-contact DOMAIN_NAME=example.com DOMAIN_CONTACT=contact.json
   ```

Note the the Registrant contact (which controls the actual domain ownership) cannot be changed programmatically. Registrant contaact must be changed manually in the AWS Console. After you transfer ownership, you'll receive a confirmation email. Follow the steps in the email.

### Transfer DNS Zone

1. Create a new DNS Zone in the destination `account_b`.
1. Go to the `example.com` DNS Zone.
1. Copy the 4 `NS` records.
1. Go to <https://console.aws.amazon.com/route53/home?region=us-east-1#DomainDetail:example.com>.
1. Replace the `Name servers` on the right with copied values.

### Transfer DNS Zone Records

1. Get all records from the zone in the source AWS account:

   ```bash
   aws-okta exec account_a -- make list-records ZONE_ID=<ZONE_ID> DOMAIN_NAME=example.com
   ```

1. Delete the `NS` and `SOA` records from the file.
1. Edit the resulting `example.com.json` file in the way described in [Migrating a hosted zone to a different AWS account](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-migrating.html) AWS docs.
1. Use the edited to create the records in the destination AWS account:

   ```bash
   aws-okta exec account_b -- make import-records ZONE_ID=<ZONE_ID> RECORDS_FILE=example.com.json
   ```
