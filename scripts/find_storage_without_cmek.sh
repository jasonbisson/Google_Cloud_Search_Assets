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

if [ $# -ne 1 ]; then
    echo $0: usage: Requires argument of Organizational name e.g.   your_dns_domain.com
    exit 1
fi

export org_name=$1
export org_id=$(gcloud organizations list --format=[no-heading] | grep ^${org_name} | awk '{print $2}')


function check_variables () {
    if [  -z "$org_id" ]; then
        printf "ERROR: GCP organization id is not set.\n\n"
        printf "To check if you have Organizational rights: gcloud organizations list\n\n"
        printf "Or $org_name has a typo which would impact the lookup for the Organizational ID\n\n"
        exit
    fi
}


function storage_kms_key () {
    gcloud asset search-all-resources --scope=organizations/${org_id} --asset-types='storage.googleapis.com/Bucket' --format='csv(name, assetType, kmsKey)'
    gcloud asset search-all-resources --scope=organizations/${org_id} --asset-types='compute.googleapis.com/Disk' --format='csv[no-heading](name, assetType, kmsKey)'
    gcloud asset search-all-resources --scope=organizations/${org_id} --asset-types='bigquery.googleapis.com/Table' --format='csv[no-heading](name, assetType, kmsKey)'
}

check_variables
storage_kms_key
