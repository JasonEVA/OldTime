//
//  BaseRequest.m
//  PalmDoctorPT
//
//  Created by Andrew Shen on 15/4/7.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "UnifiedUserInfoManager.h"
#import "UnifiedResultCodeManager.h"
#import "MyDefine.h"
#import "NSString+Manager.h"
#import "LoginResultModel.h"
#import "NSDictionary+SafeManager.h"

static NSString *const kMessage = @"message";

@implementation BaseResponse
-(void)showServerErrorMessage{
}

@end


@implementation BaseRequest

#pragma mark - Private Method
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 初始化变量
        self.params = [NSMutableDictionary dictionary];
    }
    return self;
}

// 整理必传数据
- (void)configCommonParams
{
}

// 用时间戳和索引值得到文件名 处理附件名字
- (NSString *)getFileNameWithTimeIntervalAndIndex:(NSInteger) index
{
    NSDate *date = [NSDate date];
    NSString *fileName = [NSString stringWithFormat:@"%013.0f%02ld", [date timeIntervalSince1970] * 1000.0, (long)(index % 100)];
    return fileName;
}



- (void)setAuthorizationToken:(AFHTTPRequestSerializer *)serializer {
    if ([self.action isContainsString:@"authapi"])
    {
        LoginResultModel *model = [[unifiedUserInfoManager share] getLoginResultData];
        NSString *token = model.token;
        [serializer setValue:token forHTTPHeaderField:@"Authorization"];
    }

}
#pragma mark - Interface Method

// 请求数据整理，子类实现
- (void)prepareRequest
{
    [self configCommonParams];
}

// 返回数据整理，子类实现
- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    BaseResponse *res=[[BaseResponse alloc] init];
    res.data=data;
    
    res.message = [data safeValueForKey:kMessage];
    return res;
}

// 请求数据
- (void)requestWithDelegate:(id<BaseRequestDelegate>)delegate
{
    // 整理数据
    [self prepareRequest];
    
    // 代理设置
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    // 判断是否需要token
    [self setAuthorizationToken:manager.requestSerializer];

    NSString *urlString = [kURLAddress stringByAppendingPathComponent:self.action];

    PRINT_JSON_INPUT(self.params, [NSURL URLWithString:urlString]);
    
    [manager POST:urlString parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 成功
        [self requestFinished:responseObject];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 失败
        [self requestFailed:error.userInfo];

    }];
}

// 上传图片
- (void)requestWithDelegate:(id<BaseRequestDelegate>)delegate data:(NSData *)imageData
{
    // 整理数据
    [self prepareRequest];
    
    // 代理设置
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kURLAddress]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 判断是否需要token
    [self setAuthorizationToken:manager.requestSerializer];
    
    NSString *urlString = [kURLAddress stringByAppendingPathComponent:self.action];
    
    [manager POST:urlString parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData > formData) {
        [formData appendPartWithFileData:imageData name:@"name" fileName:[NSString stringWithFormat:@"%@.png", [self getFileNameWithTimeIntervalAndIndex:0]] mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        // 成功
        [self requestFinished:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 失败
        [self requestFailed:error];
    }];
}

// Get请求
- (void)requestGetWithDelegate:(id<BaseRequestDelegate>)delegate
{
    // 整理数据
    [self prepareRequest];
    
    // 代理设置
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 判断是否需要token
    [self setAuthorizationToken:manager.requestSerializer];
    
    NSString *urlString = [kURLAddress stringByAppendingPathComponent:self.action];
    
    
    PRINT_JSON_INPUT(self.params, [NSURL URLWithString:urlString]);
    [manager GET:urlString parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 成功
        [self requestFinished:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        // 失败
        [self requestFailed:error.userInfo];
        
    }];
}

#pragma mark - Delegate
- (void)requestFinished:(id)responseObj
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucceed:withResponse:)])
    {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            PRINT_JSON_OUTPUT(responseObj);
            BOOL isSuccess = [[UnifiedResultCodeManager share] manageResultCode:responseObj];
            // 成功
            if (isSuccess)
            {
                BaseResponse *response = [BaseResponse new];
                response = [self prepareResponse:responseObj];
                
                // 整理返回数据
                [self.delegate requestSucceed:self withResponse:response];
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:withResponse:)])
                {
                    [self requestFailed:responseObj];
                }
            }
        }
    }
}

- (void)requestFailed:(id)responseObj
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:withResponse:)])
    {
        BaseResponse *response = [BaseResponse new];
        response = [self prepareResponse:responseObj];
        [self.delegate requestFail:self withResponse:response];
    }
}


- (void)httpFinishRequest:(HttpRequestResponse)finishRequest
           failureRequest:(HttpRequestResponse)failureRequest
{
    [self prepareRequest];
}

@end
