//
//  HMSuperviseFirstDateView.m
//  HMClient
//
//  Created by jasonwang on 2017/7/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperviseFirstDateView.h"

@interface HMSuperviseFirstDateView ()
@property (nonatomic, strong) UILabel *monthLb;
@property (nonatomic, strong) UILabel *yearLb;
@property (nonatomic, strong) UILabel *dayLb;

@end

@implementation HMSuperviseFirstDateView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
        [self addSubview:self.dayLb];
        [self addSubview:self.monthLb];
        [self addSubview:self.yearLb];
        
        [self.dayLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).offset(1);
        }];
        
        [self.monthLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.dayLb.mas_bottom).offset(1);
        }];
        
        [self.yearLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.monthLb.mas_bottom).offset(1);
        }];
    }
    return self;
}

- (void)fillDataWithDate:(NSDate *)date superviseScreening:(SESuperviseScreening)type{
    
    [self.dayLb setText:[date formattedDateWithFormat:@"dd"]];
    [self.monthLb setText:[date formattedDateWithFormat:@"MM月"]];
    [self.yearLb setText:[date formattedDateWithFormat:@"yyyy年"]];
    
    if (type == SESuperviseScreening_Month) {
        // 月均不显示日
        [self.dayLb setHidden:YES];
        
        [self.monthLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).offset(1);
        }];
    }
    else {
        [self.dayLb setHidden:NO];
        [self.monthLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.dayLb.mas_bottom).offset(1);
        }];
    }

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
