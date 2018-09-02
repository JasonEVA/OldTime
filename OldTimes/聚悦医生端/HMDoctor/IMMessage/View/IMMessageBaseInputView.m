//
//  IMMessageBaseInputView.m
//  HMDoctor
//
//  Created by yinquan on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "IMMessageBaseInputView.h"



@implementation IMMessageBaseInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 49)];
    if (self)
    {
        [self showTopLine];
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        
        [self createSubViews];
        [self subviewsLayouts];
    }
    return self;
}

- (void) createSubViews
{
    [self createLeftButton];
    [self createRightButton];
    [self createMessageView];
}

- (void) createRightButton
{
    _leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_leftbutton];
    
}

- (void) createLeftButton
{
    _rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_rightbutton];
}

- (void) createMessageView
{
    _messageview = [[UIView alloc]init];
    [self addSubview:_messageview];
    //[_messageview setBackgroundColor:[UIColor whiteColor]];
    [_messageview.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
    [_messageview.layer setBorderWidth:0.5];
    [_messageview.layer setCornerRadius:4];
    [_messageview.layer setMasksToBounds:YES];
}

- (void) subviewsLayouts
{
    [_leftbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(11);
    }];
    
    [_rightbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(11);
    }];
    
    [_messageview mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(_leftbutton.mas_right).offset(10);
         make.right.equalTo(_rightbutton.mas_left).offset(-10);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-4);
    }];
}
@end
