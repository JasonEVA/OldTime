//
//  NewSiteMessageMonitorRemindedTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageMonitorRemindedTableViewCell.h"
#import "NewSiteMessageMonitorRemindModel.h"
#import "NSDate+MsgManager.h"

@interface NewSiteMessageMonitorRemindedTableViewCell ()


@property (nonatomic, strong) UILabel *itemKeyLb1;
@property (nonatomic, strong) UILabel *itemValueLb1;

@end
@implementation NewSiteMessageMonitorRemindedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.titelLb setText:@"监测提醒"];
        [self.subTitelLb setText:@"请及时进行健康纪录"];
        [self.typeImage setImage:[UIImage imageNamed:@"icon_jiance"]];
        
        [self.cardView addSubview:self.itemValueLb1];
        [self.cardView addSubview:self.itemKeyLb1];

        [self configElements];
        
    }
    return self;
}

#pragma mark -private method
- (void)configElements {
    
        
    [self.itemKeyLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(15);
        make.left.equalTo(self.line).offset(15);
        make.bottom.equalTo(self.cardView).offset(-15);
    }];
    
    [self.itemValueLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemKeyLb1.mas_right).offset(15);
        make.centerY.equalTo(self.itemKeyLb1);
        make.right.lessThanOrEqualTo(self.cardView).offset(-15);
    }];
    

    
}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageMonitorRemindModel *tempModel  = [NewSiteMessageMonitorRemindModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.subTitelLb setText:tempModel.msg];
    [self.titelLb setText:tempModel.msgTitle];
    [self.itemValueLb1 setText:tempModel.kpiTitle];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
}
#pragma mark - init UI



- (UILabel *)itemKeyLb1
{
    if (!_itemKeyLb1) {
        _itemKeyLb1 = [self getLebalWithTitel:@"监测项目" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"666666"]];
    }
    return _itemKeyLb1;
}

- (UILabel *)itemValueLb1
{
    if (!_itemValueLb1) {
        _itemValueLb1 = [self getLebalWithTitel:@"默认" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _itemValueLb1;
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
