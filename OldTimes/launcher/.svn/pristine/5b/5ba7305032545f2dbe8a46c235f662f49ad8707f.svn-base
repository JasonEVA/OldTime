//
//  ChatInputView.m
//  Titans
//
//  Created by Remon Lv on 14-9-16.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatInputView.h"
#import "Slacker.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "UIColor+Hex.h"
@implementation ChatInputView
@synthesize _viewCommon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 背景色
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // 文字语音输入栏
        _viewCommon = [[ChatCommonInputView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, H_COMMON_VIEW)];
//        [_viewCommon setBackgroundColor:[UIColor grayBackground]];
        [_viewCommon setDelegate:self];
        [self addSubview:_viewCommon];
        
        // 附件输入栏
        _viewAttach = [[ChatAttachPickView alloc] initWithFrame:CGRectMake(0, H_COMMON_VIEW, frame.size.width, H_ATTACH_VIEW)];
        [_viewAttach setDelegate:self];
        [self addSubview:_viewAttach];
    }
    return self;
}

- (BOOL)isFirstResponder { return [(UITextView *)_viewCommon._txView isFirstResponder]; }
// 使得输入框失去焦点,收起键盘
- (void)packupKeyborad
{
    [_viewCommon packupKeyborad];
}

- (void)popupKeyboard
{
    [_viewCommon popupKeyboard];
}

- (void)addAtUser:(ContactPersonDetailInformationModel *)atUser {
    [self addAtUser:atUser deleteFrontAt:YES];
}

- (void)addAtUser:(ContactPersonDetailInformationModel *)atUser deleteFrontAt:(BOOL)deleteFrontAt {
    [_viewCommon addAtUser:atUser deleteFrontAt:deleteFrontAt];
}

- (NSAttributedString *)inputAttributeString {
    return [_viewCommon._txView attributedText];
}

- (void)setInputAttributeString:(NSAttributedString *)inputAttributeString {
    [_viewCommon._txView setAttributedText:inputAttributeString];
}

#pragma mark - ChatCommonInputView Delegate
// 开始或者结束添加附件事件的委托回调
- (void)ChatCommonInputViewDelegateCallBack_IsAddAttachment:(BOOL)mark
{
    // 转发委托
    if ([self.delegate respondsToSelector:@selector(ChatInputViewDelegateCallBack_IsAddAttachment:)])
    {
        [self.delegate ChatInputViewDelegateCallBack_IsAddAttachment:mark];
    }
}

- (void)ChatCommonInputViewDelegateCallBack_sendAttributeText:(NSAttributedString *)attributeText {
    if ([self.delegate respondsToSelector:@selector(ChatInputViewDelegateCallBack_sendAttributeText:)]) {
        [self.delegate ChatInputViewDelegateCallBack_sendAttributeText:attributeText];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(ChatInputViewDelegateCallBack_sendText:)]) {
        [self.delegate ChatInputViewDelegateCallBack_sendText:attributeText.string];
    }
}

// 录音按钮事件的委托回调
- (void)ChatCommonInputViewDelegateCallBack_recordVoiceWithEvents:(UIControlEvents)controlEvents
{
    // 转发委托回调
    if ([self.delegate respondsToSelector:@selector(ChatInputViewDelegateCallBack_recordVoiceWithEvents:)])
    {
        [self.delegate ChatInputViewDelegateCallBack_recordVoiceWithEvents:controlEvents];
    }
}

// 文本输入框换行的委托回调 isDefault YES是弹出附件栏目   increased是整个高度
- (void)ChatCommonInputViewDelegateCallBack_textViewHeightChanged:(BOOL)isDefaut
{
    // 改变附件栏View的Frame
    CGRect newFrame = _viewAttach.frame;
    newFrame.origin.y = [Slacker getValueWithFrame:_viewCommon.frame WithX:NO];
    _viewAttach.frame = newFrame;
    
    // 改变自身的Frame
    newFrame = self.frame;
    newFrame.size.height = _viewCommon.frame.size.height + _viewAttach.frame.size.height;
    CGFloat increased = newFrame.size.height;
    self.frame = newFrame;
    
    // 发送委托
    if ([self.delegate respondsToSelector:@selector(ChatInputViewDelegateCallBack_frameChangedWithIncreasedHeight:)])
    {
        if (!isDefaut)
        {
            increased -= 110;
        }

        [self.delegate ChatInputViewDelegateCallBack_frameChangedWithIncreasedHeight:increased];
    }
}

- (void)ChatCommonInputViewDelegateCallBack_atUser {
    if ([self.delegate respondsToSelector:@selector(ChatInputViewDelegateCallBack_atUser)]) {
        [self.delegate ChatInputViewDelegateCallBack_atUser];
    }
}

#pragma mark - ChatAttachPickView Delegate
// 附件栏选择的委托回调
- (void)ChatAttachPickViewDelegateCallBack_BtnClickedWithTag:(ChatAttachPick_tag)tag
{
    // 转发委托回调
    if ([self.delegate respondsToSelector:@selector(ChatInputViewDelegateCallBack_attchmentSelectedWithTag:)])
    {
        [self.delegate ChatInputViewDelegateCallBack_attchmentSelectedWithTag:tag];
    }
}

@end
