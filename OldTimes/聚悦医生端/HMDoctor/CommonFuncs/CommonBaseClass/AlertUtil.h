//
//  AlertUtil.h
//  DingCareDemo
//
//  Created by yinquan on 17/2/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AlertConfirmButtonClickBlock)();
typedef void(^AlertCancelButtonClickBlock)();

@interface AlertUtil : NSObject
+ (UIViewController*) topmostViewContoller;
+ (void) showAlert:(NSString*) message alertConfirmButtonClickBlock:(AlertConfirmButtonClickBlock) block;
+ (void) showAlert:(NSString*) message
    alertConfirmButtonClickBlock:(AlertConfirmButtonClickBlock) confirmBlock
    alertCancelButtonClickBlock:(AlertCancelButtonClickBlock) cancelBlock;

@end
