//
//  NewSiteMessageAppointmentRemindTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageAppointmentRemindTableViewCell.h"
#import "NewSiteMessageHealthPlanModel.h"
#import "NewSiteMessageHealthReportModel.h"
#import "NSDate+MsgManager.h"
#import "NewSiteMessageAssessModel.h"
#import "NewSiteMessageAppointmentRemindModel.h"

#define W_MAX   ([ [ UIScreen mainScreen ] bounds ].size.width - 50)   // 文字最大宽度

@interface NewSiteMessageAppointmentRemindTableViewCell ()
@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UIView *cardView;         //整个卡片View
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UILabel *bottomLb;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UILabel *planNameLb;      //计划名称
@property (nonatomic, strong) UILabel *planCycleLb;     //计划周期
@property (nonatomic) BOOL isHavePlan;              //是否有计划

@end

@implementation NewSiteMessageAppointmentRemindTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.receiveTimeLb];
        [self.contentView addSubview:self.cardView];
        [self.cardView addSubview:self.line2];
        [self.cardView addSubview:self.bottomLb];
        [self.cardView addSubview:self.arrowImage];
        [self.cardView addSubview:self.titelLb];
        [self.cardView addSubview:self.contentLb];
        [self.cardView addSubview:self.planNameLb];
        [self.cardView addSubview:self.planCycleLb];
        
        [self configElements];
        
    }
    return self;
}


#pragma mark -private method
- (void)configElements {
    [self.receiveTimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@20);
    }];
    
    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveTimeLb.mas_bottom).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.titelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).offset(15);
        make.left.equalTo(self.cardView).offset(10);
        make.right.lessThanOrEqualTo(self.cardView).offset(-20);
    }];
    
    [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.titelLb.mas_bottom).offset(11);
        make.right.equalTo(self.cardView).offset(-10);
    }];
    
    if (self.isHavePlan) {
        [self.planNameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLb.mas_bottom).offset(15);
            make.left.equalTo(self.contentLb);
            make.right.lessThanOrEqualTo(self.cardView).offset(-15);
        }];
        
        [self.planCycleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.planNameLb.mas_bottom).offset(6);
            make.left.equalTo(self.planNameLb);
            make.right.lessThanOrEqualTo(self.cardView).offset(-15);
        }];
    }
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.isHavePlan ? self.planCycleLb.mas_bottom : self.contentLb.mas_bottom).offset(10);
        make.left.equalTo(self.titelLb);
        make.right.equalTo(self.cardView).offset(-10);
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

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillHealthPlanDataWithModel:(SiteMessageLastMsgModel *)model{
    self.isHavePlan = YES;
    NewSiteMessageHealthPlanModel *tempModel  = [NewSiteMessageHealthPlanModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    [self.planNameLb setText:[NSString stringWithFormat:@"计划名称：%@",tempModel.healthPlanName]];
    [self.planCycleLb setText:[NSString stringWithFormat:@"执行周期：%@-%@",tempModel.begintime,tempModel.endtime]];
    [self.contentLb setText:tempModel.msg];
    if ([model.msgContent.mj_JSONObject[@"type"] isEqualToString:@"healthySubmit"]) {
        [self.titelLb setText:@"健康计划已制定"];
    }
    else if ([model.msgContent.mj_JSONObject[@"type"] isEqualToString:@"healthyAdjust"]) {
        [self.titelLb setText:@"健康计划已变更"];
    }
    else if ([model.msgContent.mj_JSONObject[@"type"] isEqualToString:@"healthyStop"]) {
        [self.titelLb setText:@"健康计划已到期"];
    }
    else {
        [self.titelLb setText:tempModel.msgTitle];

    }
    [self configElements];
}

- (void)fillHealReportWithModel:(SiteMessageLastMsgModel *)model {
    [self.titelLb setText:@"健康报告已发送"];
    NewSiteMessageHealthReportModel *tempModel  = [NewSiteMessageHealthReportModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    
    //饮食评估报告  饮食记录
    if ([tempModel.type isEqualToString:@"dietDetailPage"]) {
        [self.titelLb setText:tempModel.msgTitle];
    }
    
    [self.contentLb setText:tempModel.msg];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
}

- (void)fillAssessWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageAssessModel *tempModel  = [NewSiteMessageAssessModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.titelLb setText:tempModel.msgTitle];
    [self.contentLb setText:tempModel.msg];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
}
- (void)fillAppointWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageAppointmentRemindModel *tempModel  = [NewSiteMessageAppointmentRemindModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.titelLb setText:tempModel.msgTitle];
    [self.contentLb setText:tempModel.msg];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
}
#pragma mark - init UI
- (UIView *)cardView
{
    if (!_cardView) {
        _cardView = [UIView new];
        [_cardView setBackgroundColor:[UIColor whiteColor]];
        [_cardView.layer setCornerRadius:5];
        [_cardView setClipsToBounds:YES];
    }
    return _cardView;
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

- (UILabel *)bottomLb
{
    if (!_bottomLb) {
        _bottomLb = [self getLebalWithTitel:@"查看详情" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _bottomLb;
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _titelLb;
}
- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"啊上到卡还是的咖啡机好可怜见都很舒服看进度快圣诞节分离开就死定了房间看" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLb setNumberOfLines:0];
        [_contentLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_contentLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _contentLb.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLb.preferredMaxLayoutWidth = W_MAX;
    }
    return _contentLb;
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

- (UILabel *)planCycleLb {
    if (!_planCycleLb) {
        _planCycleLb = [UILabel new];
        [_planCycleLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_planCycleLb setText:@"执行周期：2016-1-12"];
        [_planCycleLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _planCycleLb;
}

- (UILabel *)planNameLb {
    if (!_planNameLb) {
        _planNameLb = [UILabel new];
        [_planNameLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_planNameLb setText:@"计划名称：高血压"];
        [_planNameLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _planNameLb;
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
