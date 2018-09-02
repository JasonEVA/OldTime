//
//  MessageBaseModel+CellSize.m
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MessageBaseModel+CellSize.h"

@implementation MessageBaseModel (CellSize)

- (CGFloat) bubbleWidth
{
    CGFloat bubbleWidth = 0;
    switch (self._type)
    {
        case msg_personal_text:
        {
            //文本消息
            bubbleWidth = [self textbubbleWidth];
        }
            break;
        case msg_personal_image:
        {
            bubbleWidth = [self imagebubbleWidth];
        }
            break;
        case msg_personal_voice:
        {
            bubbleWidth = [self voicebubbleWidth];
        }
            break;
        case msg_personal_event:
        case msg_usefulMsgMin:
        {
            NSString* content = self._content;
            if (!content || 0 == content.length) {
                break;
            }
            NSDictionary* dicContent = [NSDictionary JSONValue:content];
            if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
            {
                break;
            }
            MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
            NSString* contentType = modelContent.type;
           
            if (!contentType || 0 == contentType.length)
            {
                bubbleWidth = [self personEventWidth];
                break;
                
            }
            
            if ([contentType isEqualToString:@"testResultPage"]|| [contentType isEqualToString:@"healthTest"])
            {
                //监测预警消息
                bubbleWidth = [self personEventWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"recipePage"] || [contentType isEqualToString:@"stopRecipe"])
            {
                //监测预警消息
                bubbleWidth = [self personEventWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"userServiceOrder"] ||
                [contentType isEqualToString:@"serviceComments"] ||
                [contentType isEqualToString:@"serviceOverTime"])
            {
                //服务评价消息
                bubbleWidth = [self personEventWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyPush"])
            {
                bubbleWidth = [self personEventWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"survey"])
            {
                bubbleWidth = [self personEventWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyFilled"])
            {
                bubbleWidth = [self personEventWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyReply"])
            {
                bubbleWidth = [self personEventWidth];
                break;
            }
            if ([contentType isEqualToString:@"healthyReportDetPage"])
            {
                bubbleWidth = [self personEventWidth];
                break;
            }

            if ([contentType isEqualToString:@"applyAppoint"])
            {
                //发起申请
                bubbleWidth = [self personEventWidth];
                break;
            }
            if ([contentType isEqualToString:@"appointAgree"])
            {
                //同意申请
                bubbleWidth = [self personEventWidth];
                break;
            }
            if ([contentType isEqualToString:@"appointRefuse"])
            {
                //拒绝申请
                bubbleWidth = [self personEventWidth];
                break;
            }
            if ([contentType isEqualToString:@"appointCancel"])
            {
                //约诊取消
                bubbleWidth = [self personEventWidth];
                break;
            }
            if ([contentType isEqualToString:@"appointChange"])
            {
                //预约变更
                bubbleWidth = [self personEventWidth];
                break;
            }

            if ([contentType isEqualToString:@"healthySubmit"] ||
                [contentType isEqualToString:@"healthyAdjust"] ||
                [contentType isEqualToString:@"healthPlan"])
            {
                //发送计划
                bubbleWidth = [self personEventWidth];
                break;
            }
            if ([contentType isEqualToString:@"healthyExecute"])
            {
                //修改计划
                bubbleWidth = [self personEventWidth];
                break;
            }
            if ([contentType isEqualToString:@"healthyStop"])
            {
                //终止计划
                bubbleWidth = [self personEventWidth];
                break;
            }
            if ([contentType isEqualToString:@"adjustWarning"]||
                [contentType isEqualToString:@"continueTest"]||
                [contentType isEqualToString:@"tellVisitDoc"])
            {
                bubbleWidth = [self personEventWidth];
                break;
            }
            if ([contentType isEqualToString:@"sendCompleateDocMsg"]) {
                bubbleWidth = [self personEventWidth];
                break;
            }
        }
            break;
        default:
            break;
    }
    return bubbleWidth;
}

- (CGFloat) bubbleHeight
{
    CGFloat bubbleHeihgt = 0;
    switch (self._type)
    {
            case msg_personal_alert:
        {
            bubbleHeihgt = [self alertBubbleHeight];
        }
        case msg_personal_text:
        {
            //文本消息
            bubbleHeihgt = [self textBubbleHeight];
        }
            break;
        case msg_personal_image:
        {
            bubbleHeihgt = [self imageBubbleHeight];
        }
            break;
        case msg_personal_voice:
        {
            bubbleHeihgt = [self voicebubbleHeight];
        }
            break;
        case msg_personal_event:
        case msg_usefulMsgMin:
        {
            NSString* content = self._content;
            if (!content || 0 == content.length) {
                break;
            }
            NSDictionary* dicContent = [NSDictionary JSONValue:content];
            if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
            {
                break;
            }
            MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
            NSString* contentType = modelContent.type;
           
            if (!contentType || 0 == contentType.length)
            {
                bubbleHeihgt = [self personEventHeight];
                break;
                
            }
            
            if ([contentType isEqualToString:@"testResultPage"] || [contentType isEqualToString:@"healthTest"])
            {
                //监测预警消息
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"recipePage"] || [contentType isEqualToString:@"stopRecipe"])
            {
                //处方消息
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"userServiceOrder"] ||
                [contentType isEqualToString:@"serviceComments"] ||
                [contentType isEqualToString:@"serviceOverTime"])
            {
                //服务评价消息
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyPush"])
            {
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"survey"])
            {
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyFilled"])
            {
                bubbleHeihgt =[self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyReply"])
            {
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"healthyReportDetPage"])
            {
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"applyAppoint"])
            {
                //发起申请
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"appointAgree"])
            {
                //同意申请
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"appointRefuse"])
            {
                //拒绝申请
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"appointCancel"])
            {
                //约诊取消
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"appointChange"])
            {
                //预约变更
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"healthySubmit"] ||
                [contentType isEqualToString:@"healthyAdjust"] ||
                [contentType isEqualToString:@"healthPlan"])
            {
                //发送计划
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"healthyExecute"])
            {
                //修改计划
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"healthyStop"])
            {
                //终止计划
                bubbleHeihgt = [self personEventHeight];
                break;
            }

            if ([contentType isEqualToString:@"adjustWarning"]||
                [contentType isEqualToString:@"continueTest"]||
                [contentType isEqualToString:@"tellVisitDoc"])
            {
                bubbleHeihgt = [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"sendCompleateDocMsg"]) {
                bubbleHeihgt = [self personEventHeight];
                break;
            }
        }
            break;
        default:
            break;
    }
    return bubbleHeihgt;
}

- (CGFloat) cellHeight
{
    CGFloat cellHeihgt = 100;
    
    switch (self._type)
    {
        case msg_personal_alert:
        {
            cellHeihgt = 25 + [self alertBubbleHeight];
        }
            break;
        case msg_personal_text:
        {
            cellHeihgt = 35 + [self textBubbleHeight];
            if (cellHeihgt < 100)
            {
                cellHeihgt = 100;
            }
        }
            break;
        case msg_personal_image:
        {
            cellHeihgt = 35 + [self imageBubbleHeight];
        }
            break;
        case msg_personal_event:
        case msg_usefulMsgMin:
        {
            NSString* content = self._content;
            if (!content || 0 == content.length) {
                break;
            }
            NSDictionary* dicContent = [NSDictionary JSONValue:content];
            if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
            {
                break;
            }
            MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
            NSString* contentType = modelContent.type;
            
            if (!contentType || 0 == contentType.length)
            {
                cellHeihgt = 35 + [self personEventHeight];
                break;
                
            }
            
            if ([contentType isEqualToString:@"testResultPage"] || [contentType isEqualToString:@"healthTest"])
            {
                cellHeihgt = 35 + [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"recipePage"] || [contentType isEqualToString:@"stopRecipe"])
            {
                cellHeihgt = 35 + [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"userServiceOrder"] ||
                [contentType isEqualToString:@"serviceComments"] ||
                [contentType isEqualToString:@"serviceOverTime"])            {
                cellHeihgt = 35 + [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyPush"])
            {
                cellHeihgt = 35 + [self personEventHeight] + 25;
                break;
            }
            
            if ([contentType isEqualToString:@"survey"])
            {
                cellHeihgt = 35 + [self personEventHeight] + 25;
                break;
            }
            
            if ([contentType isEqualToString:@"surveyFilled"])
            {
                cellHeihgt = 35 + [self personEventHeight] + 25;
                break;
            }
            
            if ([contentType isEqualToString:@"surveyReply"])
            {
                cellHeihgt = 35 + [self personEventHeight] + 25;
                break;
            }
            
            if ([contentType isEqualToString:@"healthyReportDetPage"])
            {
                cellHeihgt = 35 + [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"applyAppoint"])
            {
                //发起申请
                cellHeihgt = 35 + [self personEventHeight] + 25;
                break;
            }
            if ([contentType isEqualToString:@"appointAgree"])
            {
                //同意申请
                cellHeihgt = 35 + [self personEventHeight] + 25;
                break;
            }
            if ([contentType isEqualToString:@"appointRefuse"])
            {
                //拒绝申请
                cellHeihgt = 35 + [self personEventHeight] + 25;
                break;
            }
            if ([contentType isEqualToString:@"appointCancel"])
            {
                //约诊取消
                cellHeihgt = 35 + [self personEventHeight] + 25;
                break;
            }
            if ([contentType isEqualToString:@"appointChange"])
            {
                //预约变更
                cellHeihgt = 35 + [self personEventHeight] + 25;
                break;
            }
            
            if ([contentType isEqualToString:@"healthySubmit"] ||
                [contentType isEqualToString:@"healthyAdjust"] ||
                [contentType isEqualToString:@"healthPlan"])
            {
                //发送计划
                cellHeihgt = 35 + [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"healthyExecute"])
            {
                //修改计划
                cellHeihgt = 35 + [self personEventHeight];
                break;
            }
            if ([contentType isEqualToString:@"healthyStop"])
            {
                //终止计划
                cellHeihgt = 35 + [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"adjustWarning"]||
                [contentType isEqualToString:@"continueTest"]||
                [contentType isEqualToString:@"tellVisitDoc"])
            {
                cellHeihgt = 35 + [self personEventHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"sendCompleateDocMsg"])
            {
                cellHeihgt = 35 + [self personEventHeight];
                break;
            }

        }
            break;
        default:
            break;
    }
    return cellHeihgt;
}

- (CGFloat) textbubbleWidth
{
    CGFloat maxTextWidth = kScreenWidth - 123 - 29;
    
    CGFloat textWidth = [self._content widthSystemFont:[UIFont systemFontOfSize:15]];
    if (textWidth > maxTextWidth)
    {
        textWidth = maxTextWidth;
    }
    return textWidth + 29;
}

- (CGFloat) imagebubbleWidth
{
    NSString* thumballPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:self._nativeThumbnailUrl];
    UIImage* thumbImage = [UIImage imageWithContentsOfFile:thumballPath];
    if (!thumbImage)
    {
        thumbImage = [UIImage imageNamed:@"img_default"];
    }
    if (0 == thumbImage.size.height)
    {
        return 68;
    }
    CGFloat thumbwidth = thumbImage.size.width * (112 / thumbImage.size.height);
    return thumbwidth;
}

- (CGFloat) voicebubbleWidth
{
    NSInteger length = self.attachModel.audioLength;
    CGFloat audiowidth = 29 + 35 + length * 3;
    return audiowidth;
}

- (CGFloat) voicebubbleHeight
{
    return 35;
}

- (CGFloat) alertBubbleHeight
{
    CGFloat maxTextWidth = kScreenWidth - 35;
    CGFloat textHeihgt = [self._content heightSystemFont:[UIFont systemFontOfSize:12] width:maxTextWidth];
    return textHeihgt + 2;
}

- (CGFloat) textBubbleHeight
{
    CGFloat maxTextWidth = kScreenWidth - 123 - 29;
    CGFloat textHeihgt = [self._content heightSystemFont:[UIFont systemFontOfSize:15] width:maxTextWidth];
    
    return textHeihgt + 25;
}

- (CGFloat) imageBubbleHeight
{
    return 112;
}

- (CGFloat) personEventTextWidth
{
    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
    
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
    if (textWidth > maxTextWidth)
    {
        textWidth = maxTextWidth;
    }
    
    return textWidth;
}

- (CGFloat) personEventWidth
{
    return [self personEventTextWidth] + 97;
}

- (CGFloat) personEventHeight
{
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self personEventTextWidth]];
    if (textHeight < 55)
    {
        textHeight = 55;
    }
    
    return textHeight + 20;
}
//
//
//- (CGFloat) detectResultPageTextWidth
//{
//    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
//    
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelDetectResultAlertContent* modelContent = [MessageBaseModelDetectResultAlertContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
//    if (textWidth > maxTextWidth)
//    {
//        textWidth = maxTextWidth;
//    }
//
//    return textWidth;
//}
//
//- (CGFloat) detectResultPageWidth
//{
//    return [self detectResultPageTextWidth] + 97;
//}
//
//- (CGFloat) detectResultPageHeight
//{
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelDetectResultAlertContent* modelContent = [MessageBaseModelDetectResultAlertContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
//    if (textHeight < 55)
//    {
//        textHeight = 55;
//    }
//    
//    return textHeight + 20;
//}
//
//- (CGFloat) recipePageTextWidth
//{
//    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
//    
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelRecipePageContent* modelContent = [MessageBaseModelRecipePageContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
//    if (textWidth > maxTextWidth)
//    {
//        textWidth = maxTextWidth;
//    }
//    
//    return textWidth;
//}
//
//- (CGFloat) recipePageWidth
//{
//    return [self recipePageTextWidth] + 97;
//}
//
//- (CGFloat) recipePageHeight
//{
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelRecipePageContent* modelContent = [MessageBaseModelRecipePageContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
//    if (textHeight < 55)
//    {
//        textHeight = 55;
//    }
//    
//    return textHeight + 20;
//}
//
//- (CGFloat) serviceCommentsTextWidth
//{
//    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
//    
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelServiceCommentsContent* modelContent = [MessageBaseModelServiceCommentsContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
//    if (textWidth > maxTextWidth)
//    {
//        textWidth = maxTextWidth;
//    }
//    
//    return textWidth;
//}
//
//- (CGFloat) serviceCommentsWidth
//{
//    return [self serviceCommentsTextWidth] + 97;
//}
//
//- (CGFloat) serviceCommentseHeight
//{
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelServiceCommentsContent* modelContent = [MessageBaseModelServiceCommentsContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
//    textHeight += 25;
//    if (textHeight < 55)
//    {
//        textHeight = 55;
//    }
//    
//    return textHeight + 20;
//}
//
//
//- (CGFloat) surveyTextWidth
//{
//    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
//    
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelSurveyContent* modelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
//    if (textWidth > maxTextWidth)
//    {
//        textWidth = maxTextWidth;
//    }
//    
//    return textWidth;
//}
//
//- (CGFloat) surveyWidth
//{
//    return [self surveyTextWidth] + 97;
//}
//
//- (CGFloat) surveyHeight
//{
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelSurveyContent* modelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
//   
//    if (textHeight < 55)
//    {
//        textHeight = 55;
//    }
//    
//    return textHeight + 20;
//}
//
//- (CGFloat) healthReportTextWidth
//{
//    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
//    
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelHealthReportContent* modelContent = [MessageBaseModelHealthReportContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
//    if (textWidth > maxTextWidth)
//    {
//        textWidth = maxTextWidth;
//    }
//    
//    return textWidth;
//}
//
//- (CGFloat) healthReportWidth
//{
//    return [self healthReportTextWidth] + 97;
//}
//
//- (CGFloat) healthReportHeight
//{
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelHealthReportContent* modelContent = [MessageBaseModelHealthReportContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
//    
//    if (textHeight < 55)
//    {
//        textHeight = 55;
//    }
//    
//    return textHeight + 20;
//}
//
//- (CGFloat) appointmentTextWidth
//{
//    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
//    
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelAppointmentContent* modelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
//    if (textWidth > maxTextWidth)
//    {
//        textWidth = maxTextWidth;
//    }
//    
//    return textWidth;
//}
//
//- (CGFloat) appointmentWidth
//{
//    return [self appointmentTextWidth] + 97;
//}
//
//- (CGFloat) appointmentHeight
//{
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelAppointmentContent* modelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
//    
//    if (textHeight < 55)
//    {
//        textHeight = 55;
//    }
//    
//    return textHeight + 20;
//}
//
//- (CGFloat) healthPlanTextWidth
//{
//    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
//    
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelHealthPlanContent* modelContent = [MessageBaseModelHealthPlanContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
//    if (textWidth > maxTextWidth)
//    {
//        textWidth = maxTextWidth;
//    }
//    
//    return textWidth;
//}
//
//- (CGFloat) healthPlanWidth
//{
//    return [self healthPlanTextWidth] + 97;
//}
//
//- (CGFloat) healthPlanHeight
//{
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelHealthPlanContent* modelContent = [MessageBaseModelHealthPlanContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
//    
//    if (textHeight < 55)
//    {
//        textHeight = 55;
//    }
//    
//    return textHeight + 20;
//}
//
//- (CGFloat) hospitalizationTextWidth
//{
//    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
//    
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelHospitalizationContent* modelContent = [MessageBaseModelHospitalizationContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
//    if (textWidth > maxTextWidth)
//    {
//        textWidth = maxTextWidth;
//    }
//    
//    return textWidth;
//}
//
//- (CGFloat) hospitalizationWidth
//{
//    return [self hospitalizationTextWidth] + 97;
//}
//
//- (CGFloat) hospitalizationHeight
//{
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelHospitalizationContent* modelContent = [MessageBaseModelHospitalizationContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
//    
//    if (textHeight < 55)
//    {
//        textHeight = 55;
//    }
//    
//    return textHeight + 20;
//}
//
//- (CGFloat) alertDealedTextWidth
//{
//    CGFloat maxTextWidth = kScreenWidth - 123 - 97;
//    
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelAlertDealedContent* modelContent = [MessageBaseModelAlertDealedContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
//    if (textWidth > maxTextWidth)
//    {
//        textWidth = maxTextWidth;
//    }
//    
//    return textWidth;
//}
//
//- (CGFloat) alertDealedWidth
//{
//    return [self alertDealedTextWidth] + 97;
//}
//
//- (CGFloat) alertDealedHeight
//{
//    NSString* content = self._content;
//    if (!content || 0 == content.length) {
//        return 0 ;
//    }
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//    {
//        return 0;
//    }
//    MessageBaseModelAlertDealedContent* modelContent = [MessageBaseModelAlertDealedContent mj_objectWithKeyValues:dicContent];
//    
//    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
//    
//    if (textHeight < 55)
//    {
//        textHeight = 55;
//    }
//    
//    return textHeight + 20;
//}

@end

@implementation MessageBaseModelContent


@end

@implementation MessageBaseModelDetectResultAlertContent


@end

@implementation MessageBaseModelRecipePageContent


@end

@implementation MessageBaseModelServiceCommentsContent


@end

@implementation MessageBaseModelSurveyContent


@end

@implementation MessageBaseModelHealthReportContent

@end

@implementation MessageBaseModelAppointmentContent

@end

@implementation MessageBaseModelHealthPlanContent

@end

@implementation MessageBaseModelHospitalizationContent

@end

@implementation MessageBaseModelAlertDealedContent

@end


