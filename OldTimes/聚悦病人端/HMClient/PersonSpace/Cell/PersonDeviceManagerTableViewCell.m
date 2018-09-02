//
//  PersonDeviceManagerTableViewCell.m
//  HMClient
//
//  Created by lkl on 16/4/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonDeviceManagerTableViewCell.h"

@interface PersonDeviceManagerTableViewCell ()
{
    UIImageView *deviceImage;
    UILabel *deviceName;
    UIImageView *arrowImgView;
    UILabel *deviceSelectStatus;
}
@end

@implementation PersonDeviceManagerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        deviceImage = [[UIImageView alloc] init];
        [self.contentView addSubview:deviceImage];
        
        deviceName = [[UILabel alloc] init];
        [deviceName setTextColor:[UIColor colorWithHexString:@"999999"]];
        [deviceName setFont:[UIFont font_28]];
        [self.contentView addSubview:deviceName];
        
        arrowImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:arrowImgView];
        [arrowImgView setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        
        deviceSelectStatus = [[UILabel alloc] init];
        [self.contentView addSubview:deviceSelectStatus];
        [deviceSelectStatus setHidden:YES];
        [deviceSelectStatus setText:@"修改"];
//        [deviceSelectStatus.layer setBorderWidth:1.0f];
//        [deviceSelectStatus.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
//        [deviceSelectStatus.layer setCornerRadius:3.0f];
//        [deviceSelectStatus.layer setMasksToBounds:YES];
        [deviceSelectStatus setFont:[UIFont font_28]];
        [deviceSelectStatus setTextColor:[UIColor mainThemeColor]];
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout
{
    [deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [deviceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceImage.mas_right).with.offset(10);
        make.centerY.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(deviceSelectStatus.mas_left);
    }];
    
    [arrowImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(7, 13));
    }];
    
    [deviceSelectStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setDeviceImage:(NSString *)aImage deviceName:(NSString *)aName
{
    [deviceSelectStatus setHidden:YES];
    [arrowImgView setHidden:NO];
    [deviceImage setImage:[UIImage imageNamed:aImage]];
    [deviceName setText:aName];
    [deviceName setTextColor:[UIColor commonTextColor]];
}

- (void)setdeviceSelectStatus:(BOOL)status
{
    [deviceSelectStatus setHidden:YES];
    if (status) {
        [arrowImgView setHidden:NO];
        [deviceName setTextColor:[UIColor commonGrayTextColor]];
        return;
    }
    [arrowImgView setHidden:YES];
    [deviceName setTextColor:[UIColor commonTextColor]];
}

//设置手环cell显示
- (void)setBraceletDeviceImage:(NSString *)aImage deviceName:(NSString *)aName selectStatusStr:(NSString *)str
{
    [deviceSelectStatus setHidden:NO];
    [arrowImgView setHidden:YES];
    [deviceImage setImage:[UIImage imageNamed:aImage]];
    [deviceName setText:aName];
    [deviceName setTextColor:[UIColor commonTextColor]];
    [deviceSelectStatus setText:str];
}
@end



#pragma mark -------PersonSelectDefaultDeviceTableViewCell

@interface PersonSelectDefaultDeviceTableViewCell ()
{
    UIImageView *icon;
}
@end

@implementation PersonSelectDefaultDeviceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _deviceImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_deviceImage];
        
        _deviceName = [[UILabel alloc] init];
        [_deviceName setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_deviceName setFont:[UIFont font_30]];
        [self.contentView addSubview:_deviceName];
        
        _defaultDeviceStatus = [[UILabel alloc] init];
        [_defaultDeviceStatus setText:@"设为默认"];
        [_defaultDeviceStatus setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_defaultDeviceStatus setFont:[UIFont font_24]];
        [self.contentView addSubview:_defaultDeviceStatus];
        
        icon = [[UIImageView alloc] init];
        [icon setImage:[UIImage imageNamed:@"select_m"]];
        [self.contentView addSubview:icon];
        
        [self subviewsLayout];
        
    }
    return self;
}

- (void)subviewsLayout
{
    [_deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_deviceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deviceImage.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
    [_defaultDeviceStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).with.offset(-15);
        make.centerY.mas_equalTo(self);
    }];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_defaultDeviceStatus.mas_left).with.offset(-20);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)setDeviceImage:(NSString *)aImage
            deviceName:(NSString *)aName
{
    [_deviceImage setImage:[UIImage imageNamed:aImage]];
    [_deviceName setText:aName];
}

- (void)setSelectDeviceStatus
{
    [_defaultDeviceStatus setText:@"默认设备"];
    [_defaultDeviceStatus setTextColor:[UIColor colorWithHexString:@"666666"]];
    
    [icon setImage:[UIImage imageNamed:@"select_s"]];

}

- (void)setDidDeselectDeviceStatus
{
    [_defaultDeviceStatus setText:@"设为默认"];
    [_defaultDeviceStatus setTextColor:[UIColor colorWithHexString:@"999999"]];
    
    [icon setImage:[UIImage imageNamed:@"select_m"]];
}

@end


