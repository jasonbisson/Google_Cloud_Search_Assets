# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "content_types" {
    description = "Content types for asset feed"
    type = list(string)
    default = [ "CONTENT_TYPE_UNSPECIFIED", "RESOURCE", "IAM_POLICY", "ORG_POLICY", "ACCESS_POLICY"]
}

variable "project_id" {
  description = "Project whose identity will be used for sending the asset change notifications. "
}

variable "domain" {
  description = "DNS Domain for GCP Organization"
}

variable "asset_feed" {
  description = "PubSub Topic for real time asset updates"
  default = "asset_feed"
} 
