//
//  ChatCommonInputView.m
//  Titans
//
//  Created by Remon Lv on 14-9-15.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatCommonInputView.h"
#import "UnifiedUserInfoManager.h"
#import "QuickCreateManager.h"
#import "UITextView+AtUser.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "BaseButton.h"
#import "MyDefine.h"
#import "Slacker.h"
#import "Category.h"

#define IMG_BTN_ADD         @"message_chat_btnAdd"
#define IMG_BTN_TEXT        @"message_chat_text"
#define IMG_BTN_VOICE       @"message_chat_btnVoice"
#define IMG_BTN_EMOTION     @"message_chat_btnEmotion"

//#define W_TEXTVIEW          (220 + [Slacker getXMarginFrom320ToNowScreen] * 2)
#define W_TEXTVIEW          (223 + [Slacker getXMarginFrom320ToNowScreen] * 2)
#define H_TEXTVIEW          37
#define H_ROW               18

#define W_IMG               27

@interface ChatCommonInputView ()

@property (nonatomic, strong) MASConstraint *constraintTextViewHeight;

@property (nonatomic) BOOL isFirst;            // 创建

@end

@implementation ChatCommonInputView
@synthesize _txView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // 左侧按钮（包含文字、音频输入图标）
        _btnAddAttach = [BaseButton buttonWithType:UIButtonTypeCustom];
        [_btnAddAttach setImage:[UIImage imageNamed:IMG_BTN_ADD] forState:UIControlStateNormal];
        [_btnAddAttach addTarget:self action:@selector(addAttachment) forControlEvents:UIControlEventTouchUpInside];
        [_btnAddAttach.layer setCornerRadius:W_IMG/2.0];
        [_btnAddAttach.layer setMasksToBounds:YES];
        [self addSubview:_btnAddAttach];
        
        _btnEmotionText = [BaseButton buttonWithType:UIButtonTypeCustom];
        [_btnEmotionText setContentMode:UIViewContentModeScaleToFill];
        [_btnEmotionText wz_setImage:[UIImage imageNamed:IMG_BTN_EMOTION] forState:WZControlStateNormal];
        [_btnEmotionText wz_setImage:[UIImage imageNamed:@"message_chat_text"] forState:WZControlStateSelected];
        [_btnEmotionText addTarget:self action:@selector(switchEmotionOrText) forControlEvents:UIControlEventTouchUpInside];
        [_btnEmotionText.layer setCornerRadius:W_IMG/2.0];
        [_btnEmotionText.layer setMasksToBounds:YES];
        [self addSubview:_btnEmotionText];
        
        // 右侧按钮（包含文字、音频输入图标）
        _btnVoiceText = [BaseButton buttonWithType:UIButtonTypeCustom];
        [_btnVoiceText addTarget:self action:@selector(switchTextOrVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btnVoiceText wz_setImage:[UIImage imageNamed:@"message_chat_btnVoice"] forState:WZControlStateNormal];
        [_btnVoiceText wz_setImage:[UIImage imageNamed:@"message_chat_text"] forState:WZControlStateSelected];
        [_btnVoiceText setBackgroundColor:[UIColor whiteColor]];
        [_btnVoiceText.layer setCornerRadius:W_IMG/2.0];
        [_btnVoiceText.layer setMasksToBounds:YES];
        [self addSubview:_btnVoiceText];
        
        // 输入框
        NSTextStorage* textStorage = [[NSTextStorage alloc] init];
        NSLayoutManager* layoutManager = [NSLayoutManager new];
        [textStorage addLayoutManager:layoutManager];
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(frame.size.width, IOS_SCREEN_HEIGHT)];
        textContainer.widthTracksTextView = YES;
        [layoutManager addTextContainer:textContainer];
        _txView = [[ChatInputTextView alloc] initWithFrame:CGRectMake(86.5, 6.5, W_TEXTVIEW, H_TEXTVIEW) textContainer:textContainer];
        [_txView setFont:[UIFont mtc_font_30]];
        [_txView setTextColor:[UIColor blackColor]];
        if ([[UnifiedUserInfoManager share] inputHabit] == kInputHabitSend) {
            [_txView setReturnKeyType:UIReturnKeySend];
        }
        
        _txView.linkTextAttributes = @{NSFontAttributeName:[UIFont mtc_font_30],
                                       NSForegroundColorAttributeName:[UIColor blackColor]};

        [_txView setDelegate:self];
        [_txView.layer setCornerRadius:3.0];
        [_txView.layer setBorderWidth:0.5];
        [_txView setBackgroundColor:[UIColor whiteColor]];
        [_txView.layer setBorderColor:[[UIColor borderColor] CGColor]];
        [_txView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        _txView.scrollsToTop = NO;
        
        [self addSubview:_txView];
        
        // 初始化好 emoji 输入 View
        _emojiInputView = [[MsgEmojiInputView alloc] initWithFrame:CGRectMake(0, 0, IOS_SCREEN_WIDTH, 216)];
        _emojiInputView.delegateKeyInput = _txView;
        _emojiInputView.delegateMsgSend = self;
        if ([[UnifiedUserInfoManager share] inputHabit] != kInputHabitSend)
        {
            [_emojiInputView setFrame:CGRectMake(0, 0, IOS_SCREEN_WIDTH, 180)];
        }
        
        //        _txView.inputView = _emojiInputView;  // 测试用
        
        // 录音按钮
        _btnRecordVoice = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRecordVoice setTitle:LOCAL(CHAT_TAP) forState:UIControlStateNormal];
        [_btnRecordVoice.titleLabel setFont:[UIFont mtc_font_30]];
        [_btnRecordVoice setTitleColor:[UIColor mediumFontColor] forState:UIControlStateNormal];
        [_btnRecordVoice setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor] cornerRadius:5] forState:UIControlStateNormal];
        
        [_btnRecordVoice setTag:0];
        [_btnRecordVoice.layer setCornerRadius:3.0];
        [_btnRecordVoice.layer setBorderWidth:0.5];
        _btnRecordVoice.layer.masksToBounds = YES;
        [_btnRecordVoice.layer setBorderColor:[UIColor borderColor].CGColor];
        
        // 按下开始录制
        [_btnRecordVoice addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
        // 松开停止录制
        [_btnRecordVoice addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside];
        // 按住移动到外面取消录制
        [_btnRecordVoice addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:_btnRecordVoice];
        // 默认设为文字输入模式
        [self setStyleWith:style_text];
        
        _rowOfText = 1;
        _isFirst = YES;
        
        [self initComponent];
    }
    return self;
}

- (void)initComponent
{
    [_btnAddAttach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-11);
        make.width.height.equalTo(@27);
    }];
    
    [_btnEmotionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btnAddAttach.mas_right).offset(5);
        make.width.height.bottom.equalTo(_btnAddAttach);
    }];
    
    [_txView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btnEmotionText.mas_right).offset(10);
        make.centerY.equalTo(self);
//        make.width.equalTo(@(W_TEXTVIEW));
        self.constraintTextViewHeight = make.height.equalTo(@(H_TEXTVIEW));
    }];
    
    [_btnRecordVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_txView);
        make.bottom.equalTo(self).offset(-6);
        make.top.equalTo(self).offset(6);
    }];
    
    [_btnVoiceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_txView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.width.height.bottom.equalTo(_btnAddAttach);
    }];
}

- (void)dealloc
{
    [self._txView removeObserver:self forKeyPath:@"contentSize" context:NULL];
}

// 使得输入框失去焦点,收起键盘
- (void)packupKeyborad
{
    [_txView resignFirstResponder];
    _isAddingAttachStatus = NO;
    
    // Emoji按钮和键盘还原
    if (_txView.inputView != nil)
    {
        _txView.inputView = nil;
        [_txView reloadInputViews];
    }
    _btnEmotionText.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_IsAddAttachment:)])
    {
        [self.delegate ChatCommonInputViewDelegateCallBack_IsAddAttachment:_isAddingAttachStatus];
    }
    
//    [_btnAddAttach setImage:[UIImage imageNamed:IMG_BTN_ADD] forState:UIControlStateNormal];
}

// 键盘弹出
- (void)popupKeyboard
{
    [_txView becomeFirstResponder];
}

#pragma mark - Private Method
// 画出上下两条边框
- (void)drawRect:(CGRect)rect
{
    // 开始画线
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGContextStrokePath(context);
}

/** 添加@成员 */
- (void)addAtUser:(ContactPersonDetailInformationModel *)atUser {
    [self addAtUser:atUser deleteFrontAt:YES];
}

- (void)addAtUser:(ContactPersonDetailInformationModel *)atUser deleteFrontAt:(BOOL)deleteFrontAt {
    [_txView addAtUser:atUser deleteFrontAt:deleteFrontAt];
}

// 切换模式
- (void)setStyleWith:(ChatInput_Style)style
{
    // 改变自身的高度
    CGRect newFrame = self.frame;
    
//    [_btnAddAttach setImage:[UIImage imageNamed:IMG_BTN_ADD] forState:UIControlStateNormal];
    
    // 改变左侧按钮样式和Tag 切换按钮或者输入框
    if (style == style_text)
    {
        if ([[UnifiedUserInfoManager share] inputHabit] != kInputHabitSend)
        {
            if (_txView.text.length != 0)
            {
                [_btnVoiceText setImage:[UIImage imageNamed:@"message_chat_btnTextSend"] forState:UIControlStateNormal];
            }
            else
            {
                [_btnVoiceText setImage:[UIImage imageNamed:IMG_BTN_VOICE] forState:UIControlStateNormal];
            }
        }
        
        [_btnVoiceText setSelected:NO];
        [_btnRecordVoice setHidden:YES];
        [_txView setHidden:NO];
        
        newFrame.size.height = 6.5 * 2 + _txView.frame.size.height;
    }
    else
    {
        if ([[UnifiedUserInfoManager share] inputHabit] != kInputHabitSend)
        {
            [_btnVoiceText setImage:[UIImage imageNamed:IMG_BTN_TEXT] forState:UIControlStateNormal];
        }
        [_btnVoiceText setSelected:YES];
        [_btnRecordVoice setHidden:NO];
        [_txView setHidden:YES];
        
        newFrame.size.height = 6.5 * 2 + H_TEXTVIEW;
    }
    [_btnVoiceText setTag:style];
    
    self.frame = newFrame;
    
    // 委托改变frame
    if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_textViewHeightChanged:)])
    {
        [self.delegate ChatCommonInputViewDelegateCallBack_textViewHeightChanged:NO];
    }
}

// 切换文本和语音
- (void)switchTextOrVoice:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    
    // 如果手动点击切换到键盘需要设置键盘响应
    if ((ChatInput_Style)tag == style_voice)
    {
        [_txView becomeFirstResponder];
        
        // 切换成文字
        [self setStyleWith:!(ChatInput_Style)tag];
    }
    else
    {
        if ([[UnifiedUserInfoManager share] inputHabit] != kInputHabitSend)
        {
            if (self._txView.text.length > 0)
            {
                [self sendText];
            }
            else
            {
                [self packupKeyborad];
                
                // 切换成语音
                [self setStyleWith:!(ChatInput_Style)tag];
            }
        }
        else
        {
            [self packupKeyborad];
            
            // 切换成语音
            [self setStyleWith:!(ChatInput_Style)tag];
        }
    }
    
    // Emoji按钮还原
    [_btnEmotionText setSelected:NO];
}

// 添加附件功能
- (void)addAttachment
{
    _isAddingAttachStatus = !_isAddingAttachStatus;
    
    // Emoji按钮还原
    [_btnEmotionText setSelected:NO];
    
    // 如果是
    if ([_txView isFirstResponder])
    {
        _isAddingAttachStatus = YES;
    }

    if (_isAddingAttachStatus)
    {
        // 还原成文字输入模式
        [self setStyleWith:style_text];
        
        // 输入框失去焦点
        [_txView resignFirstResponder];
    }
    else
    {
        // 输入框得到焦点
        [_txView becomeFirstResponder];
    }
    
    // 委托改变frame
    if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_textViewHeightChanged:)])
    {
        [self.delegate ChatCommonInputViewDelegateCallBack_textViewHeightChanged:_isAddingAttachStatus];
    }
    
    _txView.inputView = nil;
    
}

// 切换表情和文本
- (void)switchEmotionOrText
{
    // TODO: 如果处于语音模式，需要关闭语音
    if (_btnVoiceText.tag == style_voice)
    {
        [self setStyleWith:style_text];
    }
    
    // 如果手动点击切换到键盘需要设置键盘响应
    if (_txView.inputView == nil)
    {
        _btnEmotionText.selected = YES;
        _txView.inputView = _emojiInputView;
        [_txView reloadInputViews];
    }
    else
    {
        _btnEmotionText.selected = NO;
        _txView.inputView = nil;
        [_txView reloadInputViews];
    }
    
    [_txView becomeFirstResponder];
}

// 发送文字
- (void)sendText
{
    // 判断输入的字是否是回车，即按下return
    // 委托发送消息
    
    if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_sendAttributeText:)]) {
        [self.delegate ChatCommonInputViewDelegateCallBack_sendAttributeText:_txView.attributedText];
    }
        
    // 清理内容
    [self._txView setText:@""];
    
    [self resignTextView];
    
    [_btnVoiceText setImage:[UIImage imageNamed:IMG_BTN_VOICE] forState:UIControlStateNormal];
    
    _rowOfText = 1;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UITextView *textView = object;
    CGFloat height = textView.contentSize.height;
    if (height > 3 * H_ROW + H_TEXTVIEW) {
        height = 3 * H_ROW + H_TEXTVIEW;
    }
    else if (height < H_TEXTVIEW)
    {
        height = H_TEXTVIEW;
    }
    
    self.constraintTextViewHeight.offset = height;
    [UIView animateWithDuration:0.2 animations:^{
        [_txView layoutIfNeeded];
    }];
    
    // 改变自身frame
    CGRect newFrame = self.frame;
    
    newFrame.size.height = 6.5 * 2 + height;
    self.frame = newFrame;
    
    // 刚进入聊天页面不需要刷新
    if (!_isFirst || height > H_TEXTVIEW)
    {
        // 委托改变frame
        if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_textViewHeightChanged:)])
        {
            [self.delegate ChatCommonInputViewDelegateCallBack_textViewHeightChanged:NO];
        }
        _isFirst = NO;
    }
}

#pragma mark -
#pragma mark Interface Method
/** 关闭键盘时表情模式切换到文本模式 */
- (void)switchText
{
    [_btnEmotionText setImage:[UIImage imageNamed:IMG_BTN_EMOTION] forState:UIControlStateNormal];
    _txView.inputView = nil;
    [_txView reloadInputViews];
}

#pragma mark - LCVoice Record Method
// 开始录制
-(void)recordStart
{
    [self.delegate ChatCommonInputViewDelegateCallBack_recordVoiceWithEvents:UIControlEventTouchDown];
}
// 停止录制
-(void)recordEnd
{
    [self.delegate ChatCommonInputViewDelegateCallBack_recordVoiceWithEvents:UIControlEventTouchUpInside];
}
// 取消录制
-(void)recordCancel
{
    [self.delegate ChatCommonInputViewDelegateCallBack_recordVoiceWithEvents:UIControlEventTouchUpOutside];
}

#pragma mark - MsgEmojiInputView Delegate
- (void)MsgEmojiInputViewDelegate_SendMessage
{
    [self sendText];
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIMenuController *menuVC = [UIMenuController sharedMenuController];
    [menuVC setMenuItems:nil];
    
    if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_IsAddAttachment:)])
    {
        [self.delegate ChatCommonInputViewDelegateCallBack_IsAddAttachment:NO];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([[UnifiedUserInfoManager share] inputHabit] != kInputHabitSend)
    {
        if (_txView.text.length != 0)
        {
            [_btnVoiceText setImage:[UIImage imageNamed:@"message_chat_btnTextSend"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnVoiceText setImage:[UIImage imageNamed:IMG_BTN_VOICE] forState:UIControlStateNormal];
        }
    }
    
    // 如果行号发生变化
//    [self newLineWithColomNumber:colomNumber];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([[UnifiedUserInfoManager share] inputHabit] == kInputHabitSend && [text isEqualToString:@"\n"]) {
        [self sendText];
        return NO;
    }
    
    if ([text isEqualToString:@"@"]) {
        if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_atUser)]) {
            [(NSObject *)self.delegate performSelector:@selector(ChatCommonInputViewDelegateCallBack_atUser) withObject:nil afterDelay:0.0];
        }
    }
    
    return [textView wz_shouldChangeTextInRange:range replacementText:text];
}

- (void)resignTextView
{
    // 改变输入栏的高度
    self.constraintTextViewHeight.offset = H_TEXTVIEW;
    
    // 改变自身frame
    CGRect newFrame = self.frame;
    newFrame.size.height = 6.5 * 2 + H_TEXTVIEW;
    self.frame = newFrame;
    
    // 委托改变frame
    if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_textViewHeightChanged:)])
    {
        [self.delegate ChatCommonInputViewDelegateCallBack_textViewHeightChanged:NO];
    }
}

@end
