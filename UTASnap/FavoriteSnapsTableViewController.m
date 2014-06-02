//
//  FavoriteSnapsTableViewController.m
//  UTASnap
//
//  Created by Ayoka Systems on 4/25/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "FavoriteSnapsTableViewController.h"
#import "FavoriteSnapTableViewCell.h"
#import "Snap.h"
#import "UserProfile.h"
#import "SnapDataStore.h"
#import "SingleImageViewController.h"
#import <Parse/Parse.h>

@interface FavoriteSnapsTableViewController ()

@end

@implementation FavoriteSnapsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Favorite Snaps";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"FavoriteSnapCell" bundle:nil];
    
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"FavoriteSnapCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.favoriteSnaps count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *o = [self.favoriteSnaps objectAtIndex:indexPath.row];
    
    Snap *s = [Snap new];
    s.title = o[@"title"];
    s.description = o[@"description"];
    s.numCookies = [o[@"numCookies"] intValue];
    s.publisherUsername = o[@"publisherUsername"];
    s.snapPFObject = [self.favoriteSnaps objectAtIndex:indexPath.row];
    
    SnapDataStore *snapData = [SnapDataStore sharedStore];
    UserProfile *user = [snapData user];
    
    PFFile *imageFile = o[@"imageFile"];
    
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        //TODO
        if(!error){
            NSLog(@"retrieving image data");
            UIImage *image = [UIImage imageWithData:data];
            s.snapImage = image;
            SingleImageViewController *singleImageVc = [SingleImageViewController new];
            singleImageVc.s = s;
            singleImageVc.profile = user;
            [self presentViewController:singleImageVc animated:YES completion:nil];
            
        }else{
            NSLog(@"image data retrieval error");
            NSString *errorStr = [error localizedDescription];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: errorStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteSnapTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"FavoriteSnapCell" forIndexPath:indexPath];
    PFObject *o = [self.favoriteSnaps objectAtIndex:indexPath.row];
    cell.titleTextLbl.text = o[@"title"];
    cell.descriptionTextlbl.text = o[@"description"];
    return cell;
}

@end
