//
//  UIView+SizeExtension.m
//  HakimHospitalRegister
//
//  Created by YinQ on 15/1/12.
//  Copyright (c) 2015年 YinQuan. All rights reserved.
//

#import "UIView+SizeExtension.h"

@implementation UIView (SizeExtension)

- (CGSize) size
{
    return self.bounds.size;
}

- (float) left
{
    return self.frame.origin.x;
}

- (void) setLeft:(float)left
{
    CGRect rtFrame = self.frame;
    rtFrame.origin.x = left;
    [self setFrame:rtFrame];
}

- (float) top
{
    return self.frame.origin.y;
}

- (void) setTop:(float)top
{
    CGRect rtFrame = self.frame;
    rtFrame.origin.y = top;
    [self setFrame:rtFrame];
}

- (float) right
{
    return self.left + self.width;
}

- (void) setRight:(float)right
{
    CGRect rtFrame = self.frame;
    rtFrame.origin.x = right - self.width;
    [self setFrame:rtFrame];
}

- (float) bottom
{
    return self.top + self.height;
}

- (void) setBottom:(float)bottom
{
    CGRect rtFrame = self.frame;
    rtFrame.origin.y = bottom - self.height;
    [self setFrame:rtFrame];
}

- (float) width
{
    return self.size.width;
}

- (void) setWidth:(float)width
{
    CGRect rtFrame = self.frame;
    rtFrame.size.width = width;
    [self setFrame:rtFrame];
}

- (float) height
{
    return self.size.height;
}

- (void) setHeight:(float)height
{
    CGRect rtFrame = self.frame;
    rtFrame.size.height = height;
    [self setFrame:rtFrame];
}

//获取顶层UIView
+ (UIViewController *)appTopViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (UIView*)appTopView
{
    UIViewController* vcTop = [self appTopViewController];
    return vcTop.view;
}

- (void) showAlertMessage:(NSString*) msg
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
