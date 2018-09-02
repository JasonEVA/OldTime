//
//  SEDoctorSiteMessageEnmu.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SEDoctorSiteMessageEnmu.h"

@implementation SEDoctorSiteMessageEnmu

+ (SiteMessageSecondEditionType)acquireMessageTypeWithString:(NSString *)string {
    if ([string isEqualToString:@"YS_GG"]) {
        return SiteMessageSecondEditionType_GG;
    }
    else if ([string isEqualToString:@"YS_YHRZ"]) {
        return SiteMessageSecondEditionType_YHRZ;
    }
    else if ([string isEqualToString:@"YS_YZ"]) {
        return SiteMessageSecondEditionType_YZ;
    }
    else if ([string isEqualToString:@"YS_JKBG"]) {
        return SiteMessageSecondEditionType_JKBG;
    }
    else if ([string isEqualToString:@"YS_JDPG"]) {
        return SiteMessageSecondEditionType_JDPG;
    }
    else if ([string isEqualToString:@"YS_XTXX"]) {
        return SiteMessageSecondEditionType_XTXX;
    }
    else if ([string isEqualToString:@"YS_YYJY"]) {
        return SiteMessageSecondEditionType_YYJY;
    }
    else if ([string isEqualToString:@"YS_JKJH"]) {
        return SiteMessageSecondEditionType_JKJH;
    }
    else {
        return SiteMessageSecondEditionType_UnknowType;
    }
    
}
@end
