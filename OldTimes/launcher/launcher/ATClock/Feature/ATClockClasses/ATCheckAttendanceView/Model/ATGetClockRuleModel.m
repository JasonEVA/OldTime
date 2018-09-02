//
//  ATGetClockRuleModel.m
//  Clock
//
//  Created by SimonMiao on 16/7/22.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATGetClockRuleModel.h"
#import <MJExtension/MJExtension.h>
#import "ATAppSync.h"

@implementation ATGetClockLocationListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end

@implementation ATGetClockRuleModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

+ (ATGetClockRuleModel *)decodeClockRuleModelFromUserDefault
{
    NSDictionary *dict = [ATAppSync getClockRuleDict];
    [ATGetClockRuleModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"LocationList" : @"ATGetClockLocationListModel"
                 };
    }];
    ATGetClockRuleModel *ruleModel = [ATGetClockRuleModel mj_objectWithKeyValues:dict];
    
    return ruleModel;
}

@end
