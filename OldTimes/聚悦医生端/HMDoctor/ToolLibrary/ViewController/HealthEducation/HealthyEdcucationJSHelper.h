//
//  HealthyEdcucationJSHelper.h
//  HMDoctor
//
//  Created by yinquan on 17/1/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HealthyEdcucationJSHelperObjectProtocol <JSExport>

- (void) imageClicked:(NSString*) imageUrl;
@end

@interface HealthyEdcucationJSHelper : NSObject<HealthyEdcucationJSHelperObjectProtocol>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, retain) UIViewController* controller;

@end
