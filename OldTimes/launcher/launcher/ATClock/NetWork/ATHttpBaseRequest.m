//
//  ATHttpBaseRequest.m
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATHttpBaseRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "ATHttpConfig.h"
#import "NSString+ATConverter.h"
#import "NSDictionary+ATEX.h"

#define RETURN_CODE @"Code"
#define ERROR_MSG   @"ErrorMsg"
#define REQ_ID      @"resultID"

@implementation ATHttpBaseResponse

@end

@implementation ATHttpBaseRequest

- (instancetype)init{
    self = [super init];
    if (self) {
        self.params = [NSMutableDictionary new];
    }
    return self;
}

- (void)prepareRequest{
    [self configCommonParam];
}
//设置必传参数
- (void)configCommonParam {
    self.params[@"deviceId"] = [NSString at_getDeviceUUID];//设备标识
    self.params[@"deviceType"] = [[UIDevice currentDevice] model]; //设备类型[可不传]
}

- (ATHttpBaseResponse *)prepareResponse:(id)data {
    return nil;
}

- (void)requestWithDelegate:(id<ATHttpRequestDelegate>)del {
    [self prepareRequest];
    self.httpDel = del;
    
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",URLADDRESS,self.api];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:URLADDRESS]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0f;
//    NSString *paramsStr = [NSString at_convertFromDict:self.params];
//    NSString *aesStr = [NSData AES256EncryptWithPlainText:paramsStr withKey:KindUser];
//    NSDictionary *paramDict = @{@"body":paramsStr};
    
//    NSLog(@"%@", self.params);
    [manager POST:fullUrl parameters:self.params progress:^(NSProgress * _Nonnull uploadProgress) {
//        [self requestProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestFinished:responseObject];
//        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ATHttpBaseResponse *rsp = [ATHttpBaseResponse new];
        rsp.retCode = AF_Fail;
        [self requestFailed:rsp];
//        NSLog(@"%@", error);
    }];
}

#pragma mark - callback method

- (void)requestFinished:(id)responseObj {
    if (self.httpDel && [self.httpDel respondsToSelector:@selector(requestSucceed:withResponse:)]) {
        ATHttpBaseResponse *rsp = [ATHttpBaseResponse new];
        
        
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            //            ZUSLOG(@"***************RspObj***************\n %@",responseObj);
            int retC = [[responseObj safeValueForKey:RETURN_CODE] intValue];
            if (retC == AF_Success) {
                id dataDic = [responseObj safeValueForKey:@"Content"];
                if (dataDic == nil) {
                    [self.httpDel requestFail:self withResponse:rsp];
                }
                rsp = [self prepareResponse:dataDic];
                rsp.retCode = Return_OK;
                rsp.reqID = [responseObj safeValueForKey:REQ_ID];
                if (self.httpDel && [self.httpDel respondsToSelector:@selector(requestSucceed:withResponse:)]) {
                    [self.httpDel requestSucceed:self withResponse:rsp];
                }
                
                
            }
            else{
                
                rsp = [self prepareResponse:responseObj];
                rsp.retCode = retC;
                rsp.reqID = [responseObj safeValueForKey:REQ_ID];
                
                if (rsp.retCode == AF_TOKENERROR) {
//                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [appDelegate.interactor noticeAndAgainLogin];
                }
                
                if ([responseObj safeValueForKey:ERROR_MSG]) {
                    rsp.errorMsg = [responseObj safeValueForKey:ERROR_MSG];
                }
                if (self.httpDel && [self.httpDel respondsToSelector:@selector(requestFail:withResponse:)]) {
                    [self.httpDel requestFail:self withResponse:rsp];
                }
            }
            
        }
        else{
            rsp = [self prepareResponse:responseObj];
            rsp.retCode = AF_Fail;
            if (self.httpDel && [self.httpDel respondsToSelector:@selector(requestFail:withResponse:)]) {
                [self.httpDel requestFail:self withResponse:rsp];
            }
        }
        
    }
}

- (void)requestFailed:(id)responseObj{
    ATHttpBaseResponse *rsp = [ATHttpBaseResponse new];
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
//        ZUSLOG(@"***************RspObj***************\n %@",responseObj);
        rsp = [self prepareResponse:responseObj];
    }
    else{
        rsp = [self prepareResponse:responseObj];
        rsp.retCode = AF_Fail;
        rsp.errorMsg = @"请求超时，请检查网络状况后重试";
    }
    if (self.httpDel && [self.httpDel respondsToSelector:@selector(requestFail:withResponse:)]) {
        [self.httpDel requestFail:self withResponse:rsp];
    }
}

@end
