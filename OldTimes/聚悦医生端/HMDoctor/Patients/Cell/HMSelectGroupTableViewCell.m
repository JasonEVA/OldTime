//
//  HMSelectGroupTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/6/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSelectGroupTableViewCell.h"
#import "UIImage+JWNameImage.h"

@interface HMSelectGroupTableViewCell ()
@property (nonatomic, strong) UIImageView *ivSelected;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *lbPatientName;
@property (nonatomic, strong) UILabel *countLb;

@end


@implementation HMSelectGroupTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.ivSelected = [[UIImageView alloc]init];
        self.headImageView = [UIImageView new];
        self.lbPatientName = [UILabel new];
        [self.lbPatientName setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.lbPatientName setFont:[UIFont systemFontOfSize:15]];
        self.countLb = [UILabel new];
        [self.countLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self.countLb setFont:[UIFont systemFontOfSize:14]];
        
        [self.contentView addSubview:self.ivSelected];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.lbPatientName];
        [self.contentView addSubview:self.countLb];
        
        [self configElements];
        
        
    }
    return self;
}

- (void)configElements {
    
    [self.ivSelected mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20.5, 20.5));
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ivSelected.mas_right).offset(12.5);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerY.equalTo(self.contentView);
    }];
    
    
    [self.countLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.headImageView);
    }];
    
    [self.lbPatientName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(7);
        make.centerY.equalTo(self.headImageView);
        make.right.lessThanOrEqualTo(self.countLb.mas_left).offset(-5);
    }];
}

- (void)fillDataWith:(NSString *)groupName count:(NSInteger)count isSelected:(BOOL) selected{
    if (selected)
    {
        [self.ivSelected setImage:[UIImage imageNamed:@"c_contact_selected"]];
    }
    else
    {
        [self.ivSelected setImage:[UIImage imageNamed:@"c_contact_unselected"]];
    }
    
    [self.lbPatientName setText:groupName];
    [self.countLb setText:[NSString stringWithFormat:@"%ld",(long)count]];
    
    [self.headImageView setImage:[UIImage JW_acquireNameImageWithNameString:groupName imageSize:CGSizeMake(45, 45)]];

}
@end
