//
//  TrainRoundnessProgressBar.m
//  Shape
//
//  Created by jasonwang on 15/11/10.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainRoundnessProgressBar.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#define Radius          self.frame.size.height / 2
#define LINEWITH1       1
#define LINEWITH2       3

@interface TrainRoundnessProgressBar()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) CGFloat angale;
@end

@implementation TrainRoundnessProgressBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.label];
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
        }];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(Radius,Radius) radius:Radius - LINEWITH1 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor colorLightGray_898888] setStroke];
    [[UIColor clearColor] setFill];
    [path setLineWidth:LINEWITH1];
    [path stroke];
    [path fill];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 addArcWithCenter:CGPointMake(Radius,Radius) radius:Radius - LINEWITH2 startAngle:- M_PI_2 endAngle:- M_PI_2 + (2 * M_PI) * self.angale clockwise:YES];
        [[UIColor themeOrange_ff5d2b] setStroke];
        [[UIColor clearColor] setFill];
        [path1 setLineWidth:LINEWITH2];
        [path1 stroke];
        [path1 fill];
    
}
- (void)setMyAngale:(CGFloat)angale
{
    self.angale = angale;
    [self setNeedsDisplay];
    NSString *str = [NSString stringWithFormat:@"%0.0f%%",angale * 100];
    [self.label setText:str];
}


- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        [_label setTextColor:[UIColor whiteColor]];
        _label.font = [UIFont systemFontOfSize:14];
    }
    return _label;
}
@end
