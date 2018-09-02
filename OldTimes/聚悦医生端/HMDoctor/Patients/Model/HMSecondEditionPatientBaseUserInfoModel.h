//
//  HMSecondEditionPatientBaseUserInfoModel.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//  用户基本信息

#import <Foundation/Foundation.h>

@interface HMSecondEditionPatientBaseUserInfoModel : NSObject
@property (nonatomic, copy) NSString *sex;        //性别
@property (nonatomic) NSInteger age;        //年龄
@property (nonatomic, copy) NSString *userName;   //姓名
@property (nonatomic, copy) NSString *joinCode;   //入组编号
@property (nonatomic, copy) NSString *mobile;     //手机
@end
