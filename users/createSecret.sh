#!/bin/bash

htpasswd -c -B -b users.htpasswd user000 r3dh4t1!
for i in {1..200}
do
  userid=user$(printf "%03d\n" $i)
  echo "Working on $userid ..."
  htpasswd -B -b users.htpasswd $userid r3dh4t1!
done

# htpasswd -c -B -b users.htpasswd ^Cser_name> <password>