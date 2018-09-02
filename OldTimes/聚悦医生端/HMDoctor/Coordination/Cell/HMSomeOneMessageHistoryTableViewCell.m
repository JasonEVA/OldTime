//
//  HMSomeOneMessageHistoryTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/4/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSomeOneMessageHistoryTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "NSDate+MsgManager.h"
#import "MessageBaseModel+CellSize.h"

@interface HMSomeOneMessageHistoryTableViewCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *subTitelLb;
@property (nonatomic, strong) UILabel *timeLb;
@end
@implementation HMSomeOneMessageHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.timeLb];
        [self.contentView addSubview:self.subTitelLb];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(12.5);
            make.width.height.equalTo(@40);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(8);
            make.bottom.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.subTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titelLb);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    return self;
}

- (void)fillDataWithMessageModel:(MessageBaseModel *)model profileModel:(UserProfileModel *)profileModel{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.iconView sd_setImageWithURL:avatarURL(avatarType_80, profileModel.userName) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    [self.titelLb setText:profileModel.nickName];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:NO];
    [self.timeLb setText:strDate];
    
    [self.subTitelLb setText:[self acquireShowStringWithModel:model]];
}

- (NSString *)acquireShowStringWithModel:(MessageBaseModel *)baseModel {
    NSString *showString = @"";
    switch (baseModel._type)
    {
        case msg_personal_text:
        {
            showString = baseModel._content;
            break;
        }
            
        case msg_personal_voice:
        {
            showString = @"[语音]";
            break;
        }
            
            
        case msg_personal_image:
        {
            showString = @"[图片]";
            break;
        }
        case msg_personal_file:
        {
            // 生成附件图片
            showString = @"[文件]";
            break;
        }
            //图文消息
        case msg_personal_news: {
            showString = @"[图文消息]";
            break;
        }
        case msg_personal_alert: {
            showString = baseModel._content;
            break;
        }
            
        case msg_personal_event:
        {
            //自定义消息
            showString = @"[自定义消息]";
            NSString* content = baseModel._content;
            if (!content || 0 == content.length) {
            }
            NSDictionary* dicContent = [NSDictionary JSONValue:content];
            if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
            {
                break;
            }
            MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
            NSString* contentType = modelContent.type;
            if (!contentType || contentType.length == 0)
            {
                break;
            }
            
            if ([contentType isEqualToString:@"serviceComments"])
            {
                //服务评价消息
                showString = @"[服务评价]";
                break;
            }
            
            if ([contentType isEqualToString:@"healthyReportDetPage"])
            {
                //健康报告
                showString = @"[健康报告]";
                break;
            }
            if ([contentType isEqualToString:@"healthTest"]|| [contentType isEqualToString:@"adjustWarning"]|| [contentType isEqualToString:@"continueTest"]|| [contentType isEqualToString:@"tellVisitDoc"])
            {
                showString = @"[监测预警]";
                break;
            }
            if ([contentType isEqualToString:@"testResultPage"])
            {
                //监测提醒
                showString = @"[监测提醒]";
                break;
            }
            
            if ([contentType isEqualToString:@"healthySubmit"]
                ||[contentType isEqualToString:@"healthyStop"]
                ||[contentType isEqualToString:@"healthyExecute"]
                ||[contentType isEqualToString:@"healthPlan"]
                ||[contentType isEqualToString:@"healthyAdjust"]
                ||[contentType isEqualToString:@"healthyDraft"])
                
            {
                //健康计划
                
                showString = @"[健康计划]";
                break;
            }
            
            if ([contentType isEqualToString:@"surveyFilled"] || [contentType isEqualToString:@"surveyReply"] ||
                [contentType isEqualToString:@"surveyPush"] || [contentType isEqualToString:@"survey"])
                
            {
                //随访
                showString = @"[随访]";
                break;
            }
            
            if ([contentType isEqualToString:@"recipePage"] || [contentType isEqualToString:@"stopRecipe"])
            {
                //用药建议
                showString = @"[用药建议]";
                break;
                
            }
            if ([contentType isEqualToString:@"applyAppoint"]||
                [contentType isEqualToString:@"appointAgree"]||
                [contentType isEqualToString:@"appointRefuse"]||
                [contentType isEqualToString:@"appointChange"])
                
            {
                //处理约诊申请
                showString = @"[约诊]";
                break;
            }
            if ([contentType isEqualToString:@"sendCompleateDocMsg"])
            {
                //档案更新
                showString = @"[档案更新]";
                break;
            }
            if ([contentType isEqualToString:@"assessmentReport"])
            {
                //更新评估报告 建档
                showString = @"[健康评估]";
                break;
            }
            
            if ([contentType isEqualToString:@"assessFilled"]||
                [contentType isEqualToString:@"assessPush"])
            {
                showString = @"[健康评估]";
                break;
            }
            if ([contentType isEqualToString:@"roundsPush"] ||[contentType isEqualToString:@"roundsFilled"] || [contentType isEqualToString:@"roundsAsk"])
            {
                //查房发送
                showString = @"[查房]";
                break;
            }
            
            if ([contentType isEqualToString:@"inquirySend"])
            {
                //问诊表发送
                showString = @"[问诊表]";
                break;
            }

                break;
        }
            
        default:
            break;
    }
    return showString;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default_staff"]];
        [_iconView.layer setCornerRadius:3];
    }
    return _iconView;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb setFont:[UIFont systemFontOfSize:12]];
        [_timeLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _timeLb;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:14]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _titelLb;
}

- (UILabel *)subTitelLb {
    if (!_subTitelLb) {
        _subTitelLb = [UILabel new];
        [_subTitelLb setFont:[UIFont systemFontOfSize:16]];
        [_subTitelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _subTitelLb;
}
@end
