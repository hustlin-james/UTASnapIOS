//
//  SnapDataStore.h
//  UTASnap
//
//  Created by feifan meng on 4/9/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserProfile;

@interface SnapDataStore : NSObject

@property (nonatomic, readonly) UserProfile *user;

//public methods
+ (instancetype)sharedStore;
- (BOOL)saveChanges;
- (UserProfile *)createUser;
- (void) deleteOtherUsers;

-(void)getSnapImagesByNumCookiesAndBy:(int)offset WithCallBack:(SEL)myFunction andWith: (id)target;

@end
