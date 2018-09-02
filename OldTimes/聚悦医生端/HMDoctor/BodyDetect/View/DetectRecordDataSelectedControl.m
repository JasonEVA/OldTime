//
//  DetectRecordDataSelectedControl.m
//  HMClient
//
//  Created by yinqaun on 16/5/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecordDataSelectedControl.h"

@interface DetectRecordDataSelectedControl ()
{
    UILabel* lbSelectedName;
    UIImageView* ivArrow;
}
@end

@implementation DetectRecordDataSelectedControl

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        [self.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [self.layer setBorderWidth:0.5];
        
        lbSelectedName = [[UILabel alloc]init];
        [self addSubview:lbSelectedName];
        [lbSelectedName setBackgroundColor:[UIColor clearColor]];
        [lbSelectedName setFont:[UIFont systemFontOfSize:12]];
        [lbSelectedName setTextColor:[UIColor mainThemeColor]];
        [lbSelectedName setText:@"全部"];
        
//        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_arrow_s"]];
//        [self addSubview:ivArrow];
        
        [self subviewLayout];

    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        [self.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [self.layer setBorderWidth:0.5];
        
        lbSelectedName = [[UILabel alloc]init];
        [self addSubview:lbSelectedName];
        [lbSelectedName setBackgroundColor:[UIColor clearColor]];
        [lbSelectedName setFont:[UIFont systemFontOfSize:12]];
        [lbSelectedName setTextColor:[UIColor mainThemeColor]];
        [lbSelectedName setText:@"全部"];
        
//        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_arrow_s"]];
//        [self addSubview:ivArrow];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbSelectedName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
//    [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.right.equalTo(self).with.offset(-8.5);
//        make.size.mas_equalTo(CGSizeMake(10, 10));
//    }];
}

- (void) setSelectedName:(NSString*) name
{
    [lbSelectedName setText:name];
}
@end
