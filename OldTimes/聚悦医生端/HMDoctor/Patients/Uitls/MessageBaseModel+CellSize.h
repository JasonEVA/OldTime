//
//  MessageBaseModel+CellSize.h
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <MintcodeIMKit/MintcodeIMKit.h>
#define H_GROUPNICK 15      // 群成员昵称偏移量
#define H_CARDMINHEIGHT  85  //IMEvent卡片最小高度
#define LEFTIMAGEHEIGHT   55  //消息卡片左侧图片高度
#define H_NEWSHEIGHT   130    // 图文消息卡片高度
@interface MessageBaseModel (CellSize)

- (CGFloat) bubbleWidth;
- (CGFloat) bubbleHeight;

- (CGFloat) cellHeight;
//纯文字高度   Jason
- (CGFloat)textHeight;
//消息卡片内容高度（cell布局需要）Jason
- (CGFloat)eventContentHeight;
@end

@interface MessageBaseModelContent : NSObject
{
    
}

@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* msg;

@end

@interface MessageBaseModelDetectResultAlertContent : MessageBaseModelContent// 监测提醒
{
    
}

@property (nonatomic, retain) NSString* kpiCode;
@property (nonatomic, retain) NSString* sourceKpiCode;
@property (nonatomic, retain) NSString* reUserId;  //用户id
@property (nonatomic, retain) NSString* testDataId;
@property (nonatomic, retain) NSString* sourceTestDataId;
@property (nonatomic, retain) NSString* taskAlertId;//任务提醒d
@property (nonatomic, retain) NSString* kpiTitle;//

@end

@interface MessageBaseModelTestResultPage : MessageBaseModelContent// 监测预警

{
    
}

@property (nonatomic, retain) NSString* kpiCode; //父项kpiCode
@property (nonatomic, retain) NSString* userId;  //用户id
@property (nonatomic, retain) NSString* testDataId;//监测ID
@property (nonatomic, retain) NSString* kpiName;//检测项名称
@property (nonatomic, retain) NSString* userName;//用户姓名
@property (nonatomic, retain) NSString* age;//年龄
@property (nonatomic, retain) NSString* sex;//性别
@property (nonatomic, retain) NSString* isDone;//是否已经处理
@property (nonatomic, retain) NSString* testResulId;//监测结果ID
@property (nonatomic, retain) NSString* sourceTestDataId;//来源检测ID
@property (nonatomic, retain) NSString* sourceKpiCode;//来源父项kpicode


@end

@interface MessageBaseModelRecipePageContent  : MessageBaseModelContent
{
    
}

@property (nonatomic, retain) NSString* userRecipeId;
@end

@interface MessageBaseModelServiceCommentsContent : MessageBaseModelContent
{
    
}

@property (nonatomic, retain) NSString* userServiceId;

@end

@interface MessageBaseModelSurveyContent : MessageBaseModelContent

{
    
}

@property (nonatomic, assign) NSInteger moudleId;
@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, assign) NSInteger staffUserId;
@property (nonatomic, assign) NSInteger userId;

@end

@interface MessageBaseModelHealthReportContent : MessageBaseModelContent
{
    
}

@property (nonatomic, retain) NSString* healthyReportId;

@end

@interface MessageBaseModelAppointmentContent : MessageBaseModelContent
{
    
}

@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, assign) NSInteger appointId;
@property (nonatomic, assign) NSInteger staffId;

@end

@interface MessageBaseModelHealthPlanContent : MessageBaseModelContent
{
    
}

@property (nonatomic, retain) NSString* healthyPlanId;
@property (nonatomic, retain) NSString* userId;

@end

@interface MessageBaseModelSendCompleateDocMsg : MessageBaseModelContent //档案更新
{
    
}
@property (nonatomic, retain) NSString* docuRegId; //文档注册id
@property (nonatomic, retain) NSString* storageId;//文档存储id
@property (nonatomic, retain) NSString* visitOrgTitle;//机构名称
@property (nonatomic, retain) NSString* docuType;//文档类型
@property (nonatomic, retain) NSString* userId;   //用户id

@end

@interface MessageBaseModelRoundsPush : MessageBaseModelContent //查房发送
{
    
}
@property (nonatomic, retain) NSString* moudleId; //模板id
@property (nonatomic, retain) NSString* recordId;//记录id
@property (nonatomic, retain) NSString* staffUserId;//医生用户id
@property (nonatomic, retain) NSString* userId;   //用户id
@property (nonatomic, copy) NSString *status;   //消息状态(0:未回复；1:已回复，否；2:已回复,是)

@end

@interface MessageBaseModelAssessPush : MessageBaseModelContent //评估发送
{
    
}
@property (nonatomic, retain) NSString* moudleId; //模板id
@property (nonatomic, retain) NSString* recordId;//记录id
@property (nonatomic, retain) NSString* staffUserId;//医生用户id
@property (nonatomic, retain) NSString* userId;   //用户id

@end

@interface MessageBaseModelAssessmentReport : MessageBaseModelContent //更新评估报告
{
    
}
@property (nonatomic, retain) NSString* assessmentReportId; //评估报告ID
@property (nonatomic, retain) NSString* patientId;//患者ID


@end

@interface MessageBaseModelReceiptMsgModel : MessageBaseModelContent //更新评估报告
{
    
}
@property (nonatomic, retain) NSString* status; //已读状态    unread 未读 readed已读


@end

@interface MessageBaseAssessmentModel : MessageBaseModelContent //评估消息
{
    
}

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, retain) NSString* assessCode; //评估类型

@property (nonatomic, retain) NSString* moudleId; //模板id
@property (nonatomic, retain) NSString* recordId;//记录id
@property (nonatomic, retain) NSString* staffUserId;//医生用户id
@property (nonatomic, retain) NSString* userId;   //用户id

@end
