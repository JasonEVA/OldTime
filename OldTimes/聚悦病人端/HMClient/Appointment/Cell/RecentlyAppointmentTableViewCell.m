//
//  RecentlyAppointmentTableViewCell.m
//  HMClient
//
//  Created by yinquan on 2017/10/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "RecentlyAppointmentTableViewCell.h"
#import "RecentlyAppointmentModel.h"
#import "HMWebViewController.h"
#import "ClientHelper.h"

@interface RecentlyAppointmentTableViewCell()

@property (nonatomic, assign) NSInteger staffId;

@property (nonatomic, strong) UIImageView* portraitImageView;
@property (nonatomic, strong) UILabel* staffNameLabel;
@property (nonatomic, strong) UILabel* staffTypeLabel;
@property (nonatomic, strong) UIButton* purchaseButton;

@end

@implementation RecentlyAppointmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutElemnets];
    }
    return self;
}

- (void) setRecentlyAppointmentModel:(RecentlyAppointmentModel*) model{
    [self.portraitImageView setImage:[UIImage imageNamed:@"img_default_staff"]];
    if (model.imgUrl) {
        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    
    [self.staffNameLabel setText:model.staffName];
    [self.staffTypeLabel setText:model.staffTypeName];
    
    [self.purchaseButton setEnabled:(model.productCount > 0)];
    
    self.staffId = model.staffId;
}

- (void) layoutElemnets{
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.contentView).offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.staffNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitImageView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.staffTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.staffNameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.purchaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 25));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12.5);
    }];
}

#pragma mark - button click envent
- (void) purchaseButtonClicked:(id) sender{
    //跳转到医生的服务列表界面 HMWebViewController
    UserInfo* user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSString* urlString = [NSString stringWithFormat:@"%@/doctor/introduce.htm?staffId=%ld&userId=%ld&fromapp=Y", kBaseShopUrl, self.staffId, user.userId];
    HMBasePageViewController* webViewController = [HMViewControllerManager createViewControllerWithControllerName:@"HMWebViewController" ControllerObject:urlString];
    webViewController.navigationItem.title = @"服务";
    
}

#pragma mark - settingAndGetting
- (UIImageView*) portraitImageView{
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default_staff"]];
        [self.contentView addSubview:_portraitImageView];
        _portraitImageView.layer.cornerRadius = 20;
        _portraitImageView.layer.masksToBounds = YES;
    }
    return _portraitImageView;
}

- (UILabel*) staffNameLabel{
    if (!_staffNameLabel) {
        _staffNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_staffNameLabel];
        [_staffNameLabel setFont:[UIFont font_30]];
        [_staffNameLabel setTextColor:[UIColor commonTextColor]];
    }
    return _staffNameLabel;
}

- (UILabel*) staffTypeLabel{
    if (!_staffTypeLabel) {
        _staffTypeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_staffTypeLabel];
        [_staffTypeLabel setFont:[UIFont font_24]];
        [_staffTypeLabel setTextColor:[UIColor commonGrayTextColor]];
    }
    return _staffTypeLabel;
}

- (UIButton*) purchaseButton
{
    if (!_purchaseButton) {
        _purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_purchaseButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_purchaseButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 40) Color:[UIColor commonDarkGrayTextColor]] forState:UIControlStateDisabled];
        [_purchaseButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_purchaseButton setTitle:@"再次购买" forState:(UIControlState)UIControlStateNormal];
        [_purchaseButton setTitle:@"暂无服务" forState:(UIControlState)UIControlStateDisabled];
        
        [self.contentView addSubview:_purchaseButton];
        _purchaseButton.layer.cornerRadius = 3;
        _purchaseButton.layer.masksToBounds = YES;
        [_purchaseButton addTarget:self action:@selector(purchaseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _purchaseButton;
}
@end
