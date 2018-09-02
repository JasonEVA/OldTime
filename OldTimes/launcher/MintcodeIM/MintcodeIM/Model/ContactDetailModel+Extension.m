//
//  ContactDetailModel+Extension.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ContactDetailModel+Extension.h"
#import <objc/runtime.h>

@implementation ContactDetailModel (Extension)

- (BOOL)_getFromUnReadList {
    id value = objc_getAssociatedObject(self, _cmd);
    return value ? [value boolValue] : NO;
}

- (void)set_getFromUnReadList:(BOOL)_getFromUnReadList {
    objc_setAssociatedObject(self, @selector(_getFromUnReadList), @(_getFromUnReadList), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
