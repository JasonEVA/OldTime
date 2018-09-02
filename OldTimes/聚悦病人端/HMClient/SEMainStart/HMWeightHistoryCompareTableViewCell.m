//
//  HMWeightHistoryCompareTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeightHistoryCompareTableViewCell.h"
#import "HMTZMainDiagramDataModel.h"

@interface HMWeightHistoryCompareTableViewCell ()
@property (nonatomic, strong) UILabel *currentWeightLb;
@property (nonatomic, strong) UILabel *lastCompareLb;
@property (nonatomic, strong) UILabel *fifteenDaysCompareLb;
@property (nonatomic, strong) UIImageView *lastArrow;
@property (nonatomic, strong) UIImageView *fifiteenArrow;

@end
@implementation HMWeightHistoryCompareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.lastCompareLb];
        [self.lastCompareLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView).offset(-5);
            make.top.equalTo(self.contentView.mas_top).offset(25);
        }];
        
        [self.contentView addSubview:self.lastArrow];
        [self.lastArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.lastCompareLb);
            make.left.equalTo(self.lastCompareLb
                              .mas_right).offset(4);
        }];
        
        [self.contentView addSubview:self.currentWeightLb];
        [self.currentWeightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lastCompareLb);
            make.centerX.equalTo(self.contentView.mas_left).offset(50);
        }];
        
        [self.contentView addSubview:self.fifteenDaysCompareLb];
        [self.fifteenDaysCompareLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lastCompareLb);
            make.centerX.equalTo(self.contentView.mas_right).offset(-55);
        }];
        
        [self.contentView addSubview:self.fifiteenArrow];
        
        [self.fifiteenArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.fifteenDaysCompareLb);
            make.left.equalTo(self.fifteenDaysCompareLb.mas_right).offset(4);
        }];
        
        UILabel *stepCountUnitLb = [UILabel new];
        [stepCountUnitLb setText:@"当前体重"];
        [stepCountUnitLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [stepCountUnitLb setFont:[UIFont systemFontOfSize:14]];
        
        UILabel *distanceUnitLb = [UILabel new];
        [distanceUnitLb setText:@"比上次"];
        [distanceUnitLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [distanceUnitLb setFont:[UIFont systemFontOfSize:14]];
        
        UILabel *calorieLbUnitLb = [UILabel new];
        [calorieLbUnitLb setText:@"比15天前"];
        [calorieLbUnitLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [calorieLbUnitLb setFont:[UIFont systemFontOfSize:14]];
        
        [self.contentView addSubview:stepCountUnitLb];
        [self.contentView addSubview:distanceUnitLb];
        [self.contentView addSubview:calorieLbUnitLb];
        
        [stepCountUnitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.currentWeightLb);
            make.top.equalTo(self.currentWeightLb.mas_bottom).offset(10);
        }];
        
        [distanceUnitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.lastCompareLb).offset(5);
            make.centerY.equalTo(stepCountUnitLb);
        }];
        
        [calorieLbUnitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.fifteenDaysCompareLb).offset(5);
            make.centerY.equalTo(stepCountUnitLb);
        }];
        
        
        UILabel *knowWhoFastLb = [UILabel new];
        [knowWhoFastLb setText:@"想知道谁瘦的更快？"];
        [knowWhoFastLb setTextColor:[UIColor mainThemeColor]];
        [knowWhoFastLb setFont:[UIFont systemFontOfSize:16]];
        [knowWhoFastLb.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [knowWhoFastLb.layer setBorderWidth:1];
        [knowWhoFastLb.layer setCornerRadius:3];
        [knowWhoFastLb setTextAlignment:NSTextAlignmentCenter];
        
        [self.contentView addSubview:knowWhoFastLb];
        [knowWhoFastLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@210);
            make.height.equalTo(@40);
            make.top.equalTo(calorieLbUnitLb.mas_bottom).offset(25);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];

    }
    return self;
}

- (void)fillDataWithModel:(HMTZMainDiagramDataModel *)model {
    
    
    if (!model.nowTz || !model.nowTz.length) {
        [self.currentWeightLb setText:@"— —"];
    }
    else {
         [self.currentWeightLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@kg",model.nowTz] UnChangePart:@"kg" changePart:[NSString stringWithFormat:@"%@",model.nowTz] changeColor:[UIColor colorWithHexString:@"333333"] changeFont:[UIFont systemFontOfSize:27]]];
    }
    
    if (!model.lastTimeTz || !model.lastTimeTz.length) {
        [self.lastCompareLb setText:@"— —"];
    }
    else {
        NSString *absLast = [NSString stringWithFormat:@"%.1f",fabsf(model.lastTimeTz.floatValue)];
        [self.lastCompareLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@kg",absLast] UnChangePart:@"kg" changePart:[NSString stringWithFormat:@"%@",absLast] changeColor:[UIColor colorWithHexString:@"333333"] changeFont:[UIFont systemFontOfSize:27]]];
    }
    
    if (!model.b15dayTz || !model.b15dayTz.length) {
        [self.fifteenDaysCompareLb setText:@"— —"];
    }
    else {
        
        NSString *absFiftrrn = [NSString stringWithFormat:@"%.1f",fabsf(model.b15dayTz.floatValue)];
        
        [self.fifteenDaysCompareLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@kg",absFiftrrn] UnChangePart:@"kg" changePart:[NSString stringWithFormat:@"%@",absFiftrrn] changeColor:[UIColor colorWithHexString:@"333333"] changeFont:[UIFont systemFontOfSize:27]]];
    }
    
    NSString *imageName = @"";
    if (model.lastTimeTz.floatValue > 0) {
        imageName = @"ic_increase";
    }
    else if (model.lastTimeTz.floatValue < 0) {
        imageName = @"ic_reduce";
    }
    
    [self.lastArrow setImage:[UIImage imageNamed:imageName]];
    
    NSString *fifimageName = @"";
    if (model.b15dayTz.floatValue > 0) {
        fifimageName = @"ic_increase";
    }
    else if (model.b15dayTz.floatValue < 0) {
        fifimageName = @"ic_reduce";
    }
    
    [self.fifiteenArrow setImage:[UIImage imageNamed:fifimageName]];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)currentWeightLb {
    if (!_currentWeightLb) {
        _currentWeightLb = [UILabel new];
        [_currentWeightLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_currentWeightLb setFont:[UIFont systemFontOfSize:15]];
    }
    return _currentWeightLb;
}

- (UILabel *)lastCompareLb {
    if (!_lastCompareLb) {
        _lastCompareLb = [UILabel new];
        [_lastCompareLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_lastCompareLb setFont:[UIFont systemFontOfSize:15]];
    }
    return _lastCompareLb;
}

- (UILabel *)fifteenDaysCompareLb {
    if (!_fifteenDaysCompareLb) {
        _fifteenDaysCompareLb = [UILabel new];
        [_fifteenDaysCompareLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_fifteenDaysCompareLb setFont:[UIFont systemFontOfSize:15]];
    }
    return _fifteenDaysCompareLb;
}

- (UIImageView *)lastArrow {
    if (!_lastArrow) {
        _lastArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_increase"]];;
    }
    return _lastArrow;
}

- (UIImageView *)fifiteenArrow {
    if (!_fifiteenArrow) {
        _fifiteenArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_reduce"]];;
    }
    return _fifiteenArrow;
}
@end
