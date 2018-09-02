//
//  SEDoctorSiteMessageEnmu.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
// 站内信 分类type
typedef NS_ENUM(NSUInteger, SiteMessageSecondEditionType) {
    
    SiteMessageSecondEditionType_GG,                 //公告 YS_GG
    
    SiteMessageSecondEditionType_YHRZ,               //用户入组 YS_YHRZ
    
    SiteMessageSecondEditionType_YZ,                 //约诊 YS_YZ
    
    SiteMessageSecondEditionType_JKJH,               //健康计划 YS_JKJH
    
    SiteMessageSecondEditionType_JKBG,               //健康报告 YS_JKBG
    
    SiteMessageSecondEditionType_JDPG,               //健康评估 YS_JDPG
    
    SiteMessageSecondEditionType_XTXX,               //系统消息 YS_XTXX
    
    SiteMessageSecondEditionType_YYJY,               //用药建议 YS_YYJY
    
    SiteMessageSecondEditionType_UnknowType = 10000  //未知类型
    
};

@interface SEDoctorSiteMessageEnmu : NSObject
+ (SiteMessageSecondEditionType)acquireMessageTypeWithString:(NSString *)string;
@end
