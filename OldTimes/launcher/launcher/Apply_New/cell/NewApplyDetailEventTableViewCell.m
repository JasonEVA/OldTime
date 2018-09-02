//
//  NewApplyDetailEventTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyDetailEventTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIFont+Util.h"
#import <Masonry/Masonry.h>

#import "UIImageView+WebCache.h"
#import "MyDefine.h"
#import "AvatarUtil.h"
#import "NSDate+String.h"
#import "DateTools.h"
#import "UIImage+Manager.h"

typedef enum
{
    UNACCEPT = 0,       // 不被接受
    ACCEPT,             // 接受
    CANCLED,            // 驳回
    DEALING,            // 进行中
    ACCEPTADNTRANSFER   // 待审批
} APPLYEVENTSTATE;       // 请求事件状态

@interface NewApplyDetailEventTableViewCell()
@property (nonatomic, strong) UIImageView *imgHead;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UILabel *lblEnergency;
@property (nonatomic, strong) UIImageView *imgendTime;
@property (nonatomic, strong) UILabel *lblEndTime;
@property (nonatomic , strong)  UIButton *stateBtn;
@end

@implementation NewApplyDetailEventTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor mtc_colorWithHex:0xf5f5f5];
        
        [self.contentView addSubview:self.imgHead];
        [self.contentView addSubview:self.lblName];
        [self.contentView addSubview:self.lblTime];
        [self.contentView addSubview:self.lblEnergency];
        [self.contentView addSubview:self.imgendTime];
        [self.contentView addSubview:self.lblEndTime];
        [self.contentView addSubview:self.stateBtn];
        [self setframes];
    }
    return self;
}

- (void)setframes
{
    [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.contentView).offset(12);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgHead.mas_right).offset(5);
        make.top.equalTo(self.imgHead);
        make.height.equalTo(@15);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgHead.mas_right).offset(5);
        make.top.equalTo(self.lblName.mas_bottom);
        make.bottom.equalTo(self.imgHead.mas_bottom);
    }];
    
    [self.lblEnergency mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stateBtn.mas_left).offset(-5);
//        make.top.equalTo(self.imgHead);
        make.centerY.equalTo(self.stateBtn);
        make.height.equalTo(self.lblName);
    }];
    
    [self.lblEndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblEnergency.mas_bottom);
        make.right.equalTo(self.stateBtn);
        make.bottom.equalTo(self.imgHead);
    }];
    
    [self.imgendTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@10);
        make.centerY.equalTo(self.lblEndTime);
        make.right.equalTo(self.lblEndTime.mas_left).offset(-5);
    }];
    
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
        make.right.equalTo(self.contentView).offset(-12.5);
        make.width.equalTo(@55);
        make.height.equalTo(@20);
    }];
}

- (void)setmodel:(ApplyDetailInformationModel *)model
{
    [self.imgHead sd_setImageWithURL:avatarURL(avatarType_80, model.CREATE_USER) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    self.lblName.text = model.CREATE_USER_NAME? : @"";
	self.lblTime.text = [model getFormattedCreateTime];
	self.lblEnergency.text = model.A_IS_URGENT ? LOCAL(APPLY_ADD_PRIORITY_TITLE) : @"";
	self.lblEndTime.text = model.A_IS_URGENT ? @"" : [model getFormattedDeadLineTime];
	self.imgendTime.hidden = [self.lblEndTime.text isEqualToString:@""];
    [self setStateTitle:model.A_STATUS];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setStateTitle:(NSString *)statusTitle
{
    //根据statu动态改变颜色
    if ([statusTitle isEqualToString:@"APPROVE"])
    {
        [self changeStatement:ACCEPT];
    }
    if ([statusTitle isEqualToString:@"WAITING"])
    {
        [self changeStatement:ACCEPTADNTRANSFER];
    }
    if ([statusTitle isEqualToString:@"IN_PROGRESS"])
    {
        [self changeStatement:DEALING];
    }
    if ([statusTitle isEqualToString:@"DENY"])
    {
        [self changeStatement:UNACCEPT];
    }
    if ([statusTitle isEqualToString:@"CALL_BACK"])
    {
        [self changeStatement:CANCLED];
    }
}

#pragma mark - Pravite Method
- (void)changeStatement:(APPLYEVENTSTATE)state
{
    switch (state) {
        case UNACCEPT:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeRed]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_UNACCEPT_TITLE) forState:UIControlStateNormal];
            break;
        }
        case ACCEPT:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x22c064]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_ACCEPT_TITLE) forState:UIControlStateNormal];
            break;
        }
        case CANCLED:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0xff8447]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_BACKWARD_TITLE) forState:UIControlStateNormal];
            break;
        }
        case DEALING:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x0099ff]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_DEALING_TITLE) forState:UIControlStateNormal];
            break;
        }
        case ACCEPTADNTRANSFER:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x0099ff]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_WAITDEAL_TITLE) forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

#pragma mark - init
- (UIButton *)stateBtn
{
    if (!_stateBtn)
    {
        _stateBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _stateBtn.layer.cornerRadius = 10.0;
        _stateBtn.layer.masksToBounds = YES;
        [_stateBtn setTintColor:[UIColor whiteColor]];
        _stateBtn.titleLabel.font = [UIFont mtc_font_24];
        _stateBtn.userInteractionEnabled = NO;
    }
    return _stateBtn;
}

- (UIImageView *)imgHead
{
    if (!_imgHead)
    {
        _imgHead = [[UIImageView alloc] init];
        _imgHead.layer.cornerRadius = 2.0f;
    }
    return _imgHead;
}

- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
        _lblName.textColor = [UIColor mtc_colorWithHex:0x666666];
        _lblName.textAlignment = NSTextAlignmentLeft;
        [_lblName setFont:[UIFont mtc_font_26]];
    }
    return _lblName;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        _lblTime.textAlignment = NSTextAlignmentLeft;
        _lblTime.textColor = [UIColor mtc_colorWithHex:0x999999];
        [_lblTime setFont:[UIFont mtc_font_24]];
    }
    return _lblTime;
}

- (UILabel *)lblEnergency
{
    if (!_lblEnergency)
    {
        _lblEnergency = [[UILabel alloc] init];
        _lblEnergency.textColor = [UIColor themeRed];
        _lblEnergency.textAlignment = NSTextAlignmentRight;
        _lblEnergency.font = [UIFont mtc_font_26];
    }
    return _lblEnergency;
}

- (UILabel *)lblEndTime
{
    if (!_lblEndTime)
    {
        _lblEndTime = [[UILabel alloc] init];
        _lblEndTime.textAlignment = NSTextAlignmentRight;
        _lblEndTime.font = [UIFont mtc_font_24];
        _lblEndTime.textColor = [UIColor themeRed];
    }
    return _lblEndTime;
}

- (UIImageView *)imgendTime
{
    if (!_imgendTime)
    {
        _imgendTime = [[UIImageView alloc] init];
        [_imgendTime setImage:[UIImage imageNamed:@"shalou"]];
    }
    return _imgendTime;
}
@end
