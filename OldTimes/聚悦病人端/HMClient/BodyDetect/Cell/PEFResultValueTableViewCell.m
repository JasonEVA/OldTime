//
//  PEFResultValueTableViewCell.m
//  HMClient
//
//  Created by lkl on 2017/6/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PEFResultValueTableViewCell.h"

@interface PEFResultValueTableViewCell ()

@property (nonatomic, strong) UILabel *detectTimeLabel;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *periodLabel;

@end

@implementation PEFResultValueTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.detectTimeLabel];
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.bottomLineView];
        [self.contentView addSubview:self.valueLabel];
        [self.contentView addSubview:self.periodLabel];
        
        [self configConstraints];
    }
    return self;
}

#pragma mark - Init
- (void)configConstraints{
    
    [_detectTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(70);
        make.bottom.equalTo(_circleView.mas_top).offset(-1.5);
    }];
    
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topLineView);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.equalTo(_circleView.mas_bottom).with.offset(1.5);
        make.left.equalTo(_topLineView.mas_left);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_circleView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_valueLabel.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setDataList:(PEFResultdataListModel *)model
{
    [_detectTimeLabel setText:model.TEST_TIME];
    [_valueLabel setText:model.TEST_VALUE_UNIT];
    [_periodLabel setText:model.TEST_TIME_NAME];
}

#pragma mark -- init
- (UILabel *)detectTimeLabel{
    if (!_detectTimeLabel) {
        _detectTimeLabel = [[UILabel alloc] init];
        [_detectTimeLabel setText:@"07:36"];
        [_detectTimeLabel setTextColor:[UIColor commonGrayTextColor]];
        [_detectTimeLabel setFont:[UIFont font_26]];
    }
    return _detectTimeLabel;
}

- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        [_topLineView setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _topLineView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        [_bottomLineView setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _bottomLineView;
}

- (UIView *)circleView{
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        [_circleView setBackgroundColor:[UIColor mainThemeColor]];
        [_circleView.layer setCornerRadius:6.0f];
        [_circleView.layer setMasksToBounds:YES];
    }
    return _circleView;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        [_valueLabel setText:@"566L/min"];
        [_valueLabel setTextColor:[UIColor commonTextColor]];
        [_valueLabel setFont:[UIFont font_28]];
    }
    return _valueLabel;
}

- (UILabel *)periodLabel{
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] init];
        [_periodLabel setText:@"药前"];
        [_periodLabel setTextColor:[UIColor commonTextColor]];
        [_periodLabel setFont:[UIFont font_28]];
    }
    return _periodLabel;
}


@end



@interface PEFResultHistoryTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *middleLineView;
@property (nonatomic, strong) UILabel *mutationRateValueLb;
@property (nonatomic, strong) UILabel *mutationRateLb;
@property (nonatomic, strong) UILabel *historyMaxValueLb;
@property (nonatomic, strong) UILabel *historyMaxLb;

@end

@implementation PEFResultHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.bgView];
        [_bgView addSubview:self.middleLineView];
        [_bgView addSubview:self.mutationRateValueLb];
        [_bgView addSubview:self.mutationRateLb];
        [_bgView addSubview:self.historyMaxValueLb];
        [_bgView addSubview:self.historyMaxLb];
        
        [self configConstraints];
    }
    return self;
}

- (void)configConstraints{
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.right.equalTo(self.contentView).offset(-12.5);
        make.center.equalTo(self.contentView);
        make.height.mas_equalTo(@80);
    }];
    
    [_middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bgView);
        make.top.bottom.equalTo(_bgView);
        make.width.mas_equalTo(@1);
    }];
    
    [_mutationRateValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView).offset(15);
        make.width.mas_equalTo((ScreenWidth-25)/2);
        make.left.equalTo(_bgView);
    }];
    
    [_mutationRateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bgView).offset(-15);
        make.width.mas_equalTo(_mutationRateValueLb);
        make.left.equalTo(_mutationRateValueLb.mas_left);
    }];
    
    [_historyMaxValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mutationRateValueLb.mas_top);
        make.width.mas_equalTo(_mutationRateValueLb);
        make.left.equalTo(_mutationRateValueLb.mas_right);
    }];
    
    [_historyMaxLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_mutationRateLb.mas_bottom);
        make.width.mas_equalTo(_mutationRateValueLb);
        make.left.equalTo(_historyMaxValueLb.mas_left);
    }];
}

- (void)setPEFResult:(PEFResultModel *)model
{
    [_mutationRateValueLb setText:model.variationRate];
    [_historyMaxValueLb setText:model.maxOfHistory];
}

#pragma mark - Init
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:6.0f];
        [_bgView.layer setMasksToBounds:YES];
        [_bgView.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
        [_bgView.layer setBorderWidth:1.0f];
    }
    return _bgView;
}

- (UIView *)middleLineView{
    if (!_middleLineView) {
        _middleLineView = [[UIView alloc] init];
        [_middleLineView setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _middleLineView;
}

- (UILabel *)mutationRateValueLb{
    if (!_mutationRateValueLb) {
        _mutationRateValueLb = [[UILabel alloc] init];
        [_mutationRateValueLb setText:@"2%"];
        [_mutationRateValueLb setTextColor:[UIColor commonTextColor]];
        [_mutationRateValueLb setFont:[UIFont font_28]];
        [_mutationRateValueLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _mutationRateValueLb;
}

- (UILabel *)mutationRateLb{
    if (!_mutationRateLb) {
        _mutationRateLb = [[UILabel alloc] init];
        [_mutationRateLb setText:@"日间变异率"];
        [_mutationRateLb setTextColor:[UIColor commonGrayTextColor]];
        [_mutationRateLb setFont:[UIFont font_28]];
        [_mutationRateLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _mutationRateLb;
}

- (UILabel *)historyMaxValueLb{
    if (!_historyMaxValueLb) {
        _historyMaxValueLb = [[UILabel alloc] init];
        [_historyMaxValueLb setText:@"360L/min"];
        [_historyMaxValueLb setTextColor:[UIColor commonTextColor]];
        [_historyMaxValueLb setFont:[UIFont font_28]];
        [_historyMaxValueLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _historyMaxValueLb;
}

- (UILabel *)historyMaxLb{
    if (!_historyMaxLb) {
        _historyMaxLb = [[UILabel alloc] init];
        [_historyMaxLb setText:@"历史最高值"];
        [_historyMaxLb setTextColor:[UIColor commonGrayTextColor]];
        [_historyMaxLb setFont:[UIFont font_28]];
        [_historyMaxLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _historyMaxLb;
}

@end
