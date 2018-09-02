//
//  IMBaseRequest.h
//  launcher
//
//  Created by Lars Chen on 15/9/18.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMBaseRequest;

@interface IMBaseResponse : NSObject

@property(nonatomic,retain) NSDictionary *data;

@property (nonatomic, strong) NSString *message;

-(void)showServerErrorMessage;

@end

@protocol IMBaseRequestDelegate <NSObject>
// 成功和错误返回
@optional
// 成功
- (void)requestSucceed:(IMBaseRequest *)request withResponse:(IMBaseResponse *)response;
// 失败
- (void)requestFail:(IMBaseRequest *)request withResponse:(IMBaseResponse *)response;
@end

@interface IMBaseRequest : NSObject

@property (nonatomic, strong)       NSString *action;                          // 动作
@property (nonatomic, strong)       NSString *fileDictName;                    // 文件字段名

@property (nonatomic, strong)       NSMutableDictionary *params;            //post传递参数

/// default is -1
@property (nonatomic, assign) NSInteger identifier;



- (instancetype)initWithDelegate:(id<IMBaseRequestDelegate>)delegate;

/// 配置必要参数 default = YES
- (BOOL)configEssentialParamsIfNeed;
/**
 *  请求的数据整理
 */
- (void)prepareRequest;

/// 请求数据
- (void)requestData;

/**
 *  返回的数据
 *
 *  @param data 返回的数据
 *
 *  @return 返回数据
 */
- (IMBaseResponse *)prepareResponse:(NSDictionary *)data;

/**
 *  请求数据
 *
 *  @param delegate 委托
 *
 *  @return 请求
 */
- (void)requestWithDelegate:(id<IMBaseRequestDelegate>)delegate;

/**
 *  请求成功
 *
 *  @param responseObj 请求的结果
 */
- (void)requestFinished:(id)responseObj;

/**
 *  请求失败
 *
 *  @param responseObj 请求的结果
 */
- (void)requestFailed:(id)responseObj;



@end
