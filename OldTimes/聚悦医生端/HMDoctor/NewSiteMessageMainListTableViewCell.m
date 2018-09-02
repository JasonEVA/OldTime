//
//  NewSiteMessageMainListTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageMainListTableViewCell.h"
#import "MessageHeadImageVIew.h"
#import "NewSiteLeftIconImageView.h"
#import "SiteMessageSecondEditionMainListModel.h"
#import "ClientHelper.h"
#import "NSDate+MsgManager.h"
#define REDPOINTWEIHT     10
@interface NewSiteMessageMainListTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *redPoint;
@property (nonatomic, strong) UIImageView *muteNotificationImageView;
@property (nonatomic, strong) UILabel *unReadCountLb;
@end

@implementation NewSiteMessageMainListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.redPoint];
        [self.contentView addSubview:self.muteNotificationImageView];
        [self.contentView addSubview:self.unReadCountLb];
        
        [self configElements];

    }
    return self;
}

#pragma mark -private method
- (void)configElements {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(15);
        make.bottom.equalTo(self.avatarImageView.mas_centerY);
        make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-13);
    }];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.avatarImageView);
        make.width.height.equalTo(@REDPOINTWEIHT);
    }];
    
    [self.unReadCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView);
        make.centerX.equalTo(self.avatarImageView.mas_right).offset(-5);
        make.height.equalTo(@18);
        make.left.lessThanOrEqualTo(self.avatarImageView.mas_right).offset(-14);
        make.right.greaterThanOrEqualTo(self.avatarImageView.mas_right).offset(4);
    }];
    
    [self.muteNotificationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.avatarImageView.mas_centerY).offset(5);
        make.right.lessThanOrEqualTo(self.muteNotificationImageView.mas_left).offset(-5);
    }];


}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithModel:(SiteMessageSecondEditionMainListModel *)model {
    [self.titleLabel setText:model.typeName];
    NSDictionary *dict = model.lastMsg.msgContent.mj_JSONObject;
    if (dict[@"msg"] && [dict[@"msg"] isKindOfClass:[NSString class]]) {
        if ([model.typeCode isEqualToString:@"YSGH"] && ![dict[@"msg"] length]) {
            NSString *nikeName = model.lastMsg.doThing.mj_JSONObject[@"nickName"];
            [self.subTitleLabel setText:[NSString stringWithFormat:@"%@医生发来一段语音",nikeName]];
        }
        else {
            [self.subTitleLabel setText:dict[@"msg"]];
        }
    }
    if (model.lastMsg.createTimestamp) {
        NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.lastMsg.createTimestamp appendMinute:NO];
        [self.timeLabel setText:[NSString stringWithFormat:@"%@",strDate]];
    }
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@base.do?method=getPatinetMsgImg&typeCode=%@",kZJKBaseUrl,model.typeCode]] placeholderImage:[UIImage imageNamed:@"ic_fucha"]];
    self.muteNotificationImageView.hidden = model.status;
    if (!model.typeCount) {
        [self.redPoint setHidden:YES];
        [self.unReadCountLb setHidden:YES];
    }
    else {
        [self.redPoint setHidden:model.status];
        [self.unReadCountLb setHidden:!model.status];
        [self.unReadCountLb setText:model.typeCount > 99 ? [NSString stringWithFormat:@"•••  "] : [NSString stringWithFormat:@"%ld  ",model.typeCount]];
    }
    
}

#pragma mark - init UI

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font_32];
        [_titleLabel setText:@"监测提醒"];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont font_28];
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _subTitleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel ) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont font_24];
        _timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _timeLabel;
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [UIView new];
        [_redPoint setBackgroundColor:[UIColor colorWithHexString:@"f43530"]];
        [_redPoint.layer setCornerRadius:REDPOINTWEIHT/2];
        [_redPoint setClipsToBounds:YES];
    }
    return _redPoint;
}

- (UIImageView *)muteNotificationImageView {
    if (!_muteNotificationImageView) {
        UIImage *image = [UIImage imageNamed:@"chat_muteNotification"];
        _muteNotificationImageView = [[UIImageView alloc] initWithImage:image];
        [_muteNotificationImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _muteNotificationImageView;
}

- (UILabel *)unReadCountLb {
    if (!_unReadCountLb) {
        _unReadCountLb = [UILabel new];
        [_unReadCountLb.layer setBackgroundColor:[[UIColor colorWithHexString:@"f43530"]  CGColor]];
        [_unReadCountLb.layer setCornerRadius:9];
        [_unReadCountLb.layer setBorderWidth:1];
        [_unReadCountLb.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [_unReadCountLb setClipsToBounds:YES];
        [_unReadCountLb setTextColor:[UIColor whiteColor]];
        [_unReadCountLb setFont:[UIFont systemFontOfSize:12]];
        [_unReadCountLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _unReadCountLb;
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
