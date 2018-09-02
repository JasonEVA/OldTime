//
//  NewSiteSystemTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/6/19.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteSystemTableViewCell.h"
#import "NewSiteMessageCheackModel.h"
#import "NSDate+MsgManager.h"

#define COLOR_MESSAGE_BG [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0]

@interface NewSiteSystemTableViewCell ()
@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UILabel *contentLb;

@end

@implementation NewSiteSystemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [self.contentView addSubview:self.receiveTimeLb];
        [self.contentView addSubview:self.contentLb];
        
        [self.receiveTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(15);
            make.height.equalTo(@20);
        }];

        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.receiveTimeLb.mas_bottom).offset(15);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.left.greaterThanOrEqualTo(self.contentView).offset(10);
            make.right.lessThanOrEqualTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    
    NSString *toCheackString = @"点击查看  ";
    
    NewSiteMessageCheackModel *tempModel  = [NewSiteMessageCheackModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    NSString *tempString = [NSString stringWithFormat:@"  %@",[tempModel.msg stringByAppendingString:toCheackString]];
    NSRange range = [tempString rangeOfString:toCheackString];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:tempString];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor mainThemeColor] range:range];
    [[self contentLb] setAttributedText:attrString];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [UILabel new];
        [_contentLb setTextAlignment:NSTextAlignmentCenter];
        [_contentLb setTextColor:[UIColor whiteColor]];
        [_contentLb setFont:[UIFont font_26]];
        [_contentLb setNumberOfLines:0];
        [_contentLb setBackgroundColor:COLOR_MESSAGE_BG];
        [_contentLb.layer setCornerRadius:4];
        [_contentLb.layer setMasksToBounds:YES];
    }
    return _contentLb;
}

- (UILabel *)receiveTimeLb
{
    if (!_receiveTimeLb) {
        _receiveTimeLb = [self getLebalWithTitel:@" 12-12 18:13 " font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"FFFFFF"]];
        [_receiveTimeLb.layer setCornerRadius:3];
        [_receiveTimeLb setBackgroundColor:[UIColor colorWithHexString:@"cecece"]];
        [_receiveTimeLb setClipsToBounds:YES];
        
    }
    return _receiveTimeLb;
}
@end
