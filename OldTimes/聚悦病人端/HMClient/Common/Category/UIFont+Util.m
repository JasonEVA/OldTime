//
//  UIFont+Util.m
//  HMClient
//
//  Created by Dee on 16/9/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UIFont+Util.h"
#import "UserInfo.h"
//变大自字号时的增量

#define IOS_DEVICE_6        ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IOS_DEVICE_5        ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IOS_DEVICE_4        ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IOS_DEVICE_6Plus    ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
@implementation UIFont (Util)

+ (UIFont *)font_16 { return [self fontWithSize:8];}
+ (UIFont *)font_18 { return [self fontWithSize:9];}
+ (UIFont *)font_20 { return [self fontWithSize:10];}
+ (UIFont *)font_22 { return [self fontWithSize:11];}
+ (UIFont *)font_24 { return [self fontWithSize:12];}
+ (UIFont *)font_25 { return [self fontWithSize:12.5];}
+ (UIFont *)font_26 { return [self fontWithSize:13];}
+ (UIFont *)font_28 { return [self fontWithSize:14];}
+ (UIFont *)font_30 { return [self fontWithSize:15];}
+ (UIFont *)font_32 { return [self fontWithSize:16];}
+ (UIFont *)font_34 { return [self fontWithSize:17];}
+ (UIFont *)font_36 { return [self fontWithSize:18];}
+ (UIFont *)font_38 { return [self fontWithSize:19];}
+ (UIFont *)font_40 { return [self fontWithSize:20];}
+ (UIFont *)font_42 { return [self fontWithSize:21];}
+ (UIFont *)font_46 { return [self fontWithSize:23];}
+ (UIFont *)font_48 { return [self fontWithSize:24];}
+ (UIFont *)font_50 { return [self fontWithSize:25];}
+ (UIFont *)font_54 { return [self fontWithSize:27];}
+ (UIFont *)font_60 { return [self fontWithSize:30];}
+ (UIFont *)font_72 { return [self fontWithSize:36];}
+ (UIFont *)font_90 { return [self fontWithSize:45];}

+ (UIFont *)boldFont_20 { return [self boldFontWithSize:10];}
+ (UIFont *)boldFont_22 { return [self boldFontWithSize:11];}
+ (UIFont *)boldFont_24 { return [self boldFontWithSize:12];}
+ (UIFont *)boldFont_26 { return [self boldFontWithSize:13];}
+ (UIFont *)boldFont_28 { return [self boldFontWithSize:14];}
+ (UIFont *)boldFont_30 { return [self boldFontWithSize:15];}
+ (UIFont *)boldFont_32 { return [self boldFontWithSize:16];}
+ (UIFont *)boldFont_36 { return [self boldFontWithSize:18];}
+ (UIFont *)boldFont_40 { return [self boldFontWithSize:20];}



+ (UIFont *)boldFontWithSize:(CGFloat)size {
    UIFont* font = [UIFont boldSystemFontOfSize:size * kScreenScale];
    return font;
}

+ (UIFont *)fontWithSize:(CGFloat)size
{
    UIFont* font = [UIFont systemFontOfSize:size * kScreenScale];
    return font;
}

#if 0
+ (UIFont *)boldFontWithSize:(CGFloat)size {
    UserInfoHelper *helper = [UserInfoHelper defaultHelper];
    return [UIFont boldSystemFontOfSize:helper.isBigFont?size+[self getIncreaseMentFont]:size];
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    UserInfoHelper *helper = [UserInfoHelper defaultHelper];
    return [UIFont systemFontOfSize:helper.isBigFont?size+[self getIncreaseMentFont]:size];
}

+ (int)getIncreaseMentFont
{
    if (IOS_DEVICE_4) {
        return 3;
    }
    else if(IOS_DEVICE_5){
        return 3;
    }
    else if(IOS_DEVICE_6){
        return 4;
    }
    else if (IOS_DEVICE_6Plus){
        return 6;
    }
    return 3;
}
#endif
@end
