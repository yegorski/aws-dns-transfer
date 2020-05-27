#!/usr/bin/env bash

set -eo pipefail

accept-domain-transfer() {
    declare domain_name="${1}"
    declare password="${2}"
    aws route53domains accept-domain-transfer-from-another-aws-account \
        --domain-name ${domain_name} \
        --password "${password}"
}

get-domain() {
    declare=domain_name"${1}"
    aws route53domains get-domain-detail --domain-name ${domain_name} > ${domain_name}.json
}

import-records() {
    declare zone_id="${1}"
    declare records_file="${2}"
    aws route53 change-resource-record-sets --hosted-zone-id ${zone_id} --change-batch file://$(PWD)/imported_records/${records_file}
}

initiate-domain-transfer() {
    declare destination_account_id="${1}"
    declare domain_name="${2}"
    aws route53domains transfer-domain-to-another-aws-account \
        --domain-name ${domain_name} \
        --account-id ${destination_account_id}
}

list-domains() {
    aws route53domains list-domains
}

list-records() {
    declare zone_id="${1}"
    declare domain_name="${2}"
    aws route53 list-resource-record-sets --hosted-zone-id ${zone_id} > imported_records/${domain_name}.json
}

list-zones() {
    aws route53 list-hosted-zones
}

update-contact() {
    declare domain_name="${1}"
    declare contact_file="${2}"
    # TODO: use the passed-in contact.json file
    aws route53domains update-domain-contact --domain-name ${domain_name} \
        --admin-contact FirstName=Yegor,LastName=Ius \
        --tech-contact FirstName=Yegor,LastName=Ius
}

"$@"
