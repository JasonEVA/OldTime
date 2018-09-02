//
//  HMThirdEditionPatitentInfoHeaderTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 2017/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMThirdEditionPatitentInfoHeaderTableViewCell.h"
#import "HMThirdEditionPatitentInfoModel.h"

@interface HMThirdEditionPatitentInfoHeaderTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *lbPatientName;
@property (nonatomic, strong) UILabel *lbPatientSexAndAge;
@property (nonatomic, strong) UILabel *lbPatientAge;
@property (nonatomic, strong) UILabel *lbPatientPhone;
@property (nonatomic, strong) UILabel *lbPayment;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *mobileStr;

@end

@implementation HMThirdEditionPatitentInfoHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headerImage];
        [self.contentView addSubview:self.lbPatientName];
        [self.contentView addSubview:self.lbPatientSexAndAge];
        [self.contentView addSubview:self.lbPatientPhone];
        [self.contentView addSubview:self.lbPayment];
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(patientPhoneClick)];
        [self.lbPatientPhone setUserInteractionEnabled:YES];
        [self.lbPatientPhone addGestureRecognizer:gest];
        
        [self configElements];
    }
    return self;
}

- (void)configElements {
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.lbPatientName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImage.mas_right).offset(10);
        make.top.equalTo(_headerImage.mas_top);
    }];
    
    [self.lbPatientSexAndAge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lbPatientName.mas_right).offset(15);
        make.bottom.equalTo(_lbPatientName.mas_bottom);
    }];
    
    [self.lbPatientPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lbPatientName.mas_left);
        make.bottom.equalTo(_headerImage.mas_bottom);
    }];
    
    [self.lbPayment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lbPatientSexAndAge.mas_right).offset(15);
        make.top.equalTo(_lbPatientSexAndAge.mas_top);
    }];
}

- (void)setPatientInfoHeader:(HMThirdEditionPatitentInfoModel *)model
{
    if (!model) {
        return;
    }
    if (model.payment == 2){
        [self.lbPayment setHidden:NO];
    }
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.userInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
    [_lbPatientName setText:model.userInfo.userName];
    [_lbPatientSexAndAge setText:[NSString stringWithFormat:@"%@ | %ld岁",model.userInfo.sex,model.userInfo.age]];
    [_lbPatientPhone setText:[NSString stringWithFormat:@"联系电话：%@",model.userInfo.mobile]];
    _mobileStr = model.userInfo.mobile;
}

- (void)patientPhoneClick
{
    if (!_mobileStr) {
        return;
    }
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_mobileStr]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}

- (UIImageView *)headerImage
{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] init];

    }
    return _headerImage;
}

- (UILabel *)lbPatientName{
    if (!_lbPatientName) {
        _lbPatientName = [[UILabel alloc] init];
        [_lbPatientName setFont:[UIFont font_32]];
        [_lbPatientName setTextColor:[UIColor commonBlackTextColor_333333]];
    }
    return _lbPatientName;
}

- (UILabel *)lbPatientSexAndAge{
    if (!_lbPatientSexAndAge) {
        _lbPatientSexAndAge = [[UILabel alloc] init];
        [_lbPatientSexAndAge setFont:[UIFont font_28]];
        [_lbPatientSexAndAge setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    return _lbPatientSexAndAge;
}

- (UILabel *)lbPayment{
    if (!_lbPayment) {
        _lbPayment = [[UILabel alloc] init];
        [_lbPayment setFont:[UIFont font_28]];
        [_lbPayment setBackgroundColor:[UIColor colorWithHexString:@"B0C4DE"]];
        [_lbPayment setTextColor:[UIColor mainThemeColor]];
        [_lbPayment setText:@"收费"];
        [_lbPayment setHidden:YES];
    }
    return _lbPayment;
}

- (UILabel *)lbPatientPhone{
    if (!_lbPatientPhone) {
        _lbPatientPhone = [[UILabel alloc] init];
        [_lbPatientPhone setFont:[UIFont font_28]];
        [_lbPatientPhone setTextColor:[UIColor commonLightGrayColor_999999]];
        [_lbPatientPhone setText:@"联系电话："];
    }
    return _lbPatientPhone;
}
@end
