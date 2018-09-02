//
//  ChatInputView.h
//  Titans
//
//  Created by Remon Lv on 14-9-16.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  聊天窗口底部整体输入栏

#import <UIKit/UIKit.h>
#import "ChatAttachPickView.h"
#import "ChatCommonInputView.h"

#define H_COMMON_VIEW  50           // 语音文字输入栏高度
#define H_ATTACH_VIEW  110          // 附件输入栏高度

@class ContactPersonDetailInformationModel;

@protocol ChatInputViewDelegate <NSObject>

@optional
// 开始或者结束添加附件事件
- (void)ChatInputViewDelegateCallBack_IsAddAttachment:(BOOL)mark;

/// Return键发送文本 (使用_sendAttributeText不走该方法)
- (void)ChatInputViewDelegateCallBack_sendText:(NSString *)text;

/** 返回富文本(使用该方法_sendText无效) */
- (void)ChatInputViewDelegateCallBack_sendAttributeText:(NSAttributedString *)attributeText;

// 附件栏选择的委托回调
- (void)ChatInputViewDelegateCallBack_attchmentSelectedWithTag:(ChatAttachPick_tag)tag;

// frame变化的委托
- (void)ChatInputViewDelegateCallBack_frameChangedWithIncreasedHeight:(CGFloat)increased;

/** @人员 */
- (void)ChatInputViewDelegateCallBack_atUser;

// 录音按钮事件的委托回调
- (void)ChatInputViewDelegateCallBack_recordVoiceWithEvents:(UIControlEvents)controlEvents;

@end

@interface ChatInputView : UIView <ChatAttachPickViewDelegate,ChatCommonInputViewDelegate>
{
    ChatAttachPickView  *_viewAttach;           // 附件输入栏
}

@property (nonatomic,weak) id <ChatInputViewDelegate> delegate;

@property (nonatomic,strong) ChatCommonInputView *_viewCommon;    // 文字语音输入栏

/// 文本框中文字
@property (nonatomic, strong) NSAttributedString *inputAttributeString;
/// 键盘持有者 override
- (BOOL)isFirstResponder;

/// 使得输入框失去焦点,收起键盘
- (void)packupKeyborad;

/// 键盘弹起
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
