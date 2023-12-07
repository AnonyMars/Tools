#!/bin/bash
SEARCH_DIR="/usr/share/wazuh-dashboard/plugins/"

# Define the list of search patterns
SEARCH_PATTERNS=(
    "agent.id"
    "agent.name"
    "agent.ip"
    "agent.hostname"
    "rule.id"
    "rule.level"
    "rule.description"
    "rule.groups"
    "rule.pci_dss"
    "manager.name"
    "data.srcip"
    "data.dstip"
    "data.srcport"
    "data.dstport"
    "data.protocol"
    "data.url"
    "data.status"
    "data.systemname"
    "data.audit.command"
    "data.audit.file\.name"
    "syscheck.path"
    "syscheck.mtime"
    "syscheck.permissions"
    "syscheck.md5"
    "syscheck.sha1"
    "syscheck.sha256"
    "syscheck.event"
    "syscheck.uname_after"
    "vulnerability.severity"
    "vulnerability.package.name"
    "vulnerability.package.version"
    "vulnerability.cve"
)

# Loop through each pattern and replace it in all files within SEARCH_DIR and its subdirectories
for pattern in "${SEARCH_PATTERNS[@]}"; do
    # Replace dots in the pattern with underscores for the replacement
    replacement=$(echo "$pattern" | sed 's/\./_/g')

    # Find files with the pattern and replace it using find and sed
    find "$SEARCH_DIR" -type f -exec grep -lP "${pattern}" {} \; | while read -r file; do
        # Check if the replacement pattern already exists in the file
        if ! grep -q "$replacement" "$file"; then
            sed -i "s/${pattern}/${replacement}/g" "$file"
            echo "$file ==> OK - modified: $pattern"
        else
            echo "$file ==> ALREADY MODIFIED - pattern: $replacement"
        fi
    done
done

echo "Replacement done."

systemctl restart wazuh-dashboard
