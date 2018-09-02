//
//  BaseSelectTableViewCell.h
//  launcher
//
//  Created by williamzhang on 16/3/31.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  自带选择功能的Cell

#import <UIKit/UIKit.h>

@interface BaseSelectTableViewCell : UITableViewCell

@property (nonatomic, readonly, strong) UIView *wz_contentView;

@property (nonatomic, assign) BOOL wz_selected;

/// 左边选择框的位置 default:(0, 12, 0, 0)
@property (nonatomic, assign) UIEdgeInsets wz_leftSelectButtonInsets;

@end
