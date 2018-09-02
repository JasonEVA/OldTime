//
//  ATSHTTPBaseRequest.h
//  ATSAppStructure
//
//  Created by Andrew Shen on 2017/2/15.
//  Copyright © 2017年 AndrewShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@class ATSHTTPBaseResponse, ATSHTTPBaseRequest;

typedef void(^ATSHTTPBaseResponseCompletion)(ATSHTTPBaseResponse *response,BOOL success);

@protocol ATSHTTPBaseRequestDelegate <NSObject>
// 成功和错误返回
@optional
// 成功
- (void)requestSucceed:(ATSHTTPBaseRequest *)request response:(ATSHTTPBaseResponse *)response;

- (void)requestProgress:(CGFloat)progress request:(ATSHTTPBaseRequest *)request;

// 失败
- (void)requestFail:(ATSHTTPBaseRequest *)request response:(ATSHTTPBaseResponse *)response;

@end

@interface ATSHTTPBaseResponse : NSObject

@property (nonatomic, copy)  NSString  *message; // <##>
@property(nonatomic,retain) NSDictionary *data;
@property (nonatomic, assign)  NSInteger  errorCode; // <##>
@property (nonatomic, strong)  NSString  *fileName; // 上传文件名

@end

@interface ATSHTTPBaseRequest : NSObject

@property (nonatomic, strong)       NSString *action;                          // 动作
@property (nonatomic, strong)       NSString *fileDictName;                    // 文件字段名

@property (nonatomic, strong)       NSMutableDictionary *params;            //post传递参数
@property (nonatomic, weak)         id<ATSHTTPBaseRequestDelegate> delegate;      //回调的委托

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
- (ATSHTTPBaseResponse *)prepareResponse:(NSDictionary *)data;

/**
 *  请求数据
 *
 *  @param delegate 委托
 *
 */
- (void)requestWithDelegate:(id<ATSHTTPBaseRequestDelegate>)delegate;

/**
 *  请求数据 上传附件（单张）
 *
 */
- (void)requestWithDelegate:(id<ATSHTTPBaseRequestDelegate>)delegate data:(NSData *)fileData fileName:(NSString *)fileName;

- (void)requestUploadFileData:(NSData *)fileData fileName:(NSString *)fileName completion:(ATSHTTPBaseResponseCompletion)completion;

@end
