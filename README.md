# Import remote database script

Goal and purpose of this script is to easily import a database from a remote server. This is build and tested for Magento 2 stores.

## Benefits

- Make specific configurations for projects by using its own .env file. E.g. add prod and staging sites
- Strip huge tables when not needed with a configuration option (For instance, I was stripping `experius_emailcatcher` table manually for a project before I build this).
- It is tailored for our hosting partner Hypernode, but with minor adjustments it should work on any hosting platform
- Open source, so one can add custom functionality when needed
- Stable enough to use on a daily basis (only tested by me so far though :-))

## Inner workings

Essentially it just dumps database for remote Magento 2 installation with n98-magerun (https://github.com/netz98/n98-magerun2). The data is compressed and piped trough stdout and over SSH to the local machine.

## Prepare for use 

- place this script in for example `<magento root>/scripts/import-remote-db/`
- exclude it from repo by adding it to `.gitignore` for everyone or to `.git/info/exclude` only for yourself
- Use below variables in .env file alongside the `./import-remote-db.sh` script
- Make ./import-remote-db.sh executable `$ chmod +x ./import-remote-db.sh`
- Make sure you have a SSH-agent running ```$ eval `ssh-agent` ```
- Make sure your key is loaded `$ ssh-add`
- Make sure you have access to the remote server with your SSH-key
- Make sure you use the right n98-magerun version (see below)

### Magerun version on Hypernodes

Check available Magerun versions by running `ll /usr/local/bin/magerun*` 

Example output:

``
app@s2ltrj-webshop-magweb-cmbl:~$ ll /usr/local/bin/magerun*
lrwxrwxrwx 1 root root 11 Aug 15  2022 /usr/local/bin/magerun -> n98-magerun
lrwxrwxrwx 1 root root 17 Dec 13  2022 /usr/local/bin/magerun2 -> /usr/bin/magerun2
lrwxrwxrwx 1 root root 21 Dec 13  2022 /usr/local/bin/magerun2-4.8.0 -> /usr/bin/magerun2-4.x
lrwxrwxrwx 1 root root 21 Dec 13  2022 /usr/local/bin/magerun2-5.0.0 -> /usr/bin/magerun2-5.x
lrwxrwxrwx 1 root root 21 Dec 13  2022 /usr/local/bin/magerun2-6.1.0 -> /usr/bin/magerun2-6.x
``

## Usage

- Run script `./import-remote-db.sh`

### Environment and configuration variables

Some variables have a default value.  

- ENV_TEST_HOST
- ENV_TEST_ROOT_PATH

- ENV_STAGING_HOST
- ENV_STAGING_ROOT_PATH

- ENV_PRODUCTION_HOST
- ENV_PRODUCTION_ROOT_PATH

- MAGERUN_DB_STRIP
- MAGERUN_BIN

### Strip database

Check https://github.com/netz98/n98-magerun2#stripped-database-dump

Default values are:

- @stripped @trade @search

## TODO

 - Make possible to run script form outside the root of directory (when tried it throws an error for not finding the `.env`)

## Authors

- Akif Gumussu (info@aquive.nl)
