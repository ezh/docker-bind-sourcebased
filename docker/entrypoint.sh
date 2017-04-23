#!/bin/bash
#

chmod a+r /dev/fd/0
chmod a+w /dev/fd/1
chmod a+w /dev/fd/2

# Environment variables are set before first run
# Set initial UID:GID

CURRENT_BIND_USER_ID=$(id -u bind)
CURRENT_BIND_GROUP_ID=$(id -g bind)

if [ -n "$BIND_USER_ID" ] && [ "$BIND_USER_ID" != "$CURRENT_BIND_USER_ID" ]
then
    echo "Change BIND user id from $CURRENT_BIND_USER_ID to $BIND_USER_ID"
    usermod -u "$BIND_USER_ID" bind
fi
if [ -n "$BIND_GROUP_ID" ] && [ "$BIND_GROUP_ID" != "$CURRENT_BIND_GROUP_ID" ]
then
    echo "Change BIND group id from $CURRENT_BIND_GROUP_ID to $BIND_GROUP_ID"
    groupmod -g "$BIND_GROUP_ID" bind
fi
echo "Bind user defined as $(id bind)"

exec "$@"
