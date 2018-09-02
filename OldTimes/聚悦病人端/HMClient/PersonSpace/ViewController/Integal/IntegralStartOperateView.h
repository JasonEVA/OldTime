//
//  IntegralStartOperateView.h
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IntegralStartOperateIndex) {
    IntegralStartOperate_Rule,          //积分规则
    IntegralStartOperate_Strategy,      //积分攻略
    IntegralStartOperate_Mall,          //积分商城
};

@protocol IntegralStartOperateViewDelegate <NSObject>

- (void) operateButtonClicked:(IntegralStartOperateIndex) operateIndex;

@end

@interface IntegralStartOperateView : UIView

@property (nonatomic, weak) id<IntegralStartOperateViewDelegate> delegate;
@end
