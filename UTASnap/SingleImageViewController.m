//
//  SingleImageViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/12/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "SingleImageViewController.h"
#import "Snap.h"
#import "FDKeychain.h"

@interface SingleImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UIView *bottomButtonsView;
@property (nonatomic, strong) UIView *numberOfCookiesView;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic,strong) UILabel *numCookiesLabel;

@end

@implementation SingleImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //self.imageTitle = [[NSString alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Customize the scroll view with the image
    //UIImage *image = self.image;
    UIImage *image = self.s.snapImage;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.imageView = [UIImageView new];
    self.imageView.image = image;
    [self.imageView sizeToFit];
    
    CGRect loc = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y +60, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:loc];
    self.scrollView.contentSize = image.size;
    self.scrollView.backgroundColor = [UIColor blackColor];
    
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = self.view.frame.size.width/image.size.width;
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.zoomScale = self.view.frame.size.width/image.size.width;
    
    [self.scrollView addSubview:self.imageView];
  
    
    //Create the done button
    self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    float xoffset = self.doneButton.bounds.size.width/2;
    
    self.doneButton.frame = CGRectMake(xoffset, 40, 80,40);
    self.doneButton.backgroundColor = [UIColor whiteColor];
    self.doneButton.layer.cornerRadius = 4;
    self.doneButton.alpha = 0.7f;
    
    [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTouched)];
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    
    //Create the bottom buttons view
    self.bottomButtonsView = [self createBottomButtonsView];
    
    //Create the bottom number of cookies view
    self.numberOfCookiesView = [self createNumberOfCookiesView];
    
    //Create the bottom text view
    self.textView = [self infoTextView];
    
    //Add the subviews to the view
    
    //Add the scrollview containg the image
    [self.view addSubview:self.scrollView];
    
    //Done Button
    [self.view addSubview:self.doneButton];
    [self.view bringSubviewToFront:self.doneButton];
    
    //Bottom Text View
    [self.view addSubview:self.textView];
    [self.view bringSubviewToFront:self.textView];
    
    //Add the number of cookies view
    [self.view addSubview:self.numberOfCookiesView];
    [self.view bringSubviewToFront:self.numberOfCookiesView];
    
    //Bottom Buttons view
    [self.view addSubview:self.bottomButtonsView];
    [self.view bringSubviewToFront:self.bottomButtonsView];
    
    
   
    
}

- (void) doneButtonPressed: (id)sender{
    NSLog(@"You pressed the button");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Touching the screen should toggle the subviews visible and invisible
- (void)screenTouched{
    NSLog(@"touched the screen");
    
    if(!self.doneButton.isHidden){
        [UIView animateWithDuration:.5 animations:^{
            
            self.doneButton.alpha = 0.0f;
            self.bottomButtonsView.alpha = 0.0f;
            self.textView.alpha = 0.0f;
            self.numberOfCookiesView.alpha = 0.0f;
            
        } completion:^(BOOL finished){
            
            self.doneButton.hidden = YES;
            self.bottomButtonsView.hidden = YES;
            self.textView.hidden = YES;
            self.numberOfCookiesView.hidden = YES;
            
        }];
    }else{
        [UIView animateWithDuration:.5 animations:^{
            
            self.doneButton.alpha = 0.7f;
            self.bottomButtonsView.alpha = 0.8f;
            self.textView.alpha = 0.8f;
            self.numberOfCookiesView.alpha = 0.8f;
            
            
        } completion:^(BOOL finished){
            
            self.doneButton.hidden = NO;
            self.bottomButtonsView.hidden = NO;
            self.textView.hidden = NO;
            self.numberOfCookiesView.hidden = NO;
            
        }];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (UIView *)createBottomButtonsView{
    
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, screenBounds.size.height - 40, self.view.bounds.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = .8f;
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [plusBtn setTitle:@"+ Cookie" forState:UIControlStateNormal];
    plusBtn.frame = CGRectMake(view.bounds.origin.x,view.bounds.origin.y,100,40);
    plusBtn.backgroundColor = [UIColor whiteColor];
    [view addSubview:plusBtn];
    
    //Attach events to the button
    [plusBtn addTarget:self action:@selector(plusCookie) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Add the favorites Button
    UIButton *favBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [favBtn setTitle:@"Favorite" forState:UIControlStateNormal];
    favBtn.frame = CGRectMake(plusBtn.frame.origin.x + 110, plusBtn.frame.origin.y, 100,40);
    favBtn.backgroundColor = [UIColor whiteColor];
    [view addSubview:favBtn];
    
    [favBtn addTarget:self action:@selector(favBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    UIButton *minusBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [minusBtn setTitle:@"- Cookie" forState:UIControlStateNormal];
    minusBtn.frame = CGRectMake(view.bounds.size.width - 100,0,100,40);
    minusBtn.backgroundColor = [UIColor whiteColor];
    [view addSubview:minusBtn];
    
    //Attach event to the button
    [minusBtn addTarget:self action:@selector(minusCookie) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (void)favBtnClicked{
    NSLog(@"fav parseObjectId: %@", self.s.snapPFObject.objectId);
    NSLog(@"%@", self.profile);
    
    if(self.profile == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not logged in" message:@"Please log in or signup to favorite snaps" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //query the relation for the user and add the favorite snap
        //[FDKeychain saveItem:password forKey:@"password" forService:@"parselogin" error:&error];

        NSError *error = nil;
        NSString *password = [FDKeychain itemForKey:@"password" forService:@"parselogin" error:&error];
        NSString *username = self.profile.username;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if(user){
                PFObject *snap = self.s.snapPFObject;
                
                PFRelation *relation = [user relationForKey:@"favoriteSnaps"];
                [relation addObject:snap];
                
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorited!" message:@"Successfully favorited the snap." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to favorite" message:@"Sorry, unable to favorite image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to favorite" message:@"Sorry, unable to favorite image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }
}

- (void)plusCookie{
    NSLog(@"plusCookie parseObjectId: %@", self.s.snapPFObject.objectId);
    
    [self.s giveCookieToSnap:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            self.s.numCookies++;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Gave a cookie!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            self.numCookiesLabel.text = [NSString stringWithFormat:@"Number of Cookies: %d", self.s.numCookies];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Failed to give cookie.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)minusCookie{
    NSLog(@"minusCookie parseObjectId: %@", self.s.snapPFObject.objectId);
    
    [self.s removeCookieFromSnap:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            self.s.numCookies--;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Removed a cookie!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            self.numCookiesLabel.text = [NSString stringWithFormat:@"Number of Cookies: %d", self.s.numCookies];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Failed to remove cookie.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (UIView *)createNumberOfCookiesView{
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, screenBounds.size.height - 160, self.view.bounds.size.width, 20)];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.8f;
    
    UILabel *numCookiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height)];
    numCookiesLabel.textAlignment = NSTextAlignmentLeft;
    numCookiesLabel.font = [UIFont fontWithName:@"ArialMT" size:12];
    //numCookiesLabel.text = @"Number of Cookies: ";
    numCookiesLabel.text = [NSString stringWithFormat:@"Number of Cookies: %d", self.s.numCookies];
    
    self.numCookiesLabel = numCookiesLabel;
    [view addSubview:numCookiesLabel];
    
    return view;
}

- (UITextView *)infoTextView{
    
    NSString *imageTitle = [self.s.title stringByAppendingString:@"\n"];
    
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:imageTitle attributes:@{NSFontAttributeName: [UIFont fontWithName:@"ArialMT" size:15]}];
    
    NSAttributedString *descriptionString = [[NSAttributedString alloc] initWithString:[self.s.description stringByAppendingString: @"\n"]attributes:@{NSFontAttributeName: [UIFont fontWithName:@"ArialMT" size:12]}];
    
    NSAttributedString *publishedByString = [[NSAttributedString alloc] initWithString:[@"published by: " stringByAppendingString: self.s.publisherUsername] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"ArialMT" size:12]}];
    
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc] init];
    
    [textStr appendAttributedString:titleString];
    [textStr appendAttributedString:descriptionString];
    [textStr appendAttributedString:publishedByString];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:textStr];
    
    NSLayoutManager *textLayout = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:textLayout];
    
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(screenBounds.size.width, 100)];
    
    [textLayout addTextContainer:textContainer];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(screenBounds.origin.x,screenBounds.size.height - 140,screenBounds.size.width,100) textContainer:textContainer];
    
    textView.backgroundColor = [UIColor whiteColor];
    textView.alpha = 0.8f;
    textView.editable = NO;
    
    return textView;
}


@end
