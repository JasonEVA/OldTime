//
//  NewCommentDetailTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewCommentDetailTableViewCell.h"
#import "NewCommentDetailModel.h"

@interface NewCommentDetailTableViewCell ()
@property (nonatomic, strong) UILabel *titelLb;
@end

@implementation NewCommentDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *line = [UIView new];
        [line setBackgroundColor:[UIColor colorWithHexString:@"dddddd"]];
        
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@0.5);
        }];
        self.titelLb = [UILabel new];
        [self.titelLb setFont:[UIFont systemFontOfSize:15]];
        [self.titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.titelLb setNumberOfLines:0];
        
        [self.contentView addSubview:self.titelLb];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(30);
            make.left.equalTo(self.contentView).offset(30);
            make.right.equalTo(self.contentView).offset(-30);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)fillDataWithModel:(NewCommentDetailModel *)model {
    [self.titelLb setText:model.remariks];
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
