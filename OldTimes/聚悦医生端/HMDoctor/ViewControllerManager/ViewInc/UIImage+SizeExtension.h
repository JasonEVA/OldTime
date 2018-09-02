//
//  UIImage+SizeExtension.h
//  HakimHospitalRegister
//
//  Created by YinQ on 15/1/14.
//  Copyright (c) 2015年 YinQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SizeExtension)

//等比例缩放
- (UIImage *)scaleImageToScale:(float)scaleSize;

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect;

//缩略图
- (UIImage*) thumbnailImage;

- (UIImage*) stretchImage;

+ (UIImage*) circleImage:(float) radius Color:(UIColor*) color;
+ (UIImage*) rectImage:(CGSize) size Color:(UIColor*) color;
+ (UIImage*) rectBorderImage:(CGSize) size BorderColor:(UIColor*) color BorderWidth:(float) borderWidth;

+ (UIImage*) circleHollowImage:(CGSize) size Color:(UIColor*) color Progress:(NSInteger) progress;
@end
