//
//  ProfileNoSessViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ProfileNoSessViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "SnapDataStore.h"
#import "UserProfile.h"
#import "UserProfileViewController.h"

@interface ProfileNoSessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation ProfileNoSessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"profilenosessionvc loaded");
    
    self.loginBtn.layer.cornerRadius = 4;
    self.signupButton.layer.cornerRadius = 4;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view from its nib.
    SnapDataStore *snapData = [SnapDataStore sharedStore];
    UserProfile *user = [snapData user];
    
    if(user && user.emailVerified == NO && user.loggedIn == NO){
        //show the profile
        NSLog(@"user exists and signedup");
        self.signupButton.hidden = YES;
        
    }
    else if(user && user.emailVerified == YES && user.loggedIn == YES){
        //show the profile screen
        UserProfileViewController *vc = [UserProfileViewController new];
        [self.navigationController setViewControllers: [NSArray arrayWithObject:vc] animated:YES];
    }
    else{
        //show the login and signup
        NSLog(@"user does not exist");
    }
}

- (IBAction)loginClicked:(id)sender {
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
}
- (IBAction)signupClicked:(id)sender {
    SignUpViewController *signupVc =
    [[SignUpViewController alloc] init];
    
    //[self presentViewController:signupVc animated:YES completion:nil];
    [self.navigationController pushViewController:signupVc animated:YES];
}

@end
