//
//  AnaerobicExerciseBodyView.m
//  Shape
//
//  Created by Andrew Shen on 15/10/26.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "AnaerobicExerciseBodyView.h"
#import <Masonry/Masonry.h>
#import "UIImage+EX.h"
#import "MuscleImageView.h"
#import "ComprehensiveDataView.h"
#import "MyDefine.h"
#import "UILabel+EX.h"
#import "UIColor+Hex.h"
#import "DBUnifiedManager.h"
#import "MuscleModel.h"
#import "DateUtil.h"

typedef enum : NSUInteger {
    tag_negativeArm,
    tag_negativeCalf,
    tag_negativeDorsal,
    tag_negativeProfile,
    tag_negativeThigh,
    tag_positiveAbdominal,
    tag_positiveArm,
    tag_positiveCalf,
    tag_positiveChest,
    tag_positiveProfile,
    tag_positiveShoulder,
    tag_positiveThigh
} MuscleImageViewTag;

static CGFloat const kProfileWidth = 214; // 轮廓宽度
static CGFloat const kProfileHeight = 423; // 轮廓高度
static CGFloat const kPeroid = 7; // 周期时长

@interface AnaerobicExerciseBodyView()

@property (nonatomic, strong)  MuscleImageView  *negativeArm; // 背面上臂
@property (nonatomic, strong)  MuscleImageView  *negativeCalf;  // 背面小腿
@property (nonatomic, strong)  MuscleImageView  *negativeDorsal; // 背面背肌
@property (nonatomic, strong)  MuscleImageView  *negativeProfile; // 背面轮廓
@property (nonatomic, strong)  MuscleImageView  *negativeThigh; // 背面大腿

@property (nonatomic, strong)  MuscleImageView  *positiveAbdominal; // 正面腹肌
@property (nonatomic, strong)  MuscleImageView  *positiveArm; // 正面上臂
@property (nonatomic, strong)  MuscleImageView  *positiveCalf; // 正面小腿
@property (nonatomic, strong)  MuscleImageView  *positiveChest; // 正面胸肌
@property (nonatomic, strong)  MuscleImageView  *positiveProfile; // 正面轮廓
@property (nonatomic, strong)  MuscleImageView  *positiveShoulder; // 正面肩部
@property (nonatomic, strong)  MuscleImageView  *positiveThigh; // 正面大腿

@property (nonatomic, strong)  MuscleImageView  *currentSelectMuscle; // 当前选中的肌肉
@property (nonatomic, strong)  MuscleModel  *muscleData; // 当前选中的肌肉

@property (nonatomic, strong)  UILabel  *partName; // 部位
@property (nonatomic, strong)  UILabel  *trainingTimesTitle; // 训练次数title
@property (nonatomic, strong)  UILabel  *trainingTimesValue; // 训练次数
@property (nonatomic, strong)  UILabel  *trainingIndexTitle; // 训练指数title
@property (nonatomic, strong)  UILabel  *trainingIndexValue; // 训练指数
@property (nonatomic, strong)  UILabel  *trainingIntervalTitle; // 训练间隔title
@property (nonatomic, strong)  UILabel  *trainingIntervalValue; // 训练间隔

@property (nonatomic, strong)  UIButton  *btnTraining; // 训练此部位按钮

@property (nonatomic, strong)  ComprehensiveDataView  *comprehensiveDataView; // 综合数据view

// 位置参数
@property (nonatomic)  CGFloat  bodyWidth; // <##>
@property (nonatomic)  CGFloat  bodyHeight; // <##>
@property (nonatomic)  CGFloat  partNameTopMargin; // <##>
@property (nonatomic)  CGFloat  bodyTopMargin; // <##>

@end
@implementation AnaerobicExerciseBodyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self configElements];
    }
    return self;
}
- (instancetype)initWithPositiveSide:(BOOL)positive {
    self = [self init];
    if (self) {
        [self configViewSide:positive];
    }
    return self;
}

// 设置元素控件
- (void)configElements {
    [self addSubview:self.negativeArm]; // 背面上臂
    [self addSubview:self.negativeCalf];  // 背面小腿
    [self addSubview:self.negativeDorsal]; // 背面背肌
    [self addSubview:self.negativeProfile]; // 背面轮廓
    [self addSubview:self.negativeThigh]; // 背面大腿
    [self addSubview:self.positiveAbdominal]; // 正面腹肌
    [self addSubview:self.positiveArm]; // 正面上臂
    [self addSubview:self.positiveCalf]; // 正面小腿
    [self addSubview:self.positiveChest]; // 正面胸肌
    [self addSubview:self.positiveProfile]; // 正面轮廓
    [self addSubview:self.positiveShoulder]; // 正面肩部
    [self addSubview:self.positiveThigh]; // 正面大腿
    
    [self addSubview:self.partName];
    [self addSubview:self.trainingTimesTitle];
    [self addSubview:self.trainingTimesValue];
    [self addSubview:self.trainingIndexTitle];
    [self addSubview:self.trainingIndexValue];
    [self addSubview:self.trainingIntervalTitle];
    [self addSubview:self.trainingIntervalValue];
    [self addSubview:self.btnTraining];
    
    [self addSubview:self.comprehensiveDataView];
    

    [self needsUpdateConstraints];
}

- (void)configViewSide:(BOOL)positive {
    [self showMusclePositive:positive];
    positive ? [self selectMuscleWithMuscleView:self.positiveShoulder] : [self selectMuscleWithMuscleView:self.negativeDorsal];
}

- (void)updateConstraints {
    
    [self.positiveProfile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.bodyWidth));
        make.height.equalTo(@(self.bodyHeight));
        make.top.equalTo(self).offset(self.bodyTopMargin);
        make.left.equalTo(self).offset(10);
    }];
    
    [self.positiveAbdominal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.positiveArm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.positiveCalf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.positiveChest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.positiveShoulder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.positiveThigh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.negativeArm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.negativeCalf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.negativeDorsal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.negativeProfile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    [self.negativeThigh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positiveProfile);
    }];
    
    
    [self.partName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.positiveProfile.mas_right).offset(15).priority(MASLayoutPriorityDefaultLow);
        make.top.equalTo(self).offset(self.partNameTopMargin);
        make.left.equalTo(self.trainingTimesTitle).priority(MASLayoutPriorityDefaultHigh);
    }];
    [self.trainingTimesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.partName.mas_bottom).offset(10);
        make.left.equalTo(self.partName);
    }];
    [self.trainingTimesValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trainingTimesTitle.mas_right).offset(5);
        make.centerY.equalTo(self.trainingTimesTitle);
    }];
    [self.trainingIndexTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trainingTimesTitle.mas_bottom).offset(10);
        make.left.equalTo(self.partName);
    }];
    [self.trainingIndexValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trainingIndexTitle.mas_right).offset(5);
        make.centerY.equalTo(self.trainingIndexTitle);
    }];
    [self.trainingIntervalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trainingIndexTitle.mas_bottom).offset(10);
        make.left.equalTo(self.partName);
    }];
    [self.trainingIntervalValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trainingIntervalTitle.mas_right).offset(5);
        make.centerY.equalTo(self.trainingIntervalTitle);
        make.right.lessThanOrEqualTo(self).offset(-5);
    }];
    
    [self.btnTraining mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.partName);
        make.top.equalTo(self.trainingIntervalTitle.mas_bottom).offset(30);
        make.height.width.equalTo(@(height_65));
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

#pragma mark - Private Method
- (NSString *)muscleNameWithTag:(MuscleImageViewTag )tag {
    NSString *name;
    switch (tag) {
        case tag_negativeArm:
            name = @"上臂";
            break;
            
        case tag_negativeCalf:
            name = @"小腿";
            break;
            
        case tag_negativeDorsal:
            name = @"背";
            break;
            
        case tag_negativeThigh:
            name = @"大腿";
            break;
            
        case tag_positiveAbdominal:
            name = @"腹肌";
            break;
            
        case tag_positiveArm:
            name = @"上臂";
            break;
            
        case tag_positiveCalf:
            name = @"小腿";
            break;
            
        case tag_positiveChest:
            name = @"胸";
            break;
            
        case tag_positiveShoulder:
            name = @"肩";
            break;
            
        case tag_positiveThigh:
            name = @"大腿";
            break;
            
        default:
            name = @"";
            break;
    }
    return name;
}

- (void)showMusclePositive:(BOOL)positive {
    [self.positiveAbdominal setHidden:!positive];
    [self.positiveArm setHidden:!positive];
    [self.positiveCalf setHidden:!positive];
    [self.positiveChest setHidden:!positive];
    [self.positiveProfile setHidden:!positive];
    [self.positiveShoulder setHidden:!positive];
    [self.positiveThigh setHidden:!positive];
    
    [self.negativeArm setHidden:positive];
    [self.negativeCalf setHidden:positive];
    [self.negativeDorsal setHidden:positive];
    [self.negativeProfile setHidden:positive];
    [self.negativeThigh setHidden:positive];
    
}

// 对选中的肌肉进行操作
- (void)selectMuscleWithMuscleView:(MuscleImageView *)selectView {
    [self.currentSelectMuscle setHighlighted:NO];
    self.currentSelectMuscle = selectView;
    [self.currentSelectMuscle setHighlighted:YES];
    NSString *partName = [self muscleNameWithTag:(MuscleImageViewTag)self.currentSelectMuscle.tag];
    
    NSDate *todayTemp = [DateUtil dateWithComponents:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit date:[NSDate date]];
    NSDate *beginDate = [DateUtil dateFromDate:todayTemp intervalDay:- kPeroid];

    // 点击肌肉设置数据
    self.muscleData = [[DBUnifiedManager share] fetchMuscleData:@[partName] FromBeginDate:beginDate endDate:[NSDate date]].firstObject;
    
    // 设置数据
    [self configMuscleData:self.muscleData];
    
}

// 根据给定大小绘制图片
- (UIImage *)newImageWithName:(NSString *)name {
    return [UIImage imageScaleFromImage:[UIImage imageNamed:name] toSize:CGSizeMake(self.bodyWidth, self.bodyHeight)];
}

- (void)configMuscleData:(MuscleModel *)muscle {
    NSLog(@"-------------->%@肌肉点击",muscle.muscleName);

    if (!muscle) {
        return;
    }
    [self.partName setText:muscle.muscleName];
    [self.trainingTimesValue setText:[NSString stringWithFormat:@"%ld次",muscle.trainingTimes.integerValue]]; // 训练次数
    [self.trainingIndexValue setText:@"弱"]; // 训练指数
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[self trainingTimeInterval:muscle.lastTrainingDate]];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithHex:0x39e5ff]
                        range:NSMakeRange(0, attriString.length - 1)];
    [self.trainingIntervalValue setAttributedText:attriString];
    
    // 综合数据
    [self.comprehensiveDataView setComprehedsiveData:muscle];
}

- (NSString *)trainingTimeInterval:(NSDate *)lastDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:lastDate toDate:[NSDate date] options:0];
    NSInteger interval = dayComponents.day;
    return [NSString stringWithFormat:@"%ld天",interval];
}

#pragma mark - Event Response
- (void)imageViewTagAction:(UITapGestureRecognizer *)sender {
    if ([sender.view isKindOfClass:[MuscleImageView class]]) {
        MuscleImageView *selectView = (MuscleImageView *)sender.view;
        if (self.currentSelectMuscle.tag != selectView.tag) {
            [self selectMuscleWithMuscleView:selectView];
        }
        
    }
    
}

- (void)trainingThisPart {
    [[NSNotificationCenter defaultCenter] postNotificationName:n_trainingPart object:self.partName.text];
}
#pragma mark - Init
- (MuscleImageView *)positiveProfile {
    if (!_positiveProfile) {
        _positiveProfile = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"positive_profile"] highlightedImage:nil target:self gestureAction:nil tag:tag_positiveProfile];
    }
    return _positiveProfile;
}
- (MuscleImageView *)positiveArm {
    if (!_positiveArm) {
        _positiveArm = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"positive_arm"] highlightedImage:[self newImageWithName:@"positive_arm_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_positiveArm];
    }
    return _positiveArm;
}
- (MuscleImageView *)positiveAbdominal {
    if (!_positiveAbdominal) {
        _positiveAbdominal = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"positive_abdominal"] highlightedImage:[self newImageWithName:@"positive_abdominal_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_positiveAbdominal];
    }
    return _positiveAbdominal;
}
- (MuscleImageView *)positiveCalf {
    if (!_positiveCalf) {
        _positiveCalf = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"positive_calf"] highlightedImage:[self newImageWithName:@"positive_calf_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_positiveCalf];
    }
    return _positiveCalf;
}
- (MuscleImageView *)positiveChest {
    if (!_positiveChest) {
        _positiveChest = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"positive_chest"] highlightedImage:[self newImageWithName:@"positive_chest_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_positiveChest];
    }
    return _positiveChest;
}
- (MuscleImageView *)positiveShoulder {
    if (!_positiveShoulder) {
        _positiveShoulder = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"positive_shoulder"] highlightedImage:[self newImageWithName:@"positive_shoulder_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_positiveShoulder];
    }
    return _positiveShoulder;
}
- (MuscleImageView *)positiveThigh {
    if (!_positiveThigh) {
        _positiveThigh = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"positive_thigh"] highlightedImage:[self newImageWithName:@"positive_thigh_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_positiveThigh];
    }
    return _positiveThigh;
}
- (MuscleImageView *)negativeArm {
    if (!_negativeArm) {
        _negativeArm = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"negative_arm"] highlightedImage:[self newImageWithName:@"negative_arm_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_negativeArm];
    }
    return _negativeArm;
}
- (MuscleImageView *)negativeCalf {
    if (!_negativeCalf) {
        _negativeCalf = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"negative_calf"] highlightedImage:[self newImageWithName:@"negative_calf_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_negativeCalf];
    }
    return _negativeCalf;
}
- (MuscleImageView *)negativeDorsal {
    if (!_negativeDorsal) {
        _negativeDorsal = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"negative_dorsal"] highlightedImage:[self newImageWithName:@"negative_dorsal_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_negativeDorsal];
    }
    return _negativeDorsal;
}
- (MuscleImageView *)negativeProfile {
    if (!_negativeProfile) {
        _negativeProfile = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"negative_profile"] highlightedImage:nil target:self gestureAction:nil tag:tag_negativeProfile];
    }
    return _negativeProfile;
}
- (MuscleImageView *)negativeThigh {
    if (!_negativeThigh) {
        _negativeThigh = [[MuscleImageView alloc] initWithImage:[self newImageWithName:@"negative_thigh"] highlightedImage:[self newImageWithName:@"negative_thigh_select"] target:self gestureAction:@selector(imageViewTagAction:) tag:tag_negativeThigh];
    }
    return _negativeThigh;
}

- (UILabel *)partName {
    if (!_partName) {
        _partName = [UILabel setLabel:_partName text:@"" font:[UIFont boldSystemFontOfSize:fontSize_30] textColor:[UIColor whiteColor]];
    }
    return _partName;
}
- (UILabel *)trainingTimesTitle {
    if (!_trainingTimesTitle) {
        _trainingTimesTitle = [UILabel setLabel:_trainingTimesTitle text:@"训练次数:" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _trainingTimesTitle;
}
- (UILabel *)trainingTimesValue {
    if (!_trainingTimesValue) {
        _trainingTimesValue = [UILabel setLabel:_trainingTimesValue text:@"" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _trainingTimesValue;
}
- (UILabel *)trainingIndexTitle {
    if (!_trainingIndexTitle) {
        _trainingIndexTitle = [UILabel setLabel:_trainingIndexTitle text:@"训练指数:" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _trainingIndexTitle;
}
- (UILabel *)trainingIndexValue {
    if (!_trainingIndexValue) {
        _trainingIndexValue = [UILabel setLabel:_trainingIndexValue text:@"" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _trainingIndexValue;
}
- (UILabel *)trainingIntervalTitle {
    if (!_trainingIntervalTitle) {
        _trainingIntervalTitle = [UILabel setLabel:_trainingIntervalTitle text:@"距上次训练:" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _trainingIntervalTitle;
}

- (UILabel *)trainingIntervalValue {
    if (!_trainingIntervalValue) {
        _trainingIntervalValue = [UILabel setLabel:_trainingIntervalValue text:@"" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _trainingIntervalValue;
}

- (UIButton *)btnTraining {
    if (!_btnTraining) {
        _btnTraining = [[UIButton alloc] init];
        [_btnTraining setBackgroundImage:[UIColor switchToImageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_btnTraining setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnTraining setTitle:@"训练\n此部位" forState:UIControlStateNormal];
        [_btnTraining.titleLabel setNumberOfLines:2];
        [_btnTraining.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_btnTraining.titleLabel setFont:[UIFont systemFontOfSize:fontSize_12]];
        [_btnTraining.layer setCornerRadius:height_65 * 0.5];
        [_btnTraining.layer setMasksToBounds:YES];
        [_btnTraining addTarget:self action:@selector(trainingThisPart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnTraining;
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
    return [UIScreen mainScreen].bounds.size.width / 375 >= 1 ? 90 : [UIScreen mainScreen].bounds.size.height * 90 / 667;

}

- (CGFloat)bodyTopMargin {
    return [UIScreen mainScreen].bounds.size.width / 375 >= 1 ? 25 : [UIScreen mainScreen].bounds.size.height * 25 / 667;
}

@end
