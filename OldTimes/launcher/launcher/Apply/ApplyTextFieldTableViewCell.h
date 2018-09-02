//
//  ApplyTextFieldTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  标题cell

#import <UIKit/UIKit.h>

@interface ApplyTextFieldTableViewCell : UITableViewCell

@property(nonatomic, weak) id<UITextFieldDelegate> delegate;

+ (NSString *)identifier;

- (void)setDelegate:(id<UITextFieldDelegate>)delegate;

- (void)setTitle:(NSString *)title;

- (void)settextfieldPlaceHolder:(NSString *)string;

- (void)textEndEdting:(void (^)(NSString *text))textBlock;

@end
