//
//  HealthHistoryRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthHistoryRecordTableViewCell.h"

@interface HealthHistoryRecorView ()
{
    UIImageView* ivBackground;
    UILabel* lbHospital;
    UILabel* lbDept;
    UILabel* lbNote;
    
    UIImageView* ivDetail;
    UIImageView* ivFlag;
}

- (void) setHistoryItem:(HealthHistoryItem*) history;
@end

@implementation HealthHistoryRecorView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImage* imgBg = [UIImage imageNamed:@"history_record_bg"];
        //imgBg = [imgBg stretchImage];
        ivBackground = [[UIImageView alloc]initWithImage:imgBg];
        [self addSubview:ivBackground];
        
        lbHospital = [[UILabel alloc]init];
        [self addSubview:lbHospital];
        [lbHospital setBackgroundColor:[UIColor clearColor]];
        [lbHospital setFont:[UIFont font_28]];
        [lbHospital setTextColor:[UIColor colorWithHexString:@"333333"]];
        
        lbDept = [[UILabel alloc]init];
        [self addSubview:lbDept];
        [lbDept setBackgroundColor:[UIColor clearColor]];
        [lbDept setFont:[UIFont font_26]];
        [lbDept setTextColor:[UIColor colorWithHexString:@"999999"]];
        
        lbNote = [[UILabel alloc]init];
        [self addSubview:lbNote];
        [lbNote setBackgroundColor:[UIColor clearColor]];
        [lbNote setFont:[UIFont font_26]];
        [lbNote setTextColor:[UIColor colorWithHexString:@"999999"]];
        [lbNote setNumberOfLines:2];
        
        ivDetail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_detail"]];
        [self addSubview:ivDetail];
        
        ivFlag = [[UIImageView alloc]init];
        [self addSubview:ivFlag];
        
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    
    [lbHospital mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(22);
        make.height.equalTo(@18);
        make.top.equalTo(self).with.offset(9);
        make.right.lessThanOrEqualTo(self.mas_right).with.offset(-30);
    }];
    
    [lbDept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbHospital);
        make.height.equalTo(@17);
        make.top.equalTo(lbHospital.mas_bottom).with.offset(14.5);
        make.right.lessThanOrEqualTo(self.mas_right).with.offset(-30);
    }];
    
    [lbNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbHospital);
        make.top.equalTo(lbDept.mas_bottom).with.offset(4);
        make.right.lessThanOrEqualTo(self.mas_right).with.offset(-30);
        make.bottom.lessThanOrEqualTo(self).with.offset(-13);
    }];
    
    [ivDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.equalTo(self).with.offset(-9);
        make.top.equalTo(self).with.offset(10);
    }];
    
    [ivFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(33, 31));
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void) setHistoryItem:(HealthHistoryItem*) history
{
    [lbHospital setText:history.visitOrgTitle];
    
    [lbDept setText:@""];
    if (history.deptName && 0 < history.deptName.length) {
        [lbDept setText:[NSString stringWithFormat:@"科室:%@", history.deptName]];
    }
    
    [lbNote setText:history.docuNote];
    
    if (history.visitType && history.visitType)
    {
        if ([history.visitType isEqualToString:@"体检"])
        {
            [ivFlag setImage:[UIImage imageNamed:@"history_flag_test"]];
        }
        else if ([history.visitType isEqualToString:@"检查"])
        {
            [ivFlag setImage:[UIImage imageNamed:@"history_flag_examation"]];
        }
        else if ([history.visitType isEqualToString:@"门诊"])
        {
            [ivFlag setImage:[UIImage imageNamed:@"history_flag_clinic"]];
        }
        else if ([history.visitType isEqualToString:@"住院"])
        {
            [ivFlag setImage:[UIImage imageNamed:@"history_flag_hosptialization"]];
        }
    }
}

@end


@interface HealthHistoryRecordTableViewCell ()
{
    UIView* topLine;
    UIView* bottomline;
    UIView* circleView;
    UILabel* lbDate;
    HealthHistoryRecorView* recordView;
}
@end

@implementation HealthHistoryRecordTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        topLine = [[UIView alloc]init];
        [topLine setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:topLine];
        
        bottomline = [[UIView alloc]init];
        [bottomline setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:bottomline];
        
        circleView = [[UIView alloc]init];
        [circleView setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:circleView];
        circleView.layer.cornerRadius = 6;
        circleView.layer.masksToBounds = YES;
        
        lbDate = [[UILabel alloc]init];
        [self.contentView addSubview:lbDate];
        [lbDate setBackgroundColor:[UIColor clearColor]];
        [lbDate setTextColor:[UIColor commonTextColor]];
        [lbDate setFont:[UIFont font_22]];
        
        recordView = [[HealthHistoryRecorView alloc]init];
        [self.contentView addSubview:recordView];
        
        [self subviewLayout];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) subviewLayout
{
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@8.5);
        make.width.mas_equalTo(@1);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self).with.offset(51);
    }];
    
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@12);
        make.top.equalTo(topLine.mas_bottom).with.offset(1.5);
        make.centerX.equalTo(topLine);
    }];
    
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.equalTo(circleView.mas_bottom).with.offset(1.5);
        make.left.equalTo(self.contentView).with.offset(51);
        make.bottom.equalTo(self.contentView);
    }];
    
    [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@13);
        make.centerY.equalTo(circleView);
        make.right.equalTo(circleView.mas_left).with.offset(-4);
    }];
    
    [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleView.mas_right).with.offset(1.5);
        make.right.equalTo(self.contentView).with.offset(-14);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(@110);
    }];
}

- (void) setHistoryItem:(HealthHistoryItem*) history
{
    [lbDate setText:[history dateStr]];
    [recordView setHistoryItem:history];
}

@end
