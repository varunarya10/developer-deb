#!/bin/bash


PKG_NAME="developer-deb-$USERNAME";
PKG_INSTALL_FILE="debian/$PKG_NAME.install";

CTRL="debian/control";
CHLOG="debian/changelog";
RULES="debian/rules";
DEVELOPER_LIST_FILE="debian/$PKG_NAME.list";
DEVELOPER_PREF_FILE="debian/$PKG_NAME.pref";

RELEASE="trusty";
CHLOG_DATE=`date -R`;
CHLOG_REV=`date +%s`;


create_control_file () {
echo "Source: $PKG_NAME
Section: admin
Priority: optional
Maintainer: Ritesh Raj Sarraf <Ritesh.Sarraf@ril.com>
Build-Depends: debhelper (>= 7),
Standards-Version: 3.9.2

Package: $PKG_NAME
Architecture: all
Depends: \${misc:Depends}
Description: Developer Deb Package for user $USERNAME
 Developer Deb Package for user $USERNAME to override APT Repository
 .
 WARNING: Only used for testing" > $1
}


create_developer_list () {

echo "deb http://rjil.org/$USERNAME	main" > $1
}


create_repo_preferences () {
echo "Package: *
Pin: origin "rjil.org"
Pin-Priority: 1000" > $1
}

create_deb_install () {
echo "$DEVELOPER_LIST_FILE	/etc/apt/sources.list.d/
$DEVELOPER_PREF_FILE	/etc/apt/preferences.d/" > $1
}

create_dummy_changelog () {
echo "$PKG_NAME ($CHLOG_REV) $RELEASE; urgency=medium

  * Initial dummy changelog.

 -- Ritesh Raj Sarraf <Ritesh.Sarraf@ril.com>  $CHLOG_DATE" > $1
}

create_rules_file () {
echo "#!/usr/bin/make -f
%:
	dh \$@;
" > $1
}

create_compat_file () {
echo 7 > debian/compat;
}


# First create the debian/ folder
mkdir debian;

create_control_file $CTRL;
create_dummy_changelog $CHLOG;
create_repo_preferences $DEVELOPER_PREF_FILE;
create_developer_list $DEVELOPER_LIST_FILE;

create_deb_install $PKG_INSTALL_FILE;
create_rules_file $RULES;
create_compat_file;


# Now create the pacakge
dpkg-buildpackage -uc -us;
