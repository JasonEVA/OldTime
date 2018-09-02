//
//  CreateWorkCircleViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//  创建工作圈

#import "HMBaseViewController.h"

@class SelectContactTabbarView;

@interface CreateWorkCircleViewController : HMBaseViewController
@property (nonatomic, copy)  NSString  *workCircleID; // 工作圈ID

- (instancetype)initWithSelectView:(SelectContactTabbarView *)selectView nonSelectableContacts:(NSArray *)array;

@end
