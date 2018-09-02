//
//  ApplyDeadlineTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  承认期限cell

#import <UIKit/UIKit.h>

@interface ApplyDeadlineTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel  *deadlineLbl;

+(NSString*)identifier;
- (void)setDataWithArr:(NSArray *)array;

@end
