//
//  MessageBaseModel+Extension.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageBaseModel+Extension.h"
#import <objc/runtime.h>

@implementation MessageBaseModel (Extension)

- (BOOL)_isOfflineMsg {
    id value = objc_getAssociatedObject(self, _cmd);
    return value ? [value boolValue] : NO;
}

- (void)set_isOfflineMsg:(BOOL)_isOfflineMsg {
    objc_setAssociatedObject(self, @selector(_isOfflineMsg), @(_isOfflineMsg), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
