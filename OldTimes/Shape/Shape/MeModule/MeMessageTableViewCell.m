//
//  MeMessageTableViewCell.m
//  Shape
//
//  Created by jasonwang on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeMessageTableViewCell.h"
#import <Masonry.h>
#import "UIColor+Hex.h"

#define FONT14 14
#define FONT16 16

@interface MeMessageTableViewCell()

@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *locationLb;

@end

@implementation MeMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.myImageView];
        [self addSubview:self.nameLb];
        [self addSubview:self.sexImageView];
        [self addSubview:self.locationLb];
        [self updateConstraints];
        
    }
    return self;
}


- (void)setMyData:(MeGetUserInfoModel *)model
{
    [self.nameLb setText:model.userName];
    [self.locationLb setText:model.location];
    if (model.gender == 1) {
        [self.sexImageView setImage:[UIImage imageNamed:@"me_man"]];
    }
    else if (model.gender == 0)
    {
        [self.sexImageView setImage:[UIImage imageNamed:@"me_women"]];
    }
}

- (void)updateConstraints
{
    [self.myImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.myImageView.mas_height);
        make.left.equalTo(self).offset(30);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImageView.mas_right).offset(18);
        make.bottom.equalTo(self.mas_centerY).offset(-7);
        make.right.equalTo(self).offset(5);
    }];
    
    [self.sexImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.mas_centerY).offset(7);
    }];
    
    [self.locationLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexImageView.mas_right).offset(8);
        make.centerY.equalTo(self.sexImageView);
    }];
    [super updateConstraints];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init UI

- (UIImageView *)myImageView
{
    
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc]init];
        [_myImageView setImage:[UIImage imageNamed:@"me_icon"]];
        _myImageView.layer.cornerRadius = 31;
        [_myImageView setClipsToBounds:YES];
    }
    return _myImageView;
}

- (UIImageView *)sexImageView
{
    
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc]init];
        [_sexImageView setImage:[UIImage imageNamed:@"me_man"]];
    }
    return _sexImageView;
}

- (UILabel *)nameLb
{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        [_nameLb setText:@"Shape官方"];
        [_nameLb setTextColor:[UIColor whiteColor]];
        _nameLb.font = [UIFont systemFontOfSize:16];
    }
    return _nameLb;
}

- (UILabel *)locationLb
{
    if (!_locationLb) {
        _locationLb = [[UILabel alloc]init];
        [_locationLb setText:@"浙江 杭州"];
        [_locationLb setTextColor:[UIColor colorLightGray_989898]];
        _locationLb.font = [UIFont systemFontOfSize:14];
    }
    return _locationLb;
}
@end
