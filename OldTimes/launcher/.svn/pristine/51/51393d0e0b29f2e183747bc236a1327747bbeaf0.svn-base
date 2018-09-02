//
//  ContactDepartmentImformationModel+UserForSelect.m
//  launcher
//
//  Created by williamzhang on 15/10/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactDepartmentImformationModel+UserForSelect.h"
#import <objc/runtime.h>

@implementation ContactDepartmentImformationModel (UserForSelect)

- (BOOL)isSelect {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsSelect:(BOOL)isSelect {
    objc_setAssociatedObject(self, @selector(isSelect), @(isSelect), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSRange)searchedRange {
    return [objc_getAssociatedObject(self, _cmd) rangeValue];
}

- (void)setSearchedRange:(NSRange)searchedRange {
    NSValue *value = [NSValue valueWithRange:searchedRange];
    objc_setAssociatedObject(self, @selector(searchedRange), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
