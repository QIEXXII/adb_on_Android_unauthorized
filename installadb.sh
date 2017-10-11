#! /system/bin/sh

checkPathandroid="/.android"

# Check if "adb" is exist
type adb > /dev/null 2>&1 || { echo "adb not exist! Exit now."; exit 1;}

# Get /system writable
mount -o rw,remount /system
# Make a new directory : /.android
if [ ! -d $checkPathandroid]
    then mkdir /.android
fi
# Generate adb's Public Key(adbkey.pub) and Private Key(adbkey)
adb keygen /.android/adbkey 
# Rename adbkey.pub to adb_keys and move it to /data/misc/adb
#echo >> /data/misc/adb/adb_keys
#cat /.android/adbkey.pub >> /data/misc/adb/adb_keys
mv /.android/adbkey.pub  /data/misc/adb/adb_keys
# Get /system unwritable
mount -o ro,remount /system

# Check "adb devices"
adb kill-server
adb devices
#adb devices > /data/local/tmp/adbdevicestest
#if [ "`cat /data/local/tmp/adbdevicestest | grep device`" ]
#then
#echo "Succeed!"
#else
#adb devices
#fi
