//
//  CalculateHeightManager.h
//  Titans
//
//  Created by Andrew Shen on 14-9-25.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  根据内容计算单元格高度manager

#import <UIKit/UIKit.h>

typedef enum
{
    type_image,
    type_text,
    type_date,
    type_voice,
    type_attachment,
    type_merge,
    type_postion,
    type_task,
    type_approval,
    type_meeting,
    type_voip
}ContentType;

@class MessageBaseModel;

#define H_critical   300          // 新消息到达自动滚动到底部的视界高度

@interface CalculateHeightManager : NSObject

// 根据Model自动计算高度
+ (CGFloat)calculateHeightByModel:(MessageBaseModel *)model IsShowGroupMemberNick:(BOOL)isShow ;

/// 根据消息类型和内容计算单元格高度 (图片为单独方法)
+ (CGFloat)calculateHeightByContent:(id)content Type:(ContentType)type IsShowGroupMemberNick:(BOOL)isShow DEPRECATED_ATTRIBUTE;

/// 计算图片高度
+ (CGFloat)calculateImageHeight:(MessageBaseModel *)model isShowGroupMemberNick:(BOOL)isShow DEPRECATED_ATTRIBUTE;

+ (CGFloat)fetchHeightWhileChattingWithBaseModel:(MessageBaseModel*)model needShowName:(BOOL)needShow;
+ (CGFloat)fetchHeightWithBaseModel:(MessageBaseModel*)model needShowName:(BOOL)needShow;
+ (CGFloat)fetchAppCardHeightWithBaseModel:(MessageBaseModel*)model needShowName:(BOOL)needShow;

@end
