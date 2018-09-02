//
//  WebViewJSHelper.h
//  HMClient
//
//  Created by yinquan on 16/9/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h> 
#import "HMPingAnPayParmsModel.h"

@class ServiceDetail;

@protocol HMWebViewJSHelperObjectProtocol <JSExport>

/*
 
 */
- (NSString*) getUserPermission:(NSString*) operate;

/*
 imageClicked web页面上点击图片事件，查看大图方法
 */
- (void) imageClicked:(NSString*) imageUrl;

/*
 readyServiceOrder
 H5服务商品详情页面，点击购买，开始购买服务商品流程
 */
JSExportAs(readyOrder,
           - (void)readyServiceOrder:(NSString*) upId orderBusinessDets:(NSString*) orderBusinessDets needMsgData:(NSString*) needMsgData price:(NSString *)price recommendUserId:(NSString*) recommendUserId
           );

#pragma mark - 平安支付
- (NSDictionary *)getOrigParams;
- (void)closeWeb;

@end

@protocol HMPingAnPayJSModelDlegate <NSObject>

- (void)HMPingAnPayJSModelDlegateCallBack_pop;

@end

@interface HMWebViewJSHelper : NSObject<HMWebViewJSHelperObjectProtocol>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, retain) UIViewController* controller;
@property (nonatomic, retain) ServiceDetail* serviceDetail;

@property (nonatomic, strong) HMPingAnPayParmsModel *parmsModel;
@property (nonatomic, weak) id<HMPingAnPayJSModelDlegate> delegate;

@end
