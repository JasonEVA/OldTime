//
//  HMWebViewController.h
//  HMClient
//
//  Created by JasonWang on 2017/5/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//  通用webviewVC

#import "HMBasePageViewController.h"

@interface HMWebViewController : HMBasePageViewController
- (instancetype)initWithUrlString:(NSString *)urlString titelString:(NSString *)titelString;

@end
