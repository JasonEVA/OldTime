//
//  HMShareNoticeToPatientRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/7/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMShareNoticeToPatientRequest.h"

@implementation HMShareNoticeToPatientRequest

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postNoticeServiceUrl:@"shareNotice2DoctorUserGroup"];
    return postUrl;
}

@end
