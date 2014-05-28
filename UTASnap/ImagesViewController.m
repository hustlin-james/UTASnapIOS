//
//  ImagesViewController.m
//  UTASnap
//
//  Created by feifan meng on 4/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ImagesViewController.h"
#import "ImageUtils.h"
#import "ImagesViewImageCell.h"
#import "GlobalConstants.h"
#import "SingleImageViewController.h"
#import "SnapDataStore.h"
#import "Snap.h"
#import "UserProfile.h"
#import <Parse/Parse.h>

@interface ImagesViewController ()

@property (nonatomic) NSMutableArray *mySnaps;
@property (nonatomic, weak) UIRefreshControl *refreshControl;

@property (nonatomic) UserProfile *profile;

@end

@implementation ImagesViewController

- (instancetype) init{
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    self = [super initWithCollectionViewLayout:flow];
    if(self){
        self.navigationItem.title = @"Snaps";
        self.mySnaps = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINib *nib = [UINib nibWithNibName:@"ImagesViewImageCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"ImagesViewImageCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setItemSize:CGSizeMake(IMAGE_CELL_WIDTH, IMAGE_CELL_HEIGHT)];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];

    //Refresh control from pulling on the view
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    self.refreshControl = refreshControl;
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    //Go to parse and fetch the snap objects
    if([self.mySnaps count] == 0){
        SnapDataStore *dataStore = [SnapDataStore sharedStore];
        [dataStore getSnapImagesByNumCookiesAndBy:0 WithCallBack:@selector(getSnapImagesCallBack:error:) andWith:self];
    }
    
    //check if the user is logged in or not
    SnapDataStore *snapData = [SnapDataStore sharedStore];
    UserProfile *user = [snapData user];
    
    if(user && user.emailVerified == YES && user.loggedIn == YES){
        NSLog(@"user is logged in");
        self.profile = user;
    }else{
        self.profile = nil;
        NSLog(@"user is not logged in");
    }
    
    [super viewWillAppear:animated];
}

-(void)refreshControlAction{
    NSLog(@"Refereshing the data");
    
    [self.mySnaps removeAllObjects];
    SnapDataStore *dataStore = [SnapDataStore sharedStore];
    [dataStore getSnapImagesByNumCookiesAndBy:0 WithCallBack:@selector(getSnapImagesCallBack:error:) andWith:self];
    
    [self.refreshControl endRefreshing];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.mySnaps count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImagesViewImageCell *cell = (ImagesViewImageCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"ImagesViewImageCell" forIndexPath:indexPath];
    
    //setup the cell
    Snap *s = [self.mySnaps objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.cellImage.image = [ImageUtils createThumbnailFromImage:s.snapImage];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Snap *s = [self.mySnaps objectAtIndex:indexPath.row];
    
    SingleImageViewController *singleImageVc = [SingleImageViewController new];
    singleImageVc.s = s;
    singleImageVc.profile = self.profile;
    
    [self presentViewController:singleImageVc animated:YES completion:nil];
}

- (void)getSnapImagesCallBack:(NSArray *)objects error:(NSError *)error {
    
    if(!error){
        
        NSLog(@"numObjects: %d", [objects count]);
        
        for(int i = 0; i < [objects count]; i++){
            
            Snap *s = [Snap new];
            s.title = objects[i][@"title"];
            s.description = objects[i][@"description"];
            s.numCookies = [objects[i][@"numCookies"] intValue];
            s.publisherUsername = objects[i][@"publisherUsername"];
            //s.parseObjectId = [objects[i] objectId];
            s.snapPFObject = objects[i];
            
            [self.mySnaps addObject: s];
            
            PFFile *imageFile = objects[i][@"imageFile"];
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                //TODO
                if(!error){
                    UIImage *image = [UIImage imageWithData:data];
                    s.snapImage = image;
                    [self.collectionView reloadData];
                    
                }else{
                    NSLog(@"couln't retrieve image: %@", [error localizedDescription]);
                }
            }];
        }
        
    }else{
        NSLog(@"error retrieving images: %@", [error localizedDescription]);
    }
}
@end
