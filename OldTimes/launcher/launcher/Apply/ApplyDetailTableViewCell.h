//
//  ApplyDetailTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  右侧带有lbl的cell，比如承认者，cc，期间

#import <UIKit/UIKit.h>

@interface ApplyDetailTableViewCell : UITableViewCell

+ (NSString *)identifier;

@property(nonatomic, strong) UILabel  *applyDetailLbl;

@end
