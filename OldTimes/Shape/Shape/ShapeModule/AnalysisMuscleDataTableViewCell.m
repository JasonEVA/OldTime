//
//  AnalysisMuscleDataTableViewCell.m
//  Shape
//
//  Created by Andrew Shen on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "AnalysisMuscleDataTableViewCell.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "UILabel+EX.h"
#import "MuscleModel.h"

@interface AnalysisMuscleDataTableViewCell()
@property (nonatomic, strong)  UILabel  *title; // <##>
@property (nonatomic, strong)  UILabel  *percentage; // <##>
@property (nonatomic, strong)  UIProgressView  *progressView; // <##>
@property (nonatomic, strong)  UILabel  *times; // <##>
@property (nonatomic, strong)  UILabel  *cal; // <##>
@end

@implementation AnalysisMuscleDataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor themeBackground_373737]];
        [self setSeparatorInset:UIEdgeInsetsZero];
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }

        //
        [self addSubview:self.title];
        [self addSubview:self.percentage];
        [self addSubview:self.progressView];
        [self addSubview:self.times];
        [self addSubview:self.cal];
        
        [self initConstraints];
    }
    return self;
}

- (void)initConstraints {
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(leftSpacing);
        make.centerY.equalTo(self);
    }];
    [self.percentage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(55);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.percentage);
        make.right.equalTo(self.times.mas_left).offset(-15);
        make.top.equalTo(self.mas_centerY).offset(3);
        make.height.equalTo(@7);
    }];
    [self.times mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.cal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-rightSpacing);
    }];
}

- (void)setCellData:(MuscleModel *)model totalTrainingTimes:(NSInteger)totalTimes{
    [self.title setText:model.muscleName];
    [self.times setText:[NSString stringWithFormat:@"%ld次",(long)model.trainingTimes.integerValue]];
    [self.cal setText:[NSString stringWithFormat:@"%ld卡",(long)model.calories.integerValue]];
    CGFloat percentage = totalTimes > 0 ? (CGFloat)model.trainingTimes.integerValue / (CGFloat)totalTimes : 0;
    [self.percentage setText:[NSString stringWithFormat:@"%.1f%%",percentage * 100]];
    [self.progressView setProgress:percentage];
}
#pragma mark - Init
- (UILabel *)title {
    if (!_title) {
        _title = [UILabel setLabel:_title text:@"" font:[UIFont systemFontOfSize:17] textColor:[UIColor whiteColor]];
    }
    return _title;
}
- (UILabel *)percentage {
    if (!_percentage) {
        _percentage = [UILabel setLabel:_percentage text:@"0%" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _percentage;
}
- (UILabel *)times {
    if (!_times) {
        _times = [UILabel setLabel:_times text:@"0次" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _times;
}
- (UILabel *)cal {
    if (!_cal) {
        _cal = [UILabel setLabel:_cal text:@"0卡" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _cal;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressView setTrackTintColor:[UIColor clearColor]];
        [_progressView setTintColor:[UIColor themeOrange_ff5d2b]];
        [_progressView setProgress:0];
        [_progressView.layer setCornerRadius:3.5];
        [_progressView.layer setMasksToBounds:YES];
    }
    return _progressView;
}

@end
