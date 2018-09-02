//
//  ATSHTTPBaseRequest.m
//  ATSAppStructure
//
//  Created by Andrew Shen on 2017/2/15.
//  Copyright © 2017年 AndrewShen. All rights reserved.
//

#import "ATSHTTPBaseRequest.h"
#import "ClientHelper.h"
#import "CommonEncrypt.h"

@implementation ATSHTTPBaseResponse


@end

@interface ATSHTTPBaseRequest ()
@property (nonatomic, copy)  ATSHTTPBaseResponseCompletion  completion; // <##>
@property (nonatomic, strong)  NSString  *fileName; // 上传文件名

@end
@implementation ATSHTTPBaseRequest

#pragma mark - Private Method

- (AFHTTPSessionManager *)sharedHTTPSession{
    static AFHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化Manager
        sessionManager = [AFHTTPSessionManager manager];
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return sessionManager;
}


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

- (NSString *)appVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

// 整理必传数据
- (void)configCommonParams {
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:kIOSDeviceTokenKey];
    if (token) {
        self.params[@"deviceToken"] = token;
    }
    
    NSString* version = [self appVersion];
    if (version) {
        self.params[@"version"] = version;
    }
    
    NSInteger calltype = [PlantformConfig calltype];
    self.params[@"calltype"] = [NSString stringWithFormat:@"%ld", calltype];
    self.params[@"orgGroupCode"] = [PlantformConfig plantformCode];

    //用户ID
    UserInfoHelper* helper = [UserInfoHelper defaultHelper];
    UserInfo* user = [helper currentUserInfo];
    if (user) {
        self.params[@"operatorUserId"] = [NSString stringWithFormat:@"%ld", user.userId];
    }
}

// 用时间戳和索引值得到文件名 处理附件名字
- (NSString *)getFileNameWithTimeIntervalAndIndex:(NSInteger)index {
    NSDate *date = [NSDate date];
    NSString *fileName = [NSString stringWithFormat:@"%013.0f%02ld", [date timeIntervalSince1970] * 1000.0, (long)(index % 100)];
    return fileName;
}


- (void)setAuthorizationToken:(AFHTTPRequestSerializer *)serializer {
    //    [serializer setValue:[[unifiedUserInfoManager share] getTokenWithStatus] forHTTPHeaderField:@"Authorization"];
}

// 加密
- (NSDictionary *)p_encryptParams {
    NSString* strPost = [self.params objectJsonString];
    NSString* strEncode = [CommonEncrypt DESStringEncrypt:strPost WithKey:@"yuyou1208"];
    NSDictionary *encryptParams = @{@"param" : strEncode};
    return encryptParams;
}

- (void)p_configCer:(AFHTTPSessionManager *)manager {
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"httpsrequest" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:YES];
    // 设置证书
    [securityPolicy setPinnedCertificates:certSet];
    
    [securityPolicy setValidatesDomainName:YES];
    
    manager.securityPolicy = securityPolicy;

}
#pragma mark - Interface Method


// 请求数据整理，子类实现
- (void)prepareRequest
{
    [self configCommonParams];
}

- (BOOL)p_responseResult:(id)data {
    BOOL success = YES;
    if (!data || ![data isKindOfClass:[NSDictionary class]])
    {
        success = NO;
    }
    // 文件上传文件格式返回不一样
    NSString *type = [data valueForKey:@"type"];
    if ([type isKindOfClass:[NSString class]] && [type isEqualToString:@"success"]) {
        return YES;
    }
    NSNumber* retCode = [data valueForKey:@"ret_code"];
    if (!retCode || ![retCode isKindOfClass:[NSNumber class]]) {
        success = NO;
    }
    else {
        NSInteger errcode = [retCode integerValue];
        if (errcode != 0) {
            //接口返回非正确值
            success = NO;
        }
    }
    return success;
}
// 返回数据整理，子类实现
- (ATSHTTPBaseResponse *)prepareResponse:(NSDictionary *)data {
    NSString *resultData = [data valueForKey:@"return_msg"];
    
    ATSHTTPBaseResponse *res = [[ATSHTTPBaseResponse alloc] init];
    res.fileName = self.fileName;
    if (resultData && [resultData isKindOfClass:[NSString class]]) {
        NSString* sResult = [CommonEncrypt DESStringDecryp:(NSString*)resultData WithKey:@"yuyou1208"];
        NSString* sFrist = [sResult substringWithRange:NSMakeRange(0, 1)];
        if (/*[sFrist isEqualToString:@"["] || */[sFrist isEqualToString:@"{"])
        {
            NSDictionary* dicRetMsg = [NSObject JSONValue:sResult];
            
            //business_message
            NSString* business_message = [dicRetMsg valueForKey:@"business_message"];
            if (business_message && [business_message isKindOfClass:[NSString class]] && 0 < business_message.length) {
                res.message = business_message;
            }
            
            NSString* sBusiness_code = [dicRetMsg valueForKey:@"business_code"];
            if (!sBusiness_code || ![sBusiness_code isKindOfClass:[NSString class]] || 0 == sBusiness_code.length || ![sBusiness_code isEqualToString:@"SUCCESS"])
            {
                //错误
                res.message = @"接口调用失败。";
                return res;
            }
            
            NSDictionary *result = [dicRetMsg valueForKey:@"result"];
            if (result) {
                res.data = result;
            }
        }
    }
    return res;
}

// 请求数据
- (void)requestWithDelegate:(id<ATSHTTPBaseRequestDelegate>)delegate {
    // 整理数据
    [self prepareRequest];
    
    // 代理设置
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kZJKBaseUrl]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self p_configCer:manager];
    
    // 判断是否需要token
    [self setAuthorizationToken:manager.requestSerializer];
    
    NSDictionary *encryptParams = [self p_encryptParams];
    [manager POST:self.action parameters:encryptParams progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度
        [self requestProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功
        [self requestFinished:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败
        [self requestFailed:error.userInfo];
    }];
}

// 上传附件
- (void)requestWithDelegate:(id<ATSHTTPBaseRequestDelegate>)delegate data:(NSData *)fileData fileName:(NSString *)fileName {
    // 整理数据
    [self prepareRequest];
    
    // 代理设置
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [self sharedHTTPSession];
    [self p_configCer:manager];

    // 判断是否需要token
    [self setAuthorizationToken:manager.requestSerializer];
    NSDictionary *encryptParams = [self p_encryptParams];
    NSString *URL = [kZJKBaseUrl stringByAppendingPathComponent:self.action];
    [manager POST:URL parameters:encryptParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"name" fileName:fileName mimeType:@"text/plain"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度
        [self requestProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功
        [self requestFinished:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败
        [self requestFailed:error];
        
    }];
}

- (void)requestUploadFileData:(NSData *)fileData fileName:(NSString *)fileName completion:(ATSHTTPBaseResponseCompletion)completion {
    self.fileName = fileName;
    self.completion = completion;
    
    [self requestWithDelegate:nil data:fileData fileName:fileName];
}

#pragma mark - Delegate
- (void)requestFinished:(id)responseObj {
    if (!self.delegate && !self.completion){
        return;
    }

    BOOL isSuccess = [self p_responseResult:responseObj];
    // 成功
    if (isSuccess) {
        ATSHTTPBaseResponse *response = [self prepareResponse:responseObj];
        // 整理返回数据
        if (self.completion) {
            self.completion(response , YES);
            self.completion = nil;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucceed:response:)]){
            [self.delegate requestSucceed:self response:response];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:response:)]) {
            [self requestFailed:responseObj];
        }
    }

}

- (void)requestFailed:(id)responseObj {
    if (!self.delegate && !self.completion){
        return;
    }
    ATSHTTPBaseResponse *response = [ATSHTTPBaseResponse new];
    response.message = @"接口调用失败。";
    if (self.completion) {
        self.completion(response , NO);
        self.completion = nil;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:response:)])
    {
        [self.delegate requestFail:self response:response];
    }
}

- (void)requestProgress:(NSProgress *)progress {
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestProgress:request:)])
    {
        CGFloat progressValue = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
        [self.delegate requestProgress:progressValue request:self];
    }
    
}

@end
