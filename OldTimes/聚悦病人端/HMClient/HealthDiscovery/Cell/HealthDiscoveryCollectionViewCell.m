//
//  HealthDiscoveryCollectionViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthDiscoveryCollectionViewCell.h"

@implementation HealthDiscoveryGirdInfo


@end

@interface HealthDiscoveryCollectionViewCell ()
{
    UIImageView* ivIcon;
    UILabel* lbTitle;
    
    UIImageView* ivNoOpen;
}
@end

@implementation HealthDiscoveryCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        ivIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:ivIcon];
        
        lbTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbTitle];
        
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setFont:[UIFont font_26]];
        [lbTitle setTextColor:[UIColor colorWithHexString:@"444444"]];
        
        ivNoOpen = [[UIImageView alloc] init];
        [self addSubview:ivNoOpen];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(lbTitle.mas_top).offset(-7);
        make.width.and.height.mas_equalTo(@30);
    }];
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-17);
    }];
    
    [ivNoOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
}

- (void) setDiscoveryInfo:(HealthDiscoveryGirdInfo*) gird
{
    [lbTitle setText:gird.girdName];
    if (gird.iconName)
    {
        [ivIcon setImage:[UIImage imageNamed:gird.iconName]];
    }
}

- (void) setNoOpenImage
{
    [ivNoOpen setImage:[UIImage imageNamed:@"icon_no_open_2"]];
}

@end
