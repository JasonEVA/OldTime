//
//  VoiceHttpClient.m
//  HMDoctor
//
//  Created by lkl on 16/6/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "VoiceHttpClient.h"
#import "ClientHelper.h"
#import "NSObject+JsonExtension.h"
//#import "NSString+URLEncoding.h"
#import "AFNetworking.h"
//#import <AFNetworking.h>
#import "CommonEncrypt.h"
//#import "NSString+WXMEncrypt.h"

@interface VoiceHttpClient ()
{
    NSCondition* cdiLock;
}

@end

@implementation VoiceHttpClient
- (AFHTTPSessionManager *)sharedHTTPSession{
    static AFHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化Manager
        sessionManager = [AFHTTPSessionManager manager];
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
        
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
#ifdef kSimulation_Netwrok  //仿真环境
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"httpsrequest_sm" ofType:@"cer"];
#else   //正式环境
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"httpsrequest" ofType:@"cer"];
#endif
        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        // 是否允许,NO-- 不允许无效的证书
        [securityPolicy setAllowInvalidCertificates:YES];
        // 设置证书
        [securityPolicy setPinnedCertificates:certSet];
        
        [securityPolicy setValidatesDomainName:YES];
        
        sessionManager.securityPolicy = securityPolicy;
        
    });
    return sessionManager;
}
- (id) init
{
    self = [super init];
    if (self)
    {
        cdiLock = [[NSCondition alloc ]init];
    }
    return self;
}

- (void) startVoicePost:(NSString*) sUrl Param:(id) param VoiceData:(NSData*) voiceData
{
    AFHTTPSessionManager *manager = [self sharedHTTPSession];
    
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSString *stringURL = [NSString stringWithFormat:@"%@", sUrl];
    
    [manager POST:stringURL parameters:dicParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         // 上传文件
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"yyyyMMddHHmmss";
         NSString *str  = [formatter stringFromDate:[NSDate date]];
         //NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
         //[formData appendPartWithFileData:voiceData name:@"photos" fileName:fileName mimeType:@"image/png"];
         
         NSString *fileName = [NSString stringWithFormat:@"%@.wav", str];
         [formData appendPartWithFileData:voiceData name:@"voice" fileName:fileName mimeType:@"voice/wav"];
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         NSLog(@"PostImage progress %lld %lld", uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"上传成功");
         [self jsonPostSuccess:task Response:responseObject];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"上传失败");
         [self jsonPostFailed:task Error:error];
         NSLog(@"%@", [error localizedDescription]);
     }];
    [self lock];
}



- (void) jsonPostSuccess:(NSURLSessionDataTask *) task Response:(id) responseObject
{
    NSLog(@"jsonPostSuccess operation %@", task.response.URL.absoluteString);
    _httpSuccess = NO;
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
    {
        //NSString* strResp = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        _respResult = (NSDictionary*)responseObject;
        
        _httpSuccess = YES;
    }
    [self unlock];
}

- (void) jsonPostFailed:(NSURLSessionDataTask *) task Error:(NSError*) error
{
    NSLog(@"jsonPostFailed called.");
    //NSError* err = operation.error;
    NSLog(@"%@", error.domain);
    _httpSuccess = NO;
    [self unlock];
}

- (void) lock
{
    [cdiLock lock];
    [cdiLock wait];
    //CFRunLoopRun();
    //[lock tryLock];
    [cdiLock unlock];
}

- (void) unlock
{
    [cdiLock lock];
    [cdiLock signal];
    [cdiLock unlock];
    //[NSRunLoop currentRunLoop]
    
    //CFRunLoopStop(CFRunLoopGetCurrent());
}


@end
