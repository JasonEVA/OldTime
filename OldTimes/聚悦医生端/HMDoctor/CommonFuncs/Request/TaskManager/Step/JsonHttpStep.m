//
//  JsonHttpStep.m
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "JsonHttpStep.h"
#import "JsonHttpClient.h"
#import "AFNetworking.h"
#import "ClientHelper.h"
#import "CommonEncrypt.h"


@interface JsonHttpStep ()
{
    JsonHttpClient* httpClient;
    NSString* postUrl;
    
}
@end

@implementation JsonHttpStep

- (id) initWithUrl:(NSString*) aPostUrl Params:(id) aPostParams
{
    self = [super init];
    if (self)
    {
        _errorCode = NSIntegerMax;
        
        postUrl = aPostUrl;
        postParams = aPostParams;
    }
    
    return self;
}

- (EStepErrorCode) runStep
{
    self.stepError = [self runHttpStep];
    return self.stepError;
}

- (EStepErrorCode) runHttpStep
{
    httpClient = [[JsonHttpClient alloc]init];
    
    if (!postUrl || 0 == postUrl.length) {
        return StepError_InvalidParam;
    }
    
    //NSData* jsonData = [postParam JSONString];
    AFNetworkReachabilityManager* shareReachMgr = [AFNetworkReachabilityManager sharedManager];
    //[shareReachMgr startMonitoring];
    if (!shareReachMgr.reachable) {
        self.stepErrorMessage = [NSString stringWithFormat:@"网络连接不可用"];
        return StepError_NetworkInvalid;
    }
    
    NSMutableDictionary* dictParam = [ClientHelper buildCommonHttpParam];
   // NSDictionary* dictQuery = [NSString dictionaryWithQuery:aQuery];
    if (postParams && [postParams isKindOfClass:[NSDictionary class]])
    {
        [dictParam addEntriesFromDictionary:postParams];
    }
    [httpClient startJsonPost:postUrl Param:dictParam];
    
    if (!httpClient.httpSuccess)
    {
        //http调用失败
        self.stepErrorMessage = [NSString stringWithFormat:@"系统忙碌，请稍后再试。"];
        return StepError_NetworkRequestError;
    }
    else
    {
        id httpResp = httpClient.respResult;
        //解析http返回Json
        EStepErrorCode parserRet = [self parseJson:httpResp];
        return parserRet;
        
    }
    
    return StepError_None;
}

- (EStepErrorCode) parseJson:(id) resp
{
    if (!resp || ![resp isKindOfClass:[NSDictionary class]])
    {
        self.stepErrorMessage = [NSString stringWithFormat:@"接口调用失败。"];
        return StepError_NetwordDataError;
    }
    
    NSDictionary* dicResp = (NSDictionary*) resp;
    NSNumber* numerrcode = [dicResp valueForKey:@"ret_code"];
    NSString* strErrMsg = [dicResp valueForKey:@"err_msg"];
    
    if (strErrMsg && [strErrMsg isKindOfClass:[NSString class]])
    {
        self.stepErrorMessage = strErrMsg;
    }
    if (!numerrcode && ![numerrcode isKindOfClass:[NSNumber class]])
    {
        if (!self.stepErrorMessage)
        {
            self.stepErrorMessage = [NSString stringWithFormat:@"接口调用失败。"];
        }
        
        return StepError_NetwordDataError;
    }
    
    NSInteger errcode = [numerrcode integerValue];
    _errorCode = errcode;
    if (![self errorCodeIsValid:errcode])
    {
        //接口返回非正确值
        self.stepErrorMessage = strErrMsg;
        return StepError_NetwordDataError;
    }
    
    //解析return_msg
    id result = nil;
    NSString* sDesRet = [dicResp valueForKey:@"return_msg"];
    if (sDesRet && [sDesRet isKindOfClass:[NSString class]])
    {
        
        NSString* sResult = [CommonEncrypt DESStringDecryp:(NSString*)sDesRet WithKey:@"yuyou1208"];
        NSString* sFrist = [sResult substringWithRange:NSMakeRange(0, 1)];
        if (/*[sFrist isEqualToString:@"["] || */[sFrist isEqualToString:@"{"])
        {
            NSDictionary* dicRetMsg = [NSObject JSONValue:sResult];
            
            //business_message
            NSString* business_message = [dicRetMsg valueForKey:@"business_message"];
            if (business_message && [business_message isKindOfClass:[NSString class]] && 0 < business_message.length) {
                self.stepErrorMessage = business_message;
            }
            
            NSString* sBusiness_code = [dicRetMsg valueForKey:@"business_code"];
            if (!sBusiness_code || ![sBusiness_code isKindOfClass:[NSString class]] || 0 == sBusiness_code.length || ![sBusiness_code isEqualToString:@"SUCCESS"])
            {
                //错误
                return StepError_NetwordDataError;
            }
            
            result = [dicRetMsg valueForKey:@"result"];
            if (result)
            {
                return [self paraserResultJson:result];
                return StepError_None;

            }
        }
    }
    return StepError_None;
}


- (BOOL) errorCodeIsValid:(NSInteger) errorCode
{
    return 0 == errorCode;
}

- (EStepErrorCode) paraserResultJson:(id) result
{
    _stepResult = result;
    return StepError_None;
}

@end
