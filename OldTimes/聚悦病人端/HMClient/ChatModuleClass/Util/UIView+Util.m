//
//  UIView+Uti.m
//  launcher
//
//  Created by William Zhang on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "UIView+Util.h"
#import <objc/runtime.h>

static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;

@implementation UIView (Util)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(intrinsicContentSize);
        SEL swizzledSelector = @selector(wz_intrinsicContentSize);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        BOOL success = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (CGSize)wz_intrinsicContentSize {
    CGSize size = [self wz_intrinsicContentSize];
    size.width += self.expandSize.width;
    size.height += self.expandSize.height;
    return size;
}

- (CGSize)expandSize {
    id value = objc_getAssociatedObject(self, _cmd);
    if (value) {
        return [value CGSizeValue];
    }
    
    self.expandSize = CGSizeZero;
    return CGSizeZero;
}

- (void)setExpandSize:(CGSize)expandSize {
    objc_setAssociatedObject(self, @selector(expandSize), [NSValue valueWithCGSize:expandSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//添加tap手势
- (void)addTapActionWithBlock:(GestureActionBlock)block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        GestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}
@end

