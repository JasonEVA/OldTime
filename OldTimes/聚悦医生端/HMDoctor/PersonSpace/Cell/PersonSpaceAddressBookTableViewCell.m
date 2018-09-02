//
//  PersonSpaceAddressBookTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceAddressBookTableViewCell.h"

@interface PersonSpaceAddressBookTableViewCell ()
{
    UILabel *lbStaffName;
    UILabel *lbDepName;
    UILabel *lbHomeTel;
    UIImageView *ivPhone;
}

@end

@implementation PersonSpaceAddressBookTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        lbStaffName = [[UILabel alloc] init];
        [self addSubview:lbStaffName];
        [lbStaffName setTextColor:[UIColor commonTextColor]];
        [lbStaffName setFont:[UIFont systemFontOfSize:15]];
        [lbStaffName setTextAlignment:NSTextAlignmentCenter];
        
        lbDepName = [[UILabel alloc] init];
        [self addSubview:lbDepName];
        [lbDepName setTextColor:[UIColor commonTextColor]];
        [lbDepName setFont:[UIFont systemFontOfSize:15]];
        [lbDepName setTextAlignment:NSTextAlignmentCenter];
        
        ivPhone = [[UIImageView alloc] init];
        [self addSubview:ivPhone];
        [ivPhone setImage:[UIImage imageNamed:@"icon_maillist_phone"]];
        
        _homeTelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_homeTelBtn];
        [_homeTelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_homeTelBtn setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100*kScreenScale);
    }];
    
    [lbDepName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbStaffName.mas_right);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100*kScreenScale);
    }];
    
    [ivPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDepName.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 14));
    }];
    
    [_homeTelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivPhone.mas_right).with.offset(5);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100*kScreenScale);
    }];
    
}

- (void)setAddressBookInfo:(AddressBookInfo *)info
{
    if (info) {
        [lbStaffName setText:info.staffName];
        [lbDepName setText:info.depName];
        [_homeTelBtn setTitle:info.homeTel forState:UIControlStateNormal];
    }
}

@end
