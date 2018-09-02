//
//  BreathingSymptomView.m
//  HMClient
//
//  Created by lkl on 16/7/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingSymptomView.h"

@interface BreathingSymptomView ()
{
    UIView* conclusionview;
    UILabel* lbTitle;
    
    UILabel* lbLine;

}

@end

@implementation BreathingSymptomView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        conclusionview = [[UIView alloc]init];
        [self addSubview:conclusionview];
        
        lbTitle = [[UILabel alloc]init];
        [conclusionview addSubview:lbTitle];
        [lbTitle setTextColor:[UIColor mainThemeColor]];
        [lbTitle setFont:[UIFont boldFont_32]];
        [lbTitle setText:@"备注"];
        
        _lbResult = [[UILabel alloc]init];
        [conclusionview addSubview:_lbResult];
        [_lbResult setTextColor:[UIColor commonTextColor]];
        [_lbResult setFont:[UIFont font_28]];
        [_lbResult setNumberOfLines:0];
        
        _deleteButton = [[UIButton alloc] init];
        [self addSubview:_deleteButton];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:[UIFont font_26]];
        [_deleteButton setTitleColor:[UIColor commonBlueColor] forState:UIControlStateNormal];
        
        lbLine = [[UILabel alloc] init];
        [self addSubview:lbLine];
        [lbLine setText:@"|"];
        [lbLine setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [lbLine setTextColor:[UIColor commonBlueColor]];
        
        _editButton = [[UIButton alloc] init];
        [self addSubview:_editButton];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:[UIFont font_26]];
        [_editButton setTitleColor:[UIColor commonBlueColor] forState:UIControlStateNormal];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [conclusionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(15);
    }];
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(conclusionview);
        make.centerY.equalTo(conclusionview);
        make.height.equalTo(conclusionview);
    }];
    
    [_lbResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.top.equalTo(conclusionview.mas_bottom).with.offset(7.5);
        make.bottom.lessThanOrEqualTo(self).with.offset(-7.5);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbResult.mas_bottom).with.offset(5);
        make.right.equalTo(self).with.offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    [lbLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbResult.mas_bottom).with.offset(5);
        make.right.equalTo(_deleteButton.mas_left).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(3, 20));
    }];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbResult.mas_bottom).with.offset(5);
        make.right.equalTo(lbLine.mas_left).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
}

- (void) setDetectResult:(DetectResult*) detectResult
{
    if (!detectResult || ![detectResult isKindOfClass:[BreathingDetctResult class]]) {
        return;
    }
    BreathingDetctResult* breathResult = (BreathingDetctResult*) detectResult;
    
    [_lbResult setText:breathResult.symptom];
}

@end
