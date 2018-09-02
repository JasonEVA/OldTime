//
//  VoiceHttpStep.m
//  HMDoctor
//
//  Created by lkl on 16/6/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "VoiceHttpStep.h"
#import "VoiceHttpClient.h"
#import "AFNetworking.h"
#import "ClientHelper.h"


@interface VoiceHttpStep ()
{
    VoiceHttpClient* httpClient;
    NSString* postUrl;
    NSData* voiceData;
}
@end


@implementation VoiceHttpStep

- (id) initWithType:(NSString *)type Params:(id)aPostParams VoiceData:(NSData *)voiData
{
    self = [super init];
    if (self)
    {
        _errorCode = NSIntegerMax;
        
        postUrl = [kZJKPostFileUrl stringByAppendingFormat:@"&type=%@", type];
        postParams = aPostParams;
        voiceData = voiData;
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
    httpClient = [[VoiceHttpClient alloc]init];
    
    if (!postUrl || 0 == postUrl.length) {
        return StepError_InvalidParam;
    }
    
    //NSData* jsonData = [postParam JSONString];
    AFNetworkReachabilityManager* shareReachMgr = [AFNetworkReachabilityManager sharedManager];
    //[shareReachMgr startMonitoring];
    if (!shareReachMgr.reachable) {
        self.stepErrorMessage = [NSString stringWithFormat:@"网络连接不可用，请检查您的网络连接。"];
        return StepError_NetworkInvalid;
    }
    
    NSMutableDictionary* dictParam = [ClientHelper buildCommonHttpParam];
    // NSDictionary* dictQuery = [NSString dictionaryWithQuery:aQuery];
    if (postParams && [postParams isKindOfClass:[NSDictionary class]])
    {
        [dictParam addEntriesFromDictionary:postParams];
    }
    //[httpClient startJsonPost:postUrl Param:dictParam];
    [httpClient startVoicePost:postUrl Param:postParams VoiceData:voiceData];
    if (!httpClient.httpSuccess)
    {
        //http调用失败
        self.stepErrorMessage = [NSString stringWithFormat:@"服务器接口调用失败。"];
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
    
    NSDictionary* dicRetMsg = (NSDictionary*) resp;
    
    
    NSString* sBusiness_code = [dicRetMsg valueForKey:@"type"];
    if (!sBusiness_code || ![sBusiness_code isKindOfClass:[NSString class]] || 0 == sBusiness_code.length || ![sBusiness_code isEqualToString:@"success"])
    {
        
        //错误
        self.stepErrorMessage = [NSString stringWithFormat:@"上传声音文件失败"];
        
        return StepError_NetwordDataError;
    }
    
    NSString* name = [dicRetMsg valueForKey:@"name"];
    NSString* serverPath = [dicRetMsg valueForKey:@"serverPath"];
    
    
    NSString* result = [serverPath stringByAppendingString:name];
    if ([result isKindOfClass:[NSString class]])
    {
        return [self paraserResultJson:result];
        return StepError_None;
        
    }
    
    
    return StepError_None;
}

- (EStepErrorCode) paraserResultJson:(id) result
{
    _stepResult = result;
    return StepError_None;
}

@end
