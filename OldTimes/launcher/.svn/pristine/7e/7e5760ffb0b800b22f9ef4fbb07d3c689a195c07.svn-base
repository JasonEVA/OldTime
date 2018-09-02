//
//  ContactPersonDetailInformationModel+UseForSelect.m
//  launcher
//
//  Created by William Zhang on 15/8/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ContactPersonDetailInformationModel+UseForSelect.h"
#import <objc/runtime.h>

@implementation ContactPersonDetailInformationModel (UseForSelect)

- (NSRange)searchedRange {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if (value) {
        return [value rangeValue];
    }
    return NSMakeRange(NSNotFound, 0);
}

- (void)setSearchedRange:(NSRange)searchedRange {
    NSValue *value = [NSValue valueWithRange:searchedRange];
    objc_setAssociatedObject(self, @selector(searchedRange), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
