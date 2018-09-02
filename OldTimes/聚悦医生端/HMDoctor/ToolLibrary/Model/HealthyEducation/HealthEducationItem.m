//
//  HealthEducationItem.m
//  HMDoctor
//
//  Created by yinquan on 17/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthEducationItem.h"

@implementation HealthEducationItem

- (BOOL) isFineClass
{
    return (self.contentType == 2);
}

- (BOOL) isRecommand
{
    BOOL isRecommand = (self.topFlag &&
                        self.topFlag.length > 0 &&
                        [self.topFlag isEqualToString:@"Y"]);
    
    return isRecommand;
}
@end

@implementation HealthyEducationColumeModel


@end
