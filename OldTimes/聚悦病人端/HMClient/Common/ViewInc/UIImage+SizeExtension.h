//
//  UIImage+SizeExtension.h
//  HakimHospitalRegister
//
//  Created by YinQ on 15/1/14.
//  Copyright (c) 2015年 YinQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

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

+ (UIImage*) circleBoarderImage:(CGSize) size Color:(UIColor*) color BoarderWidth:(CGFloat) boarderWidth;

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;
@end
