//
//  ZATabBar.h
//  Copyright (c) 2013 Istergul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZATabBarDelegate;

@interface ZATabBar : UIView

@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, assign) id<ZATabBarDelegate> delegate;

@property (nonatomic, retain) UIColor *selectedColor;

@property (nonatomic) CGFloat buttonItemWidth;
@property (nonatomic) UIEdgeInsets buttonInsets;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)setImages:(NSArray *)imageArray;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

@end

@protocol ZATabBarDelegate<NSObject>
@optional
- (void)tabBar:(ZATabBar *)tabBar didSelectIndex:(NSInteger)index;
@end