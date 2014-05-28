//
//  UserProfileViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/9/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Parse/Parse.h>
#import "UserProfileViewController.h"
#import "SnapDataStore.h"
#import "UserProfile.h"
#import "ProfileNoSessViewController.h"
#import "FavoriteSnapsTableViewController.h"
#import "ChangePasswordViewController.h"

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic) UserProfile *oldUserProfile;

@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.navigationItem.title = @"Profile";
    }
    return self;
}

- (void)viewDidLayoutSubviews{
    
    SnapDataStore *dataStore = [SnapDataStore sharedStore];
    UserProfile *user = [dataStore user];
    
    self.usernameTextField.text = user.username;
    self.majorTextField.text = user.major;
    self.emailTextField.text = user.email;
    
    self.oldUserProfile = user;
    
    self.usernameTextField.userInteractionEnabled=NO;
    self.majorTextField.userInteractionEnabled=NO;
    self.emailTextField.userInteractionEnabled=NO;
    self.passwordTextField.userInteractionEnabled=NO;
    
    //dismiss the keyboard whenm tapped on the view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)singleTapDismissKeyboard{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)editBtnPressed:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
   
    if([btn.titleLabel.text isEqual:@"Edit"]){
        NSLog(@"Current button is Edit button.");
        //Change the edit button to save
        [btn setTitle:@"Save" forState:UIControlStateNormal];

        self.usernameTextField.userInteractionEnabled=YES;
        self.majorTextField.userInteractionEnabled=YES;
        self.emailTextField.userInteractionEnabled=YES;
        self.passwordTextField.userInteractionEnabled=YES;
        
    }else{
        self.usernameTextField.userInteractionEnabled=NO;
        self.majorTextField.userInteractionEnabled=NO;
        self.emailTextField.userInteractionEnabled=NO;
        self.passwordTextField.userInteractionEnabled=NO;
        
        NSLog(@"Current button is Save button.");
        [btn setTitle:@"Edit" forState:UIControlStateNormal];
        
        if([self.usernameTextField.text isEqual:@""] ||
           [self.emailTextField.text isEqual:@""] ||
           [self.passwordTextField.text isEqual:@""]){
            
            if(![self.usernameTextField.text isEqualToString:@""] &&
               ![self.emailTextField.text isEqualToString:@""] &&
               [self.passwordTextField.text isEqualToString:@""]){
                
                NSLog(@"%@", self.oldUserProfile);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password need" message:@"Please enter your current password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Field Empty" message:@"Only the major field can be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"OK", nil];
                [alert show];
            }
           
            [self resetFieldsToOld];
        }else{
            [PFUser logInWithUsernameInBackground:self.oldUserProfile.username password:self.passwordTextField.text target:self selector:@selector(handleUserLogin:error:)];
        }
        
    }
}

- (void)resetFieldsToOld{
    self.usernameTextField.text = self.oldUserProfile.username;
    self.majorTextField.text = self.oldUserProfile.major;
    self.emailTextField.text = self.oldUserProfile.email;
    self.passwordTextField.text = @"";
}

// First set up a callback.
- (void)handleUserLogin:(PFUser *)user error:(NSError *)error {
    if (user) {
        // Do stuff after successful login.
        user.email = self.emailTextField.text;
        user[@"major"] = self.majorTextField.text;
        user.username = self.usernameTextField.text;
        
        SnapDataStore *dataStore = [SnapDataStore sharedStore];
        UserProfile *localUser = [dataStore user];
        localUser.email = self.emailTextField.text;
        localUser.major = self.majorTextField.text;
        localUser.username = self.usernameTextField.text;
        
        [dataStore saveChanges];
        
        [user saveInBackgroundWithTarget:self selector:@selector(updateUserInfoComplete:error:)];
        
    } else {
        NSString *errStr = @"Please check your login credentials";
        // The login failed. Check error to see why.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:errStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [self resetFieldsToOld];
    }
}

- (void)updateUserInfoComplete:(NSNumber *)result error:(NSError *)error{
    
    if(error){
        NSString *errStr = error.description;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't update information" message:errStr delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [alert show];
        
        [self resetFieldsToOld];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You have updated your info." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        self.passwordTextField.text = @"";
    }
}

- (IBAction)changePwBtnPressed:(id)sender {
    ChangePasswordViewController *cpvc = [ChangePasswordViewController new];
    [self.navigationController pushViewController:cpvc animated:YES];
}
- (IBAction)logoutBtnPressed:(id)sender {
    SnapDataStore *dataStore = [SnapDataStore sharedStore];
    UserProfile *user = [dataStore user];
    //user.emailVerified = NO;
    user.loggedIn = NO;
    
    [dataStore saveChanges];
    
    NSLog(@"user: %@", user);
    
    ProfileNoSessViewController *vc = [ProfileNoSessViewController new];
    [self.navigationController setViewControllers: [NSArray arrayWithObject:vc] animated:YES];
}
- (IBAction)favoriteSnapsBtnPressed:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    //NSLog(@"%@", user);
    
    if(user){
        PFRelation *relation = [user relationForKey:@"favoriteSnaps"];
        [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(objects && [objects count] > 0){
                
                
                FavoriteSnapsTableViewController *vc = [FavoriteSnapsTableViewController new];
                [self.navigationController pushViewController:vc animated:YES];
                //[self.navigationController setViewControllers: [NSArray arrayWithObject:vc] animated:YES];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Favorites" message:@"You don't have any favorite snaps." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Favorites" message:@"You don't have any favorite snaps." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

@end
