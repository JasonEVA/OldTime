//
//  NewSiteMessageAllMonitorRemindedTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/11/1.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageAllMonitorRemindedTableViewCell.h"

@interface NewSiteMessageAllMonitorRemindedTableViewCell ()
@property (nonatomic, strong) UILabel *tempLabel;
@end

@implementation NewSiteMessageAllMonitorRemindedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.rightBtn setHidden:YES];
        [self.titelLb setText:@"今日监测项"];
        [self.subTitelLb setText:@"请及时纪录健康"];
        [self.typeImage setImage:[UIImage imageNamed:@"icon_jiance"]];
        
        [self layoutWithData:@[@"",@"",@""]];
    }
    return self;
}

- (void)layoutWithData:(NSArray *)array {
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *itemLb = [self getLebalWithTitel:@"测血糖  上午9：00" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
        [self.cardView addSubview:itemLb];
        [itemLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(idx?self.tempLabel.mas_bottom:self.line.mas_bottom).offset(15);
            make.left.equalTo(self.line).offset(15);
            make.right.lessThanOrEqualTo(self.cardView).offset(-20);
        }];
        self.tempLabel = itemLb;
    }];
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardView).offset(-15);
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
