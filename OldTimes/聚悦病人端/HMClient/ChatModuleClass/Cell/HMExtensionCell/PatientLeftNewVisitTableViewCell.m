//
//  PatientLeftNewVisitTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/7/26.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PatientLeftNewVisitTableViewCell.h"

@interface PatientLeftNewVisitTableViewCell ()
@property (nonatomic, strong) UILabel *contentLb;

@end
@implementation PatientLeftNewVisitTableViewCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.imgViewBubble.tintColor = [UIColor mainThemeColor];

        UIImageView *doctor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_card"]];
        self.contentLb = [UILabel new];
        [self.contentLb setNumberOfLines:0];
        [self.contentLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.contentLb setFont:[UIFont systemFontOfSize:16]];
        UILabel *bottomLb = [UILabel new];
        [bottomLb setText:@"    填写随访表"];
        [bottomLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [bottomLb setFont:[UIFont systemFontOfSize:12]];
        [bottomLb setBackgroundColor:[UIColor whiteColor]];
        [self.wz_contentView addSubview:doctor];
        [self.wz_contentView addSubview:bottomLb];
        
        [self.wz_contentView addSubview:self.contentLb];
        
        [doctor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgViewBubble).offset(12);
            make.left.equalTo(self.imgViewBubble).offset(20);
            make.width.equalTo(@35);
        }];
        
        [bottomLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.imgViewBubble);
            make.height.equalTo(@25);
        }];
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(doctor.mas_right).offset(15);
            make.top.equalTo(doctor);
            make.right.equalTo(self.imgViewBubble).offset(-15);
            make.height.lessThanOrEqualTo(@50);
            make.bottom.equalTo(bottomLb.mas_top).offset(-10);
        }];
    }
    return self;
}
//
//- (void)fillInDadaWith:(MessageBaseModel *)baseModel
//{
//    myModel = baseModel;
//    NSString* content = baseModel._content;
//    NSLog(@"自定义消息 %@", content);
//    NSDictionary* dicContent = [NSDictionary JSONValue:content];
//    
//    MessageBaseModelContent* model = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
//    [contentLb setText:model.msg];
//    if ([model.type isEqualToString:@"healthTest"]|| [model.type isEqualToString:@"adjustWarning"]|| [model.type isEqualToString:@"continueTest"]|| [model.type isEqualToString:@"tellVisitDoc"])
//    {
//        //监测预警消息
//        MessageBaseModelDetectResultAlertContent* detectResultModelContent = [MessageBaseModelDetectResultAlertContent mj_objectWithKeyValues:dicContent];
//        [leftImageView setImage:[UIImage imageNamed:@"icon_card_warning"]];
//    }
//    
//    if ([model.type isEqualToString:@"recipePage"]||[model.type isEqualToString:@"stopRecipe"])
//    {
//        //开处方消息
//        MessageBaseModelRecipePageContent* recipePageModelContent = [MessageBaseModelRecipePageContent mj_objectWithKeyValues:dicContent];
//        [leftImageView setImage:[UIImage imageNamed:@"icon_card_prescription"]];
//        
//    }
//    
//    if ([model.type isEqualToString:@"serviceComments"])
//    {
//        //服务评价消息
//        MessageBaseModelServiceCommentsContent* serviceCommentsModelContent = [MessageBaseModelServiceCommentsContent mj_objectWithKeyValues:dicContent];
//        [leftImageView setImage:[UIImage imageNamed:@"icon_card_evaluate"]];
//        
//    }
//    
//    if ([model.type isEqualToString:@"surveyPush"]||[model.type isEqualToString:@"survey"]||[model.type isEqualToString:@"surveyFilled"]||[model.type isEqualToString:@"surveyReply"])
//    {
//        //发送随访
//        MessageBaseModelSurveyContent* surveyModelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dicContent];
//        [leftImageView setImage:[UIImage imageNamed:@"icon_card_follow_up"]];
//        
//        
//    }
//    
//    
//    if ([model.type isEqualToString:@"inquirySend"])
//    {
//        //问诊表发送
//        [leftImageView setImage:[UIImage imageNamed:@"ic_inpuiry"]];
//        
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
