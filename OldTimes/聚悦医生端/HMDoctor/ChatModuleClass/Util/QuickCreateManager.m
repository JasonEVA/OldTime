//
//  QuickCreateManager.m
//  Parenting Strategy
//
//  Created by Remon Lv on 14-5-22.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "QuickCreateManager.h"

@implementation QuickCreateManager

// UILabel
+ (UILabel *)creatLableWithFrame:(CGRect)rect Text:(NSString *)text Font:(UIFont *)font Alignment:(NSTextAlignment)alignment Color:(UIColor *)color
{
    UILabel *lable = [[UILabel alloc] initWithFrame:rect];
    [lable setText:text];
    [lable setFont:font];
    [lable setTextAlignment:alignment];
    [lable setTextColor:color];
    return lable;
}

// UIImageView
+ (UIImageView *)creatImageViewWithFrame:(CGRect)rect Image:(UIImage *)image
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    [imgView setImage:image];
    return imgView;
}
+(void)createImgViewRound:(UIImageView*)imgView imgName:(NSString*)name
{
    [imgView.layer setCornerRadius:CGRectGetHeight([imgView bounds]) / 2];//设置圆形半径
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderWidth = 1;//设置外环宽度
    imgView.layer.borderColor = [[UIColor greenColor] CGColor];//设置外环颜色
    imgView.layer.contents = (id)[[UIImage imageNamed:name] CGImage];//设置图片
}
// UIView
+ (UIView *)creatViewWithFrame:(CGRect)rect BgImage:(UIImage *)imgae BgColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    if (imgae != nil)
    {
        UIImageView *imgView = [self creatImageViewWithFrame:view.bounds Image:imgae];
        [view addSubview:imgView];
    }
    if (color != nil)
    {
        [view setBackgroundColor:color];
    }
    return view;
}

// UIButton
+ (UIButton *)creatButtonWithFrame:(CGRect)rect Title:(NSString *)title TitleFont:(UIFont *)font TitleColor:(UIColor *)titleColor BgImage:(UIImage *)imgae HighImage:(UIImage *)hImage BgColor:(UIColor *)bgColor Tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if (imgae != nil)
    {
        [btn setBackgroundImage:imgae forState:UIControlStateNormal];
    }
    if (hImage != nil)
    {
        [btn setBackgroundImage:hImage forState:UIControlStateHighlighted];
    }
    if (bgColor != nil)
    {
        [btn setBackgroundColor:bgColor];
    }
    [btn setTag:tag];
    return btn;
}

// UITextField
+ (UITextField *)creatTextFieldWithFrame:(CGRect)rect Placeholder:(NSString *)title TextFont:(UIFont *)font TextColor:(UIColor *)textColor BgImage:(UIImage *)imgae BgColor:(UIColor *)bgColor Tag:(NSInteger)tag Secure:(BOOL)secure
{
    UITextField *txfd = [[UITextField alloc] initWithFrame:rect];
    if (imgae != nil)
    {
        [txfd setBackground:imgae];
    }
    if (bgColor != nil)
    {
        [txfd setBackgroundColor:bgColor];
    }
    [txfd setTag:tag];
    [txfd setPlaceholder:title];
    [txfd setTextColor:textColor];
    [txfd setFont:font];
    [txfd setSecureTextEntry:secure];
    
    // 左侧不顶格变相设置
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, rect.size.height)];
    txfd.leftView = view;
    txfd.leftViewMode = UITextFieldViewModeAlways;
    
    return txfd;
}

@end
