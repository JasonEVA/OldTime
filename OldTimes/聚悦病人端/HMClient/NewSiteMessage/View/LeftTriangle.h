//
//  LeftTriangle.h
//  launcher
//
//  Created by 马晓波 on 16/2/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTriangle : UIView
-(void)drawNowWithColor:(UIColor *)color;
- (instancetype)initWithFrame:(CGRect)frame WithColor:(UIColor *)color;
- (instancetype)initWithFrame:(CGRect)frame WithColor:(UIColor *)color colorBorderColor:(UIColor *)colorLine;
@end
