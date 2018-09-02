//
//  UIImage+SizeExtension.m
//  HakimHospitalRegister
//
//  Created by YinQ on 15/1/14.
//  Copyright (c) 2015年 YinQuan. All rights reserved.
//

#import "UIImage+SizeExtension.h"

@implementation UIImage (SizeExtension)

- (UIImage *)scaleImageToScale:(float)scaleSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef scale:1 orientation:self.imageOrientation];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();

    return smallImage;
}

- (UIImage*) thumbnailImage
{
    float imageWidth = self.size.width;
    float imageHeight = self.size.height;
    UIImage* imgThumb = nil;
    if (0 == imageHeight || 0 == imageWidth)
    {
        return imgThumb;
    }
    
    if (imageWidth/imageHeight > 240.0 / 320.0)
    {
        imgThumb = [self scaleImageToScale:(320.0 / imageHeight)];
        if (imgThumb.size.width > 480)
        {
            imgThumb = [imgThumb getSubImage:CGRectMake((imgThumb.size.width - 480)/2, 0, 480, 320)];
        }
        return imgThumb;
    }
    
    imgThumb = [self scaleImageToScale:(240.0/ imageWidth)];
    if (imgThumb.size.height > 320)
    {
        imgThumb = [imgThumb getSubImage:CGRectMake(0, (imgThumb.size.height - 320)/2, 240, 320)];
    }
    
    return imgThumb;
}


- (UIImage*) stretchImage
{
    UIImage* img = [self stretchableImageWithLeftCapWidth:(self.size.width * 0.5)  topCapHeight:(self.size.height * 0.5)];
    return img;
}

+ (UIImage*) circleImage:(float) radius Color:(UIColor*) color
{
    CGSize size = CGSizeMake(radius * 2, radius * 2);
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width , size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1);
    
    //CGContextFillEllipseInRect(context, CGRectMake(95, 95, 100.0, 100));
    
    CGContextAddArc(context, size.width/2, size.width/2, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (UIImage*) circleHollowImage:(CGSize) size Color:(UIColor*) color Progress:(NSInteger) progress
{
    size.width *= 2;
    size.height *= 2;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width , size.height );
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    
    //绘制大圆
   
    float radius = size.width;
    if (radius < size.height)
    {
        radius = size.height;
    }
    
    float radiusin = size.width;
    if (radiusin > size.height)
    {
        radiusin = size.height;
    }
    
    radiusin /= 2;
    radiusin -= radius / 8;
    float width = radius - radiusin;
    radius -= width/2;
    
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    
    CGContextAddArc(context, size.width/2, size.height/2, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    //扇形
    radiusin -= 3;
    CGContextMoveToPoint(context, size.width/2, size.height/2);
    CGContextAddArc(context, size.width/2,  size.width/2, radiusin, ((float)progress / 100) * 2 * M_PI - M_PI/2, M_PI * 2  -M_PI / 2, 0);
    CGContextSetLineWidth(context, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (UIImage*) rectImage:(CGSize) size Color:(UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width , size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) rectBorderImage:(CGSize) size BorderColor:(UIColor*) color BorderWidth:(float) borderWidth
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width , size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextAddRect(context,rect);
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
