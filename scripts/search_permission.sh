#!/bin/bash
#set -x
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[[ "$#" -ne 2 ]] && { echo "Usage : `basename "$0"` --dns-domain <your_dns_domain>"; exit 1; }
[[ "$1" = "--dns-domain" ]] &&  export org_name=$2

export org_id=$(gcloud organizations list --format=[no-heading] | grep ^${org_name} | awk '{print $2}')
export permission="iam.serviceAccounts.actAs"

function search-all-permissions () {
    gcloud asset analyze-iam-policy --organization=${org_id}  --permissions="${permission}" --format json | jq -r '.[] | .ACLs[] | [.accesses[].permission, .identities[].name, .resources[].fullResourceName] | join (",")'|sed 's/serviceAccount://g ; s/user://g ; s/\/\/cloudresourcemanager.googleapis.com\/projects\///g' |sort -u
}

search-all-permissions
