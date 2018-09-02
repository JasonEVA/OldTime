//
//  HealthPlanEditJSModel.h
//  HMDoctor
//
//  Created by jasonwang on 16/8/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//  js注入模型 防止内存泄漏 健康计划修改与JS交互

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol MintMedicalDocToolWebViewSExportProtocol <JSExport> //这是一个协议，如果采用协议的方法交互，自己定义的协议必须遵守此协议
//方法名需要和web前端协商定好一样，否则调用不到
- (void)goToPrescribeWithUserId:(NSString *)userId :(NSString *)healthyId;
@end

@protocol HealthPlanEditJSModelDelegate <NSObject>

- (void)HealthPlanEditJSModelDelegateCallBack_withUserId:(NSString *)userId healthId:(NSString *)healthId;

@end

@interface HealthPlanEditJSModel : NSObject <MintMedicalDocToolWebViewSExportProtocol>
@property (nonatomic, weak)id<HealthPlanEditJSModelDelegate> delegate;
@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;
@end
