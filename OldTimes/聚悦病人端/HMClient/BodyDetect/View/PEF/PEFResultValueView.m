//
//  PEFResultValueView.m
//  HMClient
//
//  Created by lkl on 2017/6/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PEFResultValueView.h"

@interface PEFResultValueView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *middleLineView;
@property (nonatomic, strong) UILabel *mutationRateValueLb;
@property (nonatomic, strong) UILabel *mutationRateLb;
@property (nonatomic, strong) UILabel *historyMaxValueLb;
@property (nonatomic, strong) UILabel *historyMaxLb;

@end

@implementation PEFResultValueView

- (id)init{

    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.bgView];
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
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(@65);
    }];
    
    [_middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bgView);
        make.top.bottom.equalTo(_bgView);
        make.width.mas_equalTo(@1);
    }];
    
    [_mutationRateValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView).offset(10);
        make.width.mas_equalTo((ScreenWidth-25)/2);
        make.left.equalTo(_bgView);
    }];
    
    [_mutationRateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bgView).offset(-10);
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


//
@interface PEFResultSymptomView ()

@property (nonatomic, strong) UILabel *symptomTitle;
@property (nonatomic, strong) UILabel *symptomLabel;

@end
@implementation PEFResultSymptomView

- (id)init{
    
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.symptomTitle];
        [self addSubview:self.symptomLabel];
        
        [self configConstraints];
    }
    return self;
}

- (void)configConstraints{
    
    [_symptomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.top.equalTo(self).offset(10);
    }];
    
    [_symptomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_symptomTitle.mas_left);
        make.top.equalTo(_symptomTitle.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-12.5);
    }];
}

- (void)setPEFResult:(PEFResultModel *)model
{
    if (kStringIsEmpty(model.symptoms)) {
        [_symptomLabel setText:@"无症状"];
        return;
    }

    [_symptomLabel setText:model.symptoms];
}

#pragma mark -- init
- (UILabel *)symptomTitle{
    if (!_symptomTitle) {
        _symptomTitle = [[UILabel alloc] init];
        [_symptomTitle setText:@"当日症状"];
        [_symptomTitle setTextColor:[UIColor mainThemeColor]];
        [_symptomTitle setFont:[UIFont font_28]];
    }
    return _symptomTitle;
}

- (UILabel *)symptomLabel{
    if (!_symptomLabel) {
        _symptomLabel = [[UILabel alloc] init];
        [_symptomLabel setTextColor:[UIColor commonTextColor]];
        [_symptomLabel setFont:[UIFont font_28]];
        [_symptomLabel setNumberOfLines:0];
    }
    return _symptomLabel;
}

@end
