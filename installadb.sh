#! /system/bin/sh

checkApp="/data/data/crixec.adbtoolkitsinstall"
checkPathandroid="/.android"
adbPubKey="/data/misc/adb/adb_keys"
adbPrivKey="/.android/adbkey"
adbPubKeyOld="/data/misc/adb/adb_keys_old_backup_from_installadb"

# Check if "adb" is exist :
#   * adbExist -> Jump to Next
#   * adbNotExist -> Open "ADB Tool Kits Installer"
#   * AppNotInstalled -> Jump to Coolapk
type adb > /dev/null 2>&1 || { echo "Command adb not exist! Please (re)install!";
if [ -d $checkApp  ]
then
echo "Launching: ADB Tool Kits Installer…"; am start -n crixec.adbtoolkitsinstall/crixec.adbtoolkitsinstall.MainActivity 2> /dev/null;
else
echo "ADB Tool Kits Installer is not installed.";am start -a android.intent.action.VIEW -d  https://www.coolapk.com/apk/crixec.adbtoolkitsinstall;
fi
}

# Get /system writable
mount -o rw,remount /system
# Make a new directory : /.android
if [ ! -d $checkPathandroid ]
    then mkdir /.android
fi

# Backup "/data/misc/adb/adb_keys" if  exist
if [ -f $adbPubKey ];then
  cp /data/misc/adb/adb_keys /data/misc/adb/adb_keys_old_backup_from_installadb
  echo "The old adb_keys is backuped to /data/misc/adb/adb_keys_old_backup_from_installadb."
fi
# Backup "/.android/adbkey" if exist
if [ -f $adbPrivKey ];then
    cp /.android/adbkey /.android/adbkey_old_backup_from_installadb
    echo "The old adbkey is backuped to /.android/adbkey_old_backup_from_installadb."
fi

# Generate adb's Public Key(adbkey.pub) and Private Key(adbkey)
adb keygen /.android/adbkey 
# Rename adbkey.pub to adb_keys and move it to /data/misc/adb
mv /.android/adbkey.pub  /data/misc/adb/adb_keys
#Copy old public keys to adb_keys
if [ -f $adbPubKeyOld ];then
  echo >> /data/misc/adb/adb_keys
  cat /data/misc/adb/adb_keys_old_backup_from_installadb >> /data/misc/adb/adb_keys
  echo "The old public key(s) is added."
fi

# Get /system unwritable
mount -o ro,remount /system

# Check "adb devices" 
echo
echo "Running: adb devices…"
adb kill-server
adb devices

