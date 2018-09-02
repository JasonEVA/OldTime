//
//  NewSiteMessageAssessModel.h
//  HMClient
//
//  Created by jasonwang on 2017/2/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信 健康评估model

#import <Foundation/Foundation.h>

@interface NewSiteMessageAssessModel : NSObject
@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *assessCode;
@property (nonatomic, copy) NSString *type;
@property (nonatomic) NSInteger recordId;
@property (nonatomic) NSInteger moudleId;
@property (nonatomic) NSInteger staffUserId;
@property (nonatomic) NSInteger userId;

@end

// {"msgTitle":"阶段评估问卷","recordId":126732,"moudleId":10521,"staffUserId":10612,"userId":10645,"assessCode":"JDXPG","type":"assessPush","msg":"JasonWang，您好，为了了解您最近的执行效果，请点击填写《测试阶段性评估模板阶段评估》。谢谢！"}
