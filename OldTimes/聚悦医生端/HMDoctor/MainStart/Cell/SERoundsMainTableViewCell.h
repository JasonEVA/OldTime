//
//  SERoundsMainTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第二版查房cell

#import <UIKit/UIKit.h>
@class RoundsMessionModel;
@interface SERoundsMainTableViewCell : UITableViewCell
- (void)fillDateWithModel:(RoundsMessionModel *)model isShowStatusLb:(BOOL)isShowStatusLb;
@end
