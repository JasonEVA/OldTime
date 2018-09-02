//
//  NSString+SizeExtension.h
//  HakimHospitalRegister
//
//  Created by YinQ on 15/1/13.
//  Copyright (c) 2015年 YinQuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SizeExtension)

- (float)widthSystemFontOfSize:(CGFloat)fontSize;
- (float)widthSystemFont:(UIFont *)font;
- (float)heightSystemFont:(UIFont *)font width:(CGFloat)width;
- (float)heightSystemFontOfSize:(float)fontSize width:(CGFloat)width;

- (float) heightSystemFont:(UIFont *)font width:(CGFloat)width lineSpace:(CGFloat)space;
@end
