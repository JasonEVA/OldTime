//
//  HMNewPatientSelectTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2016/10/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMNewPatientSelectTableViewCell.h"

@implementation HMNewPatientSelectTableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ivSelected = [[UIImageView alloc]init];
        [self.contentView addSubview:ivSelected];
        
        [self configElements];

        
    }
    return self;
}

- (void)configElements {
    [lbComment mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-35);
    }];
    
    [ivSelected mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20.5, 20.5));
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivSelected.mas_right).offset(12.5);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerY.equalTo(self.contentView);
    }];
    
    [lbPatientName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(7);
        make.top.equalTo(self.headImageView).with.offset(2.5);
    }];
    
    [lbPatientAge mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPatientName.mas_right).offset(5);
        make.bottom.equalTo(lbPatientName.mas_bottom);
    }];
    
    [lbComment mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPatientName);
        make.top.equalTo(lbPatientName.mas_bottom).with.offset(3.5);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        
    }];
}

- (void) setIsSelected:(BOOL) selected
{
    //c_contact_nonSelect c_contact_selected
    if (selected)
    {
        [ivSelected setImage:[UIImage imageNamed:@"c_contact_selected"]];
    }
    else
    {
        [ivSelected setImage:[UIImage imageNamed:@"c_contact_unselected"]];
    }
}

@end
