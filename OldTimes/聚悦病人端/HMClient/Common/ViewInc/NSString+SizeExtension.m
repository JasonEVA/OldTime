//
//  NSString+SizeExtension.m
//  HakimHospitalRegister
//
//  Created by YinQ on 15/1/13.
//  Copyright (c) 2015年 YinQuan. All rights reserved.
//

#import "NSString+SizeExtension.h"

@implementation NSString (SizeExtension)

- (CGSize)boundingRectWithSize:(CGSize)size withFond:(UIFont*) font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [self boundingRectWithSize:size
                                                options:NSStringDrawingTruncatesLastVisibleLine |
                                                    NSStringDrawingUsesLineFragmentOrigin |
                                                    NSStringDrawingUsesFontLeading
                                                attributes:attribute
                                                context:nil].size;
    
    return retSize;
}


- (float)widthSystemFontOfSize:(CGFloat)fontSize
{
    return [self widthSystemFont: [UIFont systemFontOfSize: fontSize]];
}

- (float)widthSystemFont:(UIFont *)font
{
    CGSize sizeContent = CGSizeMake(MAXFLOAT, font.xHeight);
    CGSize sizeWidth = [self boundingRectWithSize:sizeContent withFond:font];
    return sizeWidth.width;
}

- (float)heightSystemFontOfSize:(float)fontSize width:(CGFloat)width
{
    return [self heightSystemFont: [UIFont systemFontOfSize: fontSize] width: width];
}

- (float)heightSystemFont:(UIFont *)font width:(CGFloat)width
{
    CGSize sizeContent = CGSizeMake(width, MAXFLOAT);
    CGSize sizeHeight = [self boundingRectWithSize:sizeContent withFond:font];
    
    return sizeHeight.height;
}



- (float) heightSystemFont:(UIFont *)font width:(CGFloat)width lineSpace:(CGFloat)space
{
    CGSize sizeContent = CGSizeMake(width, MAXFLOAT);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    CGSize retSize = [self boundingRectWithSize:sizeContent
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    
    return retSize.height;
}
@end
