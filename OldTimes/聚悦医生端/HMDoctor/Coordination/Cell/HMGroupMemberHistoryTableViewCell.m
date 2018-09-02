//
//  HMGroupMemberHistoryTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/4/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMGroupMemberHistoryTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
@interface HMGroupMemberHistoryTableViewCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *subTitelLb;
@end
@implementation HMGroupMemberHistoryTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.subTitelLb];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.equalTo(@30);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.subTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb.mas_right).offset(5);
            make.centerY.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        }];
    }
    return self;
}


- (void)fillDataWithProfileModel:(UserProfileModel *)profileModel{
    [self.titelLb setText:profileModel.nickName];
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.iconView sd_setImageWithURL:avatarURL(avatarType_80, profileModel.userName) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    [self.subTitelLb setHidden:YES];
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default_staff"]];
        [_iconView.layer setCornerRadius:3];
    }
    return _iconView;
}


- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:16]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _titelLb;
}

- (UILabel *)subTitelLb {
    if (!_subTitelLb) {
        _subTitelLb = [UILabel new];
        [_subTitelLb setFont:[UIFont systemFontOfSize:14]];
        [_subTitelLb setTextColor:[UIColor colorWithHexString:@"f25555"]];
        [_subTitelLb setText:@" 团队长 "];
        [_subTitelLb.layer setBorderWidth:1];
        [_subTitelLb.layer setBorderColor:[[UIColor colorWithHexString:@"f25555"] CGColor]];
        [_subTitelLb.layer setCornerRadius:2];
    }
    return _subTitelLb;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
