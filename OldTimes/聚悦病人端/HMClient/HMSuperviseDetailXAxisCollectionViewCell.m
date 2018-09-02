//
//  HMSuperviseDetailXAxisCollectionViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/7/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperviseDetailXAxisCollectionViewCell.h"

@interface HMSuperviseDetailXAxisCollectionViewCell ()
@property (nonatomic, strong) UILabel *monthLb;
@property (nonatomic, strong) UILabel *yearLb;
@end

@implementation HMSuperviseDetailXAxisCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];

        
        [self.contentView addSubview:self.dayLb];
        [self.contentView addSubview:self.monthLb];
        [self.contentView addSubview:self.yearLb];
        
        [self.dayLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(1);
        }];
        
        [self.monthLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.dayLb.mas_bottom).offset(1);
        }];
        
        [self.yearLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.monthLb.mas_bottom).offset(1);
        }];
    }
    return self;
}

- (void)fillDataWithDate:(NSDate *)date isHide:(BOOL)isHide showDay:(BOOL)showDay showMonth:(BOOL)showMonth showYear:(BOOL)showYear superviseScreeningType:(SESuperviseScreening)type{
    
    if (type == SESuperviseScreening_Month) {
        // 月均不显示日
        [self.monthLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(1);
        }];
    }
    else {
        [self.monthLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.dayLb.mas_bottom).offset(1);
        }];
    }

    
    [self.dayLb setHidden:isHide || !showDay || type == SESuperviseScreening_Month];
    [self.monthLb setHidden:isHide || !showMonth];
    [self.yearLb setHidden:isHide || !showYear];
    
    [self.dayLb setText:[date formattedDateWithFormat:@"dd"]];
    [self.monthLb setText:[date formattedDateWithFormat:@"MM月"]];
    [self.yearLb setText:[date formattedDateWithFormat:@"yyyy年"]];
    
   
}

- (UILabel *)dayLb {
    if (!_dayLb) {
        _dayLb = [UILabel new];
        [_dayLb setFont:[UIFont systemFontOfSize:11]];
        [_dayLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _dayLb;
}

- (UILabel *)monthLb {
    if (!_monthLb) {
        _monthLb = [UILabel new];
        [_monthLb setFont:[UIFont systemFontOfSize:11]];
        [_monthLb setTextColor:[UIColor colorWithHexString:@"31c9ba"]];
    }
    return _monthLb;
}
- (UILabel *)yearLb {
    if (!_yearLb) {
        _yearLb = [UILabel new];
        [_yearLb setFont:[UIFont systemFontOfSize:11]];
        [_yearLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _yearLb;
}
@end
