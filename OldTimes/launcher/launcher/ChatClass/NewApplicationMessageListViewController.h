//
//  NewApplicationMessageListViewController.h
//  launcher
//
//  Created by 马晓波 on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "IMApplicationEnum.h"

@interface NewApplicationMessageListViewController : BaseViewController
// 根据应用类型不同区分
- (instancetype)initWithAppType:(IM_Applicaion_Type)type NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用继承ChatApplicationBaseViewController的VC");
@end
