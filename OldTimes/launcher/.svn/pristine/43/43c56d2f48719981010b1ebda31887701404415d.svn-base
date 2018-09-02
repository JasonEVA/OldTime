//
//  CalendarTextViewTableViewCell.h
//  launcher
//
//  Created by William Zhang on 15/7/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  📅新建 详细TextView Cell

#import <UIKit/UIKit.h>
#import "RichTextConfigure.h"

@protocol CalendarTextViewTableViewCellClickDelegate <NSObject>
- (void)calendarTextViewTableViewCellDidClickSpecialText:(NSString *)text textType:(RichTextType)textType;

@end

@interface CalendarTextViewTableViewCell : UITableViewCell

+ (NSString *)identifier;

@property (nonatomic, weak) id<UITextViewDelegate> delegate;
@property (nonatomic, weak) id<CalendarTextViewTableViewCellClickDelegate> clickDelegate;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, readonly) NSString *cellText;

- (void)setContent:(NSString *)content;
- (void)textViewEditable:(BOOL)Editable;
+ (CGFloat)cellForRowHeightWithText:(NSString *)text;
@end
