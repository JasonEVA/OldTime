//
//  ResetPasswordInputView.m
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ResetPasswordInputView.h"

@interface ResetPasswordInputView ()
<UITextFieldDelegate>
{
    UILabel* lbName;
}
@end

@implementation ResetPasswordInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        [lbName setTextColor:[UIColor blackColor]];
        
        _tfPassowrd = [[UITextField alloc]init];
        [self addSubview:_tfPassowrd];
        [_tfPassowrd setBackgroundColor:[UIColor clearColor]];
        [_tfPassowrd setFont:[UIFont systemFontOfSize:14]];
        [_tfPassowrd setSecureTextEntry:YES];
        [_tfPassowrd setTextColor:[UIColor commonTextColor]];
        [_tfPassowrd setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_tfPassowrd setDelegate:self];
        [_tfPassowrd setReturnKeyType:UIReturnKeyDone];
        
        [self subviewLayout];
    }
    
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    [_tfPassowrd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbName.mas_right).with.offset(9);
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-12);
        make.height.mas_equalTo(self.mas_height);
    }];
}

- (void) setName:(NSString*) name
{
    [lbName setText:name];
    [lbName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([lbName.text widthSystemFont:lbName.font] + 9);
    }];
}

- (void) setPlaceholder:(NSString*) placeholder
{
    [_tfPassowrd setPlaceholder:placeholder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
