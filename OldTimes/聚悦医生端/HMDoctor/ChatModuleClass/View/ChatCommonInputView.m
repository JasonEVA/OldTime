//
//  ChatCommonInputView.m
//  Titans
//
//  Created by Remon Lv on 14-9-15.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatCommonInputView.h"
#import "QuickCreateManager.h"
#import "UITextView+AtUser.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "BaseButton.h"
#import "Slacker.h"
//#import "Category.h"
#import "MyDefine.h"
#import "UIImage+EX.h"
#import "ContactInfoModel.h"

#define IMG_BTN_ADD         @"message_chat_btnAdd"
#define IMG_BTN_TEXT        @"message_chat_text"
#define IMG_BTN_VOICE       @"message_chat_btnVoice"
#define IMG_BTN_EMOTION     @"message_chat_btnEmotion"

//#define W_TEXTVIEW          (220 + [Slacker getXMarginFrom320ToNowScreen] * 2)
#define W_TEXTVIEW          (223 + [Slacker getXMarginFrom320ToNowScreen] * 2)
#define H_TEXTVIEW          37
#define H_ROW               18

#define W_IMG               27
#define BIGGESTSENDWORD     1000  //单条消息 限定最大发送字数

@interface ChatCommonInputView ()

@property (nonatomic, strong) MASConstraint *constraintTextViewHeight;

@property (nonatomic) BOOL isFirst;            // 创建

@property (nonatomic, strong) UILabel *placeholderLb;

@property (nonatomic) BOOL isShowPlaceholderText;

@end

@implementation ChatCommonInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // 左侧按钮（包含文字、音频输入图标）
        
        [self addSubview:self.btnAddAttach];
        
        
        [self addSubview:self.btnEmotionText];
        
        // 右侧按钮（包含文字、音频输入图标）
        [self addSubview:self.btnVoiceText];
        
        // 输入框
        
        [self addSubview:self.txView];
        [self.txView addSubview:self.placeholderLb];
        // 初始化好 emoji 输入 View
        
        
        //        _txView.inputView = _emojiInputView;  // 测试用
        
        // 录音按钮
        
        [self addSubview:self.btnRecordVoice];
        // 默认设为文字输入模式
        [self setStyleWith:style_text];
        
        self.rowOfText = 1;
        self.isFirst = YES;
        
        [self JWinitComponent];
    }
    return self;
}

- (void)JWinitComponent
{
    [self.btnVoiceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-11);
        make.width.height.equalTo(@27);
    }];
    
    [self.txView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnVoiceText.mas_right).offset(10);
        make.centerY.equalTo(self);
        self.constraintTextViewHeight = make.height.equalTo(@(H_TEXTVIEW));
    }];
    
    [self.placeholderLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.txView);
        make.left.equalTo(self.txView).offset(8);
    }];
    
    [self.btnRecordVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.txView);
        make.bottom.equalTo(self).offset(-6);
        make.top.equalTo(self).offset(6);
    }];
    
    [self.btnEmotionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.txView.mas_right).offset(10);
        make.width.height.bottom.equalTo(self.btnVoiceText);
    }];

    [self.btnAddAttach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnEmotionText.mas_right).offset(5);
        make.right.equalTo(self).offset(-10);
        make.width.height.bottom.equalTo(self.btnEmotionText);
    }];
    
}

- (void)dealloc
{
    [self.txView removeObserver:self forKeyPath:@"contentSize" context:NULL];
}

// 使得输入框失去焦点,收起键盘
- (void)packupKeyborad
{
    [self.txView resignFirstResponder];
    self.isAddingAttachStatus = NO;
    
    // Emoji按钮和键盘还原
    if (self.txView.inputView != nil)
    {
        self.txView.inputView = nil;
        [self.txView reloadInputViews];
    }
    self.btnEmotionText.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_IsAddAttachment:)])
    {
        [self.delegate ChatCommonInputViewDelegateCallBack_IsAddAttachment:_isAddingAttachStatus];
    }
    
//    [_btnAddAttach setImage:[UIImage imageNamed:IMG_BTN_ADD] forState:UIControlStateNormal];
}

// 键盘弹出
- (void)popupKeyboard
{
    [self.txView becomeFirstResponder];
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
- (void)addAtUser:(ContactInfoModel *)atUser {
    [self addAtUser:atUser deleteFrontAt:YES];
}

- (void)addAtUser:(ContactInfoModel *)atUser deleteFrontAt:(BOOL)deleteFrontAt {
    [self.txView addAtUser:atUser deleteFrontAt:deleteFrontAt];
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
        [self.btnVoiceText setSelected:NO];
        [self.btnRecordVoice setHidden:YES];
        [self.txView setHidden:NO];
        
        newFrame.size.height = 6.5 * 2 + self.txView.frame.size.height;
    }
    else
    {
        [self.btnVoiceText setSelected:YES];
        [self.btnRecordVoice setHidden:NO];
        [self.txView setHidden:YES];
        
        newFrame.size.height = 6.5 * 2 + H_TEXTVIEW;
    }
    [self.btnVoiceText setTag:style];
    
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
        [self.txView becomeFirstResponder];
        
        // 切换成文字
        [self setStyleWith:!(ChatInput_Style)tag];
    }
    else
    {
        {
            [self packupKeyborad];
            
            // 切换成语音
            [self setStyleWith:!(ChatInput_Style)tag];
        }
    }
    
    // Emoji按钮还原
    [self.btnEmotionText setSelected:NO];
}

// 添加附件功能
- (void)addAttachment
{
    self.isAddingAttachStatus = !self.isAddingAttachStatus;
    
    // Emoji按钮还原
    [self.btnEmotionText setSelected:NO];
    
    // 如果是
    if ([self.txView isFirstResponder])
    {
        self.isAddingAttachStatus = YES;
    }

    if (self.isAddingAttachStatus)
    {
        // 还原成文字输入模式
        [self setStyleWith:style_text];
        
        // 输入框失去焦点
        [self.txView resignFirstResponder];
    }
    else
    {
        // 输入框得到焦点
        [self.txView becomeFirstResponder];
    }
    
    // 委托改变frame
    if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_textViewHeightChanged:)])
    {
        [self.delegate ChatCommonInputViewDelegateCallBack_textViewHeightChanged:_isAddingAttachStatus];
    }
    
    self.txView.inputView = nil;
    
}

// 切换表情和文本
- (void)switchEmotionOrText
{
    // TODO: 如果处于语音模式，需要关闭语音
    if (self.btnVoiceText.tag == style_voice)
    {
        [self setStyleWith:style_text];
    }
    
    // 如果手动点击切换到键盘需要设置键盘响应
    if (self.txView.inputView == nil)
    {
        self.btnEmotionText.selected = YES;
        self.txView.inputView = self.emojiInputView;
        [self.txView reloadInputViews];
    }
    else
    {
        self.btnEmotionText.selected = NO;
        self.txView.inputView = nil;
        [self.txView reloadInputViews];
    }
    
    [self.txView becomeFirstResponder];
}

// 发送文字
- (void)sendText
{
    // 判断输入的字是否是回车，即按下return
    // 委托发送消息
    
    // 单条消息 限定最大发送字数
    if (self.txView.text.length > BIGGESTSENDWORD) {
        [self showAlertMessage:@"发送消息内容超长，请分条发送。"];
        return;
        
    }
    if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_sendAttributeText:)]) {
        [self.delegate ChatCommonInputViewDelegateCallBack_sendAttributeText:_txView.attributedText];
    }
        
    // 清理内容
    [self.txView setText:@""];
    
    [self.placeholderLb setHidden:!(!self.txView.text.length && self.isShowPlaceholderText)];

    [self resignTextView];
    
    [self.btnVoiceText setImage:[UIImage imageNamed:IMG_BTN_VOICE] forState:UIControlStateNormal];
    
    self.rowOfText = 1;
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
        [self.txView layoutIfNeeded];
    }];
    
    // 改变自身frame
    CGRect newFrame = self.frame;
    
    newFrame.size.height = 6.5 * 2 + height;
    self.frame = newFrame;
    
    // 刚进入聊天页面不需要刷新
    if (!self.isFirst || height > H_TEXTVIEW)
    {
        // 委托改变frame
        if ([self.delegate respondsToSelector:@selector(ChatCommonInputViewDelegateCallBack_textViewHeightChanged:)])
        {
            [self.delegate ChatCommonInputViewDelegateCallBack_textViewHeightChanged:NO];
        }
        self.isFirst = NO;
    }
}

#pragma mark -
#pragma mark Interface Method
/** 关闭键盘时表情模式切换到文本模式 */
- (void)switchText
{
    [self.btnEmotionText setImage:[UIImage imageNamed:IMG_BTN_EMOTION] forState:UIControlStateNormal];
    self.txView.inputView = nil;
    [self.txView reloadInputViews];
}

- (void)changePlaceHolderIsHidden:(BOOL)isHidden {
    self.isShowPlaceholderText = !isHidden;
    [self.placeholderLb setHidden:!(!self.txView.text.length && self.isShowPlaceholderText)];
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
    [self.placeholderLb setHidden:!(!self.txView.text.length && self.isShowPlaceholderText)];

    // 如果行号发生变化
//    [self newLineWithColomNumber:colomNumber];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
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

- (UILabel *)placeholderLb {
    if (!_placeholderLb) {
        _placeholderLb = [UILabel new];
        [_placeholderLb setText:@"回执消息："];
        [_placeholderLb setTextColor:[UIColor colorWithHexString:@"cccccc"]];
        [_placeholderLb setFont:[UIFont systemFontOfSize:15]];
        [_placeholderLb setHidden:YES];
    }
    return _placeholderLb;
}

- (UIButton *)btnAddAttach {
    if (!_btnAddAttach) {
        _btnAddAttach = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAddAttach setImage:[UIImage imageNamed:IMG_BTN_ADD] forState:UIControlStateNormal];
        [_btnAddAttach addTarget:self action:@selector(addAttachment) forControlEvents:UIControlEventTouchUpInside];
        [_btnAddAttach.layer setCornerRadius:W_IMG/2.0];
        [_btnAddAttach.layer setMasksToBounds:YES];
    }
    return _btnAddAttach;
   
}

- (BaseButton *)btnEmotionText {
    if (!_btnEmotionText) {
        _btnEmotionText = [BaseButton buttonWithType:UIButtonTypeCustom];
        [_btnEmotionText setContentMode:UIViewContentModeScaleToFill];
        [_btnEmotionText wz_setImage:[UIImage imageNamed:IMG_BTN_EMOTION] forState:WZControlStateNormal];
        [_btnEmotionText wz_setImage:[UIImage imageNamed:@"message_chat_text"] forState:WZControlStateSelected];
        [_btnEmotionText addTarget:self action:@selector(switchEmotionOrText) forControlEvents:UIControlEventTouchUpInside];
        [_btnEmotionText.layer setCornerRadius:W_IMG/2.0];
        [_btnEmotionText.layer setMasksToBounds:YES];
    }
    return _btnEmotionText;
}


- (BaseButton *)btnVoiceText {
    if (!_btnVoiceText) {
        _btnVoiceText = [BaseButton buttonWithType:UIButtonTypeCustom];
        [_btnVoiceText addTarget:self action:@selector(switchTextOrVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btnVoiceText wz_setImage:[UIImage imageNamed:@"message_chat_btnVoice"] forState:WZControlStateNormal];
        [_btnVoiceText wz_setImage:[UIImage imageNamed:@"message_chat_text"] forState:WZControlStateSelected];
        [_btnVoiceText setBackgroundColor:[UIColor whiteColor]];
        [_btnVoiceText.layer setCornerRadius:W_IMG/2.0];
        [_btnVoiceText.layer setMasksToBounds:YES];
    }
    return _btnVoiceText;
}


- (ChatInputTextView *)txView {
    if (!_txView) {
        NSTextStorage* textStorage = [[NSTextStorage alloc] init];
        NSLayoutManager* layoutManager = [NSLayoutManager new];
        [textStorage addLayoutManager:layoutManager];
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.frame.size.width, IOS_SCREEN_HEIGHT)];
        textContainer.widthTracksTextView = YES;
        [layoutManager addTextContainer:textContainer];
        _txView = [[ChatInputTextView alloc] initWithFrame:CGRectMake(86.5, 6.5, W_TEXTVIEW, H_TEXTVIEW) textContainer:textContainer];
        [_txView setFont:[UIFont systemFontOfSize:15]];
        [_txView setTextColor:[UIColor blackColor]];
        // 输入法设置
        [_txView setReturnKeyType:UIReturnKeySend];
        
        _txView.linkTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                       NSForegroundColorAttributeName:[UIColor blackColor]};
        
        [_txView setDelegate:self];
        [_txView.layer setCornerRadius:3.0];
        [_txView.layer setBorderWidth:0.5];
        [_txView setBackgroundColor:[UIColor whiteColor]];
        [_txView.layer setBorderColor:[[UIColor borderColor] CGColor]];
        [_txView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        _txView.scrollsToTop = NO;

    }
    return _txView;
}

- (MsgEmojiInputView *)emojiInputView {
    if (!_emojiInputView) {
        _emojiInputView = [[MsgEmojiInputView alloc] initWithFrame:CGRectMake(0, 0, IOS_SCREEN_WIDTH, 216)];
        _emojiInputView.delegateKeyInput = self.txView;
        _emojiInputView.delegateMsgSend = self;
    }
    return _emojiInputView;
}

- (UIButton *)btnRecordVoice {
    if (!_btnRecordVoice) {
        _btnRecordVoice = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRecordVoice setTitle:@"语音" forState:UIControlStateNormal];
        [_btnRecordVoice.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnRecordVoice setTitleColor:[UIColor mediumFontColor] forState:UIControlStateNormal];
        [_btnRecordVoice setBackgroundImage:[UIImage at_imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
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
    }
    return _btnRecordVoice;
}

@end
