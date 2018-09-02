//
//  ImageHttpClient.m
//  HMClient
//
//  Created by yinqaun on 16/4/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ImageHttpClient.h"
#import "ClientHelper.h"
#import "NSObject+JsonExtension.h"
//#import "NSString+URLEncoding.h"
#import "AFNetworking.h"
//#import <AFNetworking.h>
#import "CommonEncrypt.h"
//#import "NSString+WXMEncrypt.h"

@interface ImageHttpClient ()
{
    NSCondition* cdiLock;
}

@end




@implementation ImageHttpClient
- (AFHTTPSessionManager *)sharedHTTPSession{
    static AFHTTPSessionManager *sessionManager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sessionManager) {
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
        }
        
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

- (void) startImagePost:(NSString*) sUrl Param:(id) param ImageData:(NSData*) imageData
{
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSString *stringURL = [NSString stringWithFormat:@"%@", sUrl];
    
    AFHTTPSessionManager *manager = [self sharedHTTPSession];

    [manager POST:stringURL parameters:dicParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         // 上传文件
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"yyyyMMddHHmmss";
         NSString *str  = [formatter stringFromDate:[NSDate date]];
         NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
         [formData appendPartWithFileData:imageData name:@"photos" fileName:fileName mimeType:@"image/png"];
         
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         NSLog(@"PostImage progress %lld %lld", uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
         [self imagePostProgress:uploadProgress.completedUnitCount TotalUnit:uploadProgress.totalUnitCount];
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

- (void) imagePostProgress:(NSInteger) curUnit TotalUnit:(NSInteger) totalUnit
{
    if (_progressBlock)
    {
        _progressBlock(curUnit, totalUnit);
    }
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
