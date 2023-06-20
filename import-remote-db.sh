#!/bin/bash

# Check readme file for details
# - make sure you have set correct values in .env file
#
# Example .env file
#
# ENV_TEST_HOST="webshoptest.hypernode.io"
# ENV_STAGING_HOST="webshopacc.hypernode.io"
# ENV_PRODUCTION_HOST="webshop.hypernode.io"
# TARGET_DB="webshop"
#

# Clear screen
clear

# Set terminal colors
ORANGE='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Set default env values, these will be used when they are not set in the .env
ENV_TEST_ROOT_PATH="/data/web/project/current/"
ENV_STAGING_ROOT_PATH="$ENV_TEST_ROOT_PATH"
ENV_PRODUCTION_ROOT_PATH="$ENV_TEST_ROOT_PATH"
MAGERUN_DB_STRIP="@stripped @trade @search"
MAGERUN_BIN="magerun2"

# Source the .env file to read environment variables
. .env

# Echo current config settings on screen
echo -e "== IMPORT SOURCE =="
echo -e ""
echo -e "1) TEST Environment"
echo -e "   Host:                   ${ORANGE}$ENV_TEST_HOST${NC}"
echo -e "   Project root path:      ${ORANGE}$ENV_TEST_ROOT_PATH${NC}"

echo -e "2) STAGING Environment"
echo -e "   Host:                   ${ORANGE}$ENV_STAGING_HOST${NC}"
echo -e "   Project root path:      ${ORANGE}$ENV_STAGING_ROOT_PATH${NC}"

echo -e "3) PRODUCTION Environment"
echo -e "   Host:                   ${ORANGE}$ENV_PRODUCTION_HOST${NC}"
echo -e "   Project root path:      ${ORANGE}$ENV_PRODUCTION_ROOT_PATH${NC}"

echo -e "Magerun settings"
echo -e "   Strip:                  ${ORANGE}$MAGERUN_DB_STRIP${NC}\n"

# Read user selection
read -r -p "Choose environment to import from: " ENVIRONMENT_TO_IMPORT_FROM

# Clear screen
clear

# Set variables based on user selection
if [[ ENVIRONMENT_TO_IMPORT_FROM -eq 1 ]]
then
    echo -e "\nYou chose option 1.\n"
    HOST="$ENV_TEST_HOST"
    ROOT_PATH="$ENV_TEST_ROOT_PATH"

elif [[ ENVIRONMENT_TO_IMPORT_FROM -eq 2 ]]
then
    echo -e "\nYou chose option 2.\n"
    HOST="$ENV_STAGING_HOST"
    ROOT_PATH="$ENV_STAGING_ROOT_PATH"
elif [[ ENVIRONMENT_TO_IMPORT_FROM -eq 3 ]]
then
    echo -e "\nYou chose option 3.\n"
    HOST="$ENV_PRODUCTION_HOST"
    ROOT_PATH="$ENV_PRODUCTION_ROOT_PATH"
else
    echo -e "Invalid selection, choose 1, 2 or 3"
    echo -e "Exiting"
    exit
fi

echo -e "== IMPORT TARGET =="
echo -e ""

# Read user selection
read -r -p "Database name to import to? [$TARGET_DB]: " TARGET_DB_INPUT
TARGET_DB=${TARGET_DB_INPUT:-$TARGET_DB}

# Clear screen
clear

echo -e "== SETTINGS OVERVIEW =="
echo -e ""

echo -e "You entered: ${ORANGE}$TARGET_DB${NC}"
echo -e ""

# Present user selection config
echo -e "Importer will use below settings. Do you want to proceed?"
echo -e "   Host:                   ${ORANGE}$HOST${NC}"
echo -e "   Project root path:      ${ORANGE}$ENV_TEST_ROOT_PATH${NC}"
echo -e "   Target db to import to: ${ORANGE}$TARGET_DB${NC}"
echo -e "   Magerun settings:       ${ORANGE}$MAGERUN_DB_STRIP${NC}\n"

# Read user selection
echo -e "${RED}WARNING, PROCEEDING WILL OVERWRITE DATA IN THE TARGET DATABASE${NC}\n"
read -r -p "Are you sure you want to proceed? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo -e "Ok, let's proceed..."
        ;;
    *)
        echo -e "Type y or yes to proceed."
        echo -e "Exiting"
        exit
        ;;
esac

# Do the actual import over SSH
echo -e "Doing import...\n"
ssh $HOST "cd $ROOT_PATH && $MAGERUN_BIN db:dump --compression='gzip' --strip='"$MAGERUN_DB_STRIP"' --stdout" | gunzip | pv | mysql $TARGET_DB
