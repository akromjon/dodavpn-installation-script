#!/bin/bash

install_pritunl(){

    systemctl stop pritunl.service

    sed -i '/BACKEND_API/d' /usr/lib/pritunl/usr/lib/python3.9/site-packages/pritunl/constants.py

    sed -i '/PRITUNL_TOKEN/d' /usr/lib/pritunl/usr/lib/python3.9/site-packages/pritunl/constants.py

    local base_url=$1

    local token=$2

    if [ -z "$base_url" ] || [ -z "$token" ]; then
        echo "Error: Missing required parameters: base_url and token"
        exit 1
    fi

    echo "BACKEND_API='$base_url/api/action'" >> /usr/lib/pritunl/usr/lib/python3.9/site-packages/pritunl/constants.py

    echo "PRITUNL_TOKEN='$token'" >> /usr/lib/pritunl/usr/lib/python3.9/site-packages/pritunl/constants.py

    wget -O /usr/lib/pritunl/usr/lib/python3.9/site-packages/pritunl/server/instance_com.py https://raw.githubusercontent.com/akromjon/pritunl/main/instance_com.py

    systemctl start pritunl.service
    
}


install_pritunl_integration() {
    # Define the URL of the file to download
    local file_url="https://github.com/akromjon/pritunl-integration/raw/main/os/linux/amd64"

    # Define the destination directory
    local destination_dir="/root/pritunl-integration/os/linux"

    # Create the destination directory if it doesn't exist
    mkdir -p "$destination_dir"

    # Navigate to the destination directory
    cd "$destination_dir" || exit

    # Download the file using curl
    curl -O "$file_url"

    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Download successful. File saved to $destination_dir"
    else
        echo "Error: Download failed."
    fi

    # Make the file executable

    chmod +x amd64
}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <base_url> <token>"
    exit 1
fi


install_pritunl $1 $2
install_pritunl_integration
