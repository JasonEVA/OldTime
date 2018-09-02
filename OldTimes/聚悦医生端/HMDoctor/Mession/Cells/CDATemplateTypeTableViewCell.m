//
//  CDATemplateTypeTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CDATemplateTypeTableViewCell.h"


@interface CDATemplateTypeTableViewCell ()
{
    
}



@end

@implementation CDATemplateTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _templateLable = [[UILabel alloc]init];
        [self.contentView addSubview:_templateLable];
        [_templateLable setTextColor:[UIColor commonTextColor]];
        [_templateLable setFont:[UIFont systemFontOfSize:15]];
        
        [_templateLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(14);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-57);
            make.top.equalTo(self.contentView).with.offset(11);
        }];
        
        [self makeAssessmentCell];
    }
    return self;
}

- (void) setCreateDocumetnTemplateTypeModel:(CreateDocumetnTemplateTypeModel*) typeModel
{
    [_templateLable setText:typeModel.surveyMoudleName];
    
}

- (void) makeAssessmentCell
{
    
}
@end

@interface CDAUnAssessedTemplateTypeTableViewCell ()

@property (nonatomic, readonly) UILabel* assessmentLable;
@end

@implementation CDAUnAssessedTemplateTypeTableViewCell

- (void) makeAssessmentCell
{
    _assessmentLable = [[UILabel alloc]init];
    [self.contentView addSubview:_assessmentLable];
    [_assessmentLable setTextColor:[UIColor mainThemeColor]];
    [_assessmentLable setFont:[UIFont systemFontOfSize:15]];
    [_assessmentLable setText:@"去评估"];
    [_assessmentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView).with.offset(11);
    }];
}

@end

@interface CDAAssessedTemplateTypeTableViewCell ()

@property (nonatomic, readonly) UILabel* assessmentSummaryLable;
@end

@implementation CDAAssessedTemplateTypeTableViewCell

- (void) makeAssessmentCell
{
    UIImageView* ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c_rightArrow"]];
    [self.contentView addSubview:ivArrow];
    
    [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(8.5, 15));
    }];
    
    _assessmentSummaryLable = [[UILabel alloc]init];
    [self.contentView addSubview:_assessmentSummaryLable];
    [_assessmentSummaryLable setTextColor:[UIColor commonGrayTextColor]];
    [_assessmentSummaryLable setFont:[UIFont systemFontOfSize:12]];
    [_assessmentSummaryLable setText:@"去评估"];
    [_assessmentSummaryLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(14);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-57);
        make.top.equalTo(self.templateLable.mas_bottom).with.offset(6);
    }];
    
}

- (void) setCreateDocumetnTemplateTypeModel:(CreateDocumetnTemplateTypeModel*) typeModel
{
    [super setCreateDocumetnTemplateTypeModel:typeModel];
    
    [self.assessmentSummaryLable setText:typeModel.reportComments];
    
}
@end



@implementation CDATemplateDiagnosisTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _diagnosisLable = [[UILabel alloc]init];
        [self.contentView addSubview:_diagnosisLable];
        [_diagnosisLable setNumberOfLines:0];
        [_diagnosisLable setTextColor:[UIColor commonTextColor]];
        [_diagnosisLable setFont:[UIFont systemFontOfSize:15]];
        [_diagnosisLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(10);
            
        }];
        
    }
    return self;
}

- (void) setCreateDocumetnTemplateTypeModel:(CreateDocumetnTemplateTypeModel*) typeModel
{
    NSString* reportComments = typeModel.reportComments;
    if (!reportComments || reportComments.length == 0) {
        [_diagnosisLable setText:@"尚无诊断内容。"];
        [_diagnosisLable setTextColor:[UIColor commonGrayTextColor]];
    }
    else
    {
        [_diagnosisLable setText:reportComments];
        [_diagnosisLable setTextColor:[UIColor commonGrayTextColor]];
    }
    
}
@end
