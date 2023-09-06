set -e
SA_EMAIL=$(gcloud iam service-accounts list --filter="displayName:gce-runner-sa" --format='value(email)')
TEMPLATE_NAME=gh-runner-template-t2d-$(date +%s)
INSTANCE_GROUP_NAME=runner-group-t2d-$(date +%s)

gcloud compute instance-templates create "$TEMPLATE_NAME" --provisioning-model=spot --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud --boot-disk-type=pd-ssd --boot-disk-size=10GB --machine-type=t2d-standard-32  --scopes=cloud-platform     --service-account=$SA_EMAIL --maintenance-policy=TERMINATE --metadata-from-file=startup-script=gce/startup.sh,shutdown-script=gce/shutdown.sh
gcloud compute instance-groups managed create "$INSTANCE_GROUP_NAME" --size=1 --base-instance-name=gce-runner --template=$TEMPLATE_NAME     --zone=us-central1-a