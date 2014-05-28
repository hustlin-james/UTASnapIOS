//
//  UserProfile.h
//  UTASnap
//
//  Created by feifan meng on 4/19/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic) BOOL emailVerified;
@property (nonatomic, retain) NSDate * lastLoggedIn;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * username;
@property (nonatomic) BOOL loggedIn;

@end
