//
//  HealthRecodUpLoadSuccessView.h
//  HMClient
//
//  Created by jasonwang on 2016/12/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//  健康记录保存成功后停留3秒view

#import <UIKit/UIKit.h>

typedef void(^successViewBlock)();

@interface HealthRecodUpLoadSuccessView : UIView
- (void)showSuccessView;
- (void)jumpToNextStep:(successViewBlock)block;
@end
