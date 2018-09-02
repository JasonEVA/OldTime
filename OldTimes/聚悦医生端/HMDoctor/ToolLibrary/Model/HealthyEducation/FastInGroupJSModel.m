//
//  FastInGroupJSModel.m
//  HMDoctor
//
//  Created by jasonwang on 2017/4/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//  快速入组js注入model

#import "FastInGroupJSModel.h"

@implementation FastInGroupJSModel
- (NSString *)getDoctorUserId {
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    return [NSString stringWithFormat:@"%ld",(long)curStaff.userId];
}

- (NSString *)getDoctorUserName {
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    return curStaff.staffName;
}

- (void)getPageTitle:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(FastInGroupJSModelDelegateCallBack_getTitel:)]) {
        [self.delegate FastInGroupJSModelDelegateCallBack_getTitel:string];
    }
}

//添加监测数据
- (void)goAddRecord:(NSString *)userId{
    
    if ([self.delegate respondsToSelector:@selector(FastInGroupJSModelDelegateCallBack_goAddRecord:)]) {
        [self.delegate FastInGroupJSModelDelegateCallBack_goAddRecord:userId];
    }
}

@end
