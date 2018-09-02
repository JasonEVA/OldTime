//
//  ATHttpBaseRequest.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATHttpBaseResponse : NSObject

@property (nonatomic, assign) int retCode;//返回状态码
@property (nonatomic, strong) NSString *reqID; //请求ID
@property (nonatomic, strong) NSString *errorMsg;//错误信息

@end

@class ATHttpBaseRequest;
@protocol ATHttpRequestDelegate <NSObject>

@optional

- (void)requestSucceed:(ATHttpBaseRequest *)request withResponse:(ATHttpBaseResponse *)response;
- (void)requestFail:(ATHttpBaseRequest *)request withResponse:(ATHttpBaseResponse *)response;

//- (void)requestProgress:(CGFloat)progress request:(ATHttpBaseRequest *)request;

@end
@interface ATHttpBaseRequest : NSObject

@property (nonatomic, strong)       NSString *api;                          //调用的接口名
@property (nonatomic, strong)       NSMutableDictionary *params;            //post传递参数
@property (nonatomic, weak)         id<ATHttpRequestDelegate> httpDel;      //回调的委托

- (void)prepareRequest;

- (ATHttpBaseResponse *)prepareResponse:(id)data;
- (void)requestWithDelegate:(id<ATHttpRequestDelegate>)del;

@end
