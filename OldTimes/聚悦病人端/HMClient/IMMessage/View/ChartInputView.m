//
//  ChartInputView.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ChartInputView.h"

typedef enum : NSUInteger {
    ChartTypeTextInput,
    ChartTypeVoiceInput,
} ChartInputType;

@interface ChartInputView ()
<UITextViewDelegate>
{
    UIButton* expandbutton;
    UIButton* inputtypebutton;
    
    UITextView* tvInput;
    UIButton* voicebutton;
    ChartInputType inputtype;
    
}
@end

@implementation ChartInputView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self showTopLine];
        
        expandbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:expandbutton];
        [expandbutton setImage:[UIImage imageNamed:@"ic_message_append_btn"] forState:UIControlStateNormal];
        [expandbutton addTarget:self action:@selector(expandbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        inputtypebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:inputtypebutton];
        [inputtypebutton setImage:[UIImage imageNamed:@"ic_message_voice_btn"] forState:UIControlStateNormal];
        [inputtypebutton addTarget:self action:@selector(inputtypebuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        tvInput = [[UITextView alloc]init];
        [self addSubview:tvInput];
        tvInput.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        tvInput.layer.borderWidth = 0.5;
        tvInput.layer.cornerRadius = 2.5;
        tvInput.layer.masksToBounds = YES;
        [tvInput setDelegate:self];
        [tvInput setFont:[UIFont font_28]];
        [tvInput setReturnKeyType:UIReturnKeySend];
        
        voicebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:voicebutton];
        voicebutton.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        voicebutton.layer.borderWidth = 0.5;
        voicebutton.layer.cornerRadius = 2.5;
        voicebutton.layer.masksToBounds = YES;
        [voicebutton setHidden:YES];
        [voicebutton setTitle:@"按住开始录音" forState:UIControlStateNormal];
        [voicebutton setTitle:@"松开结束录音" forState:UIControlStateHighlighted];
        [voicebutton setTitleColor:[UIColor commonDarkGrayTextColor] forState:UIControlStateNormal];
        [voicebutton.titleLabel setFont:[UIFont font_28]];
        
        [voicebutton addTarget:self action:@selector(voicebuttonTouchDown) forControlEvents:UIControlEventTouchDown];
        [voicebutton addTarget:self action:@selector(voicebuttonTouchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        
        [self subviewLayout];
    }
    return self;
}


- (void) expandbuttonClicked:(id) sender
{
    [tvInput resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(appendbuttonClicked)])
    {
        [_delegate appendbuttonClicked];
    }
}

- (void) inputtypebuttonClicked:(id) sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(inputtypebuttonClicked)])
    {
        [_delegate inputtypebuttonClicked];
    }
    
    switch (inputtype)
    {
        case ChartTypeTextInput:
        {
            inputtype = ChartTypeVoiceInput;
            [inputtypebutton setImage:[UIImage imageNamed:@"ic_message_keyboard_btn"] forState:UIControlStateNormal];
            [tvInput resignFirstResponder];
            [tvInput setHidden:YES];
            [voicebutton setHidden:NO];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@49);
            }];
            return;
        }
            break;
        case ChartTypeVoiceInput:
        {
            inputtype = ChartTypeTextInput;
            [inputtypebutton setImage:[UIImage imageNamed:@"ic_message_voice_btn"] forState:UIControlStateNormal];
            [tvInput setHidden:NO];
            [voicebutton setHidden:YES];
            [self textChangeHeight];
            return;
        }
            break;
        default:
            break;
    }
}

- (void) voicebuttonTouchDown
{
    if (_delegate && [_delegate respondsToSelector:@selector(voicestartrecord)])
    {
        [_delegate voicestartrecord];
    }
}

- (void) voicebuttonTouchUp
{
    if (_delegate && [_delegate respondsToSelector:@selector(voiceendrecord)])
    {
        [_delegate voiceendrecord];
    }
}

- (void) subviewLayout
{
    [expandbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10.5);
        make.left.equalTo(self).with.offset(12.5);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [inputtypebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [tvInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(expandbutton.mas_right).with.offset(11);
        make.right.equalTo(inputtypebutton.mas_left).with.offset(-11);
        make.top.equalTo(self).with.offset(10);
        make.bottom.equalTo(self).with.offset(-10);
    }];
    
    [voicebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(expandbutton.mas_right).with.offset(11);
        make.right.equalTo(inputtypebutton.mas_left).with.offset(-11);
        make.top.equalTo(self).with.offset(10);
        make.bottom.equalTo(self).with.offset(-10);
    }];
    
}

- (void) closeKeyBoard
{
    [tvInput resignFirstResponder];
}

- (void) appendAtStaff:(NSString*) staffname
{
    if (staffname && 0 < staffname.length) {
        NSString* strInput = [tvInput.text stringByAppendingString:staffname];
        [tvInput setText:strInput];
    }
    //[tvInput becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text && [text isEqualToString:@"\n"])
    {
        NSString* sendText = textView.text;
        if (sendText && 0 < sendText.length)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(textInput:)])
            {
                [_delegate textInput:sendText];
            }
        }
        
        [textView setText:@""];
        [textView resignFirstResponder];
        return NO;
    }
    if (text && [text isEqualToString:@"@"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(textInputAt)])
        {
            [_delegate textInputAt];
            [self performSelector:@selector(closeKeyBoard) withObject:nil afterDelay:0.2];
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self textChangeHeight];
}

- (void) textChangeHeight
{
    CGFloat height = tvInput.contentSize.height;
    
    if (height > 57)
    {
        height = 57;
    }
    if (height < 29)
    {
        height = 29;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([NSNumber numberWithFloat:(height + 20)]);
    }];

}
@end
