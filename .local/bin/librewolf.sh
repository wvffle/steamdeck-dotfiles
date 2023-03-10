#!/bin/bash

ACTIVITY=`qdbus org.kde.ActivityManager /ActivityManager/Activities org.kde.ActivityManager.Activities.CurrentActivity`
ROOT="$HOME/.librewolf"
DEF_PROFILE="$ROOT/????????.default-release"
NEW_PROFILE="$ROOT/????????.$ACTIVITY"

if [ ! -d $NEW_PROFILE ];
then	
	flatpak run io.gitlab.librewolf-community --createprofile $ACTIVITY
	cp -a $DEF_PROFILE/* $NEW_PROFILE/
	cd $NEW_PROFILE
	rm sessionstore.*
	cd
fi

flatpak run io.gitlab.librewolf-community --no-remote -P $ACTIVITY
