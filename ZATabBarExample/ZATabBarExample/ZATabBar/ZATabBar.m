//
//  ZATabBar.m
//  Copyright (c) 2013 Istergul. All rights reserved.
//

#import "ZATabBar.h"
#import <QuartzCore/QuartzCore.h>

@interface ZATabBar ()

@end

@implementation ZATabBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray {
    self = [super initWithFrame:frame];
    if (self) {
		[self configure];
		[self setImages:imageArray];
    }
    return self;
}

- (void)configure {
    self.backgroundColor = [UIColor clearColor];
    _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_backgroundView];
    
    self.backBtnView = [[UIView alloc] init];
    self.backBtnView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    [self calcPositionButtons];
    [self addSubview:self.backBtnView];
    
    self.buttons = [[NSMutableArray alloc] init];
}

- (CGFloat)buttonItemWidth {
    CGFloat res = (_buttonItemWidth) ? _buttonItemWidth : 50.0f;
    return res;
}

- (void)setButtonItemWidth:(CGFloat)buttonItemWidth {
    _buttonItemWidth = buttonItemWidth;
    [self calcPositionButtons];
}

- (void)setButtonInsets:(UIEdgeInsets)buttonInsets {
    _buttonInsets = buttonInsets;
    [self calcPositionButtons];
}

- (void)calcPositionButtons {
    for (UIButton *btn in self.buttons) {
        btn.frame = CGRectMake(self.buttonItemWidth * btn.tag + self.buttonInsets.left,
                               self.buttonInsets.top,
                               self.buttonItemWidth - self.buttonInsets.left - self.buttonInsets.right,
                               self.frame.size.height - self.buttonInsets.top - self.buttonInsets.bottom);
    }
    CGRect backFrame = CGRectMake((self.bounds.size.width-self.buttonItemWidth*self.buttons.count)/2.0f,
                                  0.0f,
                                  self.buttonItemWidth*self.buttons.count,
                                  self.bounds.size.height);
    NSLog(@"%@", NSStringFromCGRect(backFrame));
    self.backBtnView.frame = backFrame;
}


- (void)setImages:(NSArray *)imageArray {
    for (int i = 0; i < [imageArray count]; i++) {
        NSDictionary *imgs = [imageArray objectAtIndex:i];
        [self insertTabWithImageDic:imgs atIndex:i];
    }
}

- (void)setBackgroundImage:(UIImage *)img {
	[_backgroundView setImage:img];
}

- (void)tabBarButtonClicked:(UIButton *)sender {
	[self selectTabAtIndex:sender.tag];
    NSLog(@"Select index: %d",sender.tag);
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [_delegate tabBar:self didSelectIndex:sender.tag];
    }
    NSLog(@"%@", (sender.isSelected) ? @"YES" : @"NO");
}

- (void)selectTabAtIndex:(NSInteger)index {
	for (int i = 0; i < [self.buttons count]; i++) {
		UIButton *b = [self.buttons objectAtIndex:i];
		b.selected = NO;
//        b.highlighted = NO;
        b.backgroundColor = [UIColor clearColor];
		b.userInteractionEnabled = YES;
	}
	UIButton *btn = [self.buttons objectAtIndex:index];
	btn.selected = YES;
//    btn.highlighted = YES;
    UIColor *color = (self.selectedColor) ? self.selectedColor : [UIColor clearColor];
    btn.backgroundColor = color;
    btn.userInteractionEnabled = NO;
}

- (void)removeTabAtIndex:(NSInteger)index {
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
    
    // Re-index the buttons
    for (UIButton *btn in self.buttons) {
        if (btn.tag > index) {
            btn.tag --;
        }
    }
    [self calcPositionButtons];
}

- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index {
    // Re-index the buttons
    for (UIButton *b in self.buttons) {
        if (b.tag >= index) {
            b.tag ++;
        }
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = NO;
    btn.tag = index;
    btn.frame = CGRectMake(self.buttonItemWidth * index + self.buttonInsets.top,
                           0 + self.buttonInsets.left,
                           self.buttonItemWidth - self.buttonInsets.left - self.buttonInsets.right,
                           self.frame.size.height - self.buttonInsets.top - self.buttonInsets.bottom);
    [btn setImage:[dict objectForKey:@"Normal"] forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:@"Active"] forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:@"Active"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [self.buttons insertObject:btn atIndex:index];
    [self.backBtnView addSubview:btn];
    
    [self calcPositionButtons];
}

@end
