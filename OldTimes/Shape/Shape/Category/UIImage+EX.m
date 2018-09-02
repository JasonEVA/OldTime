//
//  UIImage+EX.m
//  Shape
//
//  Created by Andrew Shen on 15/10/26.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "UIImage+EX.h"

@implementation UIImage (EX)

+ (UIImage *)imageScaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
