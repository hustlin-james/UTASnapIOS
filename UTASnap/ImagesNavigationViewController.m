//
//  ImagesNavigationViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ImagesNavigationViewController.h"
#import "ImagesViewController.h"
#import "SingleImageViewController.h"

@interface ImagesNavigationViewController ()

@end

@implementation ImagesNavigationViewController

-(instancetype)init{
    
    ImagesViewController *imagesVc = [ImagesViewController new];
    imagesVc.view.backgroundColor = [UIColor whiteColor];
    
    //Attach the imagesVc to the root view controller of the navigation controller
    self = [super initWithRootViewController:imagesVc];
    
    if(self){
        //self.navigationBar.tintColor = [UIColor orangeColor];
        UIColor *navBarColor =[UIColor colorWithRed:0.40 green:0.67 blue:0.91 alpha:1.0];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [self.navigationBar setBarTintColor:navBarColor];
        //[self.navigationBar setTranslucent:NO];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
