//
//  NewCalculateHeightManager.m
//  launcher
//
//  Created by 马晓波 on 16/3/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalculateHeightManager.h"
#import "Slacker.h"
#import "MyDefine.h"
#import "UIImageView+WebCache.h"
#import "ChatEventMissionTableViewCell.h"
#import "AppApprovalModel.h"
#import "Category.h"
#import "IMApplicationEnum.h"
#import <MintcodeIM/MintcodeIM.h>
#import <DateTools.h>

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

@implementation NewCalculateHeightManager
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
    
    if (type == type_image) {
        height = [self calculateImageHeight:model isShowGroupMemberNick:isShow];
    } else {
        height = [self calculateHeightByContent:content Type:type IsShowGroupMemberNick:isShow];
    }
    switch (type) {
        case type_image:
        case type_text:
        case type_voice:
        case type_attachment: {
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
        case type_meeting:
        case type_task:
        case type_approval:
        case type_date:
        default:
            return height;
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
            UIFont *font = [UIFont mtc_font_30];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
            CGSize size = [text boundingRectWithSize:CGSizeMake(W_MAX, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
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
        case type_newcomment:
        {
            
            UIFont *font = [UIFont systemFontOfSize:13];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
            CGSize size = [content boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            
            // 设置label长度
            if (size.height > 20)
            {
                return 165;
            }
            else
            {
                return 145;
            }
        }
            break;
        case type_approval:
        {
            MessageAppModel *  messageAppModel = (MessageAppModel*)content;
            AppApprovalModel *approveModel = [AppApprovalModel mj_objectWithKeyValues:messageAppModel.applicationDetailDictionary];
            
            // 要显示的行数
            NSInteger showIndex = MIN(4, [approveModel sortedForChatUI].count);
            height = 97.5 + showIndex * 35;
            if (messageAppModel.msgHandleStatus == 0) {
                height += 50;
            } else {
                height += 20;
            }
        }
            break;
            
        case type_meeting:
        {
            MessageAppModel * model = (MessageAppModel *)content;
            height = 207.5;
            if (model.msgHandleStatus == 1)
            {
                height -= 40;
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

- (NSString *)getDeadLineTime:(long long)time
{
    if (time <= 0)
    {
        return nil;
    }
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDate *today = [NSDate date];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
    
    if (date.year == today.year && date.month == today.month && date.day == today.day)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        //        str = [NSString stringWithFormat:@"%@%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date],LOCAL(APPLY_ACCEPT_BEFORE)];
        //去掉截止
        str = [NSString stringWithFormat:@"%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date]];
    }
    else if (date.year == today.year)
    {
        //        str = [NSString stringWithFormat:@"%ld/%ld(%@)%ld:%ld%@",date.month,date.day,[arr objectAtIndex:date.weekday -1],date.hour,date.minute,LOCAL(APPLY_ACCEPT_BEFORE)];
        //去掉截止
        str = [NSString stringWithFormat:@"%ld/%ld(%@)%ld:%ld",(long)date.month,date.day,[arr objectAtIndex:date.weekday -1],date.hour,date.minute];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy/MM/dd HH:mm"];
        //        str = [NSString stringWithFormat:@"%@%@",[df stringFromDate:date],LOCAL(APPLY_ACCEPT_BEFORE)];
        //去掉截止
        str = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
    }
    if ([str hasPrefix:@"1970"]) return nil;
    return str;
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
