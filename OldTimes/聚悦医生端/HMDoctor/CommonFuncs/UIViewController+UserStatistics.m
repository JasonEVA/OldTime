//
//  UIViewController+UserStatistics.m
//  HMDoctor
//
//  Created by Dee on 16/9/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UIViewController+UserStatistics.h"
#import <UMMobClick/MobClick.h>
@implementation UIViewController (UserStatistics)

+ (void)load {
    [self exchangeOriginMethod:@selector(viewWillAppear:) WithSwizzledMethod:@selector(kh_viewWillAppear:)];
    
    [self exchangeOriginMethod:@selector(viewWillDisappear:) WithSwizzledMethod:@selector(kh_viewWillDisappear:)];
}

+ (void)exchangeOriginMethod:(SEL)originSelector WithSwizzledMethod:(SEL)swizzledSelecotr {
      
    Method originalMethod = class_getInstanceMethod(self, originSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelecotr);
    
    BOOL success = class_addMethod(self, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(self, swizzledSelecotr, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)kh_viewWillAppear:(BOOL)animated {
    [self kh_viewWillAppear:animated];
    //友盟页面统计
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    //方便页面查找
    NSLog(@">>>%@",NSStringFromClass([self class]));
}

- (void)kh_viewWillDisappear:(BOOL)animated {
    [self kh_viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
