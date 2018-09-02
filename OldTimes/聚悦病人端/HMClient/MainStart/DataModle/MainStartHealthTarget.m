//
//  MainStartHealthTarget.m
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartHealthTarget.h"

@implementation MainStartHealthTarget

- (UIColor*) targetColor
{
    UIColor* targetColor = [UIColor clearColor];
    switch (self.color)
    {
        case 1:
        {
            targetColor = [UIColor commonRedColor];
        }
            break;
        case 2:
        {
            targetColor = [UIColor commonGreenColor];
        }
            break;
        case 3:
        {
            targetColor = [UIColor commonOrangeColor];
        }
            break;
        case 4:
        {
            targetColor = [UIColor commonBlueColor];
        }
            break;
        default:
            break;
    }
    return targetColor;
}
@end
