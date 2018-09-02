//
//  BaseInputTableViewCell.h
//  PalmDoctorPT
//
//  Created by Andrew Shen on 15/4/11.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  带输入框的cell

#import <UIKit/UIKit.h>

@protocol InputCellDelegate <NSObject>

@optional
// 结束输入回调
- (void)InputCellDelegateCallBack_endEditWithTag:(NSInteger)tag;
- (void)InputCellDelegateCallBack_endEditWithIndexPath:(NSIndexPath *)indexPath;

// 开始输入回调
- (void)InputCellDelegateCallBack_startEditWithTag:(NSInteger)tag;
- (void)InputCellDelegateCallBack_startEditWithIndexPath:(NSIndexPath*)indexPath;



@end


@interface BaseInputTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *txtFd;

@property(nonatomic) BOOL isNumber;//是否能输入纯数字

@property(nonatomic) float numberMax;//输入数字最大值
@property(nonatomic) float numberMin;//输入数字最小值

@property (nonatomic,assign) BOOL isPhone;

@property(nonatomic,retain) NSIndexPath *indexPath;

@property (nonatomic, weak)  id <InputCellDelegate>  delegate; // 委托

- (void)setTextFieldText:(NSString *)text editing:(BOOL)isEditing;
- (void)setTextFieldISPhone:(BOOL)isPhone;

@end
