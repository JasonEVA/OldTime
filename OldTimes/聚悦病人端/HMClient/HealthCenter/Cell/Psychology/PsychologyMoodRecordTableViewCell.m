//
//  PsychologyMoodRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PsychologyMoodRecordTableViewCell.h"


@interface UserPsychologyInfo (RecordTableViewCell)
{
    
}

- (UIImage*) moodImage;
@end

@implementation UserPsychologyInfo (RecordTableViewCell)

- (UIImage*) moodImage
{
    NSString* imageName = nil;
    switch (self.moodType)
    {
        case 1:
        {
            imageName = @"icon_health_plan_mood1_s";
        }
            break;
        case 2:
        {
            imageName = @"icon_health_plan_mood2_s";
        }
            break;
        case 3:
        {
            imageName = @"icon_health_plan_mood3_s";
        }
            break;
        case 4:
        {
            imageName = @"icon_health_plan_mood4_s";
        }
            break;
        default:
            break;
    }
    
    if (imageName)
    {
        return [UIImage imageNamed:imageName];
    }
    return nil;
}

- (NSString*) moodString
{
    NSString* moodString = nil;
    switch (self.moodType)
    {
        case 1:
        {
            moodString = @"开心";
        }
            break;
        case 2:
        {
            moodString = @"平静";
        }
            break;
        case 3:
        {
            moodString = @"沮丧";
        }
            break;
        case 4:
        {
            moodString = @"烦躁";
        }
            break;
        default:
            break;
    }

    return moodString;
}
@end

@interface PsychologyMoodRecordTableViewCell ()
{
    UIImageView* ivMood;
    UILabel* lbMood;
    UILabel* lbDate;
}

- (void) setMoodInfo:(UserPsychologyInfo*) userMood;
@end

@implementation PsychologyMoodRecordTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivMood = [[UIImageView alloc]init];
        [self.contentView addSubview:ivMood];
        
        [ivMood mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        lbMood = [[UILabel alloc]init];
        [self.contentView addSubview:lbMood];
        [lbMood setFont:[UIFont font_30]];
        [lbMood setTextColor:[UIColor commonTextColor]];
        
        [lbMood mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(ivMood.mas_right).with.offset(8);
        }];
        
        lbDate = [[UILabel alloc]init];
        [self.contentView addSubview:lbDate];
        [lbDate setFont:[UIFont font_26]];
        [lbDate setTextColor:[UIColor commonGrayTextColor]];
        
        [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-12.5);
        }];
    }
    return self;
}

- (void) setMoodInfo:(UserPsychologyInfo*) userMood
{
    [ivMood setImage:[userMood moodImage]];
    [lbMood setText:[userMood moodString]];
    [lbDate setText:@""];
    
    if (userMood.createTime)
    {
        NSDate* date = [NSDate dateWithString:userMood.createTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        if (date)
        {
            NSString* dateStr = [date formattedDateWithFormat:@"yyyy年MM月dd日"];
            [lbDate setText:dateStr];
        }
        
    }
}

@end
