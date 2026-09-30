#!/bin/bash

# Get Mac serial number
serialNumber=$(/usr/sbin/ioreg -rd1 -c IOPlatformExpertDevice | \
    /usr/bin/awk -F'"' '/IOPlatformSerialNumber/{print $4}')

if [[ -z "$serialNumber" ]]; then
    echo "WARNING: Unable to determine serial number."
    echo "Skipping rename so Baseline can continue."
    exit 0
fi

newName="BOC-${serialNumber}"

echo "Serial Number: $serialNumber"
echo "Desired Name: $newName"

# Set all three macOS naming values
/usr/sbin/scutil --set ComputerName "$newName" 2>&1
/usr/sbin/scutil --set LocalHostName "$newName" 2>&1
/usr/sbin/scutil --set HostName "$newName" 2>&1

# Read values back
computerName=$(/usr/sbin/scutil --get ComputerName 2>/dev/null)
localHostName=$(/usr/sbin/scutil --get LocalHostName 2>/dev/null)
hostName=$(/usr/sbin/scutil --get HostName 2>/dev/null)

echo "ComputerName: $computerName"
echo "LocalHostName: $localHostName"
echo "HostName: $hostName"

if [[ "$computerName" == "$newName" ]]; then
    echo "SUCCESS: Mac renamed to $newName"
else
    echo "WARNING: Rename did not verify."
    echo "Expected: $newName"
    echo "Actual: $computerName"
    echo "Baseline will continue."
fi

# IMPORTANT:
# Naming should never block the entire provisioning workflow.
exit 0
