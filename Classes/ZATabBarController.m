//
//  ZATabBarController.m
//  CityGuide
//
//  Copyright (c) 2013 Istergul. All rights reserved.
//

#import "ZATabBarController.h"

#define kTabBarHeight 49.0f


@interface ZATabBarController ()

@property (nonatomic, copy) NSMutableArray *viewControllers;

@property (nonatomic, retain) UIView *transitionView;

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
        [self configure];
    }
    return self;
}

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr {
    self = [super init];
    if (self) {
        [self configure];
        [self setViewControllers:vcs imageArray:arr];
    }
    return self;
}

- (void)configure {
    CGRect winFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGRect transFrame = CGRectMake(0, 0, winFrame.size.width, winFrame.size.height - kTabBarHeight);
    self.transitionView = [[[UIView alloc] initWithFrame:transFrame] autorelease];
    self.transitionView.backgroundColor =  [UIColor clearColor];
    self.transitionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _viewControllers = [[NSMutableArray array] retain];
}

- (void)dealloc {
    [self.transitionView release];
    [self.viewControllers release];
    
    [_tabBar release];
    
    [super dealloc];
}

- (void)setViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr {
    [_tabBar release];
    
    for (int i = 0; i < [_viewControllers count]; i++) {
        [self removeViewControllerAtIndex:i];
    }
    CGRect winFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGRect tabFrame = CGRectMake(0, winFrame.size.height - kTabBarHeight, winFrame.size.width, kTabBarHeight);
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
    
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.transitionView];
    [self.view addSubview:self.tabBar];
    
    self.selectedIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)hidesTabBar:(BOOL)hide animated:(BOOL)animated {
	
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
    int currentIndex = _selectedIndex;
    _selectedIndex = index;
    
    UIViewController *currentVC = [self.viewControllers objectAtIndex:currentIndex];
	UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
	
    if (selectedVC.hidesBottomBarWhenPushed) {
        NSLog(@"hide tabbar");
        [self hidesTabBar:YES animated:NO];
    } else {
        NSLog(@"show tabbar");
        [self hidesTabBar:NO animated:NO];
    }
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIViewController *)obj view].hidden = (idx == index) ? NO : YES;
    }];
    
    [currentVC viewWillDisappear:NO];
    [currentVC viewDidDisappear:NO];
    
	if ([selectedVC.view isDescendantOfView:_transitionView]) {
        [_transitionView bringSubviewToFront:selectedVC.view];
    } else {
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
    [selectedVC viewWillAppear:NO];
    [selectedVC viewDidAppear:NO];

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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // You do not need this method if you are not supporting earlier iOS Versions
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(NSUInteger)supportedInterfaceOrientations {
    if (self.selectedViewController)
        return [self.selectedViewController supportedInterfaceOrientations];
    
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate {
    return YES;
}


@end
