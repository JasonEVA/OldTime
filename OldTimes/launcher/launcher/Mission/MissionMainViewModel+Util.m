//
//  MissionMainViewModel+Util.m
//  launcher
//
//  Created by William Zhang on 15/9/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionMainViewModel+Util.h"
#import <objc/runtime.h>

@implementation MissionMainViewModel (Util)

- (BOOL)isFolder {
    NSNumber *boolNumber = objc_getAssociatedObject(self, _cmd);
    if (boolNumber) {
        return [boolNumber boolValue];
    }
    
    self.folder = NO;
    return NO;
}

- (void)setFolder:(BOOL)folder {
    NSNumber *boolNumber = [NSNumber numberWithBool:folder];
    objc_setAssociatedObject(self, @selector(isFolder), boolNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
