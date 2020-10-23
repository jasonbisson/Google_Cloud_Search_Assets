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


data "google_organization" "org" {
  domain = "${var.domain}"
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_cloud_asset_organization_feed" "organization_feed" {
  for_each        = toset(var.content_types)
  billing_project = var.project_id
  org_id          = tonumber(replace(tostring(data.google_organization.org.id), "organizations/", ""))
  feed_id         = "${each.value}"
  content_type    = "${each.value}"

  asset_types = [".*"]

  feed_output_config {
    pubsub_destination {
      topic = google_pubsub_topic.feed_output.id
    }
  }

  depends_on = [
    google_pubsub_topic_iam_member.cloud_asset_writer,
  ]
}

resource "google_pubsub_topic" "feed_output" {
  project = var.project_id
  name    = var.asset_feed
}


resource "google_pubsub_topic_iam_member" "cloud_asset_writer" {
  project = var.project_id
  topic   = google_pubsub_topic.feed_output.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudasset.iam.gserviceaccount.com"
}
