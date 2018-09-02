//
//  NSString+NumberString.h
//  HMDoctor
//
//  Created by yinquan on 2017/9/27.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NumberString)

- (BOOL) isPureInteger;

- (BOOL) isPureFloat;

- (BOOL) isNumberString;
@end
