//
//  BaseRequest.m
//  launcher
//
//  Created by William Zhang on 15/7/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDictionary+SafeManager.h"
#import "NetworkManager.h"
#import "MyDefine.h"
#import <MintcodeIM/MintcodeIM.h>
#import "AppDelegate.h"
static NSString * const la_loginName     = @"LoginName";
static NSString * const la_userName      = @"UserName";
static NSString * const la_CompanyShowID = @"CompanyShowID";
static NSString * const la_CompanyCode   = @"CompanyCode";
static NSString * const la_authToken     = @"AuthToken";
static NSString * const la_resourceUrl   = @"ResourceUri";
static NSString * const la_async         = @"async";
static NSString * const la_type          = @"type";
static NSString * const la_language      = @"Language";

static NSString * const la_response   = @"Body.response";
static NSString * const la_isSuccess  = @"Body.response.IsSuccess";
static NSString * const la_reason     = @"Body.response.Reason";
static NSString * const la_totalCount = @"Body.response.TotalCount";
static NSString * const la_data       = @"Body.response.Data";
static NSString * const la_error_msg  = @"errorMsg";
static NSString * const la_remain     = @"remain";

const NSInteger wz_defaultIdentifier = -1;
static NSString *const k_UserLoginOut_Notitication = @"userTokenFailed";
@implementation BaseResponse;
@end

@interface BaseRequest()

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, weak) id<BaseRequestDelegate> delegate;

/** 需要传输的数据 */
@property (nonatomic, strong) NSMutableDictionary *requestedData;

@end

@implementation BaseRequest

- (instancetype)init {
    return [self initWithDelegate:nil];
}

- (instancetype)initWithDelegate:(id<BaseRequestDelegate>)delegate {
    return [self initWithDelegate:delegate identifier:wz_defaultIdentifier];
}

- (instancetype)initWithDelegate:(id<BaseRequestDelegate>)delegate identifier:(NSInteger)identifer {
    self = [super init];
    if (self) {
        self.params = [NSMutableDictionary dictionary];
        self.requestedData = [NSMutableDictionary dictionary];
        self.delegate = delegate;
        self.autoConfigParamsIfNeed = YES;
        _identifier = identifer;
    }
    return self;
}

- (void)dealloc {
    [self cancelRequestIfNeed];
}

#pragma mark - Private Method
/** 取消网络请求 */
- (void)cancelRequestIfNeed {
    if (self.task) {
        [self.task cancel];
    }
}

/** 整理必传数据 */
- (void)configCommonParams {
    if (!self.isAutoConfigParamsIfNeed) {
        self.requestedData = self.params;
        return;
    }
    NSAssert(self.api && [self.api length], @"please use api interface");
    
    UnifiedUserInfoManager *userInfo = [UnifiedUserInfoManager share];
    NSDictionary *headerDict = @{la_loginName:[userInfo userShowID],
                                 la_userName: [userInfo userName],
                                 la_CompanyShowID:[userInfo companyShowID],
                                 la_CompanyCode:userInfo.companyCodeCached ?: [userInfo companyCode],
                                 la_authToken:[[UnifiedUserInfoManager share] authToken] ?: @"",
                                 la_resourceUrl:self.api ?:@"",
                                 la_async:@NO,
                                 la_type:self.type,
                                 la_language:[[UnifiedUserInfoManager share] getLanguageIdentifier]?:@""
                                 };
    
    [self.requestedData setObject:headerDict forKey:@"Header"];
    
    NSDictionary *paramDict = @{@"param":self.params};
    [self.requestedData setObject:paramDict forKey:@"Body"];
}

#pragma mark - Interface Method
- (NSString *)type { return @"POST";}

- (id)finalData { return self.isAutoConfigParamsIfNeed ? self.requestedData : self.params;}

/** 请求数据整理，子类实现 */
- (void)prepareRequest {
    [self configCommonParams];
}

/** 返回数据整理，子类实现 */
- (BaseResponse *)prepareResponse:(id)data {
    return nil;
}

- (void)requestData {
    [self prepareRequest];
    
    [self cancelRequestIfNeed];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 拼接url
//    PRINT_JSON_INPUT(self.params);
    
    [NetworkManager addNetworkProgress];
    
    NSURLSessionDataTask *aTask = [manager POST:la_URLAddress parameters:self.requestedData progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [NetworkManager removeNetworkProgress];
        if (task != self.task) {
            return;
        }
    
        [self wz_requestFinished:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [NetworkManager removeNetworkProgress];
        if (task != self.task) {
            return;
        }
        
        [self wz_requsetFailed:error.userInfo];
    }];
    
    self.task = aTask;
    [UnifiedUserInfoManager share].companyCodeCached = nil;
}

#pragma mark - Delegate
- (void)wz_requestFinished:(id)responseObj {
    NSString *reason = LOCAL(ERROROTHER);
    if ([[responseObj valueForKeyPath:@"Body.response.Code"] integerValue] == 8401) {
        AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
        [aDelegate tokenFiledLoginOut];
        //[self.delegate requestFailed:self errorMessage:@"认证失败,请重新登陆"];
    }
    
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(requestSucceeded:response:totalCount:)]) {
        return;
    }
    
    id response = [responseObj valueDictonaryForKey:la_response];
    if (![response isKindOfClass:[NSDictionary class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:errorMessage:)]) {
            [self.delegate requestFailed:self errorMessage:reason];
        }
        return;
    }
    
    BOOL isSuccess = [responseObj valueBoolForKey:la_isSuccess];
    NSString *reasonTmp = [responseObj valueStringForKeyPath:la_reason];
    if ([reasonTmp length]) {
        reason = reasonTmp;
    }
    
    if (!isSuccess) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:errorMessage:)]) {
            [self.delegate requestFailed:self errorMessage:reason];
        }
        return;
    }
    
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(requestSucceeded:response:totalCount:)]) {
        return;
    }
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
//        PRINT_STRING(@"*************response*********\n");
//        PRINT_JSON_OUTPUT(responseObj);
        
        NSInteger totalCount = [[responseObj valueNumberForKeyPath:la_totalCount] integerValue];
        
        id data = [responseObj valueDictonaryForKeyPath:la_data];
        
        BaseResponse *response = [self prepareResponse:data];
        [self.delegate requestSucceeded:self response:response totalCount:totalCount];
    }
}

- (void)wz_requsetFailed:(id)responseObj {
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:errorMessage:)]) {
        [self.delegate requestFailed:self errorMessage:LOCAL(ERROROTHER)];
    }
}

@end
