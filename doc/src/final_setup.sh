#! /bin/bash

#
# Copyright 2006-2010 Holger Levsen 
# released under the GPLv=2
#

# country=UNIX
LANG=C

# distribution we are using
DISTRO=squeeze

# hardcode mirror to use
MIRROR=ftp.us.debian.org 
#
## either use local mirror or ftp.de.debian.org
#apt-get install file
#TMPFILE=`mktemp -p /tmp`
#if $( wget -q http://mirror/debian/dists/$DISTRO/Release.gpg -O $TMPFILE && file $TMPFILE | grep PGP > /dev/null ) ; then MIRROR=mirror 
#elif $(wget -q http://ftp.de.debian.org/debian/dists/$DISTRO/Release.gpg -O $TMPFILE && file $TMPFILE | grep PGP > /dev/null ) ; then MIRROR=ftp.de.debian.org 
#else echo cannot reach a mirror, aborting && exit 1 ; fi
#rm $TMPFILE 


# which arch are we running on? (needed for sources.list)
ARCH=`dpkg --print-installation-architecture`

# install fai clients and recommended stuff
export DEBCONF_FRONTEND=noninteractive  
export DEBIAN_FRONTEND=noninteractive 
apt-get -y install fai-client subversion 

# overwrite existing sources.lists, provide sensible defaults
echo "#deb http://$MIRROR/debian/ $DISTRO main contrib non-free
#deb http://security.debian.org/ $DISTRO/updates main contrib non-free

deb http://snapshot.debian.org/archive/debian/20100704T132725Z/ squeeze main

deb http://db.debconf.org/dc-admin/archive/ $DISTRO/$ARCH/
deb http://db.debconf.org/dc-admin/archive/ $DISTRO/all/
" > /etc/apt/sources.list

# upgrade to squeeze snapshort
apt-get update 
apt-get -y install apt
apt-get -y install linux-image-2.6.32-5-686 
apt-get -y upgrade 
apt-get -y dist-upgrade

# configure fai
echo 'FAI_CONFIG_SRC="svn://svn.debian.org/svn/debconf-video/fai-config"' >> /etc/fai/fai.conf  # crude hack - last entry has precedence :)

# run first softupdate, after that you can use /usr/local/sbin/softupdate 
fai -N softupdate

# display errors
echo "cat /var/log/fai/current/error.log:"
cat /var/log/fai/current/error.log

# done
echo
echo "'fai -N softupdate' done."
echo

