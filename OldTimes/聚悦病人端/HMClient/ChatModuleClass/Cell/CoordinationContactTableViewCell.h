//
//  CoordinationContactTableViewCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//  协同联系人cell

#import <UIKit/UIKit.h>
#import "ContactInfoModel.h"
@interface CoordinationContactTableViewCell : UITableViewCell
@property (nonatomic, strong)  UILabel  *title; // <##>
@property (nonatomic)  BOOL  selectable; // 是否为选择状态

- (void)selectCellWithModel:(ContactInfoModel *)model;

- (void)configCellData:(id)model selectable:(BOOL)selectable;
@end
