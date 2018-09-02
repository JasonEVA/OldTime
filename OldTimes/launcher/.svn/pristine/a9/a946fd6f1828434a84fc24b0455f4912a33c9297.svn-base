//
//  UIActionSheet+Util.m
//  launcher
//
//  Created by williamzhang on 15/10/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "UIActionSheet+Util.h"
#import <objc/runtime.h>

@implementation UIActionSheet (Util)

- (NSInteger)identifier {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIdentifier:(NSInteger)identifier {
    objc_setAssociatedObject(self, @selector(identifier), @(identifier), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIAlertView (Util)

- (NSString *)identifier {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end