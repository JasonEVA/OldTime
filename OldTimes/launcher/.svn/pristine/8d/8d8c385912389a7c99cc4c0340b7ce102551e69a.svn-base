//
//  CalculateHeightManager.m
//  Titans
//
//  Created by Andrew Shen on 14-9-25.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "CalculateHeightManager.h"
#import "Slacker.h"
#import "MyDefine.h"
#import "UIImageView+WebCache.h"
#import "ChatEventMissionTableViewCell.h"
#import "AppApprovalModel.h"
#import "Category.h"
#import "IMApplicationEnum.h"
#import <MintcodeIM/MintcodeIM.h>
#import "LinkLabel.h"
#import "ChatLeftVoipTableViewCell.h"
#import "ChatRightVoipTableViewCell.h"
#import "NewChatLeftTextTableViewCell.h"
#import "NewChatShowDateTableViewCell.h"
#import "NewChatLeftImageTableViewCell.h"
#import "NewChatLeftAttachTableViewCell.h"
#import "NewChatLeftVoiceTableViewCell.h"
#import "NewChatEventMissionTableViewCell.h"
#import "NewEventScheduleTableViewCell.h"
#import "NewChatApproveEventTableViewCell.h"
#import "ChatForwardLeftTableViewCell.h"
#import "ChatShowDateTableViewCell.h"
#import "NewChatEventMissionLeftTableViewCell.h"
#import "NewChatEventMissionRightTableViewCell.h"

#define INCREAMENT 25       // 增量
// 下面的宽度都是指包括了气泡的
#define W_MAX   (165 + [Slacker getXMarginFrom320ToNowScreen] * 2)         // 文字最大宽度
#define W_MAX_IMAGE (100 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 图片最大宽度
#define W_MAX_POSITION (200 + [Slacker getXMarginFrom320ToNowScreen] * 2)  // ‘位置’截图最大宽度
#define W_MAX_DATE (230 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 最大宽度

#define X_BUBBLE_MARGIN_BIGGER  5.0        // 真实的图片在气泡内部的较大一边的 MARGIN
#define X_BUBBLE_MARGIN_SMALLER 2.0        // 真实的图片在气泡内部的较小一边的 MARGIN
#define Y_BUBBLE_MARGIN         2.0        // 真实的图片在气泡内部上下边的 MARGIN

#define H_MARGIN_DATE_TOP 12
#define H_MARGIN_EVENT_TOP 3
#define H_MARGIN_DATE_BOTTOM 3
#define H_MIN   80          // 最小高度
#define H_GROUPNICK 10      // 群成员昵称偏移量

@implementation CalculateHeightManager

+ (CGFloat)fetchHeightWhileChattingWithBaseModel:(MessageBaseModel*)model needShowName:(BOOL)needShow {
	CGFloat height = [CalculateHeightManager fetchHeightWithBaseModel:model needShowName:needShow];
	
	if (model._type == msg_personal_voice || model._type == msg_personal_image || model._type == msg_personal_text) {
		if ([ContactDetailModel isGroupWithTarget:model._target]) {
			// 群聊没有已读，都－20
			CGFloat decrease = 20;
			if ([model._toLoginName isEqualToString:model._target]) {
				decrease = 30;
			}
			
			return height - decrease;
		}
		
		if (![model._toLoginName isEqualToString:model._target]) {
			// 单聊对方－20
			return height - 20;
		}
	}
	
	return height;
	
}

+ (CGFloat)fetchAppCardHeightWithBaseModel:(MessageBaseModel*)model needShowName:(BOOL)needShow {
	
	switch ((IM_Applicaion_Type)model._type) {
        case msg_personal_event:
		case IM_Applicaion_task:
			if (![model._toLoginName isEqualToString: model._target]) {
				return [NewChatEventMissionLeftTableViewCell cellHeightWithContent:model needShowNickName:needShow];
			} else {
				[NewChatEventMissionRightTableViewCell cellHeightWithContent:model needShowNickName:needShow];
			}
			return [NewChatEventMissionTableViewCell height];
		case IM_Applicaion_approval:
			return [NewChatApproveEventTableViewCell cellHeightWithAppModel:model.appModel];
		case IM_Applicaion_schedule:
			return [NewEventScheduleTableViewCell heightForModel:model];
		default:
			break;
	}
	
	return 0;
}

+ (CGFloat)fetchHeightWithBaseModel:(MessageBaseModel*)model needShowName:(BOOL)needShow {
	
	switch (model._type) {
		case msg_personal_reSend:
			return 0;
		case msg_personal_text:
			return [NewChatLeftTextTableViewCell cellHeightWithContent:model._content needShowNickName:needShow];
		case msg_personal_alert:
		case msg_other_timeStamp:
			return [ChatShowDateTableViewCell cellHeightWithDateString:model._content];
		case msg_personal_image:
			return [NewChatLeftImageTableViewCell cellHeightWithContent:model needShowNickName:needShow];
		case msg_personal_file:
			return [NewChatLeftAttachTableViewCell cellHeightWithContent:model needShowNickName:needShow];
		case msg_personal_voice:
			return [NewChatLeftVoiceTableViewCell cellHeightWithContent:model needShowNickName:needShow];
		case msg_personal_mergeMessage:
			return [ChatForwardLeftTableViewCell cellHeightWithContent:nil needShowNickName:needShow];
		default:
			break;
	}
	
	switch ((IM_Applicaion_Type)model._type) {
		case IM_Applicaion_task:			
			return [NewChatEventMissionTableViewCell height];
		case IM_Applicaion_approval:
			return [NewChatApproveEventTableViewCell cellHeightWithAppModel:model.appModel];
		case IM_Applicaion_schedule:
			return [NewEventScheduleTableViewCell heightForModel:model];
		default:
			break;
	}
	
	return 0;
	
}

+ (CGFloat)calculateHeightByModel:(MessageBaseModel *)model IsShowGroupMemberNick:(BOOL)isShow
{
    // 需要计算的内容
    id content = nil;
    ContentType type;
    CGFloat height;
    
    if (model._type == msg_personal_reSend) {
        return 0;
    }
    // 文本
    else if (model._type == msg_personal_text)
    {
        content = model._content;
        type = type_text;
    }
    // 系统消息
    else if (model._type == msg_personal_alert)
    {
        content = model._content;
        type = type_date;
    }
    // 语音
    else if (model._type == msg_personal_voice)
    {
        type = type_voice;
    }
    // 图片
    else if (model._type == msg_personal_image) {
        type = type_image;
    }
    else if (model._type == msg_personal_video)
    {
        if (model._markFromReceive)
        {
            content = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
            
        }
        else
        {
            // 区分是web端同步下来的还是本地发送的
            if (model._nativeThumbnailUrl.length == 0)
            {
                content = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
            }
            else
            {
                NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeThumbnailUrl];
                content = [UIImage imageWithContentsOfFile:fullPath];
            }
        }
        type = type_image;
    }
    // 附件
    else if (model._type == msg_personal_file)
    {
        type = type_attachment;
    }
    // 任务消息
    else if (model._type == IM_Applicaion_task)
    {
        type = type_task;
    }
    else if (model._type == IM_Applicaion_schedule)
    {
        type = type_meeting;
        content = model.appModel;
    }
    else if (model._type == IM_Applicaion_approval)
    {
        type = type_approval;
        content = model.appModel;
    }
    else if (model._type == msg_personal_alert)
    {
        type = type_date;
        content = [IMApplicationUtil getMsgTextWithModel:model.appModel];
    }
    else if (model._type == msg_other_timeStamp) {
        type = type_date;
        content = model._content;
    }
    else if (model._type == msg_personal_mergeMessage) {
        type = type_merge;
    }
    else if (model._type == msg_personal_voip) {
        type = type_voip;
    }
    
    if (type == type_image) {
        height = [self calculateImageHeight:model isShowGroupMemberNick:isShow];
    }
    else if (type == type_voip) {
        height = H_MIN;
    }
    else {
        height = [self calculateHeightByContent:content Type:type IsShowGroupMemberNick:isShow];
    }
    switch (type) {
        case type_image:
        case type_text:
        case type_voice:
        case type_voip: {
            if ([ContactDetailModel isGroupWithTarget:model._target]) {
                // 群聊没有已读，都－20
                CGFloat decrease = 20;
                if ([model._toLoginName isEqualToString:model._target]) {
                    decrease = 30;
                }
                
                return height - decrease;
            }
            
            if (![model._toLoginName isEqualToString:model._target]) {
                // 单聊对方－20
                return height - 20;
            }
        }

        // fallthrough
        case type_attachment:
        case type_meeting:
        case type_task:
        case type_approval:
        case type_date:
        case type_merge:
            return height;
        default:
            return 0;
    }
}

+ (CGFloat)calculateHeightByContent:(id)content Type:(ContentType)type IsShowGroupMemberNick:(BOOL)isShow
{
    CGFloat height;
    switch (type)
    {
        case type_postion:
            // 位置（类似图片） 之后要使用时看下是否需要使用 calculateImageHeight:isShowGroupMemberNick:
        {
            // 区分收发（收是NSString，发送是UIImage）
            UIImage *image = nil;
            if ([content isKindOfClass:[NSString class]])
            {
                NSString *strImg = (NSString *)content;
                image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:strImg];
                if (image == nil)
                {
                    image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strImg];
                }
            }
            else if ([content isKindOfClass:[UIImage class]])
            {
                image = (UIImage *)content;
            }
            
            if (image == nil)
            {
                height = W_MAX_IMAGE;
            }
            else
            {
                CGFloat W_img = MIN(W_MAX_POSITION, image.size.width);
                CGFloat H_img = (W_img / image.size.width) * image.size.height;
                height = MAX(H_img + INCREAMENT, H_MIN) + (isShow ? H_GROUPNICK : 0);
            }
            
            break;
        }
        case type_text:
            // 文字
        {
            // 得到输入文字内容长度
            NSString *text = (NSString *)content;
            text = [text stringByReplacingOccurrencesOfString:@" " withString:@" "];
            
            static LinkLabel *linkLabel = nil;
            if (!linkLabel) {
                linkLabel = [LinkLabel new];
            }
            linkLabel.font = [UIFont mtc_font_30];
            [linkLabel setRichText:text atUserList:nil];
            CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:linkLabel.attributedText
                                             withConstraints:CGSizeMake(W_MAX, CGFLOAT_MAX)
                                      limitedToNumberOfLines:0];

            height = MAX(size.height + (INCREAMENT * 2) + 8, H_MIN) + (isShow ? H_GROUPNICK : 0);
            break;
        }
            
        case type_attachment:
            height = H_MIN + (isShow ? H_GROUPNICK : 0);
            break;
            
        case type_voice:
            height = H_MIN + (isShow ? H_GROUPNICK : 0);
            break;
        case type_task:
        {
            height = [ChatEventMissionTableViewCell height] + 20;
            break;
        }
            
        case type_approval:
        {
            MessageAppModel *  messageAppModel = (MessageAppModel*)content;
            
            AppApprovalModel * approvalModel = [AppApprovalModel mj_objectWithKeyValues:messageAppModel.applicationDetailDictionary];
            height = 40 + 40;
            if (messageAppModel.msgHandleStatus == 0) {
                height += 40;
            }
            if (approvalModel.start == approvalModel.end && approvalModel.deadline <= 0) {
                // 仅 分类
                height += 36;
            }else if (approvalModel.start == approvalModel.end && approvalModel.deadline > 0) {
                // 截止
                height += 72;
            }else if (approvalModel.start != approvalModel.end && approvalModel.deadline <= 0) {
                // 时间段
                height += 72;
            }else if (approvalModel.start != approvalModel.end && approvalModel.deadline > 0) {
                //define
                // 截止
                height += 108;
            }
            
        }
            break;
        case type_merge: {
            height = 150 + (isShow ? H_GROUPNICK : 0);
            break;
        }
        case type_meeting:
        {
            MessageAppModel * model = (MessageAppModel *)content;
            height = 193;
            if (model.msgHandleStatus == 1)
            {
                height -= 37;
            }
        }
            break;
        case type_date:
        default:
            // 时间戳
        {
            UIFont *font = [UIFont systemFontOfSize:13];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
            CGSize size = [(NSString *)content boundingRectWithSize:CGSizeMake(W_MAX_DATE, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            height = size.height + H_MARGIN_DATE_TOP + H_MARGIN_DATE_BOTTOM;
        }
            break;
    }
    return height;
}

+ (CGFloat)calculateImageHeight:(MessageBaseModel *)model isShowGroupMemberNick:(BOOL)isShow {
    NSString *imageUrl;
    UIImage *image = nil;
    if (model._markFromReceive) {
        imageUrl = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
    } else {
        // 区分是web端同步下来的还是本地发送的
        if (model._nativeThumbnailUrl.length == 0)
        {
            imageUrl = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
        }
        else
        {
            NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeThumbnailUrl];
            image = [UIImage imageWithContentsOfFile:fullPath];
        }
    }
    
    // 区分收发（收是NSString，发送是UIImage）
    if (!image) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    }
    
    CGFloat imageWidth  = model.attachModel.thumbnailWidth;
    CGFloat imageHeight = model.attachModel.thumbnailHeight;
    
    if (!image) {
        if (model.attachModel.thumbnailHeight == 0) {
            return W_MAX_IMAGE;
        }
    }
    else {
        imageWidth  = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;;
        imageHeight = image.size.height + Y_BUBBLE_MARGIN * 2.0;
    }
    
    CGFloat showWidth = MIN(W_MAX_IMAGE, imageWidth);
    CGFloat showHeight = (showWidth / imageWidth) * imageHeight;
    return  MAX(showHeight + INCREAMENT + 8, H_MIN) + (isShow ? H_GROUPNICK : 0);
}

@end
