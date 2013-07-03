ZATabBar is iOS component for creating tabbar without labels.

## Installing

```objective-c
$ edit Podfile
platform :ios
pod 'ZATabBar'

$ pod install
```


## Usage

There are two main classes in ZATabBar:

1. `ZATabBarController` - Represents controller for management tabbar.
2. `ZATabBar` - Represents view for tabbar.


### Preparation of data for the controller tabs

```objective-c
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

NSArray *tabVCArray = @[vc1, vc2, vc3];

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

NSArray *tabImgArray = @[imgDict1, imgDict2, imgDict3];
```

### Initializing controller

Initializing with params:

```objective-c
ZATabBarController *tabBarController = [[ZATabBarController alloc] initWithViewControllers:tabVCArray imageArray:tabImgArray];
```

Initialization and setting params:

```objective-c
ZATabBarController *tabBarController = [[ZATabBarController alloc] init];
[tabBarController setViewControllers:tabVCArray imageArray:tabImgArray];
```

### Customizing tabbar

Setting the width of tabs:

```objective-c
tabBarController.tabBar.buttonItemWidth = 80.0f;
```

Setting background color:

```objective-c
tabBarController.tabBar.backgroundView.backgroundColor = [UIColor blackColor];
```

Setting selected color:

```objective-c
tabBarController.tabBar.selectedColor = [UIColor greenColor];
```

Setting tab insets:

```objective-c
tabBarController.tabBar.buttonInsets = UIEdgeInsetsMake(5, 2, 5, 2);
```

### Hide tabbar

```objective-c
vc1.hidesBottomBarWhenPushed = YES; // like standart tabbar
```

