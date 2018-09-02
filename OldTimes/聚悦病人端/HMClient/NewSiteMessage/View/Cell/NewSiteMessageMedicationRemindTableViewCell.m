//
//  NewSiteMessageMedicationRemindTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageMedicationRemindTableViewCell.h"
#import "NewSiteMessageMedicationRemindModel.h"
#import "NSDate+MsgManager.h"

@interface NewSiteMessageMedicationRemindTableViewCell ()
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UILabel *bottomLb;
@property (nonatomic, strong) UIImageView *arrowImage;
@end
@implementation NewSiteMessageMedicationRemindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.rightBtn setHidden:YES];
        [self.typeImage setImage:[UIImage imageNamed:@"icon_yongyao"]];
        
        
        [self.cardView addSubview:self.line2];
        [self.cardView addSubview:self.bottomLb];
        [self.cardView addSubview:self.arrowImage];
        
        
    }
    return self;
}

- (void)layoutWithData:(NSArray<NewSiteMessageDrugModel *> *)array {
    [array enumerateObjectsUsingBlock:^(NewSiteMessageDrugModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *itemLb = [self getLebalWithTitel:obj.drugName font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
        [self.cardView addSubview:itemLb];
        [itemLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(idx?self.tempLabel.mas_bottom:self.line.mas_bottom).offset(15);
            make.left.equalTo(self.line).offset(15);
            make.right.lessThanOrEqualTo(self.cardView).offset(-20);
        }];
        self.tempLabel = itemLb;
    }];
}

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageMedicationRemindModel *tempModel  = [NewSiteMessageMedicationRemindModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.subTitelLb setText:tempModel.msg];
    [self.titelLb setText:tempModel.msgTitle];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    
    [self layoutWithData:tempModel.drugList];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tempLabel.mas_bottom).offset(10);
        make.left.equalTo(self.line).offset(15);
        make.right.equalTo(self.line).offset(-15);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.cardView).offset(-35);
    }];
    
    [self.bottomLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line2);
        make.top.equalTo(self.line2.mas_bottom).offset(8);
        make.right.lessThanOrEqualTo(self.arrowImage);
    }];
    
    [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line2);
        make.centerY.equalTo(self.bottomLb);
    }];


}
- (UILabel *)bottomLb
{
    if (!_bottomLb) {
        _bottomLb = [self getLebalWithTitel:@"用药说明" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"31c9ba"]];
    }
    return _bottomLb;
}

- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_r_gray_arrow"]];
    }
    return _arrowImage;
}
- (UIView *)line2
{
    if (!_line2) {
        _line2 = [UIView new];
        [_line2 setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    }
    return _line2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
