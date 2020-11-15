#!/bin/bash
set -x
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

[[ "$#" -ne 2 ]] && { echo "Usage : `basename "$0"` --identity <user@yourdomain.com or >"; exit 1; }
[[ "$1" = "--identity" ]] &&  export identity=$2
export project_id=$(gcloud config list --format 'value(core.project)')

function check_variables () {
    if [  -z "$project_id" ]; then
        printf "ERROR: GCP PROJECT_ID is not set.\n\n"
        printf "To update project config: gcloud config set project PROJECT_ID \n\n"
        exit
    fi
    
    if [  -z "$identity" ]; then
        printf "ERROR: user name is not set.\n\n"
        printf "Confirm permission with this command: gcloud organizations list \n\n"
        exit
    fi
}

function find_permissions () {
gcloud logging read "protoPayload.authenticationInfo.principalEmail=${identity}" --freshness=1d \
--project=${project_id} --format json | jq -r '.[].protoPayload | .authorizationInfo[]?.permission' |sort -u  
}

check_variables
find_permissions
