//
//  NewSiteMessageMessageTypeENUM.m
//  HMClient
//
//  Created by jasonwang on 2017/2/20.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageMessageTypeENUM.h"

@implementation NewSiteMessageMessageTypeENUM

+ (SiteMessageSecondEditionType)acquireMessageTypeWithString:(NSString *)string {
    if ([string isEqualToString:@"YSGH"]) {
        return SiteMessageSecondEditionType_YSGH;
    }
    else if ([string isEqualToString:@"JKNZ"]) {
        return SiteMessageSecondEditionType_JKNZ;
    }
    else if ([string isEqualToString:@"WDYZ"]) {
        return SiteMessageSecondEditionType_WDYZ;
    }
    else if ([string isEqualToString:@"JKJH"]) {
        return SiteMessageSecondEditionType_JKJH;
    }
    else if ([string isEqualToString:@"JKPG"]) {
        return SiteMessageSecondEditionType_JKPG;
    }
    else if ([string isEqualToString:@"JKBG"]) {
        return SiteMessageSecondEditionType_JKBG;
    }
    else if ([string isEqualToString:@"XTXX"]) {
        return SiteMessageSecondEditionType_XTXX;
    }
    else if ([string isEqualToString:@"JKKT"]) {
        return SiteMessageSecondEditionType_JKKT;
    }
    else {
        return SiteMessageSecondEditionType_UnknowType;
    }
    
}

+ (NewSiteMessageYSGHType)acquireNewSiteMessageYSGHTypeWithString:(NSString *)string {
    if ([string isEqualToString:@"userCarePage"]) {
        return NewSiteMessageYSGHType_userCarePage;
    }
    else if ([string isEqualToString:@"roundsAsk"]) {
        return NewSiteMessageYSGHType_roundsAsk;
    }
    else if ([string isEqualToString:@"surveyPush"]) {
        return NewSiteMessageYSGHType_surveyPush;
    }
    else if ([string isEqualToString:@"serviceComments"]) {
        return NewSiteMessageYSGHType_serviceComments;
    }
    else if ([string isEqualToString:@"surveyReply"]) {
        return NewSiteMessageYSGHType_surveyReply;
    }
    else {
        return NewSiteMessageYSGHType_UnknowType;
    }
}

+ (NewSiteMessageJKNZType)acquireNewSiteMessageJKNZTypeWithString:(NSString *)string {
    if ([string isEqualToString:@"reviewPush"]) {
        return NewSiteMessageJKNZType_reviewPush;
    }
    else if ([string isEqualToString:@"drugPush"]) {
        return NewSiteMessageJKNZType_drugPush;
    }
    else if ([string isEqualToString:@"healthTest"]) {
        return NewSiteMessageJKNZType_healthTest;
    }
    else {
        return NewSiteMessageJKNZType_UnknowType;
    }
}

+ (NewSiteMessageWDYZType)acquireNewSiteMessageWDYZTypeWithString:(NSString *)string {
    if ([string isEqualToString:@"appointAgree"]) {
        return NewSiteMessageWDYZType_appointAgree;
    }
    else if ([string isEqualToString:@"appointRefuse"]) {
        return NewSiteMessageWDYZType_appointRefuse;
    }
    else if ([string isEqualToString:@"appointCancel"]) {
        return NewSiteMessageWDYZType_appointCancel;
    }
    else if ([string isEqualToString:@"appointChange"]) {
        return NewSiteMessageWDYZType_appointChange;
    }
    else if ([string isEqualToString:@"appointremind"]) {
        return NewSiteMessageWDYZType_appointremind;
    }
    else {
        return NewSiteMessageWDYZType_UnknowType;
    }
}
@end
