//
//  HMThirdEditionPatitentBaseInfoModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第三版患者基本信息model

#import <Foundation/Foundation.h>

@interface HMThirdEditionPatitentBaseInfoModel : NSObject
@property (nonatomic, copy) NSString *sex;        //性别
@property (nonatomic) NSInteger age;        //年龄
@property (nonatomic, copy) NSString *userName;   //姓名
@property (nonatomic, copy) NSString *joinCode;   //入组编号
@property (nonatomic, copy) NSString *mobile;     //手机
@property (nonatomic, copy) NSString *imgUrl;
@end

@interface HMThirdEditionPatitentArchiveInfoModel : NSObject
@property (nonatomic, copy) NSString *contactName;        //姓名
@property (nonatomic, copy) NSString *contactRelation;   //关系
@property (nonatomic, copy) NSString *contactMobile;     //电话
@property (nonatomic, copy) NSString *educationLevel;     //教育
@property (nonatomic, copy) NSString *profession;     //职业
@property (nonatomic, copy) NSString *medicalPayment;   //付费方式
@property (nonatomic, copy) NSString *presentRegionFullName;     //地址
@end
