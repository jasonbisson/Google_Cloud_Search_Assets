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

[[ "$#" -ne 2 ]] && { echo "Usage : `basename "$0"` --project_id <Google Project ID>"; exit 1; }
[[ "$1" = "--project_id" ]] &&  export project_id=$2
how_far_back=5

function find_services_enabled () {
gcloud logging read "protoPayload.authorizationInfo.permission=serviceusage.services.enable AND protoPayload.response.service.state=ENABLED" \
--freshness=${how_far_back}d --project=${project_id} --format json | jq -r '.[].protoPayload.response.service.config.name' |sort -u 
}

find_services_enabled
