//
//  AerobicExerciseView.m
//  Shape
//
//  Created by Andrew Shen on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "AerobicExerciseView.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "UILabel+EX.h"
#import "ComprehensiveDataView.h"
#import "unifiedUserInfoManager.h"
#import "MeGetUserInfoModel.h"
#import "DBUnifiedManager.h"
#import "Weight.h"
#import "FatRange.h"
#import "MuscleModel.h"
#import "DateUtil.h"

static CGFloat const kProfileWidth = 214; // 轮廓宽度
static CGFloat const kProfileHeight = 423; // 轮廓高度
static CGFloat const kPeroid = 7; // 周期时长

typedef enum : NSUInteger {
    tag_loseFat,
    tag_addData,
} AerobicButtonTag;
@interface AerobicExerciseView()

@property (nonatomic, strong)  UIImageView  *positiveProfile; // 正面轮廓

@property (nonatomic, strong)  UILabel  *partName; // 部位
@property (nonatomic, strong)  UILabel  *weightTitle; // 体重title
@property (nonatomic, strong)  UILabel  *weightValue; // 体重Value
@property (nonatomic, strong)  UILabel  *fatPercentageTitle; // 体脂率title
@property (nonatomic, strong)  UILabel  *fatPercentageValue; // 体脂率Value

@property (nonatomic, strong)  UILabel  *trainingTimesTitle; // 训练次数title
@property (nonatomic, strong)  UILabel  *trainingTimesValue; // 训练次数
@property (nonatomic, strong)  UILabel  *trainingIntervalTitle; // 训练间隔title
@property (nonatomic, strong)  UILabel  *trainingIntervalValue; // 训练间隔

@property (nonatomic, strong)  UIButton  *btnFatLose; // 减脂按钮
@property (nonatomic, strong)  UIButton  *btnAddData; // 添加数据按钮

@property (nonatomic, strong)  ComprehensiveDataView  *comprehensiveDataView; // 综合数据view

// 位置参数
@property (nonatomic)  CGFloat  bodyWidth; // <##>
@property (nonatomic)  CGFloat  bodyHeight; // <##>
@property (nonatomic)  CGFloat  partNameTopMargin;
@property (nonatomic)  CGFloat  bodyTopMargin; // <##>

@end
@implementation AerobicExerciseView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAerobicData) name:n_updateAerobicData object:nil];
    }
    return self;
}

// 设置元素控件
- (void)configElements {
    [self addSubview:self.positiveProfile]; // 正面轮廓
    
    [self addSubview:self.partName];
    [self addSubview:self.weightTitle];
    [self addSubview:self.weightValue];
    [self addSubview:self.fatPercentageTitle];
    [self addSubview:self.fatPercentageValue];
    [self addSubview:self.trainingTimesTitle];
    [self addSubview:self.trainingTimesValue];
    [self addSubview:self.trainingIntervalTitle];
    [self addSubview:self.trainingIntervalValue];
    [self addSubview:self.btnFatLose];
    [self addSubview:self.btnAddData];

    [self addSubview:self.comprehensiveDataView];
    
    MeGetUserInfoModel *model = [[unifiedUserInfoManager share] getUserInfoModel];
    [self.weightValue setText:[NSString stringWithFormat:@"%.1f公斤",model.weight]];
    [self needsUpdateConstraints];
}

- (void)updateConstraints {
    
    [self.positiveProfile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.bodyHeight));
        make.width.equalTo(@(self.bodyWidth));
        make.top.equalTo(self).offset(self.bodyTopMargin);
        make.left.equalTo(self).offset(10);
    }];
    
    [self.partName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.positiveProfile.mas_right).offset(15).priority(MASLayoutPriorityDefaultLow);
        make.top.equalTo(self).offset(self.partNameTopMargin);
        make.left.equalTo(self.trainingTimesTitle).priority(MASLayoutPriorityDefaultHigh);
    }];
    [self.weightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.partName.mas_bottom).offset(10);
        make.left.equalTo(self.partName);
    }];
    [self.weightValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weightTitle.mas_right).offset(5);
        make.centerY.equalTo(self.weightTitle);
    }];
    [self.fatPercentageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weightTitle.mas_bottom).offset(10);
        make.left.equalTo(self.partName);
    }];
    [self.fatPercentageValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fatPercentageTitle.mas_right).offset(5);
        make.centerY.equalTo(self.fatPercentageTitle);
    }];

    [self.trainingTimesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fatPercentageTitle.mas_bottom).offset(10);
        make.left.equalTo(self.partName);
    }];
    [self.trainingTimesValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trainingTimesTitle.mas_right).offset(5);
        make.centerY.equalTo(self.trainingTimesTitle);
    }];
    [self.trainingIntervalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trainingTimesTitle.mas_bottom).offset(10);
        make.left.equalTo(self.partName);
    }];
    [self.trainingIntervalValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trainingIntervalTitle.mas_right).offset(5);
        make.centerY.equalTo(self.trainingIntervalTitle);
        make.right.lessThanOrEqualTo(self).offset(-5);
    }];

    [self.btnFatLose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.partName);
        make.top.equalTo(self.trainingIntervalTitle.mas_bottom).offset(30);
        make.height.width.equalTo(@(height_65));
    }];
    [self.btnAddData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.btnFatLose);
        make.top.equalTo(self.btnFatLose.mas_bottom).offset(20);
    }];
    
    [self.comprehensiveDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.lessThanOrEqualTo(self).offset(30);
        make.right.greaterThanOrEqualTo(self).offset(-30);
        make.left.greaterThanOrEqualTo(self);
        make.right.lessThanOrEqualTo(self);
        
        make.top.equalTo(self.positiveProfile.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self);

    }];

    [super updateConstraints];
}

#pragma mark - Interface Method
- (void)updateAerobicData {
    Weight *weightTemp = [[DBUnifiedManager share] fetchWeightWithCount:1].lastObject;
    FatRange *fatRangeTemp = [[DBUnifiedManager share] fetchFatRange];
    [self.positiveProfile setImage:[UIImage imageNamed:[self bodyImgWithFatRange:fatRangeTemp.fatRange]]];
    [self.weightValue setText:[NSString stringWithFormat:@"%.1f",weightTemp.weight.floatValue]];
    [self.fatPercentageValue setText:fatRangeTemp.fatRange];
}

- (void)setAerobicComprehensiveData {
    NSDate *todayTemp = [DateUtil dateWithComponents:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit date:[NSDate date]];
    NSDate *beginDate = [DateUtil dateFromDate:todayTemp intervalDay:- kPeroid];
    MuscleModel *model = [[DBUnifiedManager share] fetchComprehensiveDataFromBeginDate:beginDate endDate:[NSDate date]];
    [self setExerciseData:model];
    [self.comprehensiveDataView setComprehedsiveData:model];
}
#pragma mark - Private Method
- (void)setExerciseData:(MuscleModel *)model {
#warning 测试数据
    [self.trainingTimesValue setText:@"10次"];
//    [self.trainingTimesValue setText:[NSString stringWithFormat:@"%ld次",model.trainingTimes.integerValue]]; // 训练次数
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[self trainingTimeInterval:model.lastTrainingDate]];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithHex:0x39e5ff]
                        range:NSMakeRange(0, attriString.length - 1)];
    [self.trainingIntervalValue setAttributedText:attriString];

}

- (NSString *)trainingTimeInterval:(NSDate *)lastDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:lastDate toDate:[NSDate date] options:0];
    NSInteger interval = dayComponents.day;
    return [NSString stringWithFormat:@"%ld天",interval];
}

- (NSString *)bodyImgWithFatRange:(NSString *)fatRange {
    NSString *namePrefix = @"fat_";
    NSString *nameSuffix;
    if ([fatRange isEqualToString:@"<8%"]) {
        nameSuffix = @"8";

    } else if ([fatRange isEqualToString:@"8%~12%"]) {
        nameSuffix = @"12";

    } else if ([fatRange isEqualToString:@"12%~15%"]) {
        nameSuffix = @"15";

    } else if ([fatRange isEqualToString:@"15%~20%"]) {
        nameSuffix = @"20";

    } else if ([fatRange isEqualToString:@"20%~25%"]) {
        nameSuffix = @"25";

    } else if ([fatRange isEqualToString:@"25%~30%"]) {
        nameSuffix = @"30";

    } else {
        nameSuffix = @"35";

    }
    
    return [namePrefix stringByAppendingString:nameSuffix];
}

- (void)btnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case tag_loseFat:
            [[NSNotificationCenter defaultCenter] postNotificationName:n_trainingPart object:self.partName.text];
            break;
            
        case tag_addData:
            [[NSNotificationCenter defaultCenter] postNotificationName:n_addAerobicData object:nil];
            break;

            
        default:
            break;
    }
}
#pragma mark - Init

- (UIImageView *)positiveProfile {
    if (!_positiveProfile) {
        _positiveProfile = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fat_12"]];
    }
    return _positiveProfile;
}

- (UILabel *)partName {
    if (!_partName) {
        _partName = [UILabel setLabel:_partName text:@"全身" font:[UIFont boldSystemFontOfSize:fontSize_30] textColor:[UIColor whiteColor]];
    }
    return _partName;
}

- (UILabel *)weightTitle {
    if (!_weightTitle) {
        _weightTitle = [UILabel setLabel:_weightTitle text:@"体重:" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _weightTitle;
}
- (UILabel *)weightValue {
    if (!_weightValue) {
        _weightValue = [UILabel setLabel:_weightValue text:@"90公斤" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _weightValue;
}

- (UILabel *)fatPercentageTitle {
    if (!_fatPercentageTitle) {
        _fatPercentageTitle = [UILabel setLabel:_fatPercentageTitle text:@"体脂率:" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _fatPercentageTitle;
}
- (UILabel *)fatPercentageValue {
    if (!_fatPercentageValue) {
        _fatPercentageValue = [UILabel setLabel:_fatPercentageValue text:@"35%" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _fatPercentageValue;
}

- (UILabel *)trainingTimesTitle {
    if (!_trainingTimesTitle) {
        _trainingTimesTitle = [UILabel setLabel:_trainingTimesTitle text:@"训练次数:" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _trainingTimesTitle;
}
- (UILabel *)trainingTimesValue {
    if (!_trainingTimesValue) {
        _trainingTimesValue = [UILabel setLabel:_trainingTimesValue text:@"5次" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _trainingTimesValue;
}
- (UILabel *)trainingIntervalTitle {
    if (!_trainingIntervalTitle) {
        _trainingIntervalTitle = [UILabel setLabel:_trainingIntervalTitle text:@"距上次训练:" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _trainingIntervalTitle;
}

- (UILabel *)trainingIntervalValue {
    if (!_trainingIntervalValue) {
        _trainingIntervalValue = [UILabel setLabel:_trainingIntervalValue text:@"14天" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _trainingIntervalValue;
}

- (UIButton *)btnFatLose {
    if (!_btnFatLose) {
        _btnFatLose = [[UIButton alloc] init];
        [_btnFatLose setBackgroundImage:[UIColor switchToImageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_btnFatLose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnFatLose setTitle:@"去减脂" forState:UIControlStateNormal];
        [_btnFatLose.titleLabel setNumberOfLines:2];
        [_btnFatLose.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_btnFatLose.titleLabel setFont:[UIFont systemFontOfSize:fontSize_12]];
        [_btnFatLose.layer setCornerRadius:height_65 * 0.5];
        [_btnFatLose.layer setMasksToBounds:YES];
        _btnFatLose.tag = tag_loseFat;
        [_btnFatLose addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btnFatLose;
}

- (UIButton *)btnAddData {
    if (!_btnAddData) {
        _btnAddData = [[UIButton alloc] init];
        [_btnAddData setBackgroundImage:[UIColor switchToImageWithColor:[UIColor colorDarkGray_737272] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_btnAddData setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnAddData setTitle:@"添加数据" forState:UIControlStateNormal];
        [_btnAddData.titleLabel setNumberOfLines:2];
        [_btnAddData.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_btnAddData.titleLabel setFont:[UIFont systemFontOfSize:fontSize_12]];
        [_btnAddData.layer setCornerRadius:height_65 * 0.5];
        [_btnAddData.layer setMasksToBounds:YES];
        _btnAddData.tag = tag_addData;
        [_btnAddData addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAddData;
}

// 综合数据
- (ComprehensiveDataView *)comprehensiveDataView {
    if (!_comprehensiveDataView) {
        _comprehensiveDataView = [[ComprehensiveDataView alloc] init];
    }
    return _comprehensiveDataView;
}

// 位置参数数据
- (CGFloat)bodyWidth {
    return [UIScreen mainScreen].bounds.size.width / 375 >= 1 ? kProfileWidth : [UIScreen mainScreen].bounds.size.width * kProfileWidth / 375;
}

- (CGFloat)bodyHeight {
    return [UIScreen mainScreen].bounds.size.width / 375 >= 1 ? kProfileHeight : [UIScreen mainScreen].bounds.size.height * kProfileHeight / 667;
}

- (CGFloat)partNameTopMargin {
    return [UIScreen mainScreen].bounds.size.width / 375 >= 1 ? 105 : [UIScreen mainScreen].bounds.size.height * 105 / 667;
    
}

- (CGFloat)bodyTopMargin {
    return [UIScreen mainScreen].bounds.size.width / 375 >= 1 ? 60 : [UIScreen mainScreen].bounds.size.height * 60 / 667;
}

@end
