//
//  ZATabBarController.m
//  CityGuide
//
//  Created by Istergul on 06.05.13.
//  Copyright (c) 2013 Istergul. All rights reserved.
//

#import "ZATabBarController.h"

#define kTabBarHeight 49.0f


@interface ZATabBarController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *transitionView;

@end

@implementation ZATabBarController


#pragma mark - initialization

- (id)init {
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr {
    self = [super init];
    if (self) {
//        [self configure];
        [self setViewControllers:vcs imageArray:arr];
    }
    return self;
}

- (void)configure {
    _containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//    NSLog(@"^^ %@", NSStringFromCGRect(_containerView.frame));
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _containerView.backgroundColor = [UIColor redColor];
    
    CGRect transFrame = CGRectMake(0, 0, _containerView.bounds.size.width, _containerView.bounds.size.height - kTabBarHeight);
    _transitionView = [[UIView alloc] initWithFrame:transFrame];
    _transitionView.backgroundColor =  [UIColor greenColor];
    _transitionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _viewControllers = [[NSMutableArray alloc] init];
}

- (void)setViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr {
    for (int i = 0; i < [_viewControllers count]; i++) {
        [self removeViewControllerAtIndex:i];
    }
    
    CGRect tabFrame = CGRectMake(0, _containerView.bounds.size.height - kTabBarHeight, _containerView.bounds.size.width, kTabBarHeight);
    _tabBar = [[ZATabBar alloc] initWithFrame:tabFrame];
    _tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _tabBar.delegate = self;
    
    for (int i = 0; i < [vcs count]; i++) {
        UIViewController *vc = [vcs objectAtIndex:i];
        NSDictionary *img = [arr objectAtIndex:i];
        [self insertViewController:vc withImageDic:img atIndex:i];
    }
}


#pragma mark - controller life circle

- (void)loadView {
	[super loadView];
	
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
	self.view = _containerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.selectedIndex = 0;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	_tabBar = nil;
	_viewControllers = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//- (BOOL)tabBarTransparent
//{
//	return _tabBarTransparent;
//}

//- (void)setTabBarTransparent:(BOOL)yesOrNo {
//	if (yesOrNo == YES) {
//		_transitionView.frame = _containerView.bounds;
//	} else {
//		_transitionView.frame = CGRectMake(0, 0, _containerView.bounds.size.width, _containerView.bounds.size.height - kTabBarHeight);
//	}
//}

- (void)hidesTabBar:(BOOL)hide animated:(BOOL)animated {
//	if (hide == YES) {
//		if (self.tabBar.frame.origin.y == self.view.bounds.size.height) {
//			return;
//		}
//	} else {
//		if (self.tabBar.frame.origin.y == self.view.bounds.size.height - kTabBarHeight) {
//			return;
//		}
//	}
	
    CGRect tabBarFrame = self.tabBar.frame;
    CGRect transFrame = self.view.bounds;
    if (hide == YES) {
        tabBarFrame.origin.y = self.view.bounds.size.height;
    } else {
        tabBarFrame.origin.y = self.view.bounds.size.height - kTabBarHeight;
        transFrame.size.height = self.view.bounds.size.height - kTabBarHeight;
    }
	if (animated == YES) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
        self.tabBar.frame = tabBarFrame;
        self.transitionView.frame = transFrame;
		[UIView commitAnimations];
	} else {
        self.tabBar.frame = tabBarFrame;
        self.transitionView.frame = transFrame;
	}
//    NSLog(@"trans frame %@", NSStringFromCGRect(self.transitionView.frame));
//    NSLog(@"tabbar frame %@", NSStringFromCGRect(self.tabBar.frame));
}

- (UIViewController *)selectedViewController {
    return [_viewControllers objectAtIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)index {
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index {
    if (index >= [_viewControllers count]) {
        return;
    }
    UIViewController *vc = (UIViewController *)[_viewControllers objectAtIndex:index];
    [vc removeFromParentViewController];
    [vc.view removeFromSuperview];
    [_viewControllers removeObjectAtIndex:index];
    [_tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index {
    [_viewControllers insertObject:vc atIndex:index];
    [self addChildViewController:vc];
    [_tabBar insertTabWithImageDic:dict atIndex:index];
}

- (void)displayViewAtIndex:(NSUInteger)index {
    // Before change index, ask the delegate should change the index.
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]]) {
            return;
        }
    }
    // If target index if equal to current index, do nothing.
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0) {
        return;
    }
//    NSLog(@"Display View.");
    _selectedIndex = index;
    
	UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
	
    if (selectedVC.hidesBottomBarWhenPushed) {
//        NSLog(@"hides");
        [self hidesTabBar:YES animated:NO];
    } else {
//        NSLog(@"no hides");
        [self hidesTabBar:NO animated:NO];
    }
    
//    for (UIView *v in [_transitionView subviews]) {
//        [v removeFromSuperview];
//    }
//    NSLog(@"%@", NSStringFromCGRect(_transitionView.frame));
    
	if ([selectedVC.view isDescendantOfView:_transitionView]) {
        [_transitionView bringSubviewToFront:selectedVC.view];
    } else {
//        NSLog(@"^ %@", NSStringFromCGRect(selectedVC.view.frame));
        while (YES) {
            if (selectedVC.isViewLoaded) {
                selectedVC.view.frame = _transitionView.bounds;
                selectedVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_transitionView addSubview:selectedVC.view];
                NSLog(@"add subview");
                break;
            } else {
                NSLog(@"view not loaded");
            }
        }
	}
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController::)]) {
        [_delegate tabBarController:self didSelectViewController:selectedVC];
    }
}

#pragma mark - ZATabBarControllerDelegate

- (void)tabBar:(ZATabBar *)tabBar didSelectIndex:(NSInteger)index {
	if (self.selectedIndex == index) {
    } else {
        [self displayViewAtIndex:index];
    }
}

#pragma mark - autorotate

- (NSInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

// Determine iOS 6 Autorotation.
- (BOOL)shouldAutorotate {
    return YES;
}

// handle iOS 5 Orientation as normal
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


@end
