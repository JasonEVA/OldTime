//
//  ToolLibraryStartHeaderView.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ToolLibraryStartHeaderView.h"

@interface ToolLibraryStartHeaderView ()
{
    UILabel* lbTitle;
}


@end


@implementation ToolLibraryStartHeaderView

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
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbTitle = [[UILabel alloc] init];
        [self addSubview:lbTitle];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setFont:[UIFont systemFontOfSize:14]];
        [lbTitle setTextColor:[UIColor commonGrayTextColor]];
        
        [self showBottomLine];
        [self showTopLine];
        
        [self subviewLayout];
    }
    
    return self;
}

- (void) setTitle:(NSString*) title{
    [lbTitle setText:title];
}

- (void) subviewLayout
{
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(self).with.offset(14);
    }];
}
@end
