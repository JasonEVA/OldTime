//
//  IMBaseRequest.m
//  launcher
//
//  Created by Lars Chen on 15/9/18.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "IMBaseRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDictionary+IMSafeManager.h"
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"

@implementation IMBaseResponse

-(void)showServerErrorMessage{
    //    if([self.data objectForKey:@"message"])
    //        [SVProgressHUD showErrorWithStatus:[self.data objectForKey:@"message"]];
}

@end

@interface IMBaseRequest ()

@property (nonatomic, weak) id<IMBaseRequestDelegate> delegate;

@end

@implementation IMBaseRequest

#pragma mark - Private Method
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 初始化变量
        self.params = [NSMutableDictionary dictionary];
        _identifier = -1;
    }
    return self;
}

- (instancetype)initWithDelegate:(id<IMBaseRequestDelegate>)delegate {
    self = [self init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

// 整理必传数据
- (void)configCommonParams
{
    self.params[M_I_appName]   = [[MsgUserInfoMgr share] getAppName];
    self.params[M_I_userToken] = [[MsgUserInfoMgr share] getToken];
    self.params[M_I_userName]  = [[MsgUserInfoMgr share] getUid] ?:@"";
}

#pragma mark - Interface Method

- (BOOL)configEssentialParamsIfNeed {
    return YES;
}

// 请求数据整理，子类实现
- (void)prepareRequest
{
    if ([self configEssentialParamsIfNeed]) {
        [self configCommonParams];
    }
}

// 返回数据整理，子类实现
- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    IMBaseResponse *res=[[IMBaseResponse alloc] init];
    res.data=data;
    return res;
}

- (void)requestData {
    // 整理数据
    [self prepareRequest];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *address = [[[MsgUserInfoMgr share] getHttpIp] stringByAppendingFormat:@"/api%@", self.action];
    
    //    PRINT_JSON_INPUT(self.params, [NSURL URLWithString:address]);
    
    [manager POST:address parameters:self.params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 成功
        [self requestFinished:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 失败
        [self requestFailed:error.userInfo];
        
    }];

}

// 请求数据
- (void)requestWithDelegate:(id<IMBaseRequestDelegate>)delegate {
    self.delegate = delegate;
    [self requestData];
}

#pragma mark - Delegate
- (void)requestFinished:(id)responseObj
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucceed:withResponse:)])
    {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
//            PRINT_JSON_OUTPUT(responseObj);
            BOOL isSuccess = [[responseObj objectForKey:@"code"] integerValue] == 2000;
            ;
            //            BOOL isSuccess = YES;
            // 成功
            IMBaseResponse *response = [IMBaseResponse new];
            response.message = [responseObj im_valueStringForKey:M_I_message];
            if (isSuccess)
            {
                response = [self prepareResponse:responseObj];
                
                // 整理返回数据
                [self.delegate requestSucceed:self withResponse:response];
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:withResponse:)])
                {
                    response = [self prepareResponse:responseObj];
                    [self.delegate requestFail:self withResponse:response];
                }
            }
        }
    }
}

- (void)requestFailed:(id)responseObj
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:withResponse:)])
    {
        IMBaseResponse *response = [self prepareResponse:responseObj];
        [self.delegate requestFail:self withResponse:response];
    }
}

@end
