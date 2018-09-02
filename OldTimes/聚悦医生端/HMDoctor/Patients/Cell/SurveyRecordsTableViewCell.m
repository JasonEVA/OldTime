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
}

- (void)setSurveyRecord:(SurveyRecord *)record
{
    [lbSurveyMoudleName setText:record.surveyMoudleName];
    //[lbSurveyDate setText:@"填写时间：未填写"];
    [lbSurveyDate setAttributedText:[NSAttributedString getAttributWithUnChangePart:@"填写时间：" changePart:@"未填写" changeColor:[UIColor commonRedColor] changeFont:[UIFont font_28]]];
    
    if (record.status != 0) {
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



@interface SurveryMoudleTableViewCell ()
{
    UIImageView* ivSelected;
    UILabel* lbMoudleName;
}
@end

@implementation SurveryMoudleTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivSelected = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c_contact_nonSelect"]];
        [self.contentView addSubview:ivSelected];
        [ivSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20.5, 20.5));
//            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.centerY.equalTo(self.contentView);
        }];
        
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_previewButton];
        [_previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(60, 31));
        }];
        [_previewButton setBackgroundImage:[UIImage rectImage:CGSizeMake(60, 31) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previewButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _previewButton.layer.cornerRadius = 2.5;
        _previewButton.layer.masksToBounds = YES;
        
        lbMoudleName = [[UILabel alloc]init];
        [self.contentView addSubview:lbMoudleName];
        [lbMoudleName setFont:[UIFont systemFontOfSize:15]];
        [lbMoudleName setTextColor:[UIColor commonTextColor]];
        [lbMoudleName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
//            make.left.equalTo(self.contentView).with.offset(12.5);
            make.left.equalTo(ivSelected.mas_right).with.offset(10);
            make.right.lessThanOrEqualTo(_previewButton.mas_left).with.offset(-10);
        }];
        
        [self.contentView showBottomLine];
    }
    return self;
}

- (void) setMoudleName:(NSString*) name
{
    [lbMoudleName setText:name];
}

- (void) setIsSelected:(BOOL) selected
{
    //c_contact_nonSelect c_contact_selected
    if (selected)
    {
        [ivSelected setImage:[UIImage imageNamed:@"c_contact_selected"]];
    }
    else
    {
        [ivSelected setImage:[UIImage imageNamed:@"c_contact_nonSelect"]];
    }
}
@end
