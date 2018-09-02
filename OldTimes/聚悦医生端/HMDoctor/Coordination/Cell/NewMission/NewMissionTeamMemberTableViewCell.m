\
//
//  NewMissionTeamMemberTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewMissionTeamMemberTableViewCell.h"
#import <Masonry/Masonry.h>
#import "ServiceGroupMemberModel.h"
@interface NewMissionTeamMemberTableViewCell()
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *detailLb;
@end

@implementation NewMissionTeamMemberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.myImageView];
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.detailLb];
        
        [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@40);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myImageView.mas_right).offset(15);
            make.bottom.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY).offset(5);
            make.left.equalTo(self.titelLb);
        }];
    }
    return self;
}

- (void)fillDataWithModel:(ServiceGroupMemberModel *)model {
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.myImageView sd_setImageWithURL:avatarURL(avatarType_80,[NSString stringWithFormat:@"%ld",(long)model.userId]) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    [self.titelLb setText:model.staffName];
    [self.detailLb setText:model.staffTypeName];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImageView *)myImageView {
    if (!_myImageView) {
        _myImageView = [UIImageView new];
        [_myImageView.layer setCornerRadius:3];
        [_myImageView setClipsToBounds:YES];
    }
    return _myImageView;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:15]];
        [_titelLb setTextColor:[UIColor blackColor]];
    }
    return _titelLb;
}

- (UILabel *)detailLb {
    if (!_detailLb) {
        _detailLb = [UILabel new];
        [_detailLb setFont:[UIFont systemFontOfSize:15]];
        [_detailLb setTextColor:[UIColor lightGrayColor]];
    }
    return _detailLb;
}
@end
