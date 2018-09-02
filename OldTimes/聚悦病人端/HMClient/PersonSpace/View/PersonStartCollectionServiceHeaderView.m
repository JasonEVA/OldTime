//
//  PersonStartCollectionServiceHeaderView.m
//  HMClient
//
//  Created by yinqaun on 16/4/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonStartCollectionServiceHeaderView.h"

@interface PersonStartServiceButton : UIButton

@end

@implementation PersonStartServiceButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width - 13, (contentRect.size.height - 15)/2, 13, 15);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(3 , 3, contentRect.size.width - 19, contentRect.size.height - 6);
}
@end

@interface PersonStartCollectionServiceHeaderView ()
{
    UILabel* lbTitle;
    UIButton* btnSerivce;
    
    UIView* bottomline;
}
@end

@implementation PersonStartCollectionServiceHeaderView


- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbTitle = [[UILabel alloc]init];
        [self addSubview:lbTitle];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setFont:[UIFont font_30]];
        [lbTitle setTextColor:[UIColor colorWithHexString:@"333333"]];
        [lbTitle setText:@"我的服务"];
        
        btnSerivce = [[PersonStartServiceButton alloc]init];
        //btnSerivce = [[UIButton alloc]init];
        [self addSubview:btnSerivce];
        
        [btnSerivce setTitle:@"历史订购" forState:UIControlStateNormal];
        [btnSerivce setTitleColor:[UIColor colorWithHexString:@"31B6C1"] forState:UIControlStateNormal];
        [btnSerivce setImage:[UIImage imageNamed:@"icon_r_arrow"] forState:UIControlStateNormal];
        [btnSerivce.titleLabel setFont:[UIFont font_24]];
        [btnSerivce addTarget:self action:@selector(serviceHistoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomline = [[UIView alloc]init];
        [self addSubview:bottomline];
        [bottomline setBackgroundColor:[UIColor commonControlBorderColor]];
        
        //
        
        [self subviewLayout];
    }
    return self;
}



- (void) serviceHistoryButtonClicked:(id) sender
{
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－历史订购"];
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:nil];
}

- (void) subviewLayout
{
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(15);
    }];
    
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(0.5);
    }];
    
    [btnSerivce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-12.5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(88, 31));
    }];
}
@end
