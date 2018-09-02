//
//  MeUploadIconModel.m
//  Shape
//
//  Created by jasonwang on 15/10/26.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeUploadIconModel.h"
#import <MJExtension/MJExtension.h>

@implementation MeUploadIconModel

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if ([property isKindOfClass:[NSString class]]) {
            oldValue = @"";
        }
    }
    return oldValue;
}

@end
