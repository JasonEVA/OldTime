//
//  ATPunchAlertView.h
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ATPunchAlertViewBlock)(NSString *remark);
typedef NS_ENUM(NSInteger,CurrentStatue)
{
    k_CurrentStatus_Normal = 0, //正常
    k_CurrentStatus_Error   //异常
};
@interface ATPunchAlertView : UIView


@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *remark; //原因
@property(nonatomic, copy) NSString  *location; //地址
@property(nonatomic, assign) CurrentStatue  statue; //用于显示placeholder

@property (nonatomic, copy) ATPunchAlertViewBlock block;

- (void)writeText:(ATPunchAlertViewBlock)block;

@end
