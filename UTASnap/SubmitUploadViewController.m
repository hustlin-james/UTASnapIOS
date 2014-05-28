//
//  SubmitUploadViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/4/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "SubmitUploadViewController.h"
#import "SnapDataStore.h"
#import "UserProfile.h"
#import "Snap.h"
#include <QuartzCore/QuartzCore.h>

@interface SubmitUploadViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation SubmitUploadViewController

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
    
    self.navigationItem.title = @"Upload Image";
    // Do any additional setup after loading the view from its nib.
    self.imageView.image = self.myImage;
    
    //Add a screentap to dismiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.descriptionTextField.text = @"";
    [[self.descriptionTextField layer] setCornerRadius:10];
    [[self.descriptionTextField layer] setBorderWidth:.5];
    [self.descriptionTextField layer].borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.loadingIndicator.hidden = YES;
}

- (void)viewDidLayoutSubviews{
    self.scrollView.contentSize = ((UIView *)self.scrollView.subviews[0]).bounds.size;
}
- (IBAction)uploadButtonPressed:(id)sender {
    NSLog(@"upload button pressed");
    
    NSString *titleText = self.titleTextField.text;
    NSString *descriptionText = self.descriptionTextField.text;
    
    if([titleText isEqualToString:@""] || [descriptionText isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Fields" message:@"you must enter a title and a description" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }else{
        //Check if the user is loggedin if they are then set the uploader as the username
        //else set it as anonymous
        
        self.loadingIndicator.hidden = NO;
        [self.loadingIndicator startAnimating];
        
        //Scroll the scrollview back up
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        
        self.titleTextField.enabled = NO;
        self.descriptionTextField.editable = NO;
        self.uploadButton.enabled = NO;
        
        SnapDataStore *dataStore = [SnapDataStore sharedStore];
        UserProfile *user = [dataStore user];
        
        //Upload a Snap with the following fields
        //titleText
        //descriptionText
        int numCookies = 0;
        NSString *publisherUsername  = @"anonymous";
        
        if(user.loggedIn){
            NSLog(@"user is logged in");
            publisherUsername = user.username;
        }
        
        Snap *s = [Snap new];
        s.title = titleText;
        s.description = descriptionText;
        s.numCookies = numCookies;
        s.publisherUsername = publisherUsername;
        s.snapImage = self.myImage;
        
        
        [s uploadSnapToParse:^(BOOL succeeded, NSError *error) {
            
            self.titleTextField.enabled = YES;
            self.descriptionTextField.editable = YES;
            self.uploadButton.enabled = YES;
            
            [self.loadingIndicator stopAnimating];
            self.loadingIndicator.hidden = YES;
            
            if(succeeded){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully uploaded the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                NSString *e = [error localizedDescription];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:e delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }
}

- (void)singleTapDismissKeyboard{
    NSLog(@"screen tapped");
    [self.view endEditing:YES];
}

@end
