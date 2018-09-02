//
//  ApplyTextViewTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  详细cell

#import <UIKit/UIKit.h>
@class NewApplyFormBaseModel;
@interface ApplyTextViewTableViewCell : UITableViewCell

+ (NSString *)identifier;

@property (nonatomic, weak) id<UITextViewDelegate> delegate;

- (void)setTextWithModelStr:(NSString *)str;
- (void)setDataWithModel:(NewApplyFormBaseModel *)model;
@end
