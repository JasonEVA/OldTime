//
//  SurveyRecordsTableViewCell.m
//  HMClient
//
//  Created by lkl on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SurveyRecordsTableViewCell.h"

@interface SurveyRecordsTableViewCell ()
{
    UILabel *lbSurveyMoudleName;
    UILabel *lbSurveyDate;
    UILabel *lbcontent;
}
@end

@implementation SurveyRecordsTableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbSurveyMoudleName = [[UILabel alloc] init];
        [self addSubview:lbSurveyMoudleName];
        [lbSurveyMoudleName setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbSurveyMoudleName setFont:[UIFont font_28]];
        
        lbSurveyDate = [[UILabel alloc] init];
        [self addSubview:lbSurveyDate];
        [lbSurveyDate setText:@"填写时间:"];
        [lbSurveyDate setTextColor:[UIColor commonGrayTextColor]];
        [lbSurveyDate setFont:[UIFont font_28]];
        
        lbcontent = [[UILabel alloc] init];
        [self addSubview:lbcontent];
        [lbcontent setText:@"请及时填写随访表，以便医生对您的健康状况进行评估"];
        [lbcontent setTextColor:[UIColor commonRedColor]];
        [lbcontent setFont:[UIFont font_24]];
        
        [self subviewLayout];
        
    }
    return self;
}


- (void) subviewLayout
{
    [lbSurveyMoudleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.right.equalTo(self).offset(-12.5);
        make.top.mas_equalTo(10 * kScreenScale);
    }];
    
    [lbSurveyDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.equalTo(lbSurveyMoudleName.mas_bottom).with.offset(5 * kScreenScale);
    }];
    
    [lbcontent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.equalTo(lbSurveyDate.mas_bottom).with.offset(5 * kScreenScale);
        make.right.equalTo(self.mas_right).with.offset(-12.5);
    }];
    
}

- (void)setSurveyRecord:(SurveyRecord *)record
{
    [lbSurveyMoudleName setText:record.surveyMoudleName];
    [lbSurveyDate setText:@"填写时间：未填写"];
//    [lbSurveyDate setAttributedText:[NSAttributedString getAttributWithUnChangePart:@"填写时间：" changePart:@"未填写" changeColor:[UIColor commonRedColor] changeFont:[UIFont font_28]]];
    [lbcontent setHidden:NO];
    if (record.status != 0) {
        [lbcontent setHidden:YES];
        NSString* statusStr = @"已填写";
        switch (record.status)
        {
            case 1:
            {
                statusStr = record.fillTime;
            }
                break;
            case 2:
            {
                statusStr = [NSString stringWithFormat:@"%@ (已查看)", record.fillTime];
            }
                break;
            case 3:
            {
                statusStr = [NSString stringWithFormat:@"%@ (已回复)", record.fillTime];
            }
                break;
            default:
                break;
        }
        
        [lbSurveyDate setText:[NSString stringWithFormat:@"填写时间：%@",record.fillTime]];
    }
}

@end


