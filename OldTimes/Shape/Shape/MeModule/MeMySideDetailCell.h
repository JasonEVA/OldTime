//
//  MeMtSideDetailCell.h
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  我的体测Cell

#import "BaseInputTableViewCell.h"
#import "MyToolBar.h"

@interface MeMySideDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *unitLb;
@property (nonatomic, strong) UIDatePicker *birthdayPickView;
@property (nonatomic, strong) MyToolBar *toolBar;
@property (nonatomic,strong) UITextField *txtFd;
- (instancetype)initWithUnit:(NSString *)unit reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setDateInputView;
@end
