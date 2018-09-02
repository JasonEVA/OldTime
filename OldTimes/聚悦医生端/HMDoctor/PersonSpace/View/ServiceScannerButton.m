//
//  ServiceScannerButton.m
//  HMDoctor
//
//  Created by lkl on 16/11/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceScannerButton.h"

@interface ServiceScannerButton ()
{
    UIImageView* ivImg;
    UILabel* lbContent;
}
@end

@implementation ServiceScannerButton

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        ivImg = [[UIImageView alloc] init];
        [ivImg setImage:[UIImage imageNamed:@"icon_two_bar_codes"]];
        [self addSubview:ivImg];
        
        lbContent = [[UILabel alloc] init];
        [lbContent setFont:[UIFont systemFontOfSize:10]];
        [lbContent setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:lbContent];
        [lbContent setText:@"查看二维码"];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [ivImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lbContent.mas_top).with.offset(-5);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}


@end
