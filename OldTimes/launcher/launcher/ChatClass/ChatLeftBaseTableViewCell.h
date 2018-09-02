//
//  ChatLeftBaseTableViewController.h
//  launcher
//
//  Created by Lars Chen on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatBaseTableViewCell.h"
#import <MintcodeIM/MintcodeIM.h>

@interface ChatLeftBaseTableViewCell : ChatBaseTableViewCell

@property (nonatomic, strong) UILabel *lbTime;                      // 时间

- (void)setData:(MessageBaseModel *)model;

// 设置姓名
- (void)setRealName:(NSString *)name hidden:(BOOL)hidden;

// 设置头像
- (void)setHeadIconWithUid:(NSString *)uid;

//设置重点标志(是否展示)
- (void)setEmphasisIsShow:(BOOL)IsShow;

@end
