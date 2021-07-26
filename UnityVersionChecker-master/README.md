# UnityVersionChecker
A simple bash script that reads 16 bytes from 0x10 in a unity resource file to find its Unity Version!

# How To Use
1) Chmod +x the script in case it doesn't execute
2) Call the script, then enter the path of the resource file/apk file/ipa file
OR
   Call the script along with the directory like <script path> <resource file path>

# Info
~~It simply just reads the bytes off a file. .assets, sometimes .resources and extentionless resources in the assets/bin/data usually work!~~
~~The script uses xxd to read and convert the bytes, it should work on Mac/Linux and a Jailbroken iOS. For android a different version is uploaded that needs Busybox binaries installed to access xxd!~~ \
UPDATE 1.1
- BUSYBOX not needed anymore for android
- Can read through .ipa and .apk
- Android Version almost identical with only directory and other minor changes
- Data/Resources/unity_builtin_extra for Android and iOS and also Data/unity default resources for Android

UPDATE 1.11
- Input file is now checked for its existance so unzip doesn't throw errors
