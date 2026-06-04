#!/bin/bash
echo "=== APPLICATION HEALTH ==="
for s in catalogue user cart shipping payment dispatch frontend
do
 systemctl status $s --no-pager 2>/dev/null
done
