//
//  BodyDetectUniversalPickerView.m
//  HMClient
//
//  Created by Dee on 16/10/8.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyDetectUniversalPickerView.h"
@interface BodyDetectUniversalPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>



@property(nonatomic, strong) UIView   *contentView;                     //所有控件容器

@property(nonatomic, strong) UIPickerView  *pickerview;                 //选择控件

@property(nonatomic, strong) NSArray  *dataArray;                       //数据数组

@property(nonatomic, copy) dataCallBackBlock  myblock;                  //回调

@property(nonatomic, copy)  BodyDetectUniversalPickerSelectPicker selectBlock;                  //回调

@property(nonatomic, strong) NSMutableArray  *selectedDataArray;        //存放默认值

@property(nonatomic, assign) BOOL  isSportData;                         //是否是运动

@property(nonatomic, assign) BOOL  isBoodSugure;                        //是否是血糖

@property(nonatomic, assign) kPickerType  currentType;                  //当前的选择类型

@property(nonatomic, strong) UILabel  *shrikLabel;                      //收缩压

@property(nonatomic, strong) UILabel  *diastolicLabel;                  //舒张压

@end

@implementation BodyDetectUniversalPickerView


- (instancetype)initWithDataArray:(NSArray *)dataArray detaultArray:(nullable NSArray *)array dataCallBackBlock:(dataCallBackBlock)block
{
    if(self = [super init]) {
        self.pickerview = [[UIPickerView alloc] init];
        self.pickerview.dataSource = self;
        self.pickerview.delegate = self;
        self.pickerview.backgroundColor = [UIColor commonPickViewBackGroundColor];
        [self createFrame];
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        self.selectedDataArray = [NSMutableArray arrayWithArray:array];
        self.myblock = block;
        //产品要求点击后就直接显示默认数据
        if (self.myblock) {
            self.myblock(self.selectedDataArray);
        }
    }
    return self;
}

- (instancetype)initWithDataArray:(NSArray *)dataArray detaultArray:(nullable NSArray *)array  selectBlock:(BodyDetectUniversalPickerSelectPicker)block
{
    if(self = [super init]) {
        self.pickerview = [[UIPickerView alloc] init];
        self.pickerview.dataSource = self;
        self.pickerview.delegate = self;
        self.pickerview.backgroundColor = [UIColor commonPickViewBackGroundColor];
        [self createFrame];
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        self.selectedDataArray = [NSMutableArray arrayWithArray:array];
        self.selectBlock = block;
        //产品要求点击后就直接显示默认数据
        if (self.myblock) {
            self.myblock(self.selectedDataArray);
        }
    }
    return self;
}

- (instancetype)initWithDataArray:(NSArray *)dataArray detaultArray:(NSArray *)array pickerType:(kPickerType)type dataCallBackBlock:(dataCallBackBlock)block {
    self.currentType = type;
    return [self initWithDataArray:dataArray detaultArray:array dataCallBackBlock:block];
}

- (instancetype)initWithDataArray:(NSArray *)dataArray detaultArray:(NSArray *)array pickerType:(kPickerType)type selectBlock:(BodyDetectUniversalPickerSelectPicker)block
{
    self.currentType = type;
    return [self initWithDataArray:dataArray detaultArray:array selectBlock:block];
}

#pragma mark - UIPickerViewDelegtate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataArray[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.currentType) {
//        case k_PickerType_SportMode:
//        {
//            RecommandSportsType *type = self.dataArray[component][row];
//            return type.sportsName;
//        }
//            break;
        case k_PickerType_BloodSugar:
        {
            NSDictionary *dict = self.dataArray[component][row];
            return [dict valueForKey:@"name"];
        }
            break;
        default:
        {
             return self.dataArray[component][row];
        }
            break;
    }
   
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UILabel *lb = [pickerView viewForRow:row forComponent:component];
    lb.textColor = [UIColor mainThemeColor];
    [self.selectedDataArray replaceObjectAtIndex:component withObject:self.dataArray[component][row]];
    if (self.myblock) {
        self.myblock(self.selectedDataArray);
    }
    if (self.selectBlock) {
        self.selectBlock(row, component);
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lb = [UILabel new];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:40];
    lb.textAlignment = NSTextAlignmentCenter;
    NSString *name;
    switch (self.currentType) {
//        case k_PickerType_SportMode:
//        {
//            RecommandSportsType *type = self.dataArray[component][row];
//            name = type.sportsName;
//        }
            break;
        case k_PickerType_BloodSugar:
        {
            NSDictionary *dict = self.dataArray[component][row];
            name = [dict valueForKey:@"name"];
        }
            break;
        default:
        {
            name = self.dataArray[component][row];
        }
            break;
    }
    lb.text = name;
    return lb;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 55;
}

#pragma maark - privateMethod

- (void)setupData {
    if (self.currentType == k_PickerType_BloodPressure) {
        if ([[self.dataArray firstObject] containsObject:[self.selectedDataArray  firstObject]] && [[self.dataArray lastObject] containsObject:[self.selectedDataArray lastObject]]) {
            NSInteger highIndex = [[self.dataArray firstObject] indexOfObject:[self.selectedDataArray firstObject]];
            NSInteger lowIndex = [[self.dataArray lastObject] indexOfObject:[self.selectedDataArray lastObject]];
            [self.pickerview selectRow:highIndex inComponent:0 animated:NO];
            UILabel *lb = [self.pickerview viewForRow:highIndex forComponent:0];
            lb.textColor = [UIColor mainThemeColor];
            [self.pickerview selectRow:lowIndex inComponent:1 animated:NO];
            UILabel *lb1 = [self.pickerview viewForRow:lowIndex forComponent:1];
            lb1.textColor = [UIColor mainThemeColor];
        }
    }else
    {
        for (int i = 0; i< self.dataArray.count; i++) {
            if ([self.dataArray[i] containsObject:self.selectedDataArray[i]]) {
                NSInteger index = [self.dataArray[i] indexOfObject:self.selectedDataArray[i]];
                [self.pickerview selectRow:index inComponent:i animated:NO];
                UILabel *lb = [self.pickerview viewForRow:index forComponent:i];
                lb.textColor = [UIColor mainThemeColor];
            }
        }
    }
}

- (void)createFrame {
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    if (self.currentType == k_PickerType_BloodPressure) {
        [self.contentView addSubview:self.shrikLabel];
        [self.shrikLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.width.equalTo(self).dividedBy(2);
            make.height.equalTo(@(30));
        }];
        [self.contentView addSubview:self.diastolicLabel];
        [self.diastolicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.shrikLabel.mas_right);
            make.right.equalTo(self.contentView);
            make.height.equalTo(self.shrikLabel);
        }];
        [self.contentView addSubview:self.pickerview];
        [self.pickerview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.shrikLabel.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }else {
        [self.contentView addSubview:self.pickerview];
        [self.pickerview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    [self setNeedsLayout];
    [self updateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    self.contentView.alpha = 0;
    [UIView animateWithDuration:0.0 animations:^{
        self.contentView.alpha = 1;
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.top.equalTo(self);
        }];
    } completion:^(BOOL finished) {
        [self.pickerview reloadAllComponents];
        [self setupData];
    }];
}


#pragma mark - setterAndGetter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor commonPickViewBackGroundColor];
    }
    return _contentView;
}

- (UILabel *)shrikLabel {
    if (!_shrikLabel) {
        _shrikLabel = [[UILabel alloc] init];
        _shrikLabel.text = @"收缩压";
        _shrikLabel.textAlignment = NSTextAlignmentCenter;
        _shrikLabel.backgroundColor = [UIColor commonPickViewBackGroundColor];
    }
    return _shrikLabel;
}

- (UILabel *)diastolicLabel {
    if (!_diastolicLabel) {
        _diastolicLabel = [[UILabel alloc] init];
        _diastolicLabel.text = @"舒张压";
        _diastolicLabel.textAlignment = NSTextAlignmentCenter;
        _diastolicLabel.backgroundColor = [UIColor commonPickViewBackGroundColor];
    }
    return _diastolicLabel;
}

@end
