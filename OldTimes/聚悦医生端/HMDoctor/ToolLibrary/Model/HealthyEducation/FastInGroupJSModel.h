//
//  FastInGroupJSModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/4/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol FastInGroupJSModelWebViewSExportProtocol <JSExport> //这是一个协议，如果采用协议的方法交互，自己定义的协议必须遵守此协议
- (NSString *)getDoctorUserId;
- (NSString *)getDoctorUserName;
- (void)getPageTitle:(NSString *)string;

//添加监测数据
- (void)goAddRecord:(NSString *)userId;
@end

@protocol FastInGroupJSModelDelegate <NSObject>

- (void)FastInGroupJSModelDelegateCallBack_getTitel:(NSString *)titel;
- (void)FastInGroupJSModelDelegateCallBack_goAddRecord:(NSString *)userId;

@end

@interface FastInGroupJSModel : NSObject<FastInGroupJSModelWebViewSExportProtocol>
@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) id<FastInGroupJSModelDelegate> delegate;
@end
