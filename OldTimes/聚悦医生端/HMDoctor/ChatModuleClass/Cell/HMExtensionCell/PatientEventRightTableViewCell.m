//
//  PatientEventRightTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/6/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientEventRightTableViewCell.h"
#import "ChatBaseTableViewCell+BubbleStyleEdit.h"
#import "MessageBaseModel+CellSize.h"

#define ScreenWidth [ UIScreen mainScreen ].applicationFrame.size.width

@interface PatientEventRightTableViewCell ()
{
    UIImageView *leftImageView;
    UILabel *contentLb;
    MessageBaseModel *myModel;

}

@end
@implementation PatientEventRightTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        leftImageView = [[UIImageView alloc]init];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_evaluate"]];
        
        contentLb = [[UILabel alloc]init];
        [contentLb setTextColor:[UIColor commonTextColor]];
        [contentLb setFont:[UIFont systemFontOfSize:15]];
        [contentLb setNumberOfLines:0];
        
        [self.wz_contentView addSubview:leftImageView];
        [self.wz_contentView addSubview:contentLb];
        
        [self configElements];
    }
    return self;
}

- (void)configElements {
    [self ats_changeBubbleBackgroundImage:[UIImage imageNamed:@"chat_right_borderBubble"]];
    
    [leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewBubble).offset(12);
        make.left.equalTo(self.imgViewBubble).offset(10);
        make.height.width.mas_equalTo(55);
        
        if ([myModel eventContentHeight] < LEFTIMAGEHEIGHT) {
            make.bottom.equalTo(self.imgViewBubble).offset(-12).priorityHigh();
        } else {
            make.bottom.equalTo(self.imgViewBubble).offset(-12).priorityLow();
            
        }

    }];
    
    [contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImageView);
        make.left.equalTo(leftImageView.mas_right).offset(8);
        make.right.equalTo(self.imgViewBubble).offset(-12);
        make.width.mas_equalTo(ScreenWidth - 210);
        make.bottom.equalTo(self.imgViewBubble).offset(-12).priorityMedium();
    }];
    
    
}

- (void)fillInDadaWith:(MessageBaseModel *)baseModel
{
    myModel = baseModel;
    NSString* content = baseModel._content;
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    
    MessageBaseModelContent* model = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
    [contentLb setText:model.msg];

    if ([model.type isEqualToString:@"healthTest"]|| [model.type isEqualToString:@"adjustWarning"]|| [model.type isEqualToString:@"continueTest"]|| [model.type isEqualToString:@"tellVisitDoc"])
    {
        //监测预警消息
       MessageBaseModelDetectResultAlertContent* detectResultModelContent = [MessageBaseModelDetectResultAlertContent mj_objectWithKeyValues:dicContent];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_warning"]];
    }
    
    if ([model.type isEqualToString:@"recipePage"]||[model.type isEqualToString:@"stopRecipe"])
    {
        //开处方消息
        MessageBaseModelRecipePageContent* recipePageModelContent = [MessageBaseModelRecipePageContent mj_objectWithKeyValues:dicContent];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_prescription"]];

    }
    
    if ([model.type isEqualToString:@"serviceComments"])
    {
        //服务评价消息
        MessageBaseModelServiceCommentsContent* serviceCommentsModelContent = [MessageBaseModelServiceCommentsContent mj_objectWithKeyValues:dicContent];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_evaluate"]];

    }
    
    if ([model.type isEqualToString:@"surveyPush"]||[model.type isEqualToString:@"survey"]||[model.type isEqualToString:@"surveyFilled"]||[model.type isEqualToString:@"surveyReply"])
    {
        //发送随访
        MessageBaseModelSurveyContent* surveyModelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dicContent];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_follow_up"]];

       
    }
        if ([model.type isEqualToString:@"healthyReportDetPage"])
    {
        //健康报告
        MessageBaseModelHealthReportContent* healthReportModelContent = [MessageBaseModelHealthReportContent mj_objectWithKeyValues:dicContent];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_report"]];

    }
    
    if ([model.type isEqualToString:@"applyAppoint"]||[model.type isEqualToString:@"appointAgree"]||[model.type isEqualToString:@"appointRefuse"]||[model.type isEqualToString:@"appointCancel"]||[model.type isEqualToString:@"appointChange"])
    {
        //约诊
        MessageBaseModelAppointmentContent* appointmentModelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_appointment"]];

    }
    
    
    if ([model.type isEqualToString:@"healthySubmit"]||[model.type isEqualToString:@"healthyStop"]||[model.type isEqualToString:@"healthyExecute"]||[model.type isEqualToString:@"healthPlan"]||[model.type isEqualToString:@"healthyAdjust"]||[model.type isEqualToString:@"healthyDraft"])
    {
        //健康计划
        MessageBaseModelHealthPlanContent* healthPlanModelContent = [MessageBaseModelHealthPlanContent mj_objectWithKeyValues:dicContent];
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_health_plan"]];

    }
    if ([model.type isEqualToString:@"sendCompleateDocMsg"])
    {
        //档案更新
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_hospitalization_records"]];
        
    }
    if ([model.type isEqualToString:@"assessmentReport"]||[model.type isEqualToString:@"assessPush"]||[model.type isEqualToString:@"assessFilled"])
    {
        //1.更新评估报告 建档  2.评估发送 3.评估已填写
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_assess"]];
        
    }
    if ([model.type isEqualToString:@"roundsPush"]||[model.type isEqualToString:@"roundsFilled"]||[model.type isEqualToString:@"roundsAsk"])
    {
        //1.查房发送 2.查房已填写 3.查房询问
        [leftImageView setImage:[UIImage imageNamed:@"icon_card_chafangbiao"]];
        
    }
    if ([model.type isEqualToString:@"inquirySend"])
    {
        //问诊表发送
        [leftImageView setImage:[UIImage imageNamed:@"ic_inpuiry"]];
        
    }

    [self configElements];

}

@end
