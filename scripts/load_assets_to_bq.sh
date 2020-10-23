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
export project_id=$(gcloud config list --format 'value(core.project)')

function check_variables () {
    if [  -z "$project_id" ]; then
        printf "ERROR: GCP PROJECT_ID is not set.\n\n"
        printf "To update project config: gcloud config set project PROJECT_ID \n\n"
        exit
    fi
    
    if [  -z "$org_id" ]; then
        printf "ERROR: GCP Organization id is not set.\n\n"
        printf "Confirm permission with this command: gcloud organizations list \n\n"
        exit
    fi
}

function resource () {
    gcloud asset export --content-type 'resource' --organization=${org_id} --bigquery-table=projects/${project_id}/datasets/assets/tables/RESOURCE --output-bigquery-force
}

function iam_policy () {
    gcloud asset export --content-type 'iam_policy' --organization=${org_id} --bigquery-table=projects/${project_id}/datasets/assets/tables/IAM_POLICY --output-bigquery-force
}

function org-policy () {
    gcloud asset export --content-type 'org-policy' --organization=${org_id} --bigquery-table=projects/${project_id}/datasets/assets/tables/ORG_POLICY --output-bigquery-force
}

function access-policy () {
    gcloud asset export --content-type 'access-policy' --organization=${org_id} --bigquery-table=projects/${project_id}/datasets/assets/tables/ACCESS_POLICY --output-bigquery-force
}

check_variables
resource
iam_policy
org-policy
access-policy



