//
//  HealthPlanSummaryTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSummaryTableViewCell.h"

@implementation HealthPlanDetailSectionModel (TableViewCellHeight)

- (CGFloat) cellHeight
{
    CGFloat cellHeight = 56;
    
    CGFloat descWidth = kScreenWidth - (25 + 36 + 10) ;
    
    
    CGFloat descHeight = [self.healthyPlanDetDesc heightSystemFont:[UIFont systemFontOfSize:13] width:descWidth];
    
    cellHeight = 48 + descHeight;
    if (cellHeight < 56)
    {
        cellHeight = 56;
    }
    return cellHeight;
}

@end

@interface HealthPlanSummaryTableViewCell ()

@property (nonatomic, strong) UIImageView* iconImageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* descLabel;

@end

@implementation HealthPlanSummaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(13);
        make.top.equalTo(self.iconImageView);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(13);
        make.bottom.equalTo(self.iconImageView);
        make.right.lessThanOrEqualTo(self.contentView).offset(-12.5);
    }];
}

- (void) setHealthPlanSection:(HealthPlanDetailSectionModel*) sectionModel
{
    NSString* imageName = [NSString stringWithFormat:@"icon_healthplan_%@", sectionModel.code];
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
    [self.titleLabel setText:sectionModel.title];
    [self.descLabel setText:sectionModel.healthyPlanDetDesc];
}

#pragma mark - settingAndGetting
- (UIImageView*) iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default"]];
        [self.contentView addSubview:_iconImageView];
        
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
    }
    return _titleLabel;
}

- (UILabel*) descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_descLabel];
        [_descLabel setFont:[UIFont systemFontOfSize:13]];
        [_descLabel setTextColor:[UIColor commonGrayTextColor]];
        
    }
    return _descLabel;
}

@end
