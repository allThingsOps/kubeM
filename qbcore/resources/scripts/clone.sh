#!/bin/sh

echo ' -------------- Starting Cloning Process ----------------- '
mkdir -p /repo/clone >/dev/null 2>&1
git clone https://"${GIT_USERNAME}":"${GIT_PASS}"@dev.azure.com/pushingstart/BayCity%20Roleplay/_git/scripts-so /repo/clone >/dev/null 2>&1
#rm -r /config/resources > /dev/null 2>&1
cp -r -f /config/clone/* /config/resources >/dev/null 2>&1
echo ' -------------- Cloning Process Finished ----------------- '
