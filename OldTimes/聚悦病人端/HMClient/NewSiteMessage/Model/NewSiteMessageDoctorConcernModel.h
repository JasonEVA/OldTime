//
//  NewSiteMessageDoctorConcernModel.h
//  HMClient
//
//  Created by jasonwang on 2017/2/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信 医生关怀（医生问候）model

#import <Foundation/Foundation.h>

@interface NewSiteMessageDoctorConcernModel : NSObject

@property (nonatomic, copy) NSString *voice;
@property (nonatomic, copy) NSString *staffUserId;
@property (nonatomic, copy) NSArray  *careImg;
@property (nonatomic, copy) NSArray  *careImgDesc;
@property (nonatomic, copy) NSString *careId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *classId;
@property (nonatomic, copy) NSString *classTitle;
@property (nonatomic, copy) NSString *classPaper;
@property (nonatomic, copy) NSString *voiceLength;
@end
