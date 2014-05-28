//
//  SnapDataStore.m
//  UTASnap
//
//  Created by feifan meng on 4/9/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "SnapDataStore.h"
#import "UserProfile.h"

#import <Parse/Parse.h>

@import CoreData;

@interface SnapDataStore()

//Data Model Class
@property (nonatomic, strong) UserProfile *privateUser;

//Core Data Objects
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation SnapDataStore

+ (instancetype)sharedStore
{

    static SnapDataStore *sharedStore;
    static dispatch_once_t onceToken;
    
    dispatch_once( &onceToken , ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[SnapDataStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate{
    self = [super init];
    if(self){
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString *path = self.itemArchievePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
            @throw [NSException exceptionWithName:@"Open Failure" reason:[error localizedDescription] userInfo:nil];
        }
        
        _context = [[NSManagedObjectContext alloc]init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadUser];
    }
    return self;
}

- (NSString *)itemArchievePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"snapdatastore.data"];
}

- (BOOL)saveChanges{
    NSError *error;
    BOOL successful = [self.context save: &error];
    NSLog(@"saving changes");
    if(!successful)
        NSLog(@"Error saving: %@", [error localizedDescription]);
    return successful;
}
- (UserProfile *) createUser{
    //There should only ever be one user in the database
    //thus we need to delete the previous user
    UserProfile *profile = [NSEntityDescription insertNewObjectForEntityForName:@"UserProfile" inManagedObjectContext:self.context];
    return profile;
}

- (UserProfile *)user{
    /*
    if(!self.privateUser){
        [self loadUser];
    }
     */
    [self loadUser];
    NSLog(@"self.privateUser: %@", self.privateUser);
    return self.privateUser;
}

- (void) deleteOtherUsers{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"UserProfile" inManagedObjectContext:self.context];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    
    if(!result)
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    
    NSMutableArray *users =[[NSMutableArray alloc] initWithArray:result];
    for(UserProfile *p in users){
        [self.context deleteObject:p];
    }
}
- (void) loadUser{
    NSLog(@"loadUser: %@", self.privateUser);
    if(!self.privateUser || self.privateUser.username == nil){
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"UserProfile" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if(!result)
          [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        
        self.privateUser = [[[NSMutableArray alloc] initWithArray:result] firstObject];
    }
}

-(void)getSnapImagesByNumCookiesAndBy:(int)offset WithCallBack:(SEL)myFunction andWith: (id)target{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Snap"];
    [query orderByDescending:@"numCookies"];
    query.skip = offset;
    
    [query findObjectsInBackgroundWithTarget:target selector:myFunction];
}
@end
