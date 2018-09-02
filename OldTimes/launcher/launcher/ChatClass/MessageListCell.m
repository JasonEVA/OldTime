//
//  MessageListCell.m
//  Titans
//
//  Created by Remon Lv on 14-8-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MessageListCell.h"
#import <MJExtension/MJExtension.h>
#import <MintcodeIM/MintcodeIM.h>
#import "MessageHeadImageVIew.h"
#import "IMApplicationEnum.h"
#import "IMNickNameManager.h"
#import "NSDate+MsgManager.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface MessageListCell()

@property (nonatomic, strong) MessageHeadImageVIew *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *muteNotificationImageView;

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
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13.5);
            make.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@47);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(0);
            make.top.equalTo(self.contentView).offset(10);
            make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-13);
        }];
        
        [self.muteNotificationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.timeLabel);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)updateConstraints {
    
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentView).offset(-10);
        
        if (self.muteNotificationImageView.hidden) {
            make.right.lessThanOrEqualTo(self.contentView).offset(-13);
        } else {
            make.right.lessThanOrEqualTo(self.muteNotificationImageView.mas_left).offset(-13);
        }
    }];
    
    [super updateConstraints];
}

// 设置单元格内容
- (void)setModel:(ContactDetailModel *)model
{
    // 处理后的时间
    if (model._timeStamp != 0)
    {
        NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model._timeStamp appendMinute:NO];
        [self.timeLabel setText:strDate];
    }
    
    [self.muteNotificationImageView setHidden:model._muteNotification == 0];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    // 普通聊天
    if (!model._isApp && ![model isRelationSystem]) {
        NSString *nickName = [IMNickNameManager showNickNameWithOriginNickName:model._nickName userId:model._target];
        //在群组中直接显示nickname
        [self.titleLabel setText:model._isGroup?model._nickName:nickName];
//        [self.titleLabel setText:nickName];
        // 有人at我
        BOOL isAtMe = model._atMe;
        
        // 先显示@，再显示草稿
        NSMutableAttributedString *attributeString = [NSMutableAttributedString new];
        if (isAtMe) {
            attributeString = [[NSMutableAttributedString alloc] initWithString:LOCAL(CHAT_ATME) attributes:[self atUserFontDictionary]];
        }
        
        // 普通文字
        NSString *content = model._content;
        NSString *occurrenceString;
        NSString *replaceString;
        if ([model verifyType:msg_personal_image]) {
            occurrenceString = wz_image_type;
            replaceString = [NSString stringWithFormat:@"[%@]", LOCAL(TITLE_BTN_IMG)];
        }
        else if ([model verifyType:msg_personal_voice]) {
            occurrenceString = wz_voice_type;
            replaceString = [NSString stringWithFormat:@"[%@]", LOCAL(MESSAGE_VOICE)];
        }
        else if ([model verifyType:msg_personal_video]) {
            occurrenceString = wz_viedo_type;
            replaceString = [NSString stringWithFormat:@"[%@]", @"视频"];
        }
        else if ([model verifyType:msg_personal_file]) {
            occurrenceString = wz_file_type;
            replaceString = [NSString stringWithFormat:@"[%@]", LOCAL(TITLE_BTN_FILE)];
        }
        else if ([model verifyType:msg_personal_mergeMessage]) {
            occurrenceString = wz_mergetForward_type;
            replaceString = [NSString stringWithFormat:@"[%@]", LOCAL(SEARCH_HISTORY)];
        }
        else if ([model verifyType:msg_personal_voip]) {
            content = [content stringByReplacingOccurrencesOfString:wz_voiceVoip_type withString:@"[视频聊天]"];
            
            occurrenceString = wz_viedoVoip_type;
            replaceString = [NSString stringWithFormat:@"[%@]", @"语音聊天"];
        }
        
        if (occurrenceString) {
            content = [content stringByReplacingOccurrencesOfString:occurrenceString withString:replaceString];
        }
        
        [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:[self normalFontDictionary]]];
        
        NSString *draft = model._draft.string;
        if (!isAtMe && [draft length]) {
            // 不是atMe 有草稿
            attributeString = [[NSMutableAttributedString alloc] initWithString:LOCAL(CHAT_DRAFT) attributes:[self draftFontDictionary]];
            [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:draft attributes:[self normalFontDictionary]]];
            
        }
        
        [self.subTitleLabel setAttributedText:attributeString];
        
        // 聊天消息就用URL动态下载绑定
        [self.avatarImageView setImageWithContactModel:model];
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
        
        imageName = @"chat_list_task";
        titleName = LOCAL(Application_Mission_notify);
        imgUrl = [[NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]?:@{@"":@(0),@"": @(1),@"":@(2)}] objectForKey:@(2)];
    }
    else if ([model._target isEqualToString:im_schedule_uid]) {
    
        imageName = @"chat_list_calendar";
        titleName = LOCAL(Application_Calendar_notify);
        imgUrl = [[NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]?:@{@"":@(0),@"": @(1),@"":@(2)}] objectForKey:@(1)];
    }
    else if ([model._target isEqualToString:im_approval_uid]) {
    
        imageName = @"chat_list_leave";
        titleName = LOCAL(Application_Apply_notify);
        imgUrl = [[NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]?:@{@"":@(0),@"": @(1),@"":@(2)}] objectForKey:@(0)];
    }
    
    if ([model isRelationSystem]) {
        imageName = @"chat_list_leave";
        titleName = @"好友验证";
    }
    
    [self.avatarImageView setImage:[UIImage imageNamed:imageName] imgUrlstring:imgUrl InfoCount:model._countUnread];
    [self.titleLabel setText:titleName];
    
    // 应用系统消息的国际化
    MessageAppModel *appModel = model.appModel;
    // 判断是否是应用系统消息，应用系统消息需要翻译
    if ([model.appModel isAppSystemMessage] && ![model isRelationSystem])
    {
        
        // 要显示的文字
        NSString *content = [IMApplicationUtil getMsgTextWithModel:appModel];
        
        //应产品要求加上名字  by conan
        if ([model.appModel.msgTransType isEqualToString:@"meetingAttend"] || [model.appModel.msgTransType isEqualToString:@"meetingAttendDefinite"] || [model.appModel.msgTransType isEqualToString:@"meetingRefuseAttend"] || [model.appModel.msgTransType isEqualToString:@"meetingRefuseAttendDefinite"] || [model.appModel.msgTransType isEqualToString:@"approvePass"] || [model.appModel.msgTransType isEqualToString:@"approveBack"] || [model.appModel.msgTransType isEqualToString:@"approveBackV2"] || [model.appModel.msgTransType isEqualToString:@"approveBackDefinite"] || [model.appModel.msgTransType isEqualToString:@"approveRefuse"] || [model.appModel.msgTransType isEqualToString:@"approveRefuseDefinite"])
        {
            content = [NSString stringWithFormat:@"%@%@",model.appModel.msgFrom, content];
        }
        
     
        //显示附件
        NSDictionary *dict = [appModel.msgInfo mj_JSONObject];
        NSString *comment = dict[@"comment"];
        NSString *filePath = dict[@"filePath"];
        if (comment&& ![comment isEqualToString:@""]&&filePath&& ![filePath isEqualToString:@""]) {
            content = [NSString stringWithFormat:@"%@在%@留下了%@",model.appModel.msgFrom,appModel.msgContent,comment];
        }
        // 内容
        [self.subTitleLabel setText:content];
    }
    else
    {
        
        
//        NSDictionary *dict = [appModel.msgInfo mj_JSONObject];
//        NSString *comment = dict[@"comment"];
//        NSString *filePath = dict[@"filePath"];
//        if (comment&& ![comment isEqualToString:@""]&&filePath&& ![filePath isEqualToString:@""]) {
//           NSString* content = [NSString stringWithFormat:@"%@添加了附件:%@",model.appModel.msgFrom,comment];
//            [self.subTitleLabel setText:content];
//        }
//        else
//        {
            // 内容
            [self.subTitleLabel setText:model._content];
//        }
    }
}

#pragma mark - Private Method
- (NSDictionary *)normalFontDictionary {
    return @{NSForegroundColorAttributeName:[UIColor mediumFontColor],
             NSFontAttributeName:[UIFont mtc_font_26]};
}

- (NSDictionary *)atUserFontDictionary {
    return @{NSFontAttributeName:[UIFont mtc_font_26],
             NSForegroundColorAttributeName:[UIColor themeRed]};
}

- (NSDictionary *)draftFontDictionary {
    return @{NSFontAttributeName:[UIFont mtc_font_26],
             NSForegroundColorAttributeName:[UIColor themeGreen]};
}

#pragma mark - Initializer
- (MessageHeadImageVIew *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[MessageHeadImageVIew alloc] init];
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont mtc_font_26];
        _subTitleLabel.textColor = [UIColor mediumFontColor];
    }
    return _subTitleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel ) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont mtc_font_24];
        _timeLabel.textColor = [UIColor minorFontColor];
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

@end
