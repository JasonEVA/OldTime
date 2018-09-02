//
//  DetectRecordOverallTimeView.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecordOverallTimeView.h"

@interface DetectRecordTimeCell : UIControl
{
    UILabel* lbTimeType;
}

@property (nonatomic, assign) DetectTimeType timetype;

@end

@implementation DetectRecordTimeCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lbTimeType = [[UILabel alloc]init];
        [self addSubview:lbTimeType];
        [lbTimeType setBackgroundColor:[UIColor clearColor]];
        [lbTimeType setTextAlignment:NSTextAlignmentCenter];
        [lbTimeType setFont:[UIFont font_24]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbTimeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.center.equalTo(self);
    }];
}

- (void) setTimeType:(DetectTimeType) timetype
{
    _timetype = timetype;
    NSString* typeStr = nil;
    switch (timetype) {
        case DetectTime_Daily:
        {
            typeStr = @"日";
        }
            break;
        case DetectTime_Weekly:
        {
            typeStr = @"周";
        }
            break;
        case DetectTime_Monthly:
        {
            typeStr = @"月";
        }
            break;
        default:
            break;
    }
    [lbTimeType setText:typeStr];
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        [lbTimeType setTextColor:[UIColor mainThemeColor]];
    }
    else
    {
        [lbTimeType setTextColor:[UIColor commonGrayTextColor]];
    }
}

@end

@interface DetectRecordOverallTimeView ()
{
    NSMutableArray* timeCells;
}


@end

@implementation DetectRecordOverallTimeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _selectedTimeType = DetectTime_Monthly;
        [self createTimeCells];
    }
    return self;
}

- (void) createTimeCells
{
    if (timeCells)
    {
        for (DetectRecordTimeCell* cell in timeCells) {
            [cell removeFromSuperview];
        }
    }
    
    timeCells = [NSMutableArray array];
    CGFloat cellWidht = self.width / DetectTime_Monthly;
    for (NSInteger type = DetectTime_Daily; type <= DetectTime_Monthly ; ++type)
    {
        DetectRecordTimeCell* cell = [[DetectRecordTimeCell alloc]initWithFrame:CGRectMake(cellWidht * (type - 1), 0, cellWidht, self.height)];
        [cell setTimeType:type];
        [self addSubview:cell];
        [cell setSelected:(type == _selectedTimeType)];
        [timeCells addObject:cell];
        
        [cell addTarget:self action:@selector(timetypeCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) timetypeCellClicked:(id) sender
{
    if (![sender isKindOfClass:[DetectRecordTimeCell class]]) {
        return;
    }
    
    DetectRecordTimeCell* selCell = (DetectRecordTimeCell*) sender;
    if (selCell.timetype == _selectedTimeType)
    {
        return;
    }
    _selectedTimeType = selCell.timetype;
    
    for (DetectRecordTimeCell* cell in timeCells)
    {
        [cell setSelected:(cell == selCell)];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(timeTypeSelected:)])
    {
        [_delegate timeTypeSelected:_selectedTimeType];
    }

}

@end

@interface DetectRecordContrastTimeView ()
{
    NSMutableArray* timeCells;
}
@end

@implementation DetectRecordContrastTimeView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _selectedTimeType = DetectTime_Monthly;
        [self createTimeCells];
    }
    return self;
}

- (void) createTimeCells
{
    if (timeCells)
    {
        for (DetectRecordTimeCell* cell in timeCells) {
            [cell removeFromSuperview];
        }
    }
    
    timeCells = [NSMutableArray array];
    CGFloat cellWidht = self.width / (DetectTime_Monthly - DetectTime_Weekly + 1);
    for (NSInteger type = DetectTime_Weekly; type <= DetectTime_Monthly ; ++type)
    {
        DetectRecordTimeCell* cell = [[DetectRecordTimeCell alloc]initWithFrame:CGRectMake(cellWidht * (type - 2), 0, cellWidht, self.height)];
        [cell setTimeType:type];
        [self addSubview:cell];
        [cell setSelected:(type == _selectedTimeType)];
        [timeCells addObject:cell];
        
        [cell addTarget:self action:@selector(timetypeCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) timetypeCellClicked:(id) sender
{
    if (![sender isKindOfClass:[DetectRecordTimeCell class]]) {
        return;
    }
    
    DetectRecordTimeCell* selCell = (DetectRecordTimeCell*) sender;
    if (selCell.timetype == _selectedTimeType)
    {
        return;
    }
    _selectedTimeType = selCell.timetype;
    
    for (DetectRecordTimeCell* cell in timeCells)
    {
        [cell setSelected:(cell == selCell)];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(timeTypeSelected:)])
    {
        [_delegate timeTypeSelected:_selectedTimeType];
    }
}
@end
