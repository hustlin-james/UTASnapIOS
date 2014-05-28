//
//  SignUpViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import "SnapDataStore.h"
#import "UserProfile.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *vPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


typedef NS_ENUM(NSUInteger, WhichTextField){
    USERNAMETEXTFIELD,
    EMAILTEXTFIELD,
    PASSWORDTEXTFIELD,
    VPASSWORDTEXTFIELD,
    MAJORTEXTFIELD
};

@property (nonatomic) WhichTextField currentTextField;

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Sign Up";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [[[[self.tabBarController tabBar] items] objectAtIndex:0] setEnabled:FALSE];
    [[[[self.tabBarController tabBar] items] objectAtIndex:1] setEnabled:FALSE];
    [[[[self.tabBarController tabBar] items] objectAtIndex:2] setEnabled:FALSE];
}
- (void)viewDidLayoutSubviews{
    //Add a single tap gesture recognizer to dismiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.scrollView addGestureRecognizer:tap];
    
    [self.scrollView setContentOffset:CGPointZero animated:NO];
}
- (IBAction)submitButtonClicked:(id)sender {
    
    //Make sure all the text in the text fields are valid
    BOOL fieldEmpty = false;
    
    if([self.usernameTextField.text isEqual:@""])
        fieldEmpty = true;
    if([self.emailTextField.text isEqual:@""])
        fieldEmpty = true;
    if( [self.passwordTextField.text isEqual:@""])
        fieldEmpty = true;
    if( [self.vPasswordTextField.text isEqual:@""])
        fieldEmpty = true;
    if([self.majorTextField.text isEqual:@""])
        fieldEmpty = true;
    
    //passwords match
    BOOL passwordsMatch = false;
    if([self.passwordTextField.text isEqual:self.vPasswordTextField.text])
        passwordsMatch = true;
    
    //Check the email is valid
    BOOL emailIsGood = [self validEmail:self.emailTextField.text];
    
    NSString *errors = @"";
    if(fieldEmpty){
        errors = [errors stringByAppendingString:@"a field is empty.\n"];
    }
    
    if(!passwordsMatch)
        errors = [errors stringByAppendingString:@"password need to match.\n"];
    
    if(!emailIsGood)
        errors = [errors stringByAppendingString:@"invalid email.\n"];
    
    if(!fieldEmpty && passwordsMatch && emailIsGood){
        SnapDataStore *dataStore = [SnapDataStore sharedStore];
        [dataStore deleteOtherUsers];
        UserProfile *user = [dataStore createUser];
        
        //update user fields here...
        user.username = self.usernameTextField.text;
        user.email = self.emailTextField.text;
        user.major = self.majorTextField.text;
        user.lastLoggedIn = [NSDate date];
        user.emailVerified = NO;
        user.loggedIn = NO;
        
        [dataStore saveChanges];
        
        //Parse signup
        PFUser *pfUser = [PFUser user];
        pfUser.username = self.usernameTextField.text;
        pfUser.password = self.passwordTextField.text;
        pfUser.email = self.emailTextField.text;
        pfUser[@"major"] = self.majorTextField.text;
        
        [self.activityIndicator startAnimating];
        [pfUser signUpInBackgroundWithTarget:self
                                  selector:@selector(handleSignUp:error:)];
        
    }else{
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Errors" message:errors delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [errorAlert show];
    }
}

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error {
    [self.activityIndicator stopAnimating];
    if (!error) {
        // Hooray! Let them use the app now.
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You signup for UTASnaps. Please check your email to confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [successAlert show];
    } else {
        NSString *errorString = [error userInfo][@"error"];
        // Show the errorString somewhere and let the user try again.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SignUp error" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldBeginEditing");
    
    if([textField isEqual:self.usernameTextField]){
        self.currentTextField = USERNAMETEXTFIELD;
    }else if([textField isEqual:self.emailTextField]){
        self.currentTextField = EMAILTEXTFIELD;
    }else if( [textField isEqual:self.passwordTextField]){
        self.currentTextField = PASSWORDTEXTFIELD;
    }else if ([textField isEqual:self.vPasswordTextField]){
        self.currentTextField = VPASSWORDTEXTFIELD;
    }else{
        self.currentTextField = MAJORTEXTFIELD;
    }
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint usernameFieldOrigin = self.usernameTextField.frame.origin;
    CGFloat usernameFieldHeight = self.usernameTextField.frame.size.height;
    usernameFieldOrigin.y = usernameFieldOrigin.y + usernameFieldHeight;
    
    CGPoint emailFieldOrigin = self.emailTextField.frame.origin;
    CGFloat emailFieldHeight = self.emailTextField.frame.size.height;
    emailFieldOrigin.y = emailFieldOrigin.y + emailFieldHeight;
    
    CGPoint passwordFieldOrigin = self.passwordTextField.frame.origin;
    CGFloat passwordFieldHeight = self.passwordTextField.frame.size.height;
    passwordFieldOrigin.y  = passwordFieldOrigin.y + passwordFieldHeight;

    CGPoint vPasswordFieldOrigin = self.vPasswordTextField.frame.origin;
    CGFloat vPasswordFieldHeight = self.vPasswordTextField.frame.size.height;
    vPasswordFieldOrigin.y = vPasswordFieldOrigin.y + vPasswordFieldHeight;
    
    CGPoint majorTextFieldOrigin = self.majorTextField.frame.origin;
    CGFloat majorTextFieldHeight = self.majorTextField.frame.size.height;
    majorTextFieldOrigin.y = majorTextFieldOrigin.y + majorTextFieldHeight;
    
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height = visibleRect.size.height - keyboardSize.height;
    
    CGPoint scrollPoint = CGPointMake(0.0,0.0);
    
    if(!CGRectContainsPoint(visibleRect, usernameFieldOrigin) &&
       self.currentTextField == USERNAMETEXTFIELD){
        
        scrollPoint =
        CGPointMake(0.0, usernameFieldOrigin.y - visibleRect.size.height + usernameFieldHeight + 10);
    }
    
    if(!CGRectContainsPoint(visibleRect, emailFieldOrigin) &&
       self.currentTextField == EMAILTEXTFIELD){
        
       scrollPoint =
        CGPointMake(0.0, emailFieldOrigin.y - visibleRect.size.height + emailFieldHeight + 10);
    }
    
    if(!CGRectContainsPoint(visibleRect, passwordFieldOrigin) &&
       self.currentTextField == PASSWORDTEXTFIELD){
        
        scrollPoint =
        CGPointMake(0.0, passwordFieldOrigin.y - visibleRect.size.height + passwordFieldHeight + 10);
    }
    
    if(!CGRectContainsPoint(visibleRect, vPasswordFieldOrigin) &&
       self.currentTextField == VPASSWORDTEXTFIELD){
        
        scrollPoint =
        CGPointMake(0.0, vPasswordFieldOrigin.y - visibleRect.size.height + vPasswordFieldHeight + 10);
        
    }
    
    if(!CGRectContainsPoint(visibleRect, majorTextFieldOrigin) &&
       self.currentTextField == MAJORTEXTFIELD){
        
        scrollPoint =
        CGPointMake(0.0, majorTextFieldOrigin.y - visibleRect.size.height + majorTextFieldHeight + 10);
    }
    
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%@ viewWillDisappear", [SignUpViewController class]);
    
    [[[[self.tabBarController tabBar] items] objectAtIndex:0] setEnabled:TRUE];
    [[[[self.tabBarController tabBar] items] objectAtIndex:1] setEnabled:TRUE];
    [[[[self.tabBarController tabBar] items] objectAtIndex:2] setEnabled:TRUE];
    
    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
}

-(void)singleTapDismissKeyboard{
    [self.scrollView endEditing:YES];
}
- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}
- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}
@end
