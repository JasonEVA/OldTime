//
//  MissionDetailTimeTanleViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/7/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionDetailTimeTanleViewCell.h"
#import "MissionDetailModel.h"
@interface MissionDetailTimeTanleViewCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *timeContentView;
@end

@implementation MissionDetailTimeTanleViewCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"New_TimeClock"] highlightedImage:[UIImage imageNamed:@"Mission_redClock"]];
        [self.contentView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(18);
        }];
        
        _timeContentView = [UILabel new];
        [_timeContentView setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_timeContentView];
        [_timeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.iconView.mas_right).offset(15);
        }];
    }
    return self;
}
#pragma mark - private method

- (NSString *)getTimeStrWithModel:(MissionDetailModel *)model
{
    NSString *startTime = [self handleTimeFormatWithStr:model.startTime AllDay:model.isStartAllDay];
    NSString *endTime = [self handleTimeFormatWithStr:model.endTime AllDay:model.isEndAllDay];
    return [NSString stringWithFormat:@"%@ ~ %@",startTime,endTime];
}

- (NSString *)handleTimeFormatWithStr:(NSString *)timeStr AllDay:(BOOL)isAllday
{
    if (timeStr.length)
    {
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"." withString:@""];
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSArray *timeCompnentArray = [timeStr componentsSeparatedByString:@" "];
        NSString *tempStr = [timeStr substringFromIndex:4];
        NSMutableString *mutableStr = [tempStr mutableCopy];
        if (timeCompnentArray.count == 2)
        {
            mutableStr = [[tempStr substringToIndex:[tempStr length] - 3] mutableCopy];
        }
        [mutableStr insertString:@"/" atIndex:2];
        
        if (isAllday) {
            return  [mutableStr substringToIndex:5];
        }
        
        return mutableStr;
    }
    return @"";
}

- (void)fillDataWithTitle:(MissionDetailModel *)model {
    [self.timeContentView setText:[self getTimeStrWithModel:model]];
    if(model.taskStatus == TaskStatusTypeDone || model.taskStatus == TaskStatusTypeDisabled) {
        [self.iconView setHighlighted:NO];
        [self.timeContentView setTextColor:[UIColor commonGrayTextColor]];
    } else {
        [self.iconView setHighlighted:YES];
        [self.timeContentView setTextColor:[UIColor colorWithHexString:@"ff3366"]];
    }
}
@end
