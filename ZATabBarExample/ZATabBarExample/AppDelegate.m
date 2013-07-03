//
//  AppDelegate.m
//  ZATabBarExample
//
//  Created by Istergul on 24.06.13.
//  Copyright (c) 2013 Istergul. All rights reserved.
//

#import "AppDelegate.h"

#import "ZATabBarController.h"
#import "ViewController.h"

@implementation AppDelegate


- (NSArray *)tabBarControllers
{
    ViewController *vc1 = [[ViewController alloc] init];
    vc1.title = @"controller 1";
    vc1.view.backgroundColor = [UIColor yellowColor];
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    ViewController *vc2 = [[ViewController alloc] init];
    vc2.title = @"controller 2";
    vc2.view.backgroundColor = [UIColor greenColor];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    ViewController *vc3 = [[ViewController alloc] init];
    vc3.title = @"controller 3";
    vc3.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *nc3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    
    NSMutableArray *tabVCArray = [NSMutableArray arrayWithObjects:nc1, nc2, nc3, nil];
    return tabVCArray;
}

- (NSArray *)tabBarImages
{
    NSDictionary *imgDict1 = @{
        @"Normal":  [UIImage imageNamed:@"tabBarAR"],
        @"Active":  [UIImage imageNamed:@"tabBarARActive"]
    };
    
    NSDictionary *imgDict2 = @{
        @"Normal":  [UIImage imageNamed:@"tabBarGuide"],
        @"Active":  [UIImage imageNamed:@"tabBarGuideActive"]
    };
    
    NSDictionary *imgDict3 = @{
        @"Normal":  [UIImage imageNamed:@"tabBarInfo"],
        @"Active":  [UIImage imageNamed:@"tabBarInfoActive"]
    };
    
    return @[imgDict1, imgDict2, imgDict3];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSArray *tabVCArray = [self tabBarControllers];
    NSArray *imgArray = [self tabBarImages];
    
    ZATabBarController *tabBarController = [[ZATabBarController alloc] init];
    [tabBarController setViewControllers:tabVCArray imageArray:imgArray];
    tabBarController.tabBar.buttonItemWidth = 80.0f;
    tabBarController.tabBar.backgroundView.backgroundColor = [UIColor colorWithRed:116.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1];
    tabBarController.tabBar.selectedColor = [UIColor colorWithRed:96.0f/255.0f green:96.0f/255.0f blue:96.0f/255.0f alpha:1];
    
    NSDictionary *imgDict3 = @{
        @"Normal":  [UIImage imageNamed:@"tabBarInvest"],
        @"Active":  [UIImage imageNamed:@"tabBarInvestActive"]
    };
    [tabBarController insertViewController:[[ViewController alloc] init] withImageDic:imgDict3 atIndex:3];
    tabBarController.tabBar.buttonInsets = UIEdgeInsetsMake(5, 2, 5, 2);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = tabBarController;
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
