//
//  BloodFatResultValueView.m
//  HMClient
//
//  Created by yinqaun on 16/5/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodFatResultValueView.h"

@interface BloodFatResultValueView ()
{
    UILabel* lbName;
    UILabel* lbExtName;
    UILabel* lbValue;
    UILabel* lbUnit;
    UIImageView* ivArrow;
    
    UIView* bottomline;
}
@end

@implementation BloodFatResultValueView


- (id)initWithName:(NSString*) name ExtName:(NSString*) extName
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont font_30]];
        [lbName setText:name];
        
        lbExtName = [[UILabel alloc]init];
        [self addSubview:lbExtName];
        [lbExtName setBackgroundColor:[UIColor clearColor]];
        [lbExtName setTextColor:[UIColor commonGrayTextColor]];
        [lbExtName setFont:[UIFont font_26]];
        [lbExtName setText:extName];
        
        lbValue = [[UILabel alloc]init];
        [self addSubview:lbValue];
        [lbValue setBackgroundColor:[UIColor clearColor]];
        [lbValue setTextColor:[UIColor commonTextColor]];
        [lbValue setFont:[UIFont font_30]];
        
        lbUnit = [[UILabel alloc]init];
        [self addSubview:lbUnit];
        [lbUnit setBackgroundColor:[UIColor clearColor]];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        [lbUnit setFont:[UIFont font_24]];
        if (extName)
        {
            [lbUnit setText:@"mmol/L"];
        }
        
        
        bottomline = [[UIView alloc]init];
        [self addSubview:bottomline];
        [bottomline setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    if (lbExtName.text && 0 < lbExtName.text.length)
    {
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.top.equalTo(self).with.offset(10);
        }];
        
        [lbExtName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];

    }
    else
    {
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
        }];
    }
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-22);
        make.bottom.equalTo(lbValue);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(lbUnit.mas_left).with.offset(-2);
    }];
    
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(@0.5);
        make.bottom.equalTo(self);
    }];
}

- (void) setResultValue:(float) value
{
    [lbValue setText:[NSString stringWithFormat:@"%.2f", value]];
}
@end
