//
//  HMAdvertiseCell.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMAdvertiseCell.h"

@interface HMAdvertiseCell ()
{
    UIImageView* ivAdvertise;
}
@end

@implementation HMAdvertiseCell

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
        ivAdvertise = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:ivAdvertise];
        [ivAdvertise setImage:[UIImage imageNamed:@"img_default_advertise"]];
    }
    return self;
}

- (void) setAdvertiseInfo:(AdvertiseInfo*) advertise
{
    if (ivAdvertise)
    {
        [ivAdvertise sd_setImageWithURL:[NSURL URLWithString:advertise.imgUrlBig] placeholderImage:[UIImage imageNamed:@"img_default_advertise"]];
    }
}



@end
