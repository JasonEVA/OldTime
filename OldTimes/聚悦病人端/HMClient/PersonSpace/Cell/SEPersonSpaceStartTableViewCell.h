//
//  SEPersonSpaceStartTableViewCell.h
//  HMClient
//
//  Created by yinquan on 2017/7/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEPersonSpaceStartTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView* iconImageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* hotImageView;

- (void) showHotIcon:(BOOL) show;
- (void) showOpened:(BOOL) opened;
@end
