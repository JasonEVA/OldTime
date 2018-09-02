//
//  MainStartConsoleView.m
//  HMDoctor
//
//  Created by yinquan on 16/4/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartConsoleView.h"

@interface MainStartConsoleCell : UIControl
{
    UIImageView* ivIcon;
    UILabel* lbConsoleName;
}

- (void) setConsoleItemName:(NSString*) consolename;
@end

@implementation MainStartConsoleCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        ivIcon = [[UIImageView alloc]init];
        [self addSubview:ivIcon];
        [ivIcon setBackgroundColor:[UIColor whiteColor]];
        
        lbConsoleName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 15)];
        [self addSubview:lbConsoleName];
        
        [lbConsoleName setBackgroundColor:[UIColor clearColor]];
        [lbConsoleName setTextColor:[UIColor whiteColor]];
        [lbConsoleName setFont:[UIFont systemFontOfSize:12]];
        [lbConsoleName setTextAlignment:NSTextAlignmentCenter];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(self).with.offset(10);
        make.centerX.equalTo(self);
    }];
    
    [lbConsoleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ivIcon.mas_bottom).with.offset(12);
        make.centerX.equalTo(self);
    }];
}

- (void) setConsoleItemName:(NSString*) consolename
{
    [lbConsoleName setText:consolename];
}

@end

@implementation MainStartConsoleView

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
        [self setBackgroundColor:[UIColor colorWithHexString:kHMHeaderBackgroundColor]];
        
        NSArray* consolenames = @[@"用户随访", @"健康报告", @"健康计划", @"用户用药建议"];
        CGFloat cellwidth = self.width/consolenames.count;
        for  (NSInteger index = 0; index < consolenames.count; ++index)
        {
            MainStartConsoleCell* cell = [[MainStartConsoleCell alloc]initWithFrame:CGRectMake(index * cellwidth, 0, cellwidth, 64)];
            [self addSubview:cell];
            [cell setConsoleItemName:[consolenames objectAtIndex:index]];
        }
        
        
    }
    return self;
}

@end
