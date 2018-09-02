//
//  PatientFilterTypeView.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientFilterTypeView.h"
#import "DateUtil.h"
#define LINECOUNT    3
@interface PatientFilterTypeView ()
@property (nonatomic, strong)  UIButton  *selectedButton; // <##>
@property (nonatomic, strong)  NSMutableArray<UIButton *>  *arrayButtons; // <##>
@property (nonatomic, strong)  UIButton  *lastBtn; // <##>

@property (nonatomic, copy)  PatientFilterTagClickedHandler  tagClickedHandler; // <##>
@property (nonatomic, copy)  PatientFilterTimeRangeButtonClickedHandler  timeRangeClickedHandler; // <##>
@property (nonatomic, strong)  NSMutableArray<UIButton *>  *timeRangeButtons; // 时间区间按钮数组
@property (nonatomic, copy)  NSArray  *timeRangeTitles; // <##>

@property (nonatomic, assign)  BOOL  showAllPatientTag; // <##>

@end

@implementation PatientFilterTypeView

- (instancetype)initWithPatientFilterViewType:(PatientFilterViewType)type
{
    self = [super init];
    if (self) {
        _showAllPatientTag = type == PatientFilterViewTypeAll ? YES : NO;
        self.backgroundColor = [UIColor whiteColor];
        [self p_configElements];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithPatientFilterViewType:PatientFilterViewTypeAll];
    return self;
}

- (void)addNotiForPatientTag:(PatientFilterTagClickedHandler)block {
    self.tagClickedHandler = block;
}
- (void)addNotiForTimeRangeButton:(PatientFilterTimeRangeButtonClickedHandler)timeRangeBlock {
    self.timeRangeClickedHandler = timeRangeBlock;
}

- (void)resetPatientTag:(PatientFilterTag)tag {
    self.selectedButton.selected = NO;
    self.selectedButton.layer.borderColor = [UIColor commonControlBorderColor].CGColor;

    if (tag != PatientFilterTagNone) {
        if (self.showAllPatientTag) {
            [self patientTagClicked:self.arrayButtons[tag]];
        }
        else {
            self.selectedButton.selected = YES;
        }
    }
    
}

- (void)resetTimeRange {
    __weak typeof(self) weakSelf = self;
    [self.timeRangeButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [obj setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
        [obj setTitle:strongSelf.timeRangeTitles[idx] forState:UIControlStateNormal];
    }];
}

- (void)configTimeRangeTime:(NSDate *)date index:(NSInteger)index {
    if (self.timeRangeButtons.count - 1 < index) {
        return;
    }
    UIButton *btn = self.timeRangeButtons[index];
    if (!date) {
        [btn setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
        [btn setTitle:self.timeRangeTitles[index] forState:UIControlStateNormal];
        return;
    }
    [btn setTitleColor:[UIColor commonBlackTextColor_333333] forState:UIControlStateNormal];
    [btn setTitle:[DateUtil stringDateFormatedDate:date] forState:UIControlStateNormal];
}

- (void)patientTagClicked:(UIButton *)sender {
    if (!self.selectedButton.selected) {
        sender.selected = YES;
        sender.layer.borderColor = [UIColor mainThemeColor].CGColor;
        self.selectedButton = sender;
    }
    else {
        if (self.selectedButton.tag != sender.tag) {
            self.selectedButton.selected = NO;
            self.selectedButton.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
            sender.selected = YES;
            sender.layer.borderColor = [UIColor mainThemeColor].CGColor;
            self.selectedButton = sender;
        }
        else {
            self.selectedButton.selected = NO;
            self.selectedButton.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        }
    }
    if (self.tagClickedHandler) {
        self.tagClickedHandler(sender);
    }
}

- (void)timeRangeClicked:(UIButton *)sender {
    if (self.timeRangeClickedHandler) {
        self.timeRangeClickedHandler(sender.tag);
    }
}



// 设置元素控件
- (void)p_configElements {
    
    // 设置数据
    [self p_configData];
    
    // 设置约束
    [self p_configConstraints];
}

// 设置数据
- (void)p_configData {
}

// 设置约束
- (void)p_configConstraints {
    UIView *patientTimeRangeTitle = [self p_createTitleViewWithTitle:@"时间区间"];
    [self addSubview:patientTimeRangeTitle];
    [patientTimeRangeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(35);
//        if (!self.showPatientTag) {
//            make.top.mas_equalTo(self);
//        }
    }];

//    if (self.showPatientTag) {
        UIView *patientTagTitle = [self p_createTitleViewWithTitle:@"用户标签"];
        [self addSubview:patientTagTitle];
        [patientTagTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(35);
        }];
    
    if (self.showAllPatientTag) {
        NSArray<NSString *> *titles = @[@"套餐用户", @"免费用户", @"集团用户",@"单次咨询", @"我关注的",@""];
        self.arrayButtons = [NSMutableArray arrayWithCapacity:titles.count];
        __block NSMutableArray *tempArrayButtons = [NSMutableArray array];
        
        NSArray *tempArr = [self splitArray:titles withSubSize:LINECOUNT];
        __weak typeof(self) weakSelf = self;

        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *lineArr = (NSArray *)obj;
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [tempArrayButtons removeAllObjects];

            [lineArr enumerateObjectsUsingBlock:^(NSString * _Nonnull subObj, NSUInteger subIdx, BOOL * _Nonnull stop) {
                UIButton *btn = [strongSelf p_createButtonWithTitle:subObj];
                btn.tag = subIdx + idx * LINECOUNT;
                [strongSelf addSubview:btn];
                [tempArrayButtons addObject:btn];
                if (!subObj.length) {
                [btn setBackgroundImage:[UIImage imageColor:[UIColor clearColor] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
                    [btn setEnabled:NO];
                }
            }];
            
            [tempArrayButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:109 leadSpacing:13 tailSpacing:13];
            [tempArrayButtons mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(30);
                if (self.lastBtn) {
                    make.top.equalTo(self.lastBtn.mas_bottom).offset(5);
                }
                else {
                    make.top.equalTo(patientTagTitle.mas_bottom).offset(3);
                }
            }];
            
            self.lastBtn = tempArrayButtons.firstObject;
            
            [strongSelf.arrayButtons addObjectsFromArray:tempArrayButtons];
            
        }];
        
        [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(patientTimeRangeTitle.mas_top).offset(-12.5);
        }];
    }
    else {
        UIButton *btn = [self p_createButtonWithTitle:@"我关注的"];
        btn.tag = 2;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.top.equalTo(patientTagTitle.mas_bottom).offset(3);
            make.bottom.equalTo(patientTimeRangeTitle.mas_top).offset(-12.5);
            make.width.mas_equalTo(109);
            make.left.equalTo(self).offset(13);
        }];

    }
//    }
    
    
    UIView *sortRuleTitle = [self p_createTitleViewWithTitle:@"排序规则"];
    [self addSubview:sortRuleTitle];
    [sortRuleTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(35);
        make.bottom.mas_equalTo(self);
    }];


    self.timeRangeButtons = [NSMutableArray arrayWithCapacity:self.timeRangeTitles.count];
    __weak typeof(self) weakSelf = self;
    [self.timeRangeTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIButton *btn = [strongSelf p_createTimeRangeButtonWithTitle:obj];
        btn.tag = idx;
        [strongSelf addSubview:btn];
        [strongSelf.timeRangeButtons addObject:btn];
    }];
    [self.timeRangeButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:40 leadSpacing:13 tailSpacing:13];
    [self.timeRangeButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(patientTimeRangeTitle.mas_bottom).offset(3);
        make.bottom.equalTo(sortRuleTitle.mas_top).offset(-12.5);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor commonLightGrayColor_999999];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 1));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.timeRangeButtons);
    }];
}
/**
 *  将数组拆分成固定长度的子数组
 *
 *  @param array 需要拆分的数组
 *
 *  @param subSize 指定长度
 *
 */
- (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    
    return [arr copy];
}
- (UIView *)p_createTitleViewWithTitle:(NSString *)title {
    UIView *view = [UIView new];
    UIView *viewColor = [UIView new];
    viewColor.backgroundColor = [UIColor mainThemeColor];
    [view addSubview:viewColor];
    [viewColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(3, 21));
    }];
    UILabel *titleLb = [UILabel new];
    titleLb.font = [UIFont font_28];
    titleLb.textColor = [UIColor commonDarkGrayColor_666666];
    titleLb.text = title;
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewColor.mas_right).offset(10);
        make.centerY.equalTo(view);
    }];
    return view;
}

- (UIButton *)p_createButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont font_28]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor commonBlackTextColor_333333] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f2f5"] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateSelected];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(patientTagClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *)p_createTimeRangeButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont font_28]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"f0f2f5"];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(timeRangeClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (NSArray *)timeRangeTitles {
    if (!_timeRangeTitles) {
        _timeRangeTitles = @[@"开始时间", @"结束时间"];
    }
    return _timeRangeTitles;
}
@end
