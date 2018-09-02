//
//  ApplyCCSendTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/13.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  发件箱cell

#import <UIKit/UIKit.h>
#import "ApplyGetSendListModel.h"
#import "ApplyGetReceiveListModel.h"

@interface ApplySendTableViewCell : UITableViewCell


- (void)setTagHide;
- (void)setCellWithModel:(ApplyGetSendListModel *)model;
- (void)OnlyUsedInSearch_setCellWithModel:(ApplyGetReceiveListModel *)model;
- (void)setCCCellWithModel:(ApplyGetReceiveListModel *)model;
@end
