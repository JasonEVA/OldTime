//
//  NSAttributedString+EX.h
//  HMDoctor
//
//  Created by jasonwang on 16/5/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (EX)
/**
 *  改变一个字符串指定字符的样式（颜色，大小等）
 *
 *  @param changePart    根据数据会变化的部分
 *  @param unChangePart  固定不变的部分
 *  @param unChangeColor 固定不变部分需要改成的颜色
 *  @param unChangeFont  固定不变部分需要改成的大小
 *
 *  @return 经过改变的 NSAttributedString
 */
+ (NSAttributedString *)getAttributWithChangePart:(NSString *)changePart UnChangePart:(NSString *)unChangePart UnChangeColor:(UIColor *)unChangeColor UnChangeFont:(UIFont *)unChangeFont;

+ (NSAttributedString *)getAttributWithUnChangePart:(NSString *)unChangePart changePart:(NSString *)changePart changeColor:(UIColor *)changeColor changeFont:(UIFont *)changeFont;
@end
