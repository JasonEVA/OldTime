//
//  NewApplyGetFormInfoV2Request.m
//  launcher
//
//  Created by Dee on 16/8/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyGetFormInfoV2Request.h"
#import "NewApplyAllFormModel.h"
#import "NSDictionary+SafeManager.h"
#import <MJExtension.h>

static NSString *const FormID = @"formId";
static NSString *const ID     = @"id";
static NSString *const form = @"form";
@implementation NewApplyGetFormInfoV2Request

- (void)getFormWithFormID:(NSString *)formid
{
    self.params[FormID] = formid;
    [self requestData];
}

- (NSString *)type {
    return @"POST";
}

- (NSString *)api
{
    return @"/Form-Module/Pull";
}

- (BaseResponse *)prepareResponse:(id)data
{
    NewApplyGetFormInfoV2Response *response = [[NewApplyGetFormInfoV2Response alloc] init];
    
    NSArray *arr =  [[data valueStringForKey:form] mj_JSONObject];
    response.formModel = [[NewApplyAllFormModel alloc] initWithSortingArray:arr];
    response.formModel.formStr = [data valueStringForKey:form];
    response.formModel.formId  = [data valueStringForKey:FormID];
    return response;
}



@end

@implementation NewApplyGetFormInfoV2Response



@end