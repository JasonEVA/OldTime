//
//  ContactSelectButton.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//  带选择图标的按钮

#import <UIKit/UIKit.h>

@class ContactSelectButton;

@protocol ContactSelectButtonDelegate <NSObject>

- (void)contactSelectButtonDelegateCallBack_selectedStateChangedWithView:(ContactSelectButton *)buttonView selected:(BOOL)selected;

@end
@interface ContactSelectButton : UIView
@property (nonatomic, weak)  id<ContactSelectButtonDelegate>  delegate; // <##>
@property (nonatomic, strong)  UIButton  *button; // <##>
@property (nonatomic)  BOOL  selectable; // 是否为可选状态
@property (nonatomic)  BOOL  selected; // <##>
@property (nonatomic) BOOL isShowTopLine; //是否显示顶部的线
- (instancetype)initWithEdit:(BOOL)edit isShowTopLine:(BOOL)isShowTopLine;
@end
