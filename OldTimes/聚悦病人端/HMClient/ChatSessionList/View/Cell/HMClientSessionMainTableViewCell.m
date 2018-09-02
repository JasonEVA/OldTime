//
//  HMClientSessionMainTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/10/19.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMClientSessionMainTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "NSDate+MsgManager.h"
#import "IMNewsModel.h"
#import "IMPatientContactExtensionModel.h"

#define COLOR_BG [UIColor colorWithRed:238.0/255.0 green:44.0/255.0 blue:76.0/255.0 alpha:1.0]

static const CGFloat unReadCountLbSize = 17; //带数字红点尺寸

@interface HMClientSessionMainTableViewCell ()
@property (nonatomic, strong) UIImageView *leftPointImageView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *detailTitelLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *unReadCountLb;
@property (nonatomic, strong) UIImageView *overdueImageView;

@end



@implementation HMClientSessionMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [self configElements];
    }
    return self;
}


#pragma mark -private method
- (void)configElements {
    UIView *backView = [UIView new];
    [backView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    [backView.layer setCornerRadius:5];
    [backView setClipsToBounds:YES];
    
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
    }];
    
    [backView addSubview:self.overdueImageView];

    [backView addSubview:self.leftPointImageView];
    [backView addSubview:self.timeLb];
    [backView addSubview:self.titelLb];
    [backView addSubview:self.detailTitelLb];
    [backView addSubview:self.unReadCountLb];

    [self.leftPointImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.top.equalTo(backView).offset(13);
        make.width.height.equalTo(@40);
    }];
    
    [self.unReadCountLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-19);
        make.height.equalTo(@(unReadCountLbSize));
        make.centerY.equalTo(self.leftPointImageView);
        make.left.lessThanOrEqualTo(backView.mas_right).offset(-unReadCountLbSize-19);
    }];
    
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftPointImageView.mas_right);
        make.top.equalTo(self.leftPointImageView).offset(10);
        make.right.equalTo(backView).offset(-60);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-15);
        make.top.equalTo(self.titelLb.mas_bottom).offset(10);
        make.bottom.equalTo(backView).offset(-18);
        make.width.equalTo(@50);
    }];
    
    
    
    [self.detailTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.centerY.equalTo(self.timeLb);
        make.right.equalTo(self.titelLb);
    }];
    
    
    
    [self.overdueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(backView);
    }];
    
    
}

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


#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)setModel:(ContactDetailModel *)model {
    
    IMPatientContactExtensionModel *extensionModel = [IMPatientContactExtensionModel mj_objectWithKeyValues:[model._extension mj_JSONObject]];
    
    [self.overdueImageView setHidden:extensionModel.canChat];
    
    if (!extensionModel.canChat) {
        [self.leftPointImageView setImage:[UIImage imageNamed:@"img_expired"]];
    }
    else {
        if (extensionModel.classify == 5) {
            [self.leftPointImageView setImage:[UIImage imageNamed:@"img_single"]];

        }
        else {
            [self.leftPointImageView setImage:[UIImage imageNamed:@"img_main"]];
        }
    }
    
    // 处理后的时间
    if (model._timeStamp != 0)
    {
        NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model._timeStamp appendMinute:NO];
        [self.timeLb setText:strDate];
    }
    
    if (!model._countUnread) {
        [self.unReadCountLb setHidden:YES];
    }
    else {
        [self.unReadCountLb setHidden:model._muteNotification];
        [self.unReadCountLb setText:model._countUnread > 99 ? [NSString stringWithFormat:@"⋅⋅⋅  "] : [NSString stringWithFormat:@"%ld  ",model._countUnread]];
    }
    
    // 普通聊天
    if (!model._isApp && ![model isRelationSystem]) {
        [self.titelLb setText:model._nickName];
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
//        if (!isAtMe && [draft length]) {
//            // 不是atMe 有草稿
//            attributeString = [[NSMutableAttributedString alloc] initWithString:@"[草稿]" attributes:[self draftFontDictionary]];
//            [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:draft attributes:[self normalFontDictionary]]];
//
//        }
        
        [self.detailTitelLb setAttributedText:attributeString];
        
        
        return;
    }
    
        [self.detailTitelLb setText:model._content];

    
    
}

#pragma mark - init UI
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

- (UIImageView *)leftPointImageView {
    if (!_leftPointImageView) {
        _leftPointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_main"]];
    }
    return _leftPointImageView;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:16]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setNumberOfLines:2];
        [_titelLb setText:@"占位文案"];
    }
    return _titelLb;
}

- (UILabel *)detailTitelLb {
    if (!_detailTitelLb) {
        _detailTitelLb = [UILabel new];
        [_detailTitelLb setFont:[UIFont systemFontOfSize:14]];
        [_detailTitelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_detailTitelLb setText:@"占位文案"];
    }
    return _detailTitelLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb setFont:[UIFont systemFontOfSize:14]];
        [_timeLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_timeLb setText:@"占位文案"];
        [_timeLb setTextAlignment:NSTextAlignmentRight];
    }
    return _timeLb;
}

- (UIImageView *)overdueImageView {
    if (!_overdueImageView) {
        _overdueImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_expired2"]];
    }
    return _overdueImageView;
}

@end
