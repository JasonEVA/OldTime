//
//  MainStartEvaluateSectionCollectionViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/4/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartEvaluateSectionCollectionViewCell.h"


@interface MainStartEvaluateSectionCollectionViewCell ()
{
    UIControl* ctlEvaluate;
}
@end

@implementation MainStartEvaluateSectionCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ctlEvaluate = [[UIControl alloc]initWithFrame:CGRectMake((320 *  - 84)/2 , 6, 84, 84)];
        [self.contentView addSubview:ctlEvaluate];
        [ctlEvaluate setBackgroundColor:[UIColor colorWithHexString:@"DCDCDC"]];
        [ctlEvaluate.layer setCornerRadius:ctlEvaluate.width/2];
        [ctlEvaluate.layer setMasksToBounds:YES];
        
        UILabel* lbEvaluate = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 84, 24)];
        [lbEvaluate setBackgroundColor:[UIColor clearColor]];
        [lbEvaluate setText:@"健康自评"];
        [ctlEvaluate addSubview:lbEvaluate];
        [lbEvaluate setFont:[UIFont font_30]];
        [lbEvaluate setTextAlignment:NSTextAlignmentCenter];
        [lbEvaluate setTextColor:[UIColor commonTextColor]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ctlEvaluate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@84);
        make.width.mas_equalTo(@84);
        make.center.equalTo(self.contentView);
    }];
}
@end
