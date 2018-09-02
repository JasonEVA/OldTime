//
//  BaseRequest.h
//  PalmDoctorPT
//
//  Created by Andrew Shen on 15/4/7.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


typedef void(^HttpRequestResponse)(id data,NSInteger code,NSString *message);


@class BaseRequest;

@interface BaseResponse : NSObject

@property (nonatomic, copy)  NSString  *message; // <##>
@property(nonatomic,retain) NSDictionary *data;

-(void)showServerErrorMessage;

@end

@protocol BaseRequestDelegate <NSObject>
// 成功和错误返回
@optional
// 成功
- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response;
// 失败
- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response;
@end

@interface BaseRequest : NSObject

@property (nonatomic, strong)       NSString *action;                          // 动作
@property (nonatomic, strong)       NSString *fileDictName;                    // 文件字段名

@property (nonatomic, strong)       NSMutableDictionary *params;            //post传递参数
//@property (nonatomic, strong)       AFHTTPRequestOperation *req;            //生成的请求
@property (nonatomic, weak)         id<BaseRequestDelegate> delegate;      //回调的委托

/**
 *  请求的数据整理
 */
- (void)prepareRequest;

/**
 *  返回的数据
 *
 *  @param data 返回的数据
 *
 *  @return 返回数据
 */
- (BaseResponse *)prepareResponse:(NSDictionary *)data;

/**
 *  请求数据
 *
 *  @param delegate 委托
 *
 *  @return 请求
 */
- (void)requestWithDelegate:(id<BaseRequestDelegate>)delegate;

/**
 *  请求数据 (GET)
 *
 *  @param delegate 委托
 *
 *  @return 请求
 */
- (void)requestGetWithDelegate:(id<BaseRequestDelegate>)delegate;

/**
 *  请求数据 上传附件（单张）
 *
 *  @return 请求
 */
// 上传图片
- (void)requestWithDelegate:(id<BaseRequestDelegate>)delegate data:(NSData *)imageData;

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

- (void)httpFinishRequest:(HttpRequestResponse)finishRequest failureRequest:(HttpRequestResponse)failureRequest;

@end


