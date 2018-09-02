//
//  PatientModel.m
//  HMDoctor
//
//  Created by kylehe on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientModel.h"
#import "NSDictionary+SafeManager.h"
#import "PatientTestDataModel.h"
static NSString *const t_age = @"age";
static NSString *const t_illName = @"illName";
static NSString *const t_imgUrl = @"imgUrl";
static NSString *const t_sex = @"sex";
static NSString *const t_userid = @"userId";
static NSString *const t_userName = @"userName";
static NSString *const t_userTestData = @"userTestDatas";


@implementation PatientModel

- (instancetype)initWithDitc:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.age = [dict valueNumberForKey:t_age];
        self.illName = [dict valueStringForKey:t_illName];
        self.imgUrl = [dict valueStringForKey:t_imgUrl];
        self.sex = [dict valueStringForKey:t_sex];
        self.userID = [dict valueStringForKey:t_userid];
        self.userName = [dict valueStringForKey:t_userName];
        if ([dict valueDictonaryForKey:t_userTestData])
        {
            NSDictionary *tepmDict = [dict valueDictonaryForKey:t_userTestData];
            self.userTestDatas = [[PatientTestDataModel alloc] initWithDict:tepmDict];
        }
        
    }
    return self;
}



@end
