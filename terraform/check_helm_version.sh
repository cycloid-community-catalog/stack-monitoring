#!/bin/bash

# Define colors for use in output messages
RED='\033[0;31m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
NC='\033[0m' # No Color

if [ $# -eq 0 ]; then
  FILES=$(ls k8s/*/helm*.tf)
else
  FILES=$1
  VERSION=$2

  # only check 1 dir such staging
  if [[ ! $FILES == *.tf ]]; then
    FILES=$(ls $1/*/helm*.tf)
  fi

  # $0 <foo/helm.tf> <version to get>
fi

#
# Check TF module #
#
echo -e "${Blue}Terraform modules"

# Check EKS module
TERRAFORM_MODULES=$(curl -s https://api.github.com/repos/terraform-aws-modules/terraform-aws-eks/releases/latest | jq -r '.tag_name')
echo -e "${Yellow}  terraform-aws-modules/eks module:${NC}"
for tffile in $(grep -rn -E "source.*terraform-aws-modules/eks" . | grep -v \.sh| sed 's/:.*//'| awk '{print $1}');do
  tffile_version=$(grep -E "source.*terraform-aws-modules/eks" $tffile -A1 | grep version | sed -E 's/[^0-9]+([0-9][0-9\.]+).*/\1/')
  if [ "v$tffile_version" != "$TERRAFORM_MODULES" ]; then
    echo -e "${RED}    found in $tffile: $tffile_version vs $TERRAFORM_MODULES ${NC}"
  else
    echo -e "${NC}    found in $tffile: $tffile_version vs $TERRAFORM_MODULES ${NC}"
  fi
done

# Check VPC module
TERRAFORM_MODULES=$(curl -s https://api.github.com/repos/terraform-aws-modules/terraform-aws-vpc/releases/latest | jq -r '.tag_name')
echo -e "${Yellow}  terraform-aws-modules/vpc module:${NC}"
for tffile in $(grep -rn -E "source.*terraform-aws-modules/vpc" . | grep -v \.sh | sed 's/:.*//'| awk '{print $1}');do
  tffile_version=$(grep -E "source.*terraform-aws-modules/vpc" $tffile -A1 | grep version | sed -E 's/[^0-9]+([0-9][0-9\.]+).*/\1/')
  if [ "v$tffile_version" != "$TERRAFORM_MODULES" ]; then
    echo -e "${RED}    found in $tffile: $tffile_version vs $TERRAFORM_MODULES ${NC}"
  else
    echo -e "${NC}    found in $tffile: $tffile_version vs $TERRAFORM_MODULES ${NC}"
  fi
done

rm /tmp/charts -rf
# clean repo
# for i in $(helm repo list | awk '{print $1}');do helm repo remove $i;done
# make sure local repo updated
helm repo update 2>/dev/null
# Loop through each file in the current directory ending with "helm.tf"

# helm repo rm  $(helm repo list | awk '{print $1}' | grep -v NAME)
for helm in $FILES;do
  echo -e "${Blue}$helm"
  helm_path=$(echo $helm | sed -E 's/[^\/]+$//')
  repository=$(grep -E "^[ ]+repository[^=:alpha:]+=" $helm | head -n1 | awk '{print $3}' | sed 's/"//g')
  chart=$(grep -E "^[ ]+chart[^=:alpha:]+=" $helm | head -n1 | awk '{print $3}' | sed 's/"//g')
  name=$(grep -E "^[ ]+name[^=:alpha:]+=" $helm | head -n1 | awk '{print $3}' | sed 's/"//g')
  version=$(grep -E "^[ ]+version[^=:alpha:]+=" $helm | head -n1 | awk '{print $3}' | sed 's/"//g')
  #values_path=$(grep -E "#VALUES: " $helm | awk '{print $2}')
  local_values=$(grep -E "file.*values([-_]?.*)?.yaml" $helm | sed 's/.*\///;s/\.yaml.*/\.yaml/')
  echo $local_values
  if [ "$local_values" == "" ]; then
    local_values="values.yaml"
  fi
  # Print the chart details
  echo -e "${Yellow}  Chart:${NC} $chart"
  echo -e "${Yellow}  Repository:${NC} $repository"
  echo -e "${Yellow}  Installed version:${NC} $version"

  if [ "$(echo $chart | grep ^oci:)" != "" ]; then
    # OCI repo doesn't support search yet (https://github.com/helm/helm/issues/11000)
    latest_version=$(helm show chart $chart 2>/dev/null | grep version: | tail -n1 | awk '{print $2}')
  else
    # Add the chart repository and get the latest version of the chart from the repository
    helm repo add $chart $repository > /dev/null 2>&1
    latest_version=$(helm search repo --regexp "\v$chart/$chart\v" -o json 2> /dev/null| jq -r '.[].version' | sed 's/v//')
  fi

  echo -e "${Yellow}  Upstream version:${NC} $latest_version"

  # Check if the installed version is the latest version, and if not, print a warning message
  Yellow='\033[0;33m'
  if [ "$version" != "$latest_version" ]; then
      echo -e "${RED}  [Need to be updated]${NC}"

      # Get values from release
      chart_path=$name
      if [ "$(echo $chart | grep ^oci:)" != "" ]; then
        mkdir -p /tmp/charts/$chart_path
        helm pull $chart --untar -d /tmp/charts/$chart_path 2>/dev/null
      else
        mkdir -p /tmp/charts/$chart_path
        if [ "$VERSION" != "" ]; then
          # Get specific version
          helm pull $chart/$chart --version $VERSION --untar -d /tmp/charts/$chart_path 2>/dev/null
	else
          helm pull $chart/$chart --untar -d /tmp/charts/$chart_path 2>/dev/null
        fi
      fi

      # Download the latest values file for the chart from the given URL
      echo "  meld '$helm_path$local_values' '$(ls /tmp/charts/$chart_path/*/values.yaml)'"
      echo "  vim $helm"
  fi
  echo ""
done
