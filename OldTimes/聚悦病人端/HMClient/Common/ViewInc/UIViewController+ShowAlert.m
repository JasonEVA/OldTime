//
//  UIViewController+ShowAlert.m
//  ZJKPatient
//
//  Created by yinqaun on 15/6/11.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import "UIViewController+ShowAlert.h"

@implementation UIViewController (ShowAlert)

//- (void) showAlertMessage:(NSString*) msg
//{
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//}

- (void) showAlertMessage:(NSString *)msg title:(NSString*) title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topMostViewController = keyWindow.rootViewController;
    
    [topMostViewController presentViewController:alert animated:YES completion:nil];
}

- (void) showAlertMessage:(NSString*) msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topMostViewController = keyWindow.rootViewController;
    
    [topMostViewController presentViewController:alert animated:YES completion:nil];
}

- (void) showAlertMessage:(NSString*) msg confirmTitle:(NSString*) confirmTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topMostViewController = keyWindow.rootViewController;
    
    [topMostViewController presentViewController:alert animated:YES completion:nil];
}

+ (UIViewController*) topViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

- (void)showAlertMessage:(NSString *)msg title:(NSString *)title clicked:(void(^)())clicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (clicked) {
            clicked();
        }
    }]];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topMostViewController = keyWindow.rootViewController;
    
    [topMostViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertMessage:(NSString *)msg clicked:(void(^)())clicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (clicked) {
            clicked();
        }
    }]];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topMostViewController = keyWindow.rootViewController;
    
    [topMostViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertMessage:(NSString *)msg duration:(NSTimeInterval)duration {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    [self performSelector:@selector(dismissAlertViewController:) withObject:alert afterDelay:duration];
}

- (void)showAlertMessage:(NSString *)msg cancelTitle:(NSString *)cancelTitle cancelClicked:(void(^)())cancelClicked confirmTitle:(NSString *)confirmTitle confirmClicked:(void(^)())confirmClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelClicked) {
            cancelClicked();
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (confirmClicked) {
            confirmClicked();
        }
    }]];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topMostViewController = keyWindow.rootViewController;
    
    [topMostViewController presentViewController:alert animated:YES completion:nil];
}

- (void)dismissAlertViewController:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:nil];
}

@end
