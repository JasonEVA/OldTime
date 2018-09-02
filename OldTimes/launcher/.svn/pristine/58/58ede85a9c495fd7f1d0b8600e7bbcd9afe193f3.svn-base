//
//  ChatBaseViewController.h
//  launcher
//
//  Created by williamzhang on 15/12/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  聊天基础VC

#import "BaseViewController.h"
#import "IMApplicationEnum.h"
#import "ChattingModule.h"
#import "ChatInputView.h"
#import "WZPhotoPickerController.h"
#import "RMAudioManager.h"
#import <MintcodeIM/MintcodeIM.h>

extern NSString *const wz_default_tableViewCell_identifier;

@interface ChatBaseViewController : BaseViewController <ChatInputViewDelegate, WZPhotoPickerControllerDelegate, RMAudioManagerDelegate , UIImagePickerControllerDelegate>

/// 聊天消息管理模块
@property (nonatomic, readonly) ChattingModule *module;

/** 用户Uid */
@property (nonatomic, readonly) NSString *strUid;
/** 联系人姓名 */
@property (nonatomic, readonly) NSString *strName;
/** 联系人路径 */
@property (nonatomic, readonly) NSString *avatarPath;

/// inputView高度
@property (nonatomic, assign) CGFloat viewInputHeight;
/// 键盘上弹高度
@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, assign) BOOL ifScrollBottom;
@property (nonatomic, assign) long long currentPlayingVoiceMsgId;

// cell高度集合
@property (nonatomic, strong) NSMutableDictionary *cellHeightCache;

/// 聊天输入框
@property (nonatomic, readonly) ChatInputView *chatInputView;

//是否隐藏输入框
@property(nonatomic, assign) BOOL  isHideInputView;

@property (nonatomic, readonly) UITableView *tableView;

/**
 *  存放上传图片进度的字典（_nativeOriginalUrl, 70%）
 */
@property (nonatomic, readonly) NSDictionary *uploadImageDictionary;

@property (nonatomic, strong)  RMAudioManager  *audioManager; // 录音manager
/// 显示信息数组
@property (nonatomic, readonly) NSArray <MessageBaseModel *>*showingMessages;

- (instancetype)initWithDetailModel:(ContactDetailModel *)detailModel;

/**
 *  打开多选编辑模式
 *
 *  @param indexPath 第一个选择的IndexPath
 */
- (void)startEditingWithFirstIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 子类实现方法
- (void)voicePlayOrStopWithVoicePath:(NSString *)voicePath playVoiceMsgId:(long long)voiceMsgId;

- (UITableViewCell *)tableViewCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath;

@end
