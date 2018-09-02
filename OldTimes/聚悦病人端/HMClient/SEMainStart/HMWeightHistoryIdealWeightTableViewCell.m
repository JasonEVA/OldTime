//
//  HMWeightHistoryIdealWeightTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeightHistoryIdealWeightTableViewCell.h"

@interface HMWeightHistoryIdealWeightTableViewCell ()
@end

@implementation HMWeightHistoryIdealWeightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *titelLb = [UILabel new];
        [titelLb setText:@"理想体重"];
        [titelLb setFont:[UIFont systemFontOfSize:16]];
        [titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.contentView addSubview:titelLb];
        
        [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.bottom.equalTo(self.contentView);
            make.height.equalTo(@45);
        }];
        
        self.targetLb = [UILabel new];
        [self.targetLb setTextColor:[UIColor colorWithHexString:@"31C9BA"]];
        [self.targetLb setFont:[UIFont systemFontOfSize:16]];
        [self.targetLb setText:@"50kg"];
        [self.contentView addSubview:self.targetLb];
        [self.targetLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(titelLb.mas_right).offset(15);
        }];
        
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

@end
