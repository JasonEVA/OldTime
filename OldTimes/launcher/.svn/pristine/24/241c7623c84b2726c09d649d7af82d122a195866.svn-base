//
//  NewApplyGetFormInfoRequest.m
//  launcher
//
//  Created by 马晓波 on 16/4/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyGetFormInfoRequest.h"
#import "NewApplyAllFormModel.h"
#import "NSDictionary+SafeManager.h"
#import <MJExtension.h>

static NSString *const FormID = @"formId";

@implementation NewApplyGetFormInfoRequest
- (void)getFormId:(NSString *)string
{
    self.params[FormID] = string;
    [self requestData];
}

- (NSString *)type { return @"POST"; }
- (NSString *)api { return @"/Form-Module/Pull"; }

-(BaseResponse *)prepareResponse:(id)data
{
    NewApplyGetFormInfoResponse *response = [[NewApplyGetFormInfoResponse alloc] init];
    
    response.strFormID = [data valueStringForKey:@"formId"];
    response.strID     = [data valueStringForKey:@"id"];
    response.formStr   = [data valueStringForKey:@"form"];
	NSArray *arr       = [[data valueStringForKey:@"form"] mj_JSONObject];
    response.model = [[NewApplyAllFormModel alloc] initWithArray:arr];
    
    return response;
}
@end

@implementation NewApplyGetFormInfoResponse
@end