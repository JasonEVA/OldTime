//
//  TextViewTableViewCell.h
//  launcher
//
//  Created by TabLiu on 16/3/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  有Placeholder 功能的textViewCell

#import <UIKit/UIKit.h>


@protocol TextViewTableViewCellDelegate<NSObject>

- (void)cellEndEditingWithStr:(NSString *)string;

@end

@interface TextViewTableViewCell : UITableViewCell

@property (nonatomic,strong) UITextView * textView;

@property (nonatomic,assign) id<TextViewTableViewCellDelegate> delegate;

- (void)setPlaceholder:(NSString *)placeholder;

@end
