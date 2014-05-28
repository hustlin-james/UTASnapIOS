//
//  AppDelegate.m
//  UTASnap
//
//  Created by feifan meng on 4/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "ImagesNavigationViewController.h"
#import "UploadNavigationViewController.h"
#import "ProfileNavigationViewController.h"
#import "ParseInfo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Parse setApplicationId:[ParseInfo appId]
                  clientKey:[ParseInfo clientKey]];
    
    //[ImagesNavigationViewController new] = [[ImagesNavigationViewController alloc] init]
    
    NSDictionary *titleTextAttr =@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],
                                   NSForegroundColorAttributeName : [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:1.0]};
    
    NSDictionary *selectedTextAttr =@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    ImagesNavigationViewController *imagesNavVc = [ImagesNavigationViewController new];
    imagesNavVc.tabBarItem.title=@"Images";
    [imagesNavVc.tabBarItem setTitleTextAttributes:titleTextAttr forState:UIControlStateNormal];
    
    [imagesNavVc.tabBarItem setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
    
    UploadNavigationViewController *uploadNavVc = [UploadNavigationViewController new];
    uploadNavVc.tabBarItem.title = @"Upload";
    [uploadNavVc.tabBarItem setTitleTextAttributes:titleTextAttr forState:UIControlStateNormal];
    [uploadNavVc.tabBarItem setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
    
    ProfileNavigationViewController *profileNavVc = [ProfileNavigationViewController new];
    profileNavVc.tabBarItem.title = @"Profile";
    [profileNavVc.tabBarItem setTitleTextAttributes:titleTextAttr forState:UIControlStateNormal];
    [profileNavVc.tabBarItem setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
    
    UITabBarController *root = [UITabBarController new];
    
    UIColor *barTintColor =[UIColor colorWithRed:0.40 green:0.67 blue:0.91 alpha:1.0];
    root.viewControllers = @[imagesNavVc,uploadNavVc,profileNavVc];
    root.tabBar.barTintColor = barTintColor;
    root.tabBar.tintColor = [UIColor whiteColor];
    
    self.window.rootViewController = root;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
