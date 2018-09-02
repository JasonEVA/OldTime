//
//  BloodFatRecordHeaderView.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodFatRecordHeaderView.h"

@interface BloodFatRecordHeaderCell : UIControl
{
    UILabel* lbTitle;
    UIImageView* ivIcon;
    UIView* leftline;
}
@end

@implementation BloodFatRecordHeaderCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        lbTitle = [[UILabel alloc]init];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setTextColor:[UIColor colorWithHexString:@"808080"]];
        [lbTitle setFont:[UIFont font_22]];
        [self addSubview:lbTitle];
        
        ivIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_bloodfat_note"]];
        [self addSubview:ivIcon];
        
        leftline = [[UIView alloc]init];
        [leftline setBackgroundColor:[UIColor commonControlBorderColor]];
        [self addSubview:leftline];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(17);
    }];
    
    [leftline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo(@0.5);
    }];
    
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTitle.mas_right).with.offset(3);
        make.top.equalTo(self).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(12.5, 12.5));
    }];
}

- (void) setTitle:(NSString*) title
{
    [lbTitle setText:title];
}

@end

@interface BloodFatRecordHeaderView ()
{
    NSMutableArray* cells;
}
@end

@implementation BloodFatRecordHeaderView

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
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        [self.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
        [self.layer setBorderWidth:0.5];

        
        UILabel* lbTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, self.height)];
        [self addSubview:lbTime];
        [lbTime setBackgroundColor:[UIColor clearColor]];
        [lbTime setText:@"时间"];
        [lbTime setTextAlignment:NSTextAlignmentCenter];
        [lbTime setTextColor:[UIColor colorWithHexString:@"808080"]];
        [lbTime setFont:[UIFont font_22]];
        
        [self createCells];
    }
    return self;
}

- (void) createCells
{
    cells = [NSMutableArray array];
    CGFloat cellwidth = (self.width - 60)/4;
    NSArray* titles = @[@"TG", @"TC", @"HDL-C", @"LDL-C"];
    for (NSInteger index = 0; index < titles.count; ++index)
    {
        NSString* title = titles[index];
        CGRect rtCell = CGRectMake(60 + cellwidth * index, 0, cellwidth, self.height);
        BloodFatRecordHeaderCell* cell = [[BloodFatRecordHeaderCell alloc]initWithFrame:rtCell];
        [self addSubview:cell];
        [cells addObject:cell];
        [cell setTitle:title];
    }
}
@end
