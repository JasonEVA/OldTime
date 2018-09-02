//
//  IMBaseBlockRequest.h
//  launcher
//
//  Created by williamzhang on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBaseRequest.h"

typedef void(^IMBaseResponseCompletion)(IMBaseResponse *response,BOOL success);

@interface IMBaseBlockRequest : NSObject
/// 调用动作
@property (nonatomic, copy) NSString *action;

@property (nonatomic, strong) NSMutableDictionary *params;


@property (nonatomic, assign) BOOL ignoreCache;

/// 填入必要参数 default=YES
- (BOOL)configEssentialParamsIfNeed;

/**
 *  默认会读缓存
 */
- (void)requestDataCompletion:(IMBaseResponseCompletion)completion;

/** 与上个方法相同，只是添加是否从缓存中读取
 *  @param isFromeCache 是否从缓存中读取
 */
- (void)requestDataCompletion:(IMBaseResponseCompletion)completion isFromeCache:(BOOL)isFromeCache;


- (IMBaseResponse *)prepareResponse:(NSDictionary *)data;

/// 缓存时间 default=-1及不缓存
- (NSInteger)cacheTimeInSeconds;

@end
