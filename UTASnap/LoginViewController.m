//
//  LoginViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "LoginViewController.h"
#import "UserProfileViewController.h"
#import "SnapDataStore.h"
#import "UserProfile.h"
#import "FDKeychain.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Login";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.activityIndicator.hidesWhenStopped = YES;
    
    self.loginBtn.layer.cornerRadius = 4;
    //self.loginBtn.layer.borderWidth = 1;
    //self.loginBtn.layer.borderColor = [UIColor orangeColor].CGColor;
}
- (IBAction)loginBtnClicked:(id)sender {
    BOOL fieldEmpty = false;
    
    if([self.usernameTextField.text isEqual:@""])
        fieldEmpty = true;
    if( [self.passwordTextField.text isEqual:@""])
        fieldEmpty = true;
    
    if(fieldEmpty){
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill out all fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [error show];
    }else{
        
        [self.activityIndicator startAnimating];
        //Go to parse data and check if the email is verified
        //if it is then set the emailverified property in the local database
        //and show the user the profile vc
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text target:self selector:@selector(handleUserLogin:error:)];
    }
}

- (void)handleUserLogin:(PFUser *)user error:(NSError *)error {
   
    if (user) {
        // Do stuff after successful login.
        NSLog(@"user: %@", user);
        NSLog(@"emailVerified: %@", user[@"emailVerified"]);
        NSLog(@"major: %@", user[@"major"]);
        
        if([[user objectForKey:@"emailVerified"] boolValue]){
            
            //After the user successfully login, must update the local storage of the user
            SnapDataStore *dataStore = [SnapDataStore sharedStore];
            
            //[dataStore deleteOtherUsers];
            //UserProfile *localUser = [dataStore createUser];
            UserProfile *localUser = [dataStore user];
            
            if(localUser){
                NSLog(@"localUser exists");
                //update user fields here...
            }else{
                NSLog(@"localUser doesn't exist");
            }
            
            [dataStore deleteOtherUsers];
            localUser = [dataStore createUser];
            
            localUser.username = user.username;
            localUser.email = user.email;
            localUser.major = user[@"major"];
            localUser.lastLoggedIn = [NSDate date];
            localUser.emailVerified = YES;
            localUser.loggedIn = YES;
            
            [dataStore saveChanges];
            
            localUser = [dataStore user];
            
            NSLog(@"refetching user: %@", localUser);
            
            NSString *password = self.passwordTextField.text;
            NSError *error = nil;
            BOOL success = [FDKeychain saveItem:password forKey:@"password" forService:@"parselogin" error:&error];
            
            if(!success){
                NSLog(@"very bad error can't add loging pass to keychain");
            }else{
                NSLog(@"successfully saved passed to fdkeychain");
            }
            
            UserProfileViewController *vc = [UserProfileViewController new];
            [self.navigationController setViewControllers: [NSArray arrayWithObject:vc] animated:YES];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Email" message:@"Please verify your email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } else {
        // The login failed. Check error to see why.
        NSLog(@"error loggin user: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"error logging in.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [self.activityIndicator stopAnimating];
}
- (void)singleTapDismissKeyboard{
    [self.view endEditing:YES];
}


@end
