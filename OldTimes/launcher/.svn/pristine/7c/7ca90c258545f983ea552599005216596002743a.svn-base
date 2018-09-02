//
//  ChatCommonInputView.h
//  Titans
//
//  Created by Remon Lv on 14-9-15.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  聊天窗口文字、音频输入框

#import <UIKit/UIKit.h>
#import "MsgEmojiInputView.h"
#import "ChatInputTextView.h"

@class BaseButton;

@class ContactPersonDetailInformationModel;

typedef enum
{
    style_text = 0,
    style_voice
} ChatInput_Style;

@protocol ChatCommonInputViewDelegate <NSObject>

@optional
// 开始或者结束添加附件事件
- (void)ChatCommonInputViewDelegateCallBack_IsAddAttachment:(BOOL)mark;

/** 返回富文本 */
- (void)ChatCommonInputViewDelegateCallBack_sendAttributeText:(NSAttributedString *)attributeText;

// 文本换行的委托回调(增加的高度)  默认带附件高度
- (void)ChatCommonInputViewDelegateCallBack_textViewHeightChanged:(BOOL)isDefaut;

/** 键入@值，选择成员 */
- (void)ChatCommonInputViewDelegateCallBack_atUser;

@required
// 录音按钮的事件委托
- (void)ChatCommonInputViewDelegateCallBack_recordVoiceWithEvents:(UIControlEvents)controlEvents;

@end

@interface ChatCommonInputView : UIView <UITextViewDelegate, MsgEmojiInputViewDelegate>
{
    BaseButton *_btnVoiceText;            // 文字音频切换按钮
    UIButton *_btnAddAttach;            // 添加附件按钮
    BaseButton *_btnEmotionText;          // 添加表情
    UIButton *_btnRecordVoice;          // 声音记录按钮
    
    BOOL _isAddingAttachStatus;         // 增加附件ing标记
    NSInteger _rowOfText;               // 文本输入框行数变化标记
    
    BOOL _showAttach;                            // 是否显示附件
    
    MsgEmojiInputView *_emojiInputView;  // Emoji 输入键盘
}

@property (nonatomic,weak) id <ChatCommonInputViewDelegate> delegate;
@property (nonatomic,strong) ChatInputTextView *_txView;                // 文字输入框

// 使得输入框失去焦点,收起键盘
- (void)packupKeyborad;

// 键盘弹出
- (void)popupKeyboard;

/** 添加@User */
- (void)addAtUser:(ContactPersonDetailInformationModel *)atUser;
/**
 *  添加@User
 *
 *  @param atUser        成员信息
 *  @param deleteFrontAt 是否删除残余的@
 */
- (void)addAtUser:(ContactPersonDetailInformationModel *)atUser deleteFrontAt:(BOOL)deleteFrontAt;
@end
