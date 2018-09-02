//
//  StaffMessionStatistics.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffMessionStatistics.h"

@implementation StaffMessionStatistics

- (NSString*) messionStatisticString
{
    NSString* retString = _anCountStr;
    if (_unCountStr && 0 < _unCountStr.length)
    {
        if (retString && 0 < retString.length) {
            retString = [retString stringByAppendingFormat:@",%@", _unCountStr];
        }
        else
        {
            retString = _unCountStr;
        }
    }
    
    return retString;
}
@end
