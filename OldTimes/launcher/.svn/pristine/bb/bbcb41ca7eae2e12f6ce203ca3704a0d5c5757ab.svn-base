//
//  LiftTextFieldTableViewCell.h
//  launcher
//
//  Created by TabLiu on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiftTextFieldTableViewCellDelegate <NSObject>

- (void)textField_ShouldBeginEditing;
- (void)textField_ShouldEndEditingWithText:(NSString *)text;

@end

@interface LiftTextFieldTableViewCell : UITableViewCell

- (void)showKeyboard;
- (void)setIconImg:(NSString *)str;
@property (nonatomic,weak) id <LiftTextFieldTableViewCellDelegate> delegate;

@end
