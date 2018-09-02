//
//  DealUserWarningTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/12/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DealUserWarningTableViewCell.h"

@interface DealUserWarningTableViewCell ()
{
    UILabel *lbTime;
    UILabel* updateTimeLable;
    UILabel *lbKpiName;
    UILabel *lbDoWay;
    UIView* cuttinglineView;
}

@end

@implementation DealUserWarningTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        lbTime = [[UILabel alloc] init];
        [self.contentView addSubview:lbTime];
        [lbTime setFont:[UIFont systemFontOfSize:15.0f]];
        [lbTime setTextColor:[UIColor commonDarkGrayTextColor]];
        
        updateTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:updateTimeLable];
        [updateTimeLable setFont:[UIFont systemFontOfSize:13.0f]];
        [updateTimeLable setTextColor:[UIColor commonGrayTextColor]];
        
        lbKpiName = [[UILabel alloc] init];
        [self.contentView addSubview:lbKpiName];
        [lbKpiName setFont:[UIFont systemFontOfSize:14.0f]];
        [lbKpiName setTextColor:[UIColor commonDarkGrayTextColor]];
        
        lbDoWay = [[UILabel alloc] init];
        [self.contentView addSubview:lbDoWay];
        [lbDoWay setFont:[UIFont systemFontOfSize:13.0f]];
        [lbDoWay setTextColor:[UIColor commonDarkGrayTextColor]];
        
        cuttinglineView = [[UIView alloc] init];
        [self addSubview:cuttinglineView];
        [cuttinglineView setBackgroundColor:[UIColor whiteColor]];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout{

    [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12);
        make.top.mas_equalTo(@8);
    }];
    
    [lbKpiName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTime.mas_right).with.offset(20);
        make.top.equalTo(lbTime.mas_top);
    }];
    
    [updateTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTime.mas_left);
        make.top.equalTo(lbTime.mas_bottom).with.offset(8);
    }];
    
    [lbDoWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTime.mas_left);
        make.top.equalTo(updateTimeLable.mas_bottom).with.offset(8);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [cuttinglineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(@1);
        make.top.equalTo(self.mas_bottom).with.offset(-1);
    }];
}

- (void)setWarningRecordInfo:(UserWarningRecord *)record
{
    if (record) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:record.doDate];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *timeStr = [formatter stringFromDate:date];
        
        [lbTime setText:timeStr];
        [lbKpiName setText:record.testValue];
        [updateTimeLable setText:[NSString stringWithFormat:@"数据上传时间:%@", record.uploadTime]];
        NSString* doWayString = [NSString stringWithFormat:@"处理方式：%@",record.doWay];
        if (record.staffName && record.staffName.length > 0
            && record.processTime && record.processTime.length > 0)
        {
            doWayString = [doWayString stringByAppendingFormat:@"(%@ %@)", record.staffName, record.processTime];
        }
        [lbDoWay setText:doWayString];
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface SelectDealUserWarningTableViewCell ()
{
    UILabel *lbName;
    UIView* cuttinglineView;
}

@end

@implementation SelectDealUserWarningTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        lbName = [[UILabel alloc] init];
        [self.contentView addSubview:lbName];
        [lbName setFont:[UIFont systemFontOfSize:15.0f]];
        [lbName setTextColor:[UIColor mainThemeColor]];
        
        cuttinglineView = [[UIView alloc] init];
        [self addSubview:cuttinglineView];
        [cuttinglineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout{
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(@12);
    }];
    
    [cuttinglineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(@1);
        make.top.equalTo(self.mas_bottom).with.offset(-1);
    }];
}

- (void)setNameTitle:(NSString *)title
{
    [lbName setText:title];
}

@end
