//
//  MDSDrugDetailTableViewCell.m
//  MintmedicalDrugStore
//
//  Created by jasonwang on 16/7/27.
//  Copyright © 2016年 JasonWang. All rights reserved.
//

#import "MDSDrugDetailTableViewCell.h"
#import <Masonry/Masonry.h>
#define W_MAX   ([ [ UIScreen mainScreen ] bounds ].size.width - 20)

@interface MDSDrugDetailTableViewCell ()

@end
@implementation MDSDrugDetailTableViewCell
+ (NSString *)at_identifier {
    return NSStringFromClass([self class]);
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.detailLb];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(3);
            make.right.lessThanOrEqualTo(self.contentView).offset(-10);
        }];
        
        [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.lessThanOrEqualTo(self.contentView).offset(-10);
            make.top.equalTo(self.titelLb.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView).offset(-10);
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

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        _titelLb.font = [UIFont systemFontOfSize:15];
        _titelLb.textColor = [UIColor blackColor];
        [_titelLb setText:@"占位标题"];
    }
    return _titelLb;
}

- (UILabel *)detailLb {
    if (!_detailLb) {
        _detailLb = [UILabel new];
        [_detailLb setFont:[UIFont systemFontOfSize:15]];
        [_detailLb setTextColor:[UIColor lightGrayColor]];
        [_detailLb setNumberOfLines:0];
        [_detailLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_detailLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _detailLb.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLb.preferredMaxLayoutWidth = W_MAX;
    }
    return _detailLb;
}
@end
