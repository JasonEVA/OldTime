//
//  NewApplyAddApplyTitleTableViewCell.h
//  launcher
//
//  Created by conanma on 16/1/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewApplyAddApplyTitleTableViewCell;
@class NewApplyFormBaseModel;
@protocol NewApplyAddApplyTitleTableViewCellDelegate<NSObject>
- (void)textviewchanged:(UITextView *)textview;
- (void)textViewCell:(NewApplyAddApplyTitleTableViewCell *)cell didChangeText:(NSString *)text needreload:(BOOL)need;
@end

@interface NewApplyAddApplyTitleTableViewCell : UITableViewCell
@property (nonatomic, weak) id<NewApplyAddApplyTitleTableViewCellDelegate>delegate;
@property (nonatomic, strong) UITextView *tvwTitle;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, readonly) NSString *cellText;
@property (nonatomic) CGFloat cellheight;
+ (NSString *)identifier;
- (void)setContent:(NSString *)content;
- (CGFloat)getHeight;

- (void)setDataWithModel:(NewApplyFormBaseModel *)model;

@end
