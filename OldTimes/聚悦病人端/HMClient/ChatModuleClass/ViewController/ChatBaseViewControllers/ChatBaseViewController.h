//
//  ChatBaseViewController.h
//  launcher
//
//  Created by williamzhang on 15/12/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  聊天基础VC

#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ChattingModule.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ChatTableViewAdapter.h"
#import "ChatInputView.h"
#import "RMAudioManager.h"
#import <MWPhotoBrowser-ADS/MWPhotoBrowser.h>
#import "HMBaseViewController.h"
#import "ChatBaseTableViewCell.h"
#import "LinkLabel.h"

@interface ChatBaseViewController : HMBaseViewController <ChatTableViewAdapterDelegate>

/// 聊天消息管理模块
@property (nonatomic, strong, readonly) ChattingModule *module;

/** 用户Uid */
@property (nonatomic, copy) NSString *strUid;
/** 联系人姓名 */
@property (nonatomic, copy) NSString *strName;
/** 联系人路径 */
@property (nonatomic, copy) NSString *avatarPath;

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

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, copy, readonly)  NSArray *arrayDisplay; // 显示的数据

// 图片浏览
@property (nonatomic, strong)  MWPhotoBrowser  *photoBrowser; // 图片浏览器
@property (nonatomic, strong)  NSMutableArray  *arrayPhotos; // 大图
@property (nonatomic, strong)  NSMutableArray  *arrayThumbs; // 小图
@property (nonatomic)  NSInteger saveIndex; // 要保存的图片index

/**
 *  存放上传图片进度的字典（_nativeOriginalUrl, 70%）
 */
//@property (nonatomic, readonly) NSDictionary *uploadImageDictionary;

@property (nonatomic, strong)  RMAudioManager  *audioManager; // 录音manager

@property (nonatomic, strong, readonly)  ChatTableViewAdapter  *adapter; // <##>
@property (nonatomic, assign, readonly)  BOOL  hideSenderName; // 是否隐藏发送者名字
@property (nonatomic, assign, readonly)  BOOL  groupChat; // 是否为群聊

- (instancetype)initWithDetailModel:(ContactDetailModel *)detailModel;

// 配置是否显示发送者名字
- (void)configCellSenderNameHide:(BOOL)hide;

- (void)initModule;

// 刷新联系人信息（重新配置Adapter）
- (void)refreshTargetInfo;

// 更新界面
- (void)refreshView;
@end
