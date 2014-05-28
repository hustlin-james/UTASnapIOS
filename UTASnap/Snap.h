//
//  Snap.h
//  UTASnap
//
//  Created by feifan meng on 4/19/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Snap : NSObject

//Snap properties
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic) int numCookies;
@property (nonatomic) NSString *publisherUsername;
@property (nonatomic) PFObject *snapPFObject;

//Image
@property (nonatomic) UIImage *snapImage;

//Methods
- (void)giveCookieToSnap:(void (^)(BOOL succeeded, NSError *error))myBlock;
- (void)removeCookieFromSnap:(void (^)(BOOL succeeded, NSError *error))myBlock;
- (void)uploadSnapToParse:(void (^)(BOOL succeeded, NSError *error))myBlock;

@end
