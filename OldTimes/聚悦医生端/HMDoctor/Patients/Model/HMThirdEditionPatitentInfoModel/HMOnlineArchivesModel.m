//
//  HMOnlineArchivesModel.m
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMOnlineArchivesModel.h"

@implementation HMOnlineArchivesModel

@end

@implementation HMAdmissionAssessDateListModel

@end

//子项 既往史
@implementation HMBeforListModel : NSObject

@end

//子项 家族史
@implementation HMFamilyListModel : NSObject

@end

//子项 现病史
@implementation HMNowListModel : NSObject

@end


@implementation HMJbHistoryListModel : NSObject

+ (NSDictionary *)objectClassInArray{
    return @{
             @"nowList" : @"HMNowListModel",
             @"beforList" : @"HMBeforListModel",
             @"familyList" : @"HMFamilyListModel",
             };
}

@end
