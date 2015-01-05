
DEMO_UNIONFS() {
     BANNER "Union Filesystem"
     RMALL

     echo; pause "Let's look at the Union filesystem"
     CMD='touch /tmp/hello; ls -altr /tmp/ /bin/ls; echo;echo; rm -rf /bin/; ls -altr /tmp /bin/ls'
     SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""
     ID1=`GETLASTID`
     FID1=`GETLASTFULLID`

     echo; pause "Now let's look again"
     CMD='ls -altr /tmp/ /bin/ls'
     SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""
     ID2=`GETLASTID`
     FID2=`GETLASTFULLID`

     echo; pause "What happened?"
     LIST_ALL

     echo
     echo "Here are the ids of those 2 containers (docker ps -q -a -l):"
     echo "1st ID=$ID1 FULLID=$FID1"
     echo "2nd ID=$ID2 FULLID=$FID2"

     echo
     SHOW_DOCKER diff $ID1 | grep -v "^C /dev"
     echo
     SHOW_DOCKER diff $ID2 | grep -v "^C /dev"
     echo

     #sudo du -s /var/lib/docker/containers/{$FID1,$FID2}

     #echo
     #echo "sudo diff -rq /var/lib/docker/containers/{$FID1,$FID2}"
     #echo
     #sudo diff -rq /var/lib/docker/containers/{$FID1,$FID2}

     ## echo
     ## echo "We can see the differences under the aufs directories:"
     ## echo
     ## echo "sudo diff -rq /var/lib/docker/aufs/diff/{$FID1,$FID2}"
     ## echo
     ## sudo diff -rq /var/lib/docker/aufs/diff/{$FID1,$FID2}

     echo;
     pause "We can also reattach to an old container - let's try container1 (will FAIL)"
     SHOW_DOCKER start $FID1
     SHOW_DOCKER attach $FID1

     echo
     pause "Let's try container2"
     SHOW_DOCKER start $FID2
     SHOW_DOCKER attach $FID2

     ## echo
     ## LIST_ALL
     ## pause "Let's try container2 via lxc-attach"
     ## SHOW_DOCKER start $FID2
     ## LIST_ALL
     ## echo "sudo lxc-attach --name $FID2"
     ## sudo lxc-attach --name $FID2
     ## LIST_ALL
}

DEMO5() {
    DEMO_UNIONFS
}

