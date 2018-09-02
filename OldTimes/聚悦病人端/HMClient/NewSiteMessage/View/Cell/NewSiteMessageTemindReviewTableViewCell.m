//
//  NewSiteMessageTemindReviewTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageTemindReviewTableViewCell.h"
#import "NewSiteMessageTemindReviewModel.h"
#import "NSDate+MsgManager.h"

@interface NewSiteMessageTemindReviewTableViewCell ()
@property (nonatomic, strong) UILabel *itemKeyLb1;
@property (nonatomic, strong) UILabel *itemValueLb1;
@property (nonatomic, strong) UILabel *itemKeyLb2;
@property (nonatomic, strong) UILabel *itemValueLb2;
@end

@implementation NewSiteMessageTemindReviewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.rightBtn setText:@"约专家"];
        [self.typeImage setImage:[UIImage imageNamed:@"icon_fucha"]];

        [self.cardView addSubview:self.itemValueLb1];
        [self.cardView addSubview:self.itemKeyLb1];
        [self.cardView addSubview:self.itemValueLb2];
        [self.cardView addSubview:self.itemKeyLb2];
        
        [self configElements];
        
    }
    return self;
}

- (void)configElements {
    
    
    [self.itemKeyLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(15);
        make.left.equalTo(self.line).offset(15);
    }];
    
    [self.itemValueLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemKeyLb1.mas_right).offset(15);
        make.top.equalTo(self.itemKeyLb1);
        make.right.lessThanOrEqualTo(self.cardView).offset(-15);
    }];
    
    [self.itemKeyLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemValueLb1.mas_bottom).offset(10);
        make.left.equalTo(self.line).offset(15);
        make.bottom.equalTo(self.cardView).offset(-15);
    }];
    
    [self.itemValueLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemKeyLb2.mas_right).offset(15);
        make.centerY.equalTo(self.itemKeyLb2);
        make.right.lessThanOrEqualTo(self.cardView).offset(-15);
    }];
    
}

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageTemindReviewModel *tempModel  = [NewSiteMessageTemindReviewModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.subTitelLb setText:tempModel.msg];
    [self.titelLb setText:tempModel.msgTitle];
    [self.itemValueLb2 setText:tempModel.reviewTime];
    [self.itemValueLb1 setAttributedText:[self acquireAttStringWithString:[self acquireStringWithArray:tempModel.indecesNames]]];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];

}

- (NSString *)acquireStringWithArray:(NSArray *)array {
    __block NSString *tempString = @"";
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:[NSString class]]) {
            if (!tempString.length) {
                tempString = obj;
            }
            else {
                tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"\n%@",obj]];
            }
        }
    }];
    return tempString;
}

- (NSMutableAttributedString *)acquireAttStringWithString:(NSString *)string {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
}


- (UILabel *)itemKeyLb1
{
    if (!_itemKeyLb1) {
        _itemKeyLb1 = [self getLebalWithTitel:@"复查项目" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"666666"]];
    }
    return _itemKeyLb1;
}

- (UILabel *)itemValueLb1
{
    if (!_itemValueLb1) {
        _itemValueLb1 = [self getLebalWithTitel:@"随访\n123\n456\n1232" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
        [_itemValueLb1 setNumberOfLines:0];
    }
    return _itemValueLb1;
}

- (UILabel *)itemKeyLb2
{
    if (!_itemKeyLb2) {
        _itemKeyLb2 = [self getLebalWithTitel:@"复查时间" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"666666"]];
    }
    return _itemKeyLb2;
}

- (UILabel *)itemValueLb2
{
    if (!_itemValueLb2) {
        _itemValueLb2 = [self getLebalWithTitel:@"2016-10-27" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _itemValueLb2;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
