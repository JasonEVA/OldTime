//
//  MessageListCell.m
//  Titans
//
//  Created by Remon Lv on 14-8-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MessageListCell.h"
#import <MJExtension/MJExtension.h>
#import "MessageHeadImageVIew.h"
#import "NSDate+MsgManager.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "IMApplicationConfigure.h"
#import "IMPatientContactExtensionModel.h"
#import "ChatIMConfigure.h"
#import "JWHeadImageView.h"
#import "IMNewsModel.h"

#define COLOR_BG [UIColor colorWithRed:238.0/255.0 green:44.0/255.0 blue:76.0/255.0 alpha:1.0]

static const CGFloat unReadCountLbSize = 17; //带数字红点尺寸
static const CGFloat redPointSize = 8;        //不带数字尺寸

@interface MessageListCell()

@property (nonatomic, strong) JWHeadImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *muteNotificationImageView;
@property (nonatomic, strong) UILabel *payLb;   //收费标示
// 未读红点
@property (nonatomic, strong) UILabel *unReadCountLb;
@property (nonatomic, strong) UIView *redPoint;
@property (nonatomic, strong) ContactDetailModel *contactDetailModel;
@end

@implementation MessageListCell

+ (NSString *)identifier { return NSStringFromClass(self);}
+ (CGFloat)height        { return 60;}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.canLeftHandleIfNeed = YES;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.muteNotificationImageView];
        [self.contentView addSubview:self.payLb];
        [self.contentView addSubview:self.redPoint];
        [self.contentView addSubview:self.unReadCountLb];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13.5);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@45);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        [self.payLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.width.equalTo(@35);
            make.height.equalTo(@17);
            make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-13);
        }];
        
        
    }
    return self;
}

- (void)updateConstraints {
    
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-5);
    }];
    
    [self.unReadCountLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel);
        make.height.equalTo(@(unReadCountLbSize));
        make.centerY.equalTo(self.subTitleLabel);
        make.left.lessThanOrEqualTo(self.timeLabel.mas_right).offset(-unReadCountLbSize);
    }];
    
    [self.redPoint mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel);
        make.centerY.equalTo(self.subTitleLabel);
        make.width.height.equalTo(@(redPointSize));
    }];
    
    [self.muteNotificationImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.contactDetailModel._countUnread) {
            make.right.equalTo(self.redPoint.mas_left).offset(-8);
        }
        else {
            make.right.equalTo(self.timeLabel);

        }
        make.centerY.equalTo(self.subTitleLabel);
    }];
    
    [super updateConstraints];
}

// 设置单元格内容
- (void)setModel:(ContactDetailModel *)model
{
    self.contactDetailModel = model;
    //每次执行set 方法时进行初始化
    self.subTitleLabel.text = @"";
    self.titleLabel.text = @"";
    self.timeLabel.text = @"";
    
     [self.contentView setBackgroundColor:model._stick ? [UIColor colorWithHexString:@"eeefef"]:[UIColor whiteColor]];
    
    // 处理后的时间
    if (model._timeStamp != 0)
    {
        NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model._timeStamp appendMinute:NO];
        [self.timeLabel setText:strDate];
    }
    
    [self.muteNotificationImageView setHidden:model._muteNotification == 0];
    if (!model._isGroup) {
        [self.muteNotificationImageView setHidden:YES];
    }
    if (!model._countUnread) {
        [self.redPoint setHidden:YES];
        [self.unReadCountLb setHidden:YES];
    }
    else {
        [self.redPoint setHidden:!model._muteNotification];
        [self.unReadCountLb setHidden:model._muteNotification];
        [self.unReadCountLb setText:model._countUnread > 99 ? [NSString stringWithFormat:@"⋅⋅⋅  "] : [NSString stringWithFormat:@"%ld  ",model._countUnread]];
    }

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    // 普通聊天
    if (!model._isApp && ![model isRelationSystem]) {
        [self.titleLabel setText:model._nickName];
        // 有人at我
        BOOL isAtMe = model._atMe;
        
        // 先显示@，再显示草稿
        NSMutableAttributedString *attributeString = [NSMutableAttributedString new];
        if (isAtMe) {
            attributeString = [[NSMutableAttributedString alloc] initWithString:@"[有人@我]" attributes:[self atUserFontDictionary]];
        }
        
        // 普通文字
        NSString *content = model._content;
        NSString *occurrenceString;
        NSString *replaceString;
        if ([model verifyType:msg_personal_image]) {
            occurrenceString = wz_image_type;
            replaceString = [NSString stringWithFormat:@"[%@]",@"图片"];
        }
        else if ([model verifyType:msg_personal_voice]) {
            occurrenceString = wz_voice_type;
            replaceString = [NSString stringWithFormat:@"[%@]", @"语音"];
        }
        else if ([model verifyType:msg_personal_video]) {
            occurrenceString = wz_viedo_type;
            replaceString = [NSString stringWithFormat:@"[%@]", @"视频"];
        }
        else if ([model verifyType:msg_personal_file]) {
            occurrenceString = wz_file_type;
            replaceString = [NSString stringWithFormat:@"[%@]", @"文件"];
        }
        else if ([model verifyType:msg_personal_news]) {
            occurrenceString = wz_news_type;
            //图文消息
            NSString* content = model._lastMsgModel._content;
            if (!content || 0 == content.length) {
                return;
            }
            NSDictionary* dicContent = [NSDictionary JSONValue:content];
            if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
            {
                return;
            }
            IMNewsModel* modelContent = [IMNewsModel mj_objectWithKeyValues:dicContent];
            [modelContent conmfirmNewsType];

            switch (modelContent.newsType) {
                case News_Normal:
                {
                    replaceString = [NSString stringWithFormat:@"[%@]", @"健康宣教"];

                    break;
                }
                case News_EdcuationClassroom:
                {
                    replaceString = [NSString stringWithFormat:@"[%@]", @"健康课堂"];

                    break;
                }
                case News_Notice:
                {
                    replaceString = [NSString stringWithFormat:@"[%@]", @"公告"];

                    break;
                }
                default:
                    replaceString = [NSString stringWithFormat:@"[%@]", @"图文消息"];

                    break;
            }
        }

        else if ([model verifyType:msg_personal_mergeMessage]) {
            occurrenceString = wz_mergetForward_type;
            replaceString = [NSString stringWithFormat:@"[%@]", @"历史消息"];
        }
        else {
            // 如果是单聊的应用消息
            NSDictionary *dictTemp = [content mj_JSONObject];
            NSString *str = dictTemp[@"msgTitle"];
            if (str) {
                content = str;
            }
        }
        if (occurrenceString) {
            content = [content stringByReplacingOccurrencesOfString:occurrenceString withString:replaceString];
        }
        
        [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:[self normalFontDictionary]]];
        
        NSString *draft = model._draft.string;
        if (!isAtMe && [draft length]) {
            // 不是atMe 有草稿
            attributeString = [[NSMutableAttributedString alloc] initWithString:@"[草稿]" attributes:[self draftFontDictionary]];
            [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:draft attributes:[self normalFontDictionary]]];
            
        }
        
        [self.subTitleLabel setAttributedText:attributeString];
        
        // 聊天消息就用URL动态下载绑定
        if (model._isGroup) {
            // 群都有本地生成头像
            [self.avatarImageView fillImageWithName:model._nickName ];
        }
        else {
            [self.avatarImageView fillImageWithName:model._nickName url:avatarURL(avatarType_80, model._target)];
        }
        
//        //添加收费标识
//        if (model._extension && [model._tag isEqualToString:im_doctorPatientGroupTag]) {
//            IMPatientContactExtensionModel *extension = [[IMPatientContactExtensionModel alloc] initWithExtensionJsonString:model._extension];
//            [self.payLb setHidden:!extension.isPay];
//        }
//        else {
//            [self.payLb setHidden:YES];
//        }
        
        return;
    }
    
    // 是app消息
    NSString *imageName = @"";
    NSString *titleName = @"";
    NSString *imgUrl = @"";
    NSString *Path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"appImgs"];
    // 中文名字
    if ([model._target isEqualToString:im_task_uid]) {
        
        imageName = @"my_mession";
        titleName = @"协同任务";
        imgUrl = [[NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]?:@{@"":@(0),@"": @(1),@"":@(2)}] objectForKey:@(2)];
    }
    
    if ([model isRelationSystem]) {
        imageName = @"system_message";
        titleName = @"好友验证";
    }
    [self.avatarImageView fillImageWithImage:[UIImage imageNamed:imageName]];
    [self.titleLabel setText:titleName];
    
    if ([model._target isEqualToString:im_task_uid])
    {
        NSDictionary *dictTemp = [model._lastMsgModel._content mj_JSONObject];
        NSString *str = dictTemp[@"msgInfo"];
        //为应对历史和新收到的model数据结构不同
        if (!str) {
            NSDictionary *dict = [dictTemp[@"content"] mj_JSONObject];
            str = dict[@"msgInfo"];
        }
        // 要显示的文字
        [self.subTitleLabel setText:str ?: @""];
    }
    else
    {
        // 内容
        [self.subTitleLabel setText:model._content];
    }
    
    
    

}

#pragma mark - Private Method
- (NSDictionary *)normalFontDictionary {
    return @{NSForegroundColorAttributeName:[UIColor commonLightGrayColor_999999],
             NSFontAttributeName:[UIFont font_26]};
}

- (NSDictionary *)atUserFontDictionary {
    return @{NSFontAttributeName:[UIFont font_26],
             NSForegroundColorAttributeName:[UIColor commonRedColor]};
}

- (NSDictionary *)draftFontDictionary {
    return @{NSFontAttributeName:[UIFont font_26],
             NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ff6088"]};
}

#pragma mark - Initializer
- (JWHeadImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[JWHeadImageView alloc] init];
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font_30];
        _titleLabel.textColor = [UIColor commonBlackTextColor_333333];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont font_26];
        _subTitleLabel.textColor = [UIColor commonLightGrayColor_999999];
    }
    return _subTitleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel ) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont font_24];
        _timeLabel.textColor = [UIColor commonLightGrayColor_999999];
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _timeLabel;
}

- (UIImageView *)muteNotificationImageView {
    if (!_muteNotificationImageView) {
        UIImage *image = [UIImage imageNamed:@"chat_muteNotification"];
        _muteNotificationImageView = [[UIImageView alloc] initWithImage:image];
        [_muteNotificationImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _muteNotificationImageView;
}

- (UILabel *)payLb {
    if (!_payLb) {
        _payLb = [UILabel new];
        [_payLb setText:@"收费"];
        [_payLb setTextColor:[UIColor colorWithHexString:@"0099ff"]];
        [_payLb setFont:[UIFont font_26]];
        [_payLb setBackgroundColor:[UIColor colorWithHexString:@"c7e8ff"]];
        [_payLb setTextAlignment:NSTextAlignmentCenter];
        [_payLb.layer setCornerRadius:1];
        [_payLb setClipsToBounds:YES];
        [_payLb setHidden:YES];
    }
    return _payLb;
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [UIView new];
        [_redPoint setBackgroundColor:COLOR_BG];
        [_redPoint.layer setCornerRadius:redPointSize / 2];
        [_redPoint setClipsToBounds:YES];
    }
    return _redPoint;
}

- (UILabel *)unReadCountLb {
    if (!_unReadCountLb) {
        _unReadCountLb = [UILabel new];
        [_unReadCountLb.layer setBackgroundColor:[COLOR_BG CGColor]];
        [_unReadCountLb.layer setCornerRadius:unReadCountLbSize / 2];
        [_unReadCountLb setClipsToBounds:YES];
        [_unReadCountLb setTextColor:[UIColor whiteColor]];
        [_unReadCountLb setFont:[UIFont systemFontOfSize:12]];
        [_unReadCountLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _unReadCountLb;
}

@end
