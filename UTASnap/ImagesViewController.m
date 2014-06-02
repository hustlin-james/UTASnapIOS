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

#define NUM_CELLS_PER_PAGE 10

@interface ImagesViewController (){
    int currentPage;
}

@property (nonatomic,strong) NSMutableArray *mySnaps;
@property (nonatomic, weak) UIRefreshControl *refreshControl;

@property (nonatomic) UserProfile *profile;

@end

@implementation ImagesViewController

- (instancetype) init{
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    self = [super initWithCollectionViewLayout:flow];
    if(self){
        self.navigationItem.title = @"Snaps";
        //self.mySnaps = [[NSMutableArray alloc] init];
        self.mySnaps = [NSMutableArray array];
        
        for(int i = 0; i < NUM_CELLS_PER_PAGE; i++){
            [self.mySnaps addObject:[Snap new]];
        }
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
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
    //currentPage = 0;
    //[self.mySnaps removeAllObjects];
    /*
    SnapDataStore *dataStore = [SnapDataStore sharedStore];
    [dataStore getSnapImagesByNumCookiesAndByOffset:0 andByLimit:NUM_CELLS_PER_PAGE WithCallBack:@selector(getSnapImagesCallBack:error:) andWithTarget:self];
    
    [self.refreshControl endRefreshing];
     */
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"self.mySnaps: %d", [self.mySnaps count]);
    return [self.mySnaps count];
    //return 20;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"indexPath.item: %d", indexPath.item);
    
    int numCells = indexPath.item+1;
    if( numCells % NUM_CELLS_PER_PAGE == 0){
        currentPage = numCells / NUM_CELLS_PER_PAGE;
        
        NSLog(@"currentPage: %d", currentPage);
        NSLog(@"self.Snaps.count: %d", self.mySnaps.count);
        
        if(self.mySnaps.count <= numCells){
            NSLog(@"fetching more items");
            for(int i = 0; i < NUM_CELLS_PER_PAGE; i++){
                [self.mySnaps addObject:[Snap new]];
            }
            [self.collectionView reloadData];
        }else{
            //[self.collectionView reloadData];
        }
    }
    
    ImagesViewImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ImagesViewImageCell" forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor clearColor];
    //UIImage *image = [UIImage imageNamed:@"a.jpg"];
    //cell.cellImage.image = image;
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    Snap *s = [self.mySnaps objectAtIndex:indexPath.row];
    
    SingleImageViewController *singleImageVc = [SingleImageViewController new];
    singleImageVc.s = s;
    singleImageVc.profile = self.profile;
    
    [self presentViewController:singleImageVc animated:YES completion:nil];
     */
}

- (void)getSnapImagesCallBack:(NSArray *)objects error:(NSError *)error {
    
    if(!error){
        
        NSLog(@"objects count: %d", objects.count);
        NSLog(@"currentPage: %d", currentPage);
        
        for(int i = 0; i < [objects count]; i++){
            
            int index = NUM_CELLS_PER_PAGE*currentPage + i;
            
            PFObject *o = objects[i];
            Snap *s = self.mySnaps[index];
            s.title =o[@"title"];
            s.description = o[@"description"];
            s.numCookies = [o[@"numCookies"] intValue];
            s.publisherUsername = o[@"publisherUsername"];
            s.snapPFObject = o;
            
            PFFile *imageFile = objects[i][@"imageFile"];
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                //TODO
                if(!error){
                    UIImage *image = [UIImage imageWithData:data];
                    s.snapImage = image;
                    //[self.collectionView reloadData];
                    NSIndexPath *ip = [NSIndexPath indexPathForItem:index inSection:0];
                    [self.collectionView reloadItemsAtIndexPaths:@[ip]];
                }else{
                    NSLog(@"couln't retrieve image: %@", [error localizedDescription]);
                }
            }];
        }
        
        currentPage++;
        
    }else{
        NSLog(@"error retrieving images: %@", [error localizedDescription]);
    }
}
@end
