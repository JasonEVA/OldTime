//
//  HealthReportTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthReportTableViewCell.h"
#import "HealthReportRecordView.h"

@interface HealthReport (ReportTableCell)
{
    
}

- (NSString*) yearString;
- (NSString*) dateString;
@end

@implementation HealthReport (ReportTableCell)

- (NSString*) yearString
{
    if (!self.summarizeTime || 0 == self.summarizeTime.length)
    {
        return nil;
    }
    NSDate* date = [NSDate dateWithString:self.summarizeTime formatString:@"yyyy-MM-dd"];
    NSString* yearStr = [date formattedDateWithFormat:@"yyyy"];
    return yearStr;
}

- (NSString*) dateString
{
    if (!self.summarizeTime || 0 == self.summarizeTime.length)
    {
        return nil;
    }
    NSDate* date = [NSDate dateWithString:self.summarizeTime formatString:@"yyyy-MM-dd"];
    NSString* dateStr = [date formattedDateWithFormat:@"MM/dd"];
    return dateStr;
}
@end

@interface HealthReportTableViewCell ()
{
    UIView* topLine;
    UIView* bottomline;
    UIView* circleView;
    UILabel* lbYear;
    UILabel* lbDate;
    
    HealthReportRecordView* recordview;
}
@end

@implementation HealthReportTableViewCell

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
        
        lbYear = [[UILabel alloc]init];
        [self.contentView addSubview:lbYear];
        [lbYear setBackgroundColor:[UIColor clearColor]];
        [lbYear setTextColor:[UIColor commonTextColor]];
        [lbYear setFont:[UIFont font_22]];
        
        lbDate = [[UILabel alloc]init];
        [self.contentView addSubview:lbDate];
        [lbDate setBackgroundColor:[UIColor clearColor]];
        [lbDate setTextColor:[UIColor commonTextColor]];
        [lbDate setFont:[UIFont font_22]];
        
        recordview = [[HealthReportRecordView alloc]init];
        [self.contentView addSubview:recordview];
        
        [self subviewLayout];
    }
    return self;
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
    
    [lbYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@13);
        make.bottom.equalTo(circleView.mas_centerY);
        make.right.equalTo(circleView.mas_left).with.offset(-4);
    }];
    
    [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@13);
        make.top.equalTo(circleView.mas_centerY);
        make.right.equalTo(circleView.mas_left).with.offset(-4);
    }];

    [recordview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleView.mas_right).with.offset(2);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
}

- (void) setHealthReport:(HealthReport*) report
{
    [lbYear setText:[report yearString]];
    [lbDate setText:[report dateString]];
    
    [recordview setHealthReport:report];
}

@end
