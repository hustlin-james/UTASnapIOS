//
//  UserProfile.m
//  UTASnap
//
//  Created by feifan meng on 4/19/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "UserProfile.h"


@implementation UserProfile

@dynamic email;
@dynamic emailVerified;
@dynamic lastLoggedIn;
@dynamic major;
@dynamic username;
@dynamic loggedIn;

- (NSString *)description{
    return [NSString stringWithFormat:@"username: %@, email: %@, lastLoggedIn: %@, major: %@, emailVerified: %hhd, loggedIn: %hhd", self.username,self.email, self.lastLoggedIn, self.major, self.emailVerified, self.loggedIn];
}

@end
