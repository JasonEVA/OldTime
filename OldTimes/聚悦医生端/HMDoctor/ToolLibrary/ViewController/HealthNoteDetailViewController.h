//
//  HealthNoteDetailViewController.h
//  HMClient
//
//  Created by lkl on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"
@class IMNewsModel;
@interface HealthNoteDetailViewController : HMBasePageViewController
//通过IM消息卡片进入详情
- (instancetype)initWithNewsModel:(IMNewsModel *)model;
@end
