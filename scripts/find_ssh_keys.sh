#!/bin/bash
#set -x

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

function find_ssh_keys_in_projects () {
    for project in $(gcloud asset search-all-resources --scope organizations/${org_id} --asset-types=cloudresourcemanager.googleapis.com/Project --format json |jq -r '.[] | select(.state == "ACTIVE") | .additionalAttributes.projectId'); do
        if [[ $(gcloud compute project-info describe --project=$project --format json |grep ssh-keys) ]]; then
            echo "Project: $project has SSH keys in metadata"
        fi
    done
}

function find_ssh_keys_in_compute () {
    for project in $(gcloud asset search-all-resources --scope organizations/${org_id} --asset-types=cloudresourcemanager.googleapis.com/Project --format json |jq -r '.[] | select(.state == "ACTIVE") | .additionalAttributes.projectId'); do
        for instance in $(gcloud compute instances list --project=${project} --format json | jq -r '.[].name'); do
            if [[ $(gcloud compute instances list --project $project --filter="name=('$instance')" --format=json |grep ssh-keys) ]]; then
                echo "Compute: $instance in $project has SSH keys in metadata"
            fi
        done
    done
}


find_ssh_keys_in_projects
find_ssh_keys_in_compute
