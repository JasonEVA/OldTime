//
//  HMCommonLanguageViewController.h
//  HMDoctor
//
//  Created by jasonwang on 16/9/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//  常用语列表页

#import "HMBaseViewController.h"
typedef void(^cellClick)(NSString *content);
@interface HMCommonLanguageViewController : HMBaseViewController
- (void)btnClick:(cellClick)block;

@end
