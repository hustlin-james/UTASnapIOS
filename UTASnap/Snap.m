//
//  Snap.m
//  UTASnap
//
//  Created by feifan meng on 4/19/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "Snap.h"


@implementation Snap


- (void)giveCookieToSnap:(void (^)(BOOL succeeded, NSError *error))myBlock
{
    self.snapPFObject[@"numCookies"] = @([self.snapPFObject[@"numCookies"] intValue] + 1);
    [self.snapPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        myBlock(succeeded, error);
    }];
    
}

- (void)removeCookieFromSnap:(void (^)(BOOL succeeded, NSError *error))myBlock{
    self.snapPFObject[@"numCookies"] = @([self.snapPFObject[@"numCookies"] intValue] - 1);
    [self.snapPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        myBlock(succeeded, error);
    }];
}

- (void)uploadSnapToParse:(void (^)(BOOL succeeded, NSError *error))myBlock{
    
    //NSData *imageData = UIImagePNGRepresentation(self.snapImage);
    NSData *imageData = UIImageJPEGRepresentation(self.snapImage, 1.0);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    
    PFObject *snap = [PFObject objectWithClassName:@"Snap"];
    snap[@"imageFile"] = imageFile;
    snap[@"title"] = self.title;
    snap[@"description"] = self.description;
    snap[@"numCookies"] = [NSNumber numberWithInt:self.numCookies];
    snap[@"publisherUsername"] = self.publisherUsername;
    
    [snap saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //TODO
        myBlock(succeeded, error);
    }];
}
@end
