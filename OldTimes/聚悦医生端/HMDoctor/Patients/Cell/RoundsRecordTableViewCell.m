//
//  RoundsRecordTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/9/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsRecordTableViewCell.h"
#import "RoundsRecordView.h"

@interface RoundsRecord (EvaluationDate)

@end

@implementation RoundsRecord (RoundsDate)

- (NSString*) dateStr
{
    if (!self.time)
    {
        return nil;
    }
    
    //NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSDate* visitDate = [NSDate dateWithString:self.time formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [visitDate formattedDateWithFormat:@"MM-dd"];
    
    return dateStr;
    
}

@end

@interface RoundsRecordTableViewCell ()
{
    UIView* topLine;
    UIView* bottomline;
    UIView* circleView;
    UILabel* lbDate;
    UILabel* lbTime;
    
    RoundsRecordView* recordview;
}
@end

@implementation RoundsRecordTableViewCell

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
        [lbDate setFont:[UIFont systemFontOfSize:11]];
        
        lbTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbTime];
        [lbTime setBackgroundColor:[UIColor clearColor]];
        [lbTime setTextColor:[UIColor commonTextColor]];
        [lbTime setFont:[UIFont systemFontOfSize:11]];
        
        recordview = [[RoundsRecordView alloc]init];
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
    
    [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@13);
        make.centerY.equalTo(circleView);
        make.right.equalTo(circleView.mas_left).with.offset(-4);
    }];
    
    [recordview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleView.mas_right).with.offset(2);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    
    
}

- (void)setRoundsRecord:(RoundsRecord *)record
{
    [lbDate setText:[record dateStr]];
    
    [recordview setRoundsRecord:record];
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
