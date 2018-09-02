//
//  UILable+FontFit.m
//  HMClient
//
//  Created by yinquan on 16/9/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UILable+FontFit.h"

@implementation UILabel (FontFit)


//
- (void) setFontFit:(UIFont *)font
{
    CGFloat fontSize = font.pointSize;
    UIFont* fitfont = [UIFont systemFontOfSize:fontSize * kScreenScale];
//    self.font = fitfont;
    [self setFontFit:fitfont];
}

@end

@implementation UITextView (FontFit)

- (void) setFontFit:(UIFont *)font
{
    CGFloat fontSize = font.pointSize;
    UIFont* fitfont = [UIFont systemFontOfSize:fontSize * kScreenScale];
    //    self.font = fitfont;
    [self setFont:fitfont];
}

@end

@implementation UITextField (FontFit)

- (void) setFontFit:(UIFont *)font
{
    CGFloat fontSize = font.pointSize;
    UIFont* fitfont = [UIFont systemFontOfSize:fontSize * kScreenScale];
    //    self.font = fitfont;
    [self setFont:fitfont];
}

@end
