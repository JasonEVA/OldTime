//
//  UIView+Progress.h
//  ZJKPatient
//
//  Created by yinqaun on 15/6/4.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

#define kZJKWaitViewTag 0x3510

#define kWXMImageProgressViewTag  0x5420

@interface UIView (Progress)

- (void) showWaitView;
- (void) showWaitView:(NSString*) content;
- (void) closeWaitView;

- (void) showImageProgressView:(NSInteger) progress;

@end
