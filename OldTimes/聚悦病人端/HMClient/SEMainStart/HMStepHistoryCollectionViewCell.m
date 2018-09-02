//
//  HMStepHistoryCollectionViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/8/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMStepHistoryCollectionViewCell.h"
#import "HMStepHistoryModel.h"

#define CYLINDERWIDTH    15
#define MAXSTEPCOUNT     30000.0
@interface HMStepHistoryCollectionViewCell ()
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UIView *cylinder;
@property (nonatomic, strong) MASConstraint *cylinderHieght;

@end

@implementation HMStepHistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.dateLb];
        [self.contentView addSubview:self.cylinder];
        
        [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.cylinder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@CYLINDERWIDTH);
            make.centerX.equalTo(self.contentView);
            self.cylinderHieght = make.height.equalTo(@0);
            make.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)fillDataWithModel:(HMStepHistoryModel *)model groupPKScreening:(HMGroupPKScreening)groupPKScreening{
    if (!model.upTimeStamp) {
        [self.dateLb setText:@""];
        self.cylinderHieght.offset = 0;
        return;
    }
    
    switch (groupPKScreening) {
        case HMGroupPKScreening_Day:
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.upTimeStamp / 1000];
            NSString *dateString = @"";
            if ([date isToday]) {
                dateString = @"今日";
            }
            else {
                dateString = [date formattedDateWithFormat:@"MM.dd"];
            }
            [self.dateLb setText:dateString];
            if (model.stepCount > 0) {
                self.cylinderHieght.offset = MAX(25, MIN(1,(model.stepCount / MAXSTEPCOUNT)) * (self.frame.size.height - 25));

            }
            else {
                self.cylinderHieght.offset = 0;
            }
            break;
        }
        case HMGroupPKScreening_Week:
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.upTimeStamp / 1000];
            NSDate *sunday = [date dateByAddingDays:6];

            NSString *dateString = @"";
            if ([[NSDate date] isEarlierThanOrEqualTo:sunday]&&[[NSDate date] isLaterThanOrEqualTo:date]) {
                dateString = @"本周";
            }
            else {
                dateString = [NSString stringWithFormat:@"%@",[date formattedDateWithFormat:@"MM.dd"]];
            }
            [self.dateLb setText:dateString];
            if (model.stepCount > 0) {
                self.cylinderHieght.offset = MAX(25, MIN(1,(model.stepCount / (MAXSTEPCOUNT*7))) * (self.frame.size.height - 25));
            }
            else {
                self.cylinderHieght.offset = 0 ;
            }
            
            break;
        }
        case HMGroupPKScreening_Month:
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.upTimeStamp / 1000];
            NSString *dateString = @"";
            if (date.month == [NSDate date].month) {
                dateString = @"本月";
            }
            else {
                dateString = [date formattedDateWithFormat:@"MM月"];
            }
            [self.dateLb setText:dateString];
            if (model.stepCount > 0) {
                 self.cylinderHieght.offset = MAX(25, MIN(1,(model.stepCount / (MAXSTEPCOUNT*30))) * (self.frame.size.height - 25));
            }
            else {
                self.cylinderHieght.offset = 0 ;
            }
           
            break;
        }
            
        default:
            break;
    }
    
   
}

- (void)updateCellStatusIsSelect:(BOOL)isSelect {
    if (isSelect) {
        [self.dateLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.cylinder setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    }
    else {
        [self.dateLb setTextColor:[UIColor colorWithHexString:@"ffffff" alpha:0.5]];
        [self.cylinder setBackgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:0.5]];
    }
}

- (UILabel *)dateLb {
    if (!_dateLb) {
        _dateLb  = [UILabel new];
        [_dateLb setFont:[UIFont systemFontOfSize:12]];
        [_dateLb setTextColor:[UIColor colorWithHexString:@"ffffff" alpha:0.5]];
    }
    return _dateLb;
}

- (UIView *)cylinder {
    if (!_cylinder) {
        _cylinder = [[UIView alloc] init];
        [_cylinder.layer setCornerRadius:CYLINDERWIDTH / 2];
        [_cylinder.layer setBackgroundColor:[[UIColor colorWithHexString:@"FFFFFF" alpha:0.5] CGColor]];
        [_cylinder setClipsToBounds:YES];
    }
    return _cylinder;
}



@end
