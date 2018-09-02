//
//  HMDoctorIconNavView.h
//  HMClient
//
//  Created by jasonwang on 2016/10/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//  医患聊天顶部医生头像缩略图View

#import <UIKit/UIKit.h>

@interface HMDoctorIconNavView : UIView
- (void)fillDataWithDataList:(NSArray<StaffInfo *> *)dataList;
@end
