//
//  MeChangeInfoCell.h
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  个人信息修改CELL

#import "BaseInputTableViewCell.h"
#import "MeChangeNameViewController.h"
#import "MyToolBar.h"
#import "MeGetUserInfoModel.h"

@interface MeChangeInfoCell : BaseInputTableViewCell<UIPickerViewDataSource,UIPickerViewDelegate,MyToolBarDelegate>
@property (nonatomic, strong) UIPickerView *sexPickView;
@property (nonatomic, strong) UIPickerView *locationPickView;
@property (nonatomic, strong) UIPickerView *birthdayPickView;
@property (nonatomic, strong) MyToolBar *toolBar;

@property (nonatomic, copy) NSArray *sexArr;     //性别数据源
@property (nonatomic) NSInteger yearMax;         //可选年龄最大值
@property (nonatomic) NSInteger yearMin;         //可选年龄最小值
@property (nonatomic) NSInteger year;            //当前年份
@property (nonatomic) NSInteger month;           //当前月份
@property (nonatomic) NSMutableDictionary *locationDict;  //所在地数据源
@property (nonatomic, copy) NSArray *provinceArray;//省份的数组
@property (nonatomic, copy) NSArray *cityArray; //城市的数组，在接下来的代码中会有根据省份的选择进行数据更新的操作

@property (nonatomic) keyboardType keyboardType;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, strong) MeGetUserInfoModel *model;

- (void)updatePickerView:(MeGetUserInfoModel *)model;
@end
