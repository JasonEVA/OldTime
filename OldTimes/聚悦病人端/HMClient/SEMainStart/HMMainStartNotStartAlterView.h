//
//  HMMainStartNotStartAlterView.h
//  HMClient
//
//  Created by JasonWang on 2017/5/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//  首页未完成弹出框

#import <UIKit/UIKit.h>
#import "HMSEMainStartEnum.h"

@class PlanMessionListItem;
typedef void(^MSAlterBlock)(HMMainStartAlterBtnType clickType);

@interface HMMainStartNotStartAlterView : UIView
@property (nonatomic, strong) PlanMessionListItem *tempModel;
- (void)configImage:(UIImage *)image titel:(NSString *)titel;
- (void)btnClickBlock:(MSAlterBlock)block;
@end
