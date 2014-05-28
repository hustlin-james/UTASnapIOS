//
//  UploadNavigationViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "UploadNavigationViewController.h"
#import "UploadViewController.h"

@interface UploadNavigationViewController ()

@end

@implementation UploadNavigationViewController

-(instancetype)init{
    UploadViewController *uploadVc = [UploadViewController new];
    self = [super initWithRootViewController:uploadVc];
    if(self){
        UIColor *navBarColor =[UIColor colorWithRed:0.40 green:0.67 blue:0.91 alpha:1.0];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [self.navigationBar setBarTintColor:navBarColor];
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

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
