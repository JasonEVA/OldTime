//
//  BaseRequest.h
//  launcher
//
//  Created by William Zhang on 15/7/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  网络请求基类

#import <Foundation/Foundation.h>

extern const NSInteger wz_defaultIdentifier;

@protocol BaseRequestDelegate;

@interface BaseResponse : NSObject
@end

@interface BaseRequest : NSObject

/**
 *  网络请求区分专用，返回至resonse中（默认－1）
 */
@property (nonatomic, readonly) NSInteger identifier;

/**
 *  开启自动填充必要参数（token,anotherName）
 *  默认开启(在[super prepareReuest]之前调用才有效)
 */
@property (nonatomic, getter=isAutoConfigParamsIfNeed) BOOL autoConfigParamsIfNeed;

/** 调用接口 */
@property (nonatomic, copy) NSString *api;
/** 获取类型（默认POST） */
@property (nonatomic, copy) NSString *type;
/**
 *  post传输参数（大部分情况下都是NSMutableDictionry，上传文件时自定义）
 */
@property (nonatomic, strong) id params;

/**
 *  处理完成的数据
 */
@property (nonatomic, readonly) id finalData;

- (instancetype)initWithDelegate:(id<BaseRequestDelegate>)delegate;
/**
 *  initializer
 *
 *  @param identifer 请求区分标识(默认 wz_defaultIdentifier)
 *
 *  @return initialized object
 */
- (instancetype)initWithDelegate:(id<BaseRequestDelegate>)delegate identifier:(NSInteger)identifer;

/// 请求数据整理
/// 若无须自动填充必要参数，在[super prepareReuest]之前设置autoConfigParamsIfNeed 仅在.m中使用
- (void)prepareRequest;

/** 返回数据 */
- (BaseResponse *)prepareResponse:(id)data;
/** 请求数据 */
- (void)requestData;

@end

@protocol BaseRequestDelegate <NSObject>

@optional

- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response DEPRECATED_ATTRIBUTE;
- (void)requestFailed:(BaseRequest *)request errorId:(NSInteger)errorId DEPRECATED_ATTRIBUTE;

/**
 *  请求成功
 *
 *  @param request    请求基类
 *  @param response   请求返回基类（没有则返回nil）
 *  @param totalCount 请求总条数
 */
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount;

/**
 *  请求失败
 *
 *  @param request      请求基类
 *  @param errorMessage 请求失败原因
 */
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage;

@end

