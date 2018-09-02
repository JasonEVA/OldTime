//
//  DetectRecordSegmentedView.m
//  HMClient
//
//  Created by yinqaun on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecordSegmentedView.h"

@interface DetectRecordSegmentedCell : UIControl
{
    UILabel* lbTitle;
}

- (void) setTitle:(NSString*) title;
@end

@implementation DetectRecordSegmentedCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lbTitle = [[UILabel alloc]initWithFrame:self.bounds];
        [self addSubview:lbTitle];
        [lbTitle setBackgroundColor:[UIColor whiteColor]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setFont:[UIFont font_24]];
    }
    return self;
}

- (void) setTitle:(NSString*) title
{
    [lbTitle setText:title];
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        [lbTitle setBackgroundColor:[UIColor mainThemeColor]];
        [lbTitle setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [lbTitle setBackgroundColor:[UIColor whiteColor]];
        [lbTitle setTextColor:[UIColor mainThemeColor]];
    }
}



@end

@interface DetectRecordSegmentedView ()
{
    NSMutableArray* segmentedCells;
}
@end

@implementation DetectRecordSegmentedView

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
        [self setBackgroundColor:[UIColor mainThemeColor]];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        [self.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [self.layer setBorderWidth:0.5];
        //[self.layer setCornerRadius:2.5];
        
        //[self.layer setMasksToBounds:YES];
        
        [self createSegmentedCells];
    }
    return self;
}

- (void) createSegmentedCells
{
    if (segmentedCells)
    {
        for (DetectRecordSegmentedCell* cell in segmentedCells) {
            [cell removeFromSuperview];
        }
    }
    
    segmentedCells = [NSMutableArray array];
    NSArray* titles = @[@"整体趋势", @"时段对比", @"数值记录"];
    CGFloat cellwidth = (self.width - (titles.count - 1))/3;
    for (NSInteger index = 0; index < titles.count; ++index)
    {
        CGRect rtCell = CGRectMake((cellwidth + 1) * index, 0, cellwidth, self.height);
        DetectRecordSegmentedCell* cell = [[DetectRecordSegmentedCell alloc]initWithFrame:rtCell];
        [self addSubview:cell];
        [cell setTitle:titles[index]];
        [cell setSelected:(index == self.selectedIndex)];
        [segmentedCells addObject:cell];
        
        [cell addTarget:self action:@selector(segmentedCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void) segmentedCellClicked:(id) sender
{
    if (![sender isKindOfClass:[DetectRecordSegmentedCell class]]) {
        return;
    }
    
    DetectRecordSegmentedCell* selCell = (DetectRecordSegmentedCell*)sender;
    NSInteger selIndex = [segmentedCells indexOfObject:selCell];
    if (NSNotFound == selIndex)
    {
        return;
    }
    if (selIndex == self.selectedIndex)
    {
        return;
    }
    [self setSelectedIndex:selIndex];
    
    for (DetectRecordSegmentedCell* cell in segmentedCells)
    {
        [cell setSelected:(cell == selCell)];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(segmentedview:SelectedIndex:)])
    {
        [_delegate segmentedview:self SelectedIndex:selIndex];
    }
}

@end
