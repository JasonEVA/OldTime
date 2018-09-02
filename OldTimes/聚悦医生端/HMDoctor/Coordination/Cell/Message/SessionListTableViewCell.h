//
//  SessionListTableViewCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//  消息列表cell
#import <MintcodeIMKit/MintcodeIMKit.h>

#import <UIKit/UIKit.h>
@class SessionListModel;

@interface SessionListTableViewCell : UITableViewCell

// 设置数据
- (void)configCellData:(ContactDetailModel *)model;

@end
