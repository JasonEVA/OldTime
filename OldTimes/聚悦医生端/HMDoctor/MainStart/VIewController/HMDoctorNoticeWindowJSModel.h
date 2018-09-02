//
//  HMDoctorNoticeWindowJSModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/7/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//  公告窗JS交互model

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef NS_ENUM(NSUInteger, SendType) {
    
    SendType_Work,

    SendType_Patitent,
    
    Back
    
};

@protocol HMDoctorNoticeWindowJSModelWebViewSExportProtocol <JSExport> //这是一个协议，如果采用协议的方法交互，自己定义的协议必须遵守此协议
- (void)sendYHNotesId:(NSString *)notesId;
- (void)sendWorkNotesId:(NSString *)notesId;
- (void)backPre;
@end

@protocol HMDoctorNoticeWindowJSModelDelegate <NSObject>

- (void)HMDoctorNoticeWindowJSModelDelegateCallBack_SendClick:(SendType)type noteId:(NSString *)noteId;

@end

@interface HMDoctorNoticeWindowJSModel : NSObject<HMDoctorNoticeWindowJSModelWebViewSExportProtocol>
@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) id<HMDoctorNoticeWindowJSModelDelegate> delegate;
@end
