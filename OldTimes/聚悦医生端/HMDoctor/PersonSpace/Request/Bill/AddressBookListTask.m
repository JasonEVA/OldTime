//
//  AddressBookListTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AddressBookListTask.h"
#import "AddressBookInfo.h"

@implementation AddressBookListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postStaffServiceUrl:@"getMailListPage"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* list = [dicResp valueForKey:@"list"];
        NSMutableArray* addressBookArray = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicRecord in list)
            {
                
                AddressBookInfo* addressBook = [AddressBookInfo mj_objectWithKeyValues:dicRecord];
                
                [addressBookArray addObject:addressBook];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:addressBookArray forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation AddressBookSearchTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDepServiceUrl:@"getDepsByKeyName"];
    return postUrl;
}

@end



@implementation AddressBookDepNameListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDepServiceUrl:@"getDepByOrgId"];
    return postUrl;
}
@end

@implementation getDepsByKeyNameListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDepServiceUrl:@"getDepsByKeyName"];
    return postUrl;
}

@end



