//
//  HMHistoryCollectBaseTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/4.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMHistoryCollectBaseTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "NSDate+MsgManager.h"
@implementation HMHistoryCollectBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nikeNameLb];
        [self.contentView addSubview:self.timeLb];
        [self baseConfigElements];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -private method
- (void)baseConfigElements {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.height.width.equalTo(@25);
    }];
    
    [self.nikeNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(10);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.iconView);
//        make.left.lessThanOrEqualTo(self.nikeNameLb.mas_right).offset(20);
    }];
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)setBaseDataWithModel:(MessageBaseModel *)model {
    NSString *timeString = [NSDate im_dateFormaterWithTimeInterval:model._createDate];
    [self.timeLb setText:[NSString stringWithFormat:@"收藏于 %@",timeString]];
    
    [self.nikeNameLb setText:[model getNickName]];
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.iconView sd_setImageWithURL:avatarURL(avatarType_80, [model getUserName]) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
}
#pragma mark - init UI

- (UIImageView *)iconView {
    if(!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default_user"]];
        [_iconView.layer setCornerRadius:12.5];
        [_iconView setClipsToBounds:YES];
    }
    return _iconView;
}

- (UILabel *)nikeNameLb {
    if (!_nikeNameLb) {
        _nikeNameLb = [UILabel new];
        [_nikeNameLb setFont:[UIFont font_28]];
        [_nikeNameLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_nikeNameLb setText:@"Jason"];
    }
    return _nikeNameLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb setFont:[UIFont font_28]];
        [_timeLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_timeLb setText:@"今天"];

    }
    return _timeLb;
}

@end
