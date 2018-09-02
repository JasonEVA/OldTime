//
//  HMNewDoctorCareAlterTextTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/6/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMNewDoctorCareAlterTextTableViewCell.h"


@interface HMNewDoctorCareAlterTextTableViewCell ()
@property(nonatomic, strong) UILabel *textLb;
@end

@implementation HMNewDoctorCareAlterTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.textLb];
        [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.bottom.equalTo(self.contentView).offset(2);
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

- (void)fillDataWithString:(NSString *)string {
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2.0];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    [self.textLb setAttributedText:attributedString1];
    //设置行间距后适配高度显示
    [self.textLb sizeToFit];
}

- (UILabel *)textLb {
    if (!_textLb) {
        _textLb = [UILabel new];
        [_textLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_textLb setFont:[UIFont fontWithName:@"PingFang-SC-Light" size:15]];
        [_textLb setNumberOfLines:0];
    }
    return _textLb;
}

@end
