//
//  HealthDetectPlanEditFooterView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthDetectPlanEditFooterView : UIView

@property (nonatomic, strong) UIButton* deleteButton;   //删除
@property (nonatomic, strong) UIButton* appendButton;   //添加预警
@property (nonatomic, strong) UIButton* ascendingButton;    //升序
@property (nonatomic, strong) UIButton* descendingButton;   //降序
@end
