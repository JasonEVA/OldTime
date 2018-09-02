//
//  BloodPressureThriceDetectSuggestTableViewCell.m
//  HMClient
//
//  Created by lkl on 2017/5/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodPressureThriceDetectSuggestTableViewCell.h"

@interface BloodPressureThriceDetectSuggestTableViewCell ()

@property (nonatomic, strong) UILabel *suggestLabel;
@property (nonatomic, strong) UIImageView *ivImg;

@end

@implementation BloodPressureThriceDetectSuggestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.suggestLabel];
        [_suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12.5);
            make.right.equalTo(self.contentView).offset(-12.5);
            make.center.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.ivImg];
        [_ivImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@5);
        }];
    }
    return self;
}

#pragma mark -- init
- (UILabel *)suggestLabel {
    if (!_suggestLabel) {
        _suggestLabel = [UILabel new];
        [_suggestLabel setFont:[UIFont font_30]];
        [_suggestLabel setTextColor:[UIColor commonDarkGrayTextColor]];
        [_suggestLabel setNumberOfLines:0];
        [_suggestLabel setText:@"经医生建议，测量时，为保证血压数据的准确性，需在十分钟之内测量1～3次，每次间隔约1-3分钟，每次测量结束后请松开臂带重新绑定。"];
    }
    return _suggestLabel;
}

- (UIImageView *)ivImg{
    if (!_ivImg) {
        _ivImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_img1"]];
    }
    return _ivImg;
}

@end
