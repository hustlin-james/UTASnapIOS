UTASnap
=======

UTASnapIOS

This is the UTA Snap Code for IOS.

Project Setup:

follow the instructions at:

https://parse.com/apps/quickstart#parse_data/mobile/ios/native/existing

to import all the neccessary parse frameworks.

Make sure you don't store the key in a file that you will upload.

You can create a new class ParseInfo with static public methods

+ (NSString *) appId;
+ (NSString *) clientKey;

that returns the parse key information.

Also make sure when you push, these are in the .gitignore file:

UTASnap/ParseInfo.h

UTASnap/ParseInfo.m

Parse.framework/*
