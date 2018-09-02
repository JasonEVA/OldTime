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
    //每次执行set 方法时进行初始化
    self.subTitleLabel.text = @"";
    self.titleLabel.text = @"";
    self.timeLabel.text = @"";
    
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
        else if ([model verifyType:msg_personal_mergeMessage]) {
            occurrenceString = wz_mergetForward_type;
            replaceString = [NSString stringWithFormat:@"[%@]", @"历史消息"];
        }
        else if ([model verifyType:msg_personal_news]) {
            occurrenceString = wz_news_type;
            replaceString = [NSString stringWithFormat:@"[%@]", @"健康课堂"];
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
        
        imageName = @"my_mession";
        titleName = @"协同任务";
        imgUrl = [[NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]?:@{@"":@(0),@"": @(1),@"":@(2)}] objectForKey:@(2)];
    }
    
    if ([model isRelationSystem]) {
        imageName = @"system_message";
        titleName = @"好友验证";
    }
    
//    [self.avatarImageView setImage:[UIImage imageNamed:imageName] InfoCount:model._countUnread];
    [self.avatarImageView setImage:[UIImage imageNamed:imageName] imgUrlstring:imgUrl InfoCount:model._countUnread];
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
    return @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],
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
- (MessageHeadImageVIew *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[MessageHeadImageVIew alloc] init];
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font_30];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont font_26];
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

- (UIImageView *)muteNotificationImageView {
    if (!_muteNotificationImageView) {
        UIImage *image = [UIImage imageNamed:@"chat_muteNotification"];
        _muteNotificationImageView = [[UIImageView alloc] initWithImage:image];
        [_muteNotificationImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _muteNotificationImageView;
}

@end
