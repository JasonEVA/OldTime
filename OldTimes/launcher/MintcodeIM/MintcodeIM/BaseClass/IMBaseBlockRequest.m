//
//  IMBaseBlockRequest.m
//  launcher
//
//  Created by williamzhang on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMBaseBlockRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDictionary+IMSafeManager.h"
#import "IMBaseBlockRequestPrivate.h"
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"

@implementation IMBaseBlockRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _params = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)configEssentialParamsIfNeed {
    return YES;
}

- (void)prepareRequest {
    if (![self configEssentialParamsIfNeed]) {
        return;
    }
    
    self.params[M_I_appName] = [[MsgUserInfoMgr share] getAppName];
    self.params[M_I_userName] = [[MsgUserInfoMgr share] getUid] ?: @"";
    self.params[M_I_userToken] = [[MsgUserInfoMgr share] getToken];
}

- (NSInteger)cacheTimeInSeconds {
    return -1;
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data {
    return nil;
}

- (void)requestDataCompletion:(IMBaseResponseCompletion)completion isFromeCache:(BOOL)isFromeCache
{
    [self prepareRequest];

    if (isFromeCache)
    {
        id cache = [self cacheJson];
        if (cache) {
            
            !completion ?: completion([self prepareResponse:cache], YES);
            
            return;
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *url = [[[MsgUserInfoMgr share] getHttpIp] stringByAppendingFormat:@"/api%@",self.action];
    [manager POST:url parameters:self.params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (!completion) {
            return;
        }
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            completion([self prepareResponse:responseObject], NO);
            return;
        }
        
        BOOL isSuccess = [[responseObject im_valueNumberForKey:@"code"] integerValue] == 2000;
        if (isSuccess) {
            [self saveJsonResponseToCacheFile:responseObject];
        }
        !completion ?: completion([self prepareResponse:responseObject], isSuccess);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !completion ?: completion([self prepareResponse:error.userInfo], NO);
    }];

}

- (void)requestDataCompletion:(IMBaseResponseCompletion)completion {
   [self prepareRequest];
    
    id cache = [self cacheJson];
    if (cache) {
        
        !completion ?: completion([self prepareResponse:cache], YES);
        
        return;
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *url = [[[MsgUserInfoMgr share] getHttpIp] stringByAppendingFormat:@"/api%@",self.action];
    [manager POST:url parameters:self.params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (!completion) {
            return;
        }
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            completion([self prepareResponse:responseObject], NO);
            return;
        }
        
        BOOL isSuccess = [[responseObject im_valueNumberForKey:@"code"] integerValue] == 2000;
        if (isSuccess) {
            [self saveJsonResponseToCacheFile:responseObject];
        }
        !completion ?: completion([self prepareResponse:responseObject], isSuccess);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !completion ?: completion([self prepareResponse:error.userInfo], NO);
    }];
}


#pragma mark - Cache

- (id)cacheJson {
    if (self.ignoreCache) {
        return nil;
    }
    
    if ([self cacheTimeInSeconds] < 0) {
        return nil;
    }
    
    NSString *path = [self cacheFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        return nil;
    }
    
    int seconds = [self cacheFileDuration:path];
    if (seconds < 0 || seconds > [self cacheTimeInSeconds]) {
        return nil;
    }
    
    id cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return cacheJson;
}

- (void)checkDirectory:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:filePath];
    } else {
        if (!isDir) {
            [fileManager removeItemAtPath:filePath error:nil];
            [self createBaseDirectoryAtPath:filePath];
        }
    }
}

- (void)createBaseDirectoryAtPath:(NSString *)path {
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

- (NSString *)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"MintcodeSDKRequestCache"];

    [self checkDirectory:path];
    return path;
}

- (NSString *)cacheFileName {
    NSString *baseUrl = [[MsgUserInfoMgr share] getHttpIp];
    NSString *requestUrl = self.action;
    
    NSString *requestInfo = [NSString stringWithFormat:@"Host: %@ Url:%@ Argument: %@",baseUrl, requestUrl, self.params];
    NSString *cachFileName = [IMBaseBlockRequestPrivate md5StringFromString:requestInfo];
    return cachFileName;
}

- (NSString *)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

- (int)cacheFileDuration:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:nil];
    if (!attributes) {
        return -1;
    }
    
    return -[[attributes fileModificationDate] timeIntervalSinceNow];
}

- (void)saveJsonResponseToCacheFile:(id)jsonResponse {
    if ([self cacheTimeInSeconds] > 0) {
        if (jsonResponse != nil) {
            [NSKeyedArchiver archiveRootObject:jsonResponse toFile:[self cacheFilePath]];
        }
    }
}

@end
