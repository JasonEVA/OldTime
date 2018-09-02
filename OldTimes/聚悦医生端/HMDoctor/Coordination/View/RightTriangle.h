//
//  RightTriangle.h
//  launcher
//
//  Created by 马晓波 on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightTriangle : UIView
- (instancetype)initWithFrame:(CGRect)frame WithColor:(UIColor *)color colorBorderColor:(UIColor *)colorLine;
-(void)drawNowWithColor:(UIColor *)color;
@end
