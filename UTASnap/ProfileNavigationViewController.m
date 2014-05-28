//
//  ProfileNavigationViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ProfileNavigationViewController.h"
#import "ProfileNoSessViewController.h"

@interface ProfileNavigationViewController ()

@end

@implementation ProfileNavigationViewController

- (instancetype)init{
    ProfileNoSessViewController *profileNoSessVc = [ProfileNoSessViewController new];
    
    self = [super initWithRootViewController:profileNoSessVc];
    if(self){
        UIColor *navBarColor =[UIColor colorWithRed:0.40 green:0.67 blue:0.91 alpha:1.0];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [self.navigationBar setBarTintColor:navBarColor];
        
        [self.navigationBar setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"ProfileNavVC loaded");
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@ viewDidAppear", [ProfileNavigationViewController class]);
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@ viewWillAppear", [ProfileNavigationViewController class]);
}

@end
