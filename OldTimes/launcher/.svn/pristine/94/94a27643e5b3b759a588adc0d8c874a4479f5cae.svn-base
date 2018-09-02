//
//  NewApplyExpendTxtFieldV2TableViewCell.h
//  launcher
//
//  Created by Dee on 16/8/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  金额输入框 Form_inputType_textInput

#import <UIKit/UIKit.h>

typedef void(^textChangeCallBackBlcok)(NSString *text);
typedef void(^textFieldLocationBlock)(CGRect currentRect);
@class NewApplyFormBaseModel;

@interface NewApplyExpendTxtFieldV2TableViewCell : UITableViewCell


@property(nonatomic, strong) UITextField  *expendField;

//获取当前输入的文本
- (void)getTextWithBlock:(textChangeCallBackBlcok)block;

//isAcountType 用于判断是否是金额输入框，并对应进行格式化处理
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isAccountType:(BOOL)isAccountType;

- (void)setDataWithModel:(NewApplyFormBaseModel *)model;

- (void)getLocationWithBlock:(textFieldLocationBlock)block;


+ (NSString *)identifier;

@end
