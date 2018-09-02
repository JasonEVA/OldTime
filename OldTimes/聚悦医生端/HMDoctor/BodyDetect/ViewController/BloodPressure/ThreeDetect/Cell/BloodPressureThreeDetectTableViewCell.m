//
//  BloodPressureThreeDetectTableViewCell.m
//  HMClient
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodPressureThreeDetectTableViewCell.h"

@interface BloodPressureThreeDetectTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, strong) UIButton *detectButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *ivImg;

@end

@implementation BloodPressureThreeDetectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(12.5);
            make.right.equalTo(self.contentView).offset(-12.5);
            make.height.mas_equalTo(@40);
        }];
        
        [_bgView addSubview:self.titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bgView);
        }];
        
        [_bgView addSubview:self.ivImg];
        [_ivImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).offset(5);
            make.centerY.equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
//        [self.contentView addSubview:self.detectButton];
//        [_detectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.contentView);
//            make.left.equalTo(self.contentView).offset(12.5);
//            make.right.equalTo(self.contentView).offset(-12.5);
//            make.height.mas_equalTo(@40);
//        }];
    }
    return self;
}

- (void)setDetectButtonTitle:(NSString *)str
{
    [_titleLabel setText:str];
}

- (void)setDetectButtonHidden
{
    [_bgView setHidden:YES];
}

#pragma mark -- init
- (UIView *)bgView{

    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [_bgView setBackgroundColor:[UIColor mainThemeColor]];
        _bgView.alpha = 0.5f;
        [_bgView.layer setCornerRadius:5.0f];
        [_bgView.layer setMasksToBounds:YES];
        [_bgView.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [_bgView.layer setBorderWidth:0.5f];
    }
    return _bgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setText:@"测量血压"];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
        [_titleLabel setFont:[UIFont font_30]];
    }
    return _titleLabel;
}

//- (UIButton *)detectButton {
//    if (!_detectButton) {
//        _detectButton = [UIButton new];
//        [_detectButton setTitle:@"开始测量" forState:UIControlStateNormal];
//        [_detectButton.titleLabel setFont:[UIFont font_32]];
//        [_detectButton setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
//        [_detectButton setBackgroundColor:[UIColor colorWithHexString:@"31c9ba" alpha:0.1]];
//        [_detectButton.layer setCornerRadius:5.0f];
//        [_detectButton.layer setMasksToBounds:YES];
//    }
//    return _detectButton;
//}

- (UIImageView *)ivImg{
    if (!_ivImg) {
        _ivImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history_detail"]];
    }
    return _ivImg;
}


@end


@interface BloodPressureThriceDetectDataTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *detectTimeLabel;
@property (nonatomic, strong) UILabel *xyValueLabel;
@property (nonatomic, strong) UILabel *bpmValueLabel;
@property (nonatomic, strong) UILabel *xyLabel;
@property (nonatomic, strong) UILabel *bmpLabel;

@end

@implementation BloodPressureThriceDetectDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12.5);
            make.right.equalTo(self.contentView).offset(-12.5);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        
        [_bgView addSubview:self.detectTimeLabel];
        [_detectTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_bgView).offset(12.5);
        }];
        
        [_bgView addSubview:self.xyValueLabel];
        [_xyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView);
            make.top.equalTo(_bgView).offset(10);
        }];
        
        [_bgView addSubview:self.bpmValueLabel];
        [_bpmValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_xyValueLabel.mas_top);
            make.right.equalTo(_bgView).offset(-12.5);
        }];
        
        [_bgView addSubview:self.xyLabel];
        [_xyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView);
            make.bottom.equalTo(_bgView).offset(-10);
        }];
        
        [_bgView addSubview:self.bmpLabel];
        [_bmpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bpmValueLabel);
            make.bottom.equalTo(_xyLabel);
        }];
    }
    return self;
}

- (void)setBloodPressureValue:(NSDictionary *)dic
{
    if (kDictIsEmpty(dic)) {
        return;
    }
    [_xyValueLabel setAttributedText:[NSAttributedString getAttributWithChangePart:@"mmHg" UnChangePart:[NSString stringWithFormat:@"%@/%@",dic[@"SSY"],dic[@"SZY"]] UnChangeColor:[UIColor commonTextColor] UnChangeFont:[UIFont font_40]]];
    
    [_bpmValueLabel setAttributedText:[NSAttributedString getAttributWithChangePart:@"bpm" UnChangePart:[NSString stringWithFormat:@"%@",dic[@"XL_OF_XY"]] UnChangeColor:[UIColor commonTextColor] UnChangeFont:[UIFont font_40]]];
    
    NSDate *excDate = [NSDate dateWithString:dic[@"testTime"] formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [excDate formattedDateWithFormat:@"HH:mm"];
    [_detectTimeLabel setText:dateStr];
}

#pragma mark -- init
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor colorWithHexString:@"f6f6f6"]];
    }
    return _bgView;
}

- (UILabel *)xyValueLabel{
    if (!_xyValueLabel) {
        _xyValueLabel = [UILabel new];
        [_xyValueLabel setText:@"120/80mmHg"];
        [_xyValueLabel setTextColor:[UIColor commonTextColor]];
        [_xyValueLabel setFont:[UIFont font_28]];
    }
    return _xyValueLabel;
}

- (UILabel *)bpmValueLabel{
    if (!_bpmValueLabel) {
        _bpmValueLabel = [UILabel new];
        [_bpmValueLabel setText:@"75次/分"];
        [_bpmValueLabel setTextColor:[UIColor commonTextColor]];
        [_bpmValueLabel setFont:[UIFont font_28]];
    }
    return _bpmValueLabel;
}

- (UILabel *)xyLabel{
    if (!_xyLabel) {
        _xyLabel = [UILabel new];
        [_xyLabel setText:@"收缩压／舒张压"];
        [_xyLabel setTextColor:[UIColor commonGrayTextColor]];
        [_xyLabel setFont:[UIFont font_24]];
    }
    return _xyLabel;
}

- (UILabel *)bmpLabel{
    if (!_bmpLabel) {
        _bmpLabel = [UILabel new];
        [_bmpLabel setText:@"心率"];
        [_bmpLabel setTextColor:[UIColor commonGrayTextColor]];
        [_bmpLabel setFont:[UIFont font_24]];
    }
    return _bmpLabel;
}

- (UILabel *)detectTimeLabel{
    if (!_detectTimeLabel) {
        _detectTimeLabel = [UILabel new];
        [_detectTimeLabel setText:@"10:30"];
        [_detectTimeLabel setTextColor:[UIColor commonTextColor]];
        [_detectTimeLabel setFont:[UIFont font_30]];
    }
    return _detectTimeLabel;
}

@end
