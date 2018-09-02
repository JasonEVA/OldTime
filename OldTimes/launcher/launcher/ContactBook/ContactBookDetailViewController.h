//
//  ContactBookDetailViewController.h
//  launcher
//
//  Created by williamzhang on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  新版通讯录详情界面

#import "BaseViewController.h"

typedef void(^backBlock)(void);

@class ContactPersonDetailInformationModel;

@interface ContactBookDetailViewController : BaseViewController

/** 初始化用户 */
- (instancetype)initWithUserModel:(ContactPersonDetailInformationModel *)model;

/** 使用showId初始化  IM中的userName */
- (instancetype)initWithUserShowId:(NSString *)showId;

- (void)notifyStartChat:(void(^)())startChatBlock;
- (void)setbackblock:(backBlock)block;
@property (nonatomic,copy)void (^getStrName)(NSString *str);

@end
