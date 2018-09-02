//
//  JsonHttpClient.m
//  weixiangmao
//
//  Created by yinqaun on 15/11/3.
//  Copyright © 2015年 绿天下. All rights reserved.
//

#import "JsonHttpClient.h"
#import "ClientHelper.h"
#import "NSObject+JsonExtension.h"
//#import "NSString+URLEncoding.h"
#import "AFNetworking.h"
//#import <AFNetworking.h>
#import "CommonEncrypt.h"
//#import "NSString+WXMEncrypt.h"

@interface JsonHttpClient ()
{
    NSCondition* cdiLock;
}

@end

@implementation JsonHttpClient
- (AFHTTPSessionManager *)sharedHTTPSession{
    static AFHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            // 初始化Manager
            sessionManager = [AFHTTPSessionManager manager];
            sessionManager.requestSerializer=[AFJSONRequestSerializer serializer];
            // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
            sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            sessionManager.requestSerializer.timeoutInterval = 30.0;
        // 支持压缩文件
        [sessionManager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
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

- (void) startJsonPost:(NSString*) sUrl Param:(id) param
{
    //NSData* dataJson = [param objectJsonString];
    NSString* strPost = [param objectJsonString];
    //NSString* strPost = [[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding];
    NSString* strEncode = [CommonEncrypt DESStringEncrypt:strPost WithKey:@"yuyou1208"];
    NSDictionary* postDict = [NSDictionary dictionaryWithObjectsAndKeys:strEncode, @"param", nil];
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [self sharedHTTPSession];

    // post请求
    __weak typeof(self) weakSelf = self;
    [manager POST:sUrl parameters:postDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf jsonPostSuccess:task Response:responseObject];
        return ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        [strongSelf jsonPostFailed:task Error:error];
        NSLog(@"%@", [error localizedDescription]);
    }];
    [self lock];
}

- (void) jsonPostSuccess:(NSURLSessionDataTask *) task Response:(id) responseObject
{
    NSLog(@"jsonPostSuccess operation %@", task.response.URL.absoluteString);
    _httpSuccess = NO;
    if (responseObject )
    {
        NSString* strResp = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        _respResult = [NSObject JSONValue:strResp];
        
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
