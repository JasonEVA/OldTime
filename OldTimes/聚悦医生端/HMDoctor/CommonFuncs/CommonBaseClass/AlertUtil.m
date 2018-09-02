//
//  AlertUtil.m
//  DingCareDemo
//
//  Created by yinquan on 17/2/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "AlertUtil.h"

@implementation AlertUtil

+ (UIViewController*) topmostViewContoller
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    return appRootVC;
}

+ (void) showAlert:(NSString*) message alertConfirmButtonClickBlock:(AlertConfirmButtonClickBlock) block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __block AlertConfirmButtonClickBlock confirmBlock = block;
    //添加确定
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定按钮");
        if (confirmBlock)
        {
            confirmBlock();
        }
    }]];
    UIViewController* topmostViewController = [self topmostViewContoller];
    [topmostViewController presentViewController:alert animated:YES completion:nil];
}

+ (void) showAlert:(NSString*) message
        alertConfirmButtonClickBlock:(AlertConfirmButtonClickBlock) aConfirmBlock
        alertCancelButtonClickBlock:(AlertCancelButtonClickBlock) aCancelBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __block AlertConfirmButtonClickBlock confirmBlock = aConfirmBlock;
    //添加确定
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定按钮");
        if (confirmBlock)
        {
            confirmBlock();
        }
    }]];
    __block AlertConfirmButtonClickBlock cancelBlock = aCancelBlock;
    //添加确定
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消按钮");
        if (cancelBlock)
        {
            cancelBlock();
        }
    }]];
    UIViewController* topmostViewController = [self topmostViewContoller];
    [topmostViewController presentViewController:alert animated:YES completion:nil];
}
@end
