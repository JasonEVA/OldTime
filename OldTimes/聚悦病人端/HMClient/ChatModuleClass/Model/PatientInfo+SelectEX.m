//
//  PatientInfo+SelectEX.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientInfo+SelectEX.h"
#import <objc/runtime.h>

@implementation PatientInfo (SelectEX)

- (void)setAt_selected:(BOOL)at_selected {
    objc_setAssociatedObject(self, @selector(at_selected), @(at_selected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)at_selected {
    id value = objc_getAssociatedObject(self, _cmd);
    return value ? [value boolValue] : NO;
}

@end
