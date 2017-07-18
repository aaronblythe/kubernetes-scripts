orig_dir=$PWD

cd
cd Downloads
./google-cloud-sdk/install.sh

# Need to start another tab in terminal
# I was able to simply re-run
gcloud init

# Need to wait a few minutes for creation
gcloud compute instances list

echo "You will have to enable the Google Compute Engine API in the Console and accept billing for your project"

cd $orig_dir
