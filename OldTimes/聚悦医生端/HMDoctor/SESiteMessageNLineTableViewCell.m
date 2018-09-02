//
//  SESiteMessageNLineTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SESiteMessageNLineTableViewCell.h"
#import "SiteMessageLastMsgModel.h"
#import "NSDate+MsgManager.h"

@interface SESiteMessageNLineTableViewCell ()
@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UIView *cardView;         //整个卡片View
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UILabel *bottomLb;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *key1Lb;
@property (nonatomic, strong) UILabel *vaule1Lb;
@property (nonatomic, strong) UILabel *key2Lb;
@property (nonatomic, strong) UILabel *vaule2Lb;
@property (nonatomic, strong) UILabel *key3Lb;
@property (nonatomic, strong) UILabel *vaule3Lb;

@property (nonatomic, strong) UILabel *contentLb;

@end

@implementation SESiteMessageNLineTableViewCell
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
        [self.cardView addSubview:self.key1Lb];
        [self.cardView addSubview:self.key2Lb];
        [self.cardView addSubview:self.key3Lb];
        [self.cardView addSubview:self.vaule1Lb];
        [self.cardView addSubview:self.vaule2Lb];
        [self.cardView addSubview:self.vaule3Lb];
        [self.cardView addSubview:self.contentLb];
        [self configElements];
        
    }
    return self;
}
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
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
    }];
    

    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLb.mas_bottom).offset(10).priorityMedium();
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

- (void)fillBaseDataWithModel:(SiteMessageLastMsgModel *)model {
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
}

- (void)showContentLb:(BOOL)isShow {
    [self.contentLb setHidden:!isShow];
    [self.key1Lb setHidden:isShow];
    [self.key2Lb setHidden:isShow];
    [self.key3Lb setHidden:isShow];
    [self.vaule1Lb setHidden:isShow];
    [self.vaule2Lb setHidden:isShow];
    [self.vaule3Lb setHidden:isShow];

}
#pragma mark - interface
// 约诊数据源方法
- (void)fillAppointmentDataWithModel:(SiteMessageLastMsgModel *)model {
    [self fillBaseDataWithModel:model];
    
    SESiteMessageAppointmentModel *tempModel  = [SESiteMessageAppointmentModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.titelLb setText:tempModel.msgTitle];

    [self showContentLb:[tempModel.type isEqualToString:@"appointing"]];
    
    if ([tempModel.type isEqualToString:@"appointing"]) {
        // 助手类型消息
        [self.contentLb setText:tempModel.msg];
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.titelLb.mas_bottom).offset(5);
            make.right.lessThanOrEqualTo(self.cardView).offset(-10);
        }];
        
        [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLb.mas_bottom).offset(10).priorityHigh();
            make.left.equalTo(self.titelLb);
            make.right.equalTo(self.cardView).offset(-10);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(self.cardView).offset(-35);
        }];
        
    }
    else {
        
        [self.key1Lb setText:@"患者："];
        [self.vaule1Lb setText:tempModel.patientName];
        
        [self.key1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.titelLb.mas_bottom).offset(5);
        }];
        [self.vaule1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.key1Lb);
            make.left.equalTo(self.key1Lb.mas_right);
            make.right.lessThanOrEqualTo(self.cardView).offset(-10);
        }];
        
        [self.key1Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.vaule1Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.key2Lb setText:@"就诊医院："];
        [self.vaule2Lb setText:tempModel.appointAddr];
        
        [self.key2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.vaule1Lb.mas_bottom).offset(5);
        }];
        
        [self.vaule2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.key2Lb);
            make.left.equalTo(self.key2Lb.mas_right);
            make.right.lessThanOrEqualTo(self.cardView).offset(-10);
        }];
        [self.key2Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.vaule2Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.key3Lb setText:@"就诊时间："];
        [self.vaule3Lb setText:tempModel.appointTime];
        
        [self.key3Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.vaule2Lb.mas_bottom).offset(5);
        }];
        
        [self.vaule3Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.key3Lb);
            make.left.equalTo(self.key3Lb.mas_right);
            make.right.lessThanOrEqualTo(self.cardView).offset(-10);
        }];
        [self.key3Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.vaule3Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vaule3Lb.mas_bottom).offset(10).priorityHigh();
            make.left.equalTo(self.titelLb);
            make.right.equalTo(self.cardView).offset(-10);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(self.cardView).offset(-35);
        }];

    }

}
// 用户入组数据源方法
- (void)fillServiceOrderDataWithModel:(SiteMessageLastMsgModel *)model {
    [self fillBaseDataWithModel:model];
    
    SESiteMessageServiceOrderModel *tempModel  = [SESiteMessageServiceOrderModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.titelLb setText:tempModel.msgTitle];
    
    
    [self.key1Lb setText:@"订购套餐："];
    [self.vaule1Lb setText:tempModel.productName];
    
    [self.key1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.titelLb.mas_bottom).offset(5);
    }];
    [self.vaule1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.key1Lb);
        make.left.equalTo(self.key1Lb.mas_right);
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
    }];
    
    [self.key1Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    if ([tempModel.type isEqualToString:@"notifyStopInWeek"]) {
        // 服务到期
        [self.key2Lb setText:@"期限："];
        [self.vaule2Lb setText:[NSString stringWithFormat:@"%@ — %@",tempModel.beginTime,tempModel.endTime]];
        
        [self.key2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.vaule1Lb.mas_bottom).offset(5);
        }];
        
        [self.vaule2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.key2Lb);
            make.left.equalTo(self.key2Lb.mas_right);
            make.right.lessThanOrEqualTo(self.cardView).offset(-10);
            make.bottom.equalTo(self.cardView).offset(-15);
        }];
    }
    else {
        
        if ([tempModel.type isEqualToString:@"awaitDispatch"]) {
            // 分配
            [self.key2Lb setText:@"主要提供者："];
            [self.vaule2Lb setText:tempModel.teamName];
        }
        else {
            // 入组提醒 notifyDoctor
            [self.key2Lb setText:@"期限："];
            [self.vaule2Lb setText:tempModel.timeLimit];
        }
        
        [self.key2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.vaule1Lb.mas_bottom).offset(5);
        }];
        
        [self.vaule2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.key2Lb);
            make.left.equalTo(self.key2Lb.mas_right);
            make.right.lessThanOrEqualTo(self.cardView).offset(-10);
        }];
        
        [self.key3Lb setText:@"用户来源："];
        [self.vaule3Lb setText:tempModel.registerTypeName];
        
        [self.key3Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.vaule2Lb.mas_bottom).offset(5);
        }];
        
        [self.vaule3Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.key3Lb);
            make.left.equalTo(self.key3Lb.mas_right);
            make.right.lessThanOrEqualTo(self.cardView).offset(-10);
            make.bottom.equalTo(self.cardView).offset(-15);
            
        }];
    }
    
    
    
    [self.vaule2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.key2Lb);
        make.left.equalTo(self.key2Lb.mas_right);
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
    }];
    [self.key2Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.vaule2Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.key3Lb setText:@"用户来源："];
    [self.vaule3Lb setText:tempModel.registerTypeName];
    
    [self.key3Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.vaule2Lb.mas_bottom).offset(5);
    }];
    
    [self.vaule3Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.key3Lb);
        make.left.equalTo(self.key3Lb.mas_right);
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
        make.bottom.equalTo(self.cardView).offset(-15);

    }];
    [self.key3Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.vaule3Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.line2 setHidden:YES];
    [self.arrowImage setHidden:YES];
    [self.bottomLb setHidden:YES];

}

// 健康计划数据源方法
- (void)fillHealthPlanDataWithModel:(SiteMessageLastMsgModel *)model {
    [self fillBaseDataWithModel:model];
    
    SESiteMessageHealthPlanModel *tempModel  = [SESiteMessageHealthPlanModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.titelLb setText:tempModel.msgTitle];
    
    
    [self.contentLb setText:tempModel.msg];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.titelLb.mas_bottom).offset(5);
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
    }];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLb.mas_bottom).offset(10).priorityHigh();
        make.left.equalTo(self.titelLb);
        make.right.equalTo(self.cardView).offset(-10);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.cardView).offset(-35);
    }];
}

// 建档评估数据源方法
- (void)fillEvaluationDataWithModel:(SiteMessageLastMsgModel *)model {
    [self fillBaseDataWithModel:model];
    
    SESiteMessageEvaluationModel *tempModel  = [SESiteMessageEvaluationModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.titelLb setText:tempModel.msgTitle];
    
    
    [self.key1Lb setText:@"订购套餐："];
    [self.vaule1Lb setText:tempModel.productName];
    
    [self.key1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.titelLb.mas_bottom).offset(5);
    }];
    [self.vaule1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.key1Lb);
        make.left.equalTo(self.key1Lb.mas_right);
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
    }];
    [self.key1Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.vaule1Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.key2Lb setText:@"主要提供者："];
    [self.vaule2Lb setText:tempModel.providerName];
    
    
    [self.key2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.vaule1Lb.mas_bottom).offset(5);
    }];
    
    [self.vaule2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.key2Lb);
        make.left.equalTo(self.key2Lb.mas_right);
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
    }];
    [self.key2Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.vaule2Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.key3Lb setText:@"用户来源："];
    [self.vaule3Lb setText:tempModel.registerTypeName];
    
    [self.key3Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.vaule2Lb.mas_bottom).offset(5);
    }];
    
    [self.vaule3Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.key3Lb);
        make.left.equalTo(self.key3Lb.mas_right);
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
        make.bottom.equalTo(self.cardView).offset(-15);
        
    }];
    [self.key3Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.vaule3Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.line2 setHidden:YES];
    [self.arrowImage setHidden:YES];
    [self.bottomLb setHidden:YES];
}

// 用药建议数据源方法
- (void)fillMedicineSuggestedDataWithModel:(SiteMessageLastMsgModel *)model {
    [self fillBaseDataWithModel:model];

    SESiteMessageMedicineSuggestedModel *tempModel  = [SESiteMessageMedicineSuggestedModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.titelLb setText:tempModel.msgTitle];

    [self.key1Lb setText:@"患者："];
    [self.vaule1Lb setText:tempModel.userName];
    
    [self.key1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.titelLb.mas_bottom).offset(5);
    }];
    [self.vaule1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.key1Lb);
        make.left.equalTo(self.key1Lb.mas_right);
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
    }];
    [self.key1Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.vaule1Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.key2Lb setText:@"有效期："];
    [self.vaule2Lb setText:[NSString stringWithFormat:@"%@ — %@",tempModel.beginTime,tempModel.endTime]];
    
    [self.key2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.vaule1Lb.mas_bottom).offset(5);
    }];
    
    [self.vaule2Lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.key2Lb);
        make.left.equalTo(self.key2Lb.mas_right);
        make.right.lessThanOrEqualTo(self.cardView).offset(-10);
    }];
    [self.key2Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.vaule2Lb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vaule2Lb.mas_bottom).offset(10).priorityHigh();
        make.left.equalTo(self.titelLb);
        make.right.equalTo(self.cardView).offset(-10);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.cardView).offset(-35);
    }];

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
        _receiveTimeLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"FFFFFF"]];
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
        [_titelLb setNumberOfLines:0];
    }
    return _titelLb;
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

- (UILabel *)key1Lb {
    if (!_key1Lb) {
        _key1Lb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"666666"]];
    }
    return _key1Lb;
}

- (UILabel *)key2Lb {
    if (!_key2Lb) {
        _key2Lb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"666666"]];
    }
    return _key2Lb;
}

- (UILabel *)key3Lb {
    if (!_key3Lb) {
        _key3Lb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"666666"]];
    }
    return _key3Lb;
}

- (UILabel *)vaule1Lb {
    if (!_vaule1Lb) {
        _vaule1Lb = [self getLebalWithTitel:@" " font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"666666"]];
        [_vaule1Lb setNumberOfLines:1];
    }
    return _vaule1Lb;
}

- (UILabel *)vaule2Lb {
    if (!_vaule2Lb) {
        _vaule2Lb = [self getLebalWithTitel:@" " font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"666666"]];
        [_vaule2Lb setNumberOfLines:1];

    }
    return _vaule2Lb;
}

- (UILabel *)vaule3Lb {
    if (!_vaule3Lb) {
        _vaule3Lb = [self getLebalWithTitel:@" " font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"666666"]];
        [_vaule3Lb setNumberOfLines:1];
    }
    return _vaule3Lb;
}

- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"666666"]];
        [_contentLb setNumberOfLines:3];
    }
    return _contentLb;
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
