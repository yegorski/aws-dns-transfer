.DEFAULT_GOAL := help

help: ## Shows this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

accept-domain-transfer: ## Accepts domain transfer. Run in destination AWS account after initiating the transfer via `transfer-domain`.
	./dns.bash accept-domain-transfer $(DOMAIN_NAME) '$(value PASSWORD)'

get-domain: ## Gets `DOMAIN_NAME` domain details.
	./dns.bash get-domain $(DOMAIN_NAME)

import-records: ## Creates DNS records listed in `RECORDS_FILE` in `ZONE_ID` zone.
	./dns.bash import-records $(ZONE_ID) $(RECORDS_FILE)

initiate-domain-transfer: ## Transfers `DOMAIN_NAME` to `DESTINATION_ACCOUNT_ID` using `contact.json` details.
	./dns.bash initiate-domain-transfer $(DESTINATION_ACCOUNT_ID) $(DOMAIN_NAME)

list-domains: ## Lists Route53 Domains.
	./dns.bash list-domains

list-records: ## Outputs to `DOMAIN_NAME`.json file `ZONE_ID` DNS Zone records.
	./dns.bash list-records $(ZONE_ID) $(DOMAIN_NAME)

list-zones: ## Prints to the screen Route53 DNS Zones.
	./dns.bash list-zones

update-contact: ## Updates `DOMAIN_NAME` domain contact details with the contents of `DOMAIN_CONTACT` file.
	./dns.bash update-contact $(DOMAIN_NAME) $(DOMAIN_CONTACT)

.PHONY: help
