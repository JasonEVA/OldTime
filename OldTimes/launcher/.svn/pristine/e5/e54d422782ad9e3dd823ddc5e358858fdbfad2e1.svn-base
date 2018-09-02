//
//  ChatApplicationBaseViewController.h
//  launcher
//
//  Created by williamzhang on 16/5/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  聊天应用基类

#import "BaseViewController.h"
#import <MintcodeIM/MintcodeIM.h>
#import "ImApplicationConfigure.h"

@interface ChatApplicationBaseViewController : BaseViewController

@property (nonatomic, readonly) UITableView *tableView;


@property (nonatomic, readonly) NSArray *arrayDisplay;

#pragma mark - 子类继承方法
- (NSString *)applicationUid;

- (NSString *)buttonTitle;
- (UIImage *)buttonImage;
- (UIImage *)buttonHighlightedImage;

- (void)clickedButton;

- (CGFloat)heightForMessageModel:(MessageBaseModel *)model;
- (UITableViewCell *)cellForMessageModel:(MessageBaseModel *)model withRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)didSelectCellForMessageModel:(MessageBaseModel *)model;
//- (void)getIndepath
#pragma mark - 子类使用方法
/// 时间cell已经注册过
- (void)tableViewRegisterClass:(Class)registerClass forCellReuseIdentifier:(NSString *)reuserIdentifier;

@end
