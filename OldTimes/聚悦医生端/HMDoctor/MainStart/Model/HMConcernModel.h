//
//  HMConcernModel.h
//  HMDoctor
//
//  Created by jasonwang on 2016/12/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//  群发关怀model

#import <Foundation/Foundation.h>
#import "HMConcernPatientModel.h"
#import "HMConcernTeamModel.h"

@interface HMConcernModel : NSObject
@property (nonatomic, copy) NSString *createTimeView;     //发送时间
@property (nonatomic, copy) NSString *voice;              //语音地址
@property (nonatomic, copy) NSString *careCon;            //关怀文本
@property (nonatomic, copy) NSArray <HMConcernPatientModel* >*userRemarks;             //患者信息
@property (nonatomic, copy) NSArray <HMConcernTeamModel* >*teamRemarks;             //群组信息
@property (nonatomic, copy) NSString *careTime;              //时间
@property (nonatomic, copy) NSString *classPaper;          // 宣教副标题
@property (nonatomic, copy) NSString *classTitle;          // 宣教标题
@property (nonatomic, copy) NSString *classId;             // 宣教Id
@property (nonatomic, copy) NSArray *careImg;              // 关怀图片
@property (nonatomic, copy) NSArray *careImgDesc;              // 关怀图片
@property (nonatomic, copy) NSString *voiceLength;                 // 语音长度

@end
