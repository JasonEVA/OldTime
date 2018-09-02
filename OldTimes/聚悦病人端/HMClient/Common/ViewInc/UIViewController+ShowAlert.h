//
//  UIViewController+ShowAlert.h
//  ZJKPatient
//
//  Created by yinqaun on 15/6/11.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowAlert)
{
    
}

- (void) showAlertMessage:(NSString *)msg title:(NSString*) title;
- (void) showAlertMessage:(NSString*) msg;
- (void) showAlertMessage:(NSString*) msg confirmTitle:(NSString*) confirmTitle;

+ (UIViewController*) topViewController;

- (void)showAlertMessage:(NSString *)msg title:(NSString *)title clicked:(void(^)())clicked;
- (void)showAlertMessage:(NSString *)msg clicked:(void(^)())clicked;
- (void)showAlertMessage:(NSString *)msg duration:(NSTimeInterval)duration;

- (void)showAlertMessage:(NSString *)msg cancelTitle:(NSString *)cancelTitle cancelClicked:(void(^)())cancelClicked confirmTitle:(NSString *)confirmTitle confirmClicked:(void(^)())confirmClicked;

@end
