//
//  RadarGradientLayer.h
//  Shape
//
//  Created by Andrew Shen on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface RadarGradientLayer : CAGradientLayer
- (UIColor *)colorOfPoint:(CGPoint)point;
@end
