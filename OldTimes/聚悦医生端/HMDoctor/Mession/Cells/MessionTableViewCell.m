//
//  MessionTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MessionTableViewCell.h"

@interface MessionTableViewCell ()
{
    UIImageView* ivIcon;
    UILabel* lbMessionName;
    UILabel* lbMessionComment;
    UILabel* lbStatus;
    UILabel* lbDate;
}

@end

@implementation MessionTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:ivIcon];
        ivIcon.layer.borderWidth = 0.5;
        ivIcon.layer.borderColor = [[UIColor colorWithHexString:@"E2E2E2"] CGColor];
        ivIcon.layer.cornerRadius = 13;
        ivIcon.layer.masksToBounds = YES;
        
        lbMessionName = [[UILabel alloc]init];
        [self.contentView addSubview:lbMessionName];
        [lbMessionName setTextColor:[UIColor colorWithHexString:@"535353"]];
        [lbMessionName setFont:[UIFont systemFontOfSize:14]];
        
        lbMessionComment = [[UILabel alloc]init];
        [self.contentView addSubview:lbMessionComment];
        [lbMessionComment setTextColor:[UIColor colorWithHexString:@"535353"]];
        [lbMessionComment setFont:[UIFont systemFontOfSize:12]];
        
        lbStatus = [[UILabel alloc]init];
        [self.contentView addSubview:lbStatus];
        [lbStatus setTextColor:[UIColor colorWithHexString:@"535353"]];
        [lbStatus setFont:[UIFont systemFontOfSize:12]];
        
        lbDate = [[UILabel alloc]init];
        [self.contentView addSubview:lbDate];
        [lbDate setTextColor:[UIColor colorWithHexString:@"535353"]];
        [lbDate setFont:[UIFont systemFontOfSize:12]];
        
        [self subviewLayout];
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

- (void) subviewLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [lbMessionName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(8);
        make.top.equalTo(self.contentView).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(200, 18));
        //make.size.height.mas_equalTo(18);
    }];
    
    [lbMessionComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(8);
        make.top.equalTo(lbMessionName.mas_bottom).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(210, 16));
    }];
    
    [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(15);
        make.bottom.equalTo(lbMessionName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(64, 16));
    }];
    
    [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(15);
        make.bottom.equalTo(lbMessionComment.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(64, 16));
    }];
}

- (void) setMessionInfo:(MessionInfo*) mession
{
    [lbMessionName setText:mession.messionName];
    [lbMessionComment setText:@"到杨家坪社区卫生中心对社区医生进行指导"];
    [lbStatus setText:@"待处理"];
    [lbDate setText:@"15:00"];
}

@end
