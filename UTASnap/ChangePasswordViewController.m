//
//  ChangePasswordViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Parse/Parse.h>
#import "ChangePasswordViewController.h"
#import "SnapDataStore.h"
#import "UserProfile.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *aNewPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *vNewPasswordField;

@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}
- (IBAction)submitBtnPressed:(id)sender {
    
    if([self.currentPasswordField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Current Password" message:@"Please input the current password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if( ![self.aNewPasswordField.text isEqualToString:@""] &&
           [self.aNewPasswordField.text isEqual:self.vNewPasswordField.text]){
            //Retrieve User from the Parse database and check that the current password
            //matches it then update the parse database and the local database
            SnapDataStore *dataStore = [SnapDataStore sharedStore];
            UserProfile *profile = [dataStore user];
            NSLog(@"profile: %@", profile);
            
            [PFUser logInWithUsernameInBackground:profile.username
                                         password:self.currentPasswordField.text
                                           target:self
                                         selector:@selector(handleUserLogin:error:)];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Password Error" message:@"The new password doesn't match. Please check your spelling" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}
- (void)handleUserLogin:(PFUser *)user error:(NSError *)error {
    if (user) {
        // Do stuff after successful login.
        user.password = self.aNewPasswordField.text;
        [user saveInBackgroundWithTarget:self selector:@selector(updateUserFinished:error:)];
        
    } else {
        // The login failed. Check error to see why.
        NSString *localError = [error localizedDescription];
        NSString *error = [localError stringByAppendingString:@". Check if you input the current password correctly."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)updateUserFinished:(NSNumber *)result error:(NSError *)error{
    
    if(error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved Password" message:@"Your password has been updated!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)singleTapDismissKeyboard{
    [self.view endEditing:YES];
}

@end
