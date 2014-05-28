//
//  SingleImageViewController.h
//  UTASnap
//
//  Created by feifan meng on 4/12/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"

@class Snap;
@interface SingleImageViewController : UIViewController <UIScrollViewDelegate>

/*
@property (nonatomic, strong) NSString *imageTitle;
@property (nonatomic, strong) NSString *imageDescription;

@property (nonatomic, strong) UIImage *image;
 */

@property (nonatomic, strong) Snap *s;
@property (nonatomic) UserProfile *profile;

@end
