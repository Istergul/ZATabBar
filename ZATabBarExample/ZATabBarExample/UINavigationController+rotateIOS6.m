//
//  UINavigationController+rotateIOS6.m
//  ZATabBarExample
//
//  Created by Istergul on 27.06.13.
//  Copyright (c) 2013 Istergul. All rights reserved.
//

#import "UINavigationController+rotateIOS6.h"

@implementation UINavigationController (rotateIOS6)

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
