//
//  SportsPlanTargetTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SportsPlanTargetTableViewCell.h"

@interface SportsPlanTargetView : UIView
{
    UIImageView* ivCircle;
    
    UILabel* lbTarget;
    UIView* taskview;
    UILabel* lbMinute;
    UILabel* lbMinuteUnit;

}

- (void) setUserSportsDetail:(UserSportsDetail*) sportsDetail;
@end

@implementation SportsPlanTargetView

- (id) init
{
    self = [super init];
    if (self)
    {
        ivCircle = [[UIImageView alloc]init];
        [self addSubview:ivCircle];
        [ivCircle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.and.bottom.equalTo(self);
        }];
        
        [ivCircle setImage:[self circleBoarderTargetImage:CGSizeMake(102, 102) Color:[UIColor commonGreenColor] BoarderWidth:3 Rate:0]];
        
        lbTarget = [[UILabel alloc]init];
        [self addSubview:lbTarget];
        [lbTarget setText:@"目标 --分钟"];
        [lbTarget setFont:[UIFont font_24]];
        [lbTarget setTextColor:[UIColor commonLightGrayTextColor]];
        [lbTarget mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(18);
        }];
        
        taskview = [[UILabel alloc]init];
        [self addSubview:taskview];
        [taskview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(@30);
        }];
        
        lbMinute = [[UILabel alloc]init];
        [taskview addSubview:lbMinute];
        [lbMinute setText:@"0"];
        [lbMinute setFont:[UIFont systemFontOfSize:27]];
        [lbMinute setTextColor:[UIColor commonGreenColor]];
        [lbMinute mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(taskview);
            make.bottom.equalTo(taskview);
        }];
        
        lbMinuteUnit = [[UILabel alloc]init];
        [taskview addSubview:lbMinuteUnit];
        [lbMinuteUnit setText:@"分钟"];
        [lbMinuteUnit setFont:[UIFont font_26]];
        [lbMinuteUnit setTextColor:[UIColor commonGrayTextColor]];
        [lbMinuteUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbMinute.mas_right);
            make.right.equalTo(taskview);
            make.bottom.equalTo(taskview).with.offset(-5);
        }];
        
        UILabel* lbSports = [[UILabel alloc]init];
        [self addSubview:lbSports];
        [lbSports setText:@"运动"];
        [lbSports setFont:[UIFont font_24]];
        [lbSports setTextColor:[UIColor commonLightGrayTextColor]];
        [lbSports mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).with.offset(-15);
        }];
    }
    return self;
}

- (void) setUserSportsDetail:(UserSportsDetail*) sportsDetail
{
    [lbTarget setText:[NSString stringWithFormat:@"目标 %ld分钟", sportsDetail.target]];
    [lbMinute setText:[NSString stringWithFormat:@"%ld", sportsDetail.userSportsTotalTimes]];
    
    if (0 == sportsDetail.target)
    {
        [ivCircle setImage:[self circleBoarderTargetImage:CGSizeMake(102, 102) Color:[UIColor commonGreenColor] BoarderWidth:3 Rate:0]];
    }
    else
    {
        [ivCircle setImage:[self circleBoarderTargetImage:CGSizeMake(102, 102) Color:[UIColor commonGreenColor] BoarderWidth:3 Rate:2.0 *sportsDetail.userSportsTotalTimes/sportsDetail.target]];
    }
    
}

- (UIImage*) circleBoarderTargetImage:(CGSize) size
                                Color:(UIColor*) color
                         BoarderWidth:(CGFloat) boarderWidth
                                 Rate:(CGFloat)rate
{
    size.width *= 2;
    size.height *= 2;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width , size.height );
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    
    //绘制大圆
    
    float radius = size.width;
    if (radius < size.height)
    {
        radius = size.height;
    }
    
    float radiusin = size.width;
    if (radiusin > size.height)
    {
        radiusin = size.height;
    }
    
    radius = radius/2 - boarderWidth;
    
    CGFloat red, green, blue, alpha;
    
    [[UIColor colorWithHexString:@"DDDDDD"] getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, boarderWidth * 2);
    
    CGContextAddArc(context, size.width/2, size.height/2, radius, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, boarderWidth * 2);
    
    CGContextAddArc(context, size.width/2, size.height/2, radius, M_PI/2, M_PI * rate + M_PI/2, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    //CGContextClosePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end

@interface SportsPlanTargetExecuteCell : UIView
{
    UILabel* lbSportsName;
    UILabel* lbDuration;
}

- (id) initWithSportEachTime:(SportsEachTime*) eachTime;
@end

@implementation SportsPlanTargetExecuteCell

- (id) initWithSportEachTime:(SportsEachTime*) eachTime
{
    self = [super init];
    if (self)
    {
        lbSportsName = [[UILabel alloc]init];
        [self addSubview:lbSportsName];
        [lbSportsName setTextColor:[UIColor commonGrayTextColor]];
        [lbSportsName setFont:[UIFont font_24]];
        [lbSportsName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(14);
        }];
        [lbSportsName setText:eachTime.sportsName];
        
        lbDuration = [[UILabel alloc]init];
        [self addSubview:lbDuration];
        [lbDuration setTextColor:[UIColor mainThemeColor]];
        [lbDuration setFont:[UIFont font_28]];
        [lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(lbSportsName.mas_bottom).with.offset(3);
        }];
        [lbDuration setText:[NSString stringWithFormat:@"%ld分钟", eachTime.sportTimes]];
    }
    return self;
}

@end

@interface SportsPlanTargetExecuteView : UIScrollView
{
    
}

- (void) setEachTimes:(NSArray*) eachtimes;
@end

@implementation SportsPlanTargetExecuteView

- (void) setEachTimes:(NSArray*) eachtimes
{
    NSArray* subviews = [self subviews];
    for (UIView* subview in subviews)
    {
        [subview removeFromSuperview];
    }
    
    MASViewAttribute* leftattr = self.mas_left;
    for (SportsEachTime* eachtime in eachtimes)
    {
        SportsPlanTargetExecuteCell* cell = [[SportsPlanTargetExecuteCell alloc]initWithSportEachTime:eachtime];
        [self addSubview:cell];
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            make.left.equalTo(leftattr);
            make.width.mas_equalTo([NSNumber numberWithFloat:(kScreenWidth/4)]);
        }];
        leftattr = cell.mas_right;
    }
    [self setContentSize:CGSizeMake((kScreenWidth/4) * eachtimes.count, 70)];
}
@end

@interface SportsPlanTargetTableViewCell ()
{
    SportsPlanTargetView* targetview;
    SportsPlanTargetExecuteView* executeview;
}
@end

@implementation SportsPlanTargetTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        targetview = [[SportsPlanTargetView alloc]init];
        [self.contentView addSubview:targetview];
        [targetview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(102, 102));
        }];
        
        executeview = [[SportsPlanTargetExecuteView alloc]init];
        [self.contentView addSubview:executeview];
        [executeview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@70);
        }];
    }
    return self;
}

- (void) setUserSportsDetail:(UserSportsDetail*) sportsDetail
{
    if (!sportsDetail)
    {
        return;
    }
    [targetview setUserSportsDetail:sportsDetail];
    
    [executeview setEachTimes:sportsDetail.userSportsEachTimes];
}

@end
