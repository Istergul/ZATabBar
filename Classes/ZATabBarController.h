//
//  ZATabBarController.h
//  CityGuide
//
//  Copyright (c) 2013 Istergul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZATabBar.h"

@protocol ZATabBarControllerDelegate;

@interface ZATabBarController : UIViewController <ZATabBarDelegate>

@property (nonatomic, readonly) UIViewController *selectedViewController;
@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic, readonly) ZATabBar *tabBar;
@property (nonatomic, assign) id<ZATabBarControllerDelegate> delegate;

@property (nonatomic) BOOL tabBarHidden;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;
- (void)setViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;

- (void)displayViewAtIndex:(NSUInteger)index;

- (void)removeViewControllerAtIndex:(NSUInteger)index;
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

@end

@protocol ZATabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(ZATabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(ZATabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end
