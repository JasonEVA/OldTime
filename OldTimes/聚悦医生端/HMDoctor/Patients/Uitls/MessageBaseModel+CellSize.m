//
//  MessageBaseModel+CellSize.m
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MessageBaseModel+CellSize.h"
#define H_OFFSET    45      // 间距偏移量
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
                break;
                
            }
            
            if ([contentType isEqualToString:@"testResultPage"]|| [contentType isEqualToString:@"healthTest"])
            {
                //监测预警消息
                bubbleWidth = [self detectResultPageWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"recipePage"])
            {
                //监测预警消息
                bubbleWidth = [self recipePageWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"serviceComments"])
            {
                //服务评价消息
                bubbleWidth = [self serviceCommentsWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyPush"])
            {
                bubbleWidth = [self surveyWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"survey"])
            {
                bubbleWidth = [self surveyWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyFilled"])
            {
                bubbleWidth = [self surveyWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyReply"])
            {
                bubbleWidth = [self surveyWidth];
                break;
            }
            if ([contentType isEqualToString:@"healthyReportDetPage"])
            {
                bubbleWidth = [self healthReportWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"applyAppoint"])
            {
                //发起申请
                bubbleWidth = [self appointmentWidth];
                break;
            }
            if ([contentType isEqualToString:@"appointAgree"])
            {
                //同意申请
                bubbleWidth = [self appointmentWidth];
                break;
            }
            if ([contentType isEqualToString:@"appointRefuse"])
            {
                //拒绝申请
                bubbleWidth = [self appointmentWidth];
                break;
            }
            if ([contentType isEqualToString:@"appointCancel"])
            {
                //约诊取消
                bubbleWidth = [self appointmentWidth];
                break;
            }
            if ([contentType isEqualToString:@"appointChange"])
            {
                //预约变更
                bubbleWidth = [self appointmentWidth];
                break;
            }
            
            if ([contentType isEqualToString:@"healthySubmit"])
            {
                //发送计划
                bubbleWidth = [self healthPlanWidth];
                break;
            }
            if ([contentType isEqualToString:@"healthyExecute"])
            {
                //修改计划
                bubbleWidth = [self healthPlanWidth];
                break;
            }
            if ([contentType isEqualToString:@"healthyStop"])
            {
                //终止计划
                bubbleWidth = [self healthPlanWidth];
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
                break;
                
            }
            
            if ([contentType isEqualToString:@"testResultPage"] || [contentType isEqualToString:@"healthTest"])
            {
                //监测预警消息
                bubbleHeihgt = [self detectResultPageHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"recipePage"])
            {
                //处方消息
                bubbleHeihgt = [self recipePageHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"serviceComments"])
            {
                //服务评价消息
                bubbleHeihgt = [self serviceCommentseHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyPush"])
            {
                bubbleHeihgt = [self surveyHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"survey"])
            {
                bubbleHeihgt = [self surveyHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyFilled"])
            {
                bubbleHeihgt =[self surveyHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"surveyReply"])
            {
                bubbleHeihgt = [self surveyHeight];
                break;
            }
            if ([contentType isEqualToString:@"healthyReportDetPage"])
            {
                bubbleHeihgt = [self healthReportHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"applyAppoint"])
            {
                //发起申请
                bubbleHeihgt = [self appointmentHeight];
                break;
            }
            if ([contentType isEqualToString:@"appointAgree"])
            {
                //同意申请
                bubbleHeihgt = [self appointmentHeight];
                break;
            }
            if ([contentType isEqualToString:@"appointRefuse"])
            {
                //拒绝申请
                bubbleHeihgt = [self appointmentHeight];
                break;
            }
            if ([contentType isEqualToString:@"appointCancel"])
            {
                //约诊取消
                bubbleHeihgt = [self appointmentHeight];
                break;
            }
            if ([contentType isEqualToString:@"appointChange"])
            {
                //预约变更
                bubbleHeihgt = [self appointmentHeight];
                break;
            }
            
            if ([contentType isEqualToString:@"healthySubmit"])
            {
                //发送计划
                bubbleHeihgt = [self healthPlanHeight];
                break;
            }
            if ([contentType isEqualToString:@"healthyExecute"])
            {
                //修改计划
                bubbleHeihgt = [self healthPlanHeight];
                break;
            }
            if ([contentType isEqualToString:@"healthyStop"])
            {
                //终止计划
                bubbleHeihgt = [self healthPlanHeight];
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
                break;
                
            }
            
            cellHeihgt = [self eventCommentHeight];

        }
            break;
        default:
            break;
        
    }
    return cellHeihgt;
}

//消息卡片内容高度（cell布局需要）(纯文字高度或者文字的高度加控件高度)
- (CGFloat)eventContentHeight {
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;;
    }
    MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
    NSString* contentType = modelContent.type;
    
    if (!contentType || 0 == contentType.length)
    {
        return 0;;
        
    }
    
    if ([contentType isEqualToString:@"testResultPage"])
    {//预警（两个按钮）
        return [self textHeight] + 25;
    }
    if ([contentType isEqualToString:@"roundsAsk"])
    {//查房问询（两个单选按钮）
        return [self textHeight] + 25;
    }
    if ([contentType isEqualToString:@"serviceComments"])
    {//服务评价
        return [self textHeight] + 25;
    }
    //默认返回纯文字高度
    return [self textHeight];
}
//纯文字高度
- (CGFloat)textHeight {
    
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelContent* model = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textHeight = [model.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self eventCellCommonWidth]];
    return textHeight;
}

//默认卡片高度
- (CGFloat) eventCommentHeight {
    
    CGFloat textHeight = [self eventContentHeight];
    textHeight += H_OFFSET;
    
    if ([self._fromLoginName isEqualToString:[MessageManager getUserID]]) {
        return textHeight;
    }
    else {
        return textHeight + H_GROUPNICK;
    }
}
//默认卡片宽度
- (CGFloat)eventCellCommonWidth {
    CGFloat maxTextWidth = kScreenWidth - 210;
    
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
- (CGFloat) textbubbleWidth
{
    CGFloat maxTextWidth = kScreenWidth - 210;
    
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
    CGFloat maxTextWidth = kScreenWidth - 210;
    CGFloat textHeihgt = [self._content heightSystemFont:[UIFont systemFontOfSize:15] width:maxTextWidth];
    
    return textHeihgt + 25;
}

- (CGFloat) imageBubbleHeight
{
    return 112;
}



- (CGFloat) detectResultPageTextWidth
{
    CGFloat maxTextWidth = kScreenWidth - 210;
    
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelDetectResultAlertContent* modelContent = [MessageBaseModelDetectResultAlertContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
    if (textWidth > maxTextWidth)
    {
        textWidth = maxTextWidth;
    }
    
    return textWidth;
}

- (CGFloat) detectResultPageWidth
{
    return [self detectResultPageTextWidth] + 97;
}

- (CGFloat) detectResultPageHeight
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
    MessageBaseModelDetectResultAlertContent* modelContent = [MessageBaseModelDetectResultAlertContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
    
    return textHeight;
}

- (CGFloat) recipePageTextWidth
{
    CGFloat maxTextWidth = kScreenWidth - 210;
    
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelRecipePageContent* modelContent = [MessageBaseModelRecipePageContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
    if (textWidth > maxTextWidth)
    {
        textWidth = maxTextWidth;
    }
    
    return textWidth;
}

- (CGFloat) recipePageWidth
{
    return [self recipePageTextWidth] + 97;
}

- (CGFloat) recipePageHeight
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
    MessageBaseModelRecipePageContent* modelContent = [MessageBaseModelRecipePageContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
    
    return textHeight;
}

- (CGFloat) serviceCommentsTextWidth
{
    CGFloat maxTextWidth = kScreenWidth - 210;
    
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelServiceCommentsContent* modelContent = [MessageBaseModelServiceCommentsContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
    if (textWidth > maxTextWidth)
    {
        textWidth = maxTextWidth;
    }
    
    return textWidth;
}

- (CGFloat) serviceCommentsWidth
{
    return [self serviceCommentsTextWidth] + 97;
}

- (CGFloat) serviceCommentseHeight
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
    MessageBaseModelServiceCommentsContent* modelContent = [MessageBaseModelServiceCommentsContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
    textHeight += 25;
    
    return textHeight;
}


- (CGFloat) surveyTextWidth
{
    CGFloat maxTextWidth = kScreenWidth - 210;
    
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelSurveyContent* modelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
    if (textWidth > maxTextWidth)
    {
        textWidth = maxTextWidth;
    }
    
    return textWidth;
}

- (CGFloat) surveyWidth
{
    return [self surveyTextWidth] + 97;
}

- (CGFloat) surveyHeight
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
    MessageBaseModelSurveyContent* modelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
    
    return textHeight;
}

- (CGFloat) healthReportTextWidth
{
    CGFloat maxTextWidth = kScreenWidth - 210;
    
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelHealthReportContent* modelContent = [MessageBaseModelHealthReportContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
    if (textWidth > maxTextWidth)
    {
        textWidth = maxTextWidth;
    }
    
    return textWidth;
}

- (CGFloat) healthReportWidth
{
    return [self healthReportTextWidth] + 97;
}

- (CGFloat) healthReportHeight
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
    MessageBaseModelHealthReportContent* modelContent = [MessageBaseModelHealthReportContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
    
    return textHeight;
}

- (CGFloat) appointmentTextWidth
{
    CGFloat maxTextWidth = kScreenWidth - 210;
    
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelAppointmentContent* modelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
    if (textWidth > maxTextWidth)
    {
        textWidth = maxTextWidth;
    }
    
    return textWidth;
}

- (CGFloat) appointmentWidth
{
    return [self appointmentTextWidth] + 97;
}

- (CGFloat) appointmentHeight
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
    MessageBaseModelAppointmentContent* modelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
    return textHeight;
}

- (CGFloat) healthPlanTextWidth
{
    CGFloat maxTextWidth = kScreenWidth - 210;
    
    NSString* content = self._content;
    if (!content || 0 == content.length) {
        return 0 ;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    MessageBaseModelHealthPlanContent* modelContent = [MessageBaseModelHealthPlanContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textWidth = [modelContent.msg widthSystemFont:[UIFont systemFontOfSize:15]];
    if (textWidth > maxTextWidth)
    {
        textWidth = maxTextWidth;
    }
    
    return textWidth;
}

- (CGFloat) healthPlanWidth
{
    return [self healthPlanTextWidth] + 97;
}

- (CGFloat) healthPlanHeight
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
    MessageBaseModelHealthPlanContent* modelContent = [MessageBaseModelHealthPlanContent mj_objectWithKeyValues:dicContent];
    
    CGFloat textHeight = [modelContent.msg heightSystemFont:[UIFont systemFontOfSize:15] width:[self detectResultPageTextWidth]];
    return textHeight;
}

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

@implementation MessageBaseModelTestResultPage

@end


@implementation MessageBaseModelSendCompleateDocMsg

@end

@implementation MessageBaseModelRoundsPush


@end
@implementation MessageBaseModelAssessPush


@end

@implementation MessageBaseModelAssessmentReport



@end

@implementation MessageBaseModelReceiptMsgModel

@end

@implementation MessageBaseAssessmentModel

@end
