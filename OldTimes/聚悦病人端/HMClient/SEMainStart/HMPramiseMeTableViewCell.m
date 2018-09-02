//
//  HMPramiseMeTableViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMPramiseMeTableViewCell.h"
#import "HMPramiseMeModel.h"
#import "AvatarUtil.h"
#import "UIImage+JWNameImage.h"

@interface HMPramiseMeTableViewCell ()
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *timeLb;
@end
@implementation HMPramiseMeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.headView];
        [self.contentView addSubview:self.nameLb];
        [self.contentView addSubview:self.timeLb];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.equalTo(@40);
        }];
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.headView.mas_right).offset(15);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
        }];

    }
    return self;
}

- (void)fillDataWith:(HMPramiseMeModel *)model {
    NSURL *urlHead = avatarURL(avatarType_80, [NSString stringWithFormat:@"%ld",model.userId]);
    [self.headView sd_setImageWithURL:urlHead placeholderImage:[UIImage JW_acquireNameImageWithNameString:model.userName imageSize:CGSizeMake(40, 40)]];
    [self.nameLb setText:model.userName];
    NSString *dateString = @"";
    NSDate *date = [NSDate dateWithString:model.favourTime formatString:@"yyyy-MM-dd HH-mm-ss"];
    if ([date isToday]) {
        dateString = [date formattedDateWithFormat:@"HH:mm"];
    }
    else {
        dateString = [date formattedDateWithFormat:@"MM:dd"];
    }
    [self.timeLb setText:dateString];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user_head_80"]];
        [_headView.layer setCornerRadius:20];
        [_headView setClipsToBounds:YES];
    }
    return _headView;
}

- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [UILabel new];
        [_nameLb setText:@"微辣"];
        [_nameLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_nameLb setFont:[UIFont systemFontOfSize:16]];
    }
    return _nameLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb setText:@"17：55"];
        [_timeLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_timeLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _timeLb;
}
@end
