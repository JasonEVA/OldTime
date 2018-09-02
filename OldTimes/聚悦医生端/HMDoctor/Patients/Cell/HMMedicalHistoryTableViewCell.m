//
//  HMMedicalHistoryTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMMedicalHistoryTableViewCell.h"

@interface MedicalHistoryView : UIView

@property (nonatomic, strong) UILabel *medHistoryLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *bottomView;

- (void)setMedicalHistoryTitle:(NSString *)title dateStr:(NSString *)date;
@end

@implementation MedicalHistoryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.medHistoryLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.bottomView];
        
        [self configElements];
    }
    return self;
}

- (void)configElements{
    [_medHistoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(10);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_medHistoryLabel);
        make.right.equalTo(self).offset(-12);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_medHistoryLabel.mas_left);
        make.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(@1);
    }];
}

- (void)setMedicalHistoryTitle:(NSString *)title dateStr:(NSString *)date
{
    [_medHistoryLabel setText:title];
    [_dateLabel setText:date];
    if (!date) {
        [_dateLabel setHidden:YES];
    }
}

- (UILabel *)medHistoryLabel {
    if (!_medHistoryLabel) {
        _medHistoryLabel = [UILabel new];
        [_medHistoryLabel setFont:[UIFont font_28]];
        [_medHistoryLabel setTextColor:[UIColor commonTextColor]];
        [_medHistoryLabel setText:@"高血压1级高危"];
    }
    return _medHistoryLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        [_dateLabel setFont:[UIFont font_28]];
        [_dateLabel setTextColor:[UIColor commonGrayTextColor]];
        [_dateLabel setText:@"2016-01-01"];
    }
    return _dateLabel;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        [_bottomView setBackgroundColor:[UIColor commonLightGrayColor_ebebeb]];
    }
    return _bottomView;
}

@end


@interface HMMedicalHistoryTableViewCell ()

@end

@implementation HMMedicalHistoryTableViewCell

@end


//***********  现病史   *******************
@interface HMHistoryIllnessTableViewCell ()

@property (nonatomic, strong) MedicalHistoryView *medicalView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *cureLabel;
@property (nonatomic, strong) UILabel *curStateLabel;
@property (nonatomic, strong) UIView *SeparatorView;

@end

@implementation HMHistoryIllnessTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.medicalView];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.cureLabel];
        [self.contentView addSubview:self.curStateLabel];
        [self.contentView addSubview:self.SeparatorView];
        
        [self configElements];
    }
    return self;
}

- (void)configElements{
    
    [_medicalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(@40);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_medicalView.mas_bottom);
        make.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(@1);
    }];
    
    [_cureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(12);
    }];
    
    [_curStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cureLabel.mas_left);
        make.top.equalTo(_cureLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-12);
    }];
    
    [_SeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(@1);
    }];
}

//赋值  现病史
- (void)setHistoryIllnessNowInfo:(HMNowListModel *)info{

    [_medicalView setMedicalHistoryTitle:info.JB_NAME dateStr:info.CONFIRMED_DATE];
    [_cureLabel setText:[NSString stringWithFormat:@"治疗/手术：%@",info.TAKE_WAY]];
    
    if (info.RECENT_DESC) {
        [_curStateLabel setText:[NSString stringWithFormat:@"近期情况：%@",info.RECENT_DESC]];
    }
}

//既往史
- (void)setHistoryIllnessBeforeInfo:(HMBeforListModel *)info{
    
    [_medicalView setMedicalHistoryTitle:info.JB_NAME dateStr:info.CONFIRMED_DATE];
    [_cureLabel setText:[NSString stringWithFormat:@"治疗/手术：%@",info.TAKE_WAY]];
    [_curStateLabel setText:[NSString stringWithFormat:@"结局：%@",info.END_TYPE]];
}

#pragma mark - init UI
- (MedicalHistoryView *)medicalView{
    if (!_medicalView) {
        _medicalView = [[MedicalHistoryView alloc] init];
    }
    return _medicalView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setBackgroundColor:[UIColor whiteColor]];
    }
    return _lineView;
}

- (UILabel *)cureLabel {
    if (!_cureLabel) {
        _cureLabel = [UILabel new];
        [_cureLabel setFont:[UIFont font_28]];
        [_cureLabel setTextColor:[UIColor commonGrayTextColor]];
        [_cureLabel setText:@"治疗/手术："];
    }
    return _cureLabel;
}

- (UILabel *)curStateLabel {
    if (!_curStateLabel) {
        _curStateLabel = [UILabel new];
        [_curStateLabel setFont:[UIFont font_28]];
        [_curStateLabel setTextColor:[UIColor commonGrayTextColor]];
        [_curStateLabel setNumberOfLines:0];
        [_curStateLabel setText:@"近期情况："];
    }
    return _curStateLabel;
}

- (UIView *)SeparatorView{
    if (!_SeparatorView) {
        _SeparatorView = [UIView new];
        [_SeparatorView setBackgroundColor:[UIColor commonLightGrayTextColor]];
    }
    return _SeparatorView;
}

@end

//***********  家族史   *******************
@interface HMFamilyHistoryTableViewCell ()
@property (nonatomic, strong) MedicalHistoryView *medicalView;
@property (nonatomic, strong) UILabel *familyLabel;
@property (nonatomic, strong) UIView *SeparatorView;

@end

@implementation HMFamilyHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.medicalView];
        [self.contentView addSubview:self.familyLabel];
        [self.contentView addSubview:self.SeparatorView];

        [self configElements];
    }
    return self;
}

- (void)configElements{
    
    [_medicalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(@40);
    }];
    
    [_familyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_medicalView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(12);
    }];
    
    [_SeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(@1);
    }];
}

- (void)setFamilyHistoryInfo:(HMFamilyListModel *)info
{
    if (info.ZAOFA_TYPE) {
        [_medicalView setMedicalHistoryTitle:info.JB_NAME dateStr:[NSString stringWithFormat:@"是否早发：%@",info.ZAOFA_TYPE]];
    }
    else{
        [_medicalView setMedicalHistoryTitle:info.JB_NAME dateStr:nil];
    }

    if (info.SHIP_TYPE) {
        [_familyLabel setText:[NSString stringWithFormat:@"关系：%@",info.SHIP_TYPE]];

    }
    else{
        [_familyLabel setText:@"无"];
    }
}

#pragma mark - init UI
- (MedicalHistoryView *)medicalView{
    if (!_medicalView) {
        _medicalView = [[MedicalHistoryView alloc] init];
    }
    return _medicalView;
}

- (UILabel *)familyLabel {
    if (!_familyLabel) {
        _familyLabel = [UILabel new];
        [_familyLabel setFont:[UIFont font_28]];
        [_familyLabel setTextColor:[UIColor commonGrayTextColor]];
        [_familyLabel setText:@"父母、其他亲属"];
    }
    return _familyLabel;
}

- (UIView *)SeparatorView{
    if (!_SeparatorView) {
        _SeparatorView = [UIView new];
        [_SeparatorView setBackgroundColor:[UIColor commonLightGrayTextColor]];
    }
    return _SeparatorView;
}

@end

@interface HMBeforeHistoryTableViewCell ()
@property (nonatomic, strong) MedicalHistoryView *medicalView;
@property (nonatomic, strong) UIView *SeparatorView;
@end

@implementation HMBeforeHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.medicalView];
        [self.contentView addSubview:self.SeparatorView];
        
        [self configElements];
    }
    return self;
}

- (void)configElements{
    
    [_medicalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(@40);
    }];
    
    [_SeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(@1);
    }];
}

//既往史
- (void)setHistoryIllnessBeforeInfo:(HMBeforListModel *)info{
    
    [_medicalView setMedicalHistoryTitle:info.JB_NAME dateStr:info.CONFIRMED_DATE];
}

#pragma mark - init UI
- (MedicalHistoryView *)medicalView{
    if (!_medicalView) {
        _medicalView = [[MedicalHistoryView alloc] init];
    }
    return _medicalView;
}

- (UIView *)SeparatorView{
    if (!_SeparatorView) {
        _SeparatorView = [UIView new];
        [_SeparatorView setBackgroundColor:[UIColor commonLightGrayTextColor]];
    }
    return _SeparatorView;
}

@end

