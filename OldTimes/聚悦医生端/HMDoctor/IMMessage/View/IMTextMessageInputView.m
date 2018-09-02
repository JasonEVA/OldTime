//
//  IMTextMessageInputView.m
//  HMDoctor
//
//  Created by yinquan on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "IMTextMessageInputView.h"

@interface IMTextMessageInputView ()
{
    
}
@end

@implementation IMTextMessageInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) createSubViews
{
    [super createSubViews];
    [self.leftbutton setBackgroundImage:[UIImage imageNamed:@"img_imvoice_button"] forState:UIControlStateNormal];
    [self.rightbutton setBackgroundImage:[UIImage imageNamed:@"img_message_append_button"] forState:UIControlStateNormal];
    
    _tvMessage = [[UITextView alloc]init];
    [_tvMessage setFont:[UIFont systemFontOfSize:14]];
    [self.messageview addSubview:_tvMessage];
    [_tvMessage setBackgroundColor:[UIColor whiteColor]];
    _tvMessage.returnKeyType = UIReturnKeySend;
}

- (void) subviewsLayouts
{
    [super subviewsLayouts];
    if (_tvMessage)
    {
        [_tvMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.messageview);
            make.left.equalTo(self.messageview);
            make.top.equalTo(self.messageview);
        }];
    }
    
}
@end
