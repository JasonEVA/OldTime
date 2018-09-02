//
//  UIImage+JWNameImage.h
//  HMClient
//
//  Created by jasonwang on 2017/5/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//  根据string返回对应头像图片分类

#import <UIKit/UIKit.h>

@interface UIImage (JWNameImage)
+ (UIImage *)JW_acquireNameImageWithNameString:(NSString *)string imageSize:(CGSize)size;

+ (UIImage *)JW_acquireNameImageWithNameString:(NSString *)string imageSize:(CGSize)size font:(UIFont *)font;
@end
