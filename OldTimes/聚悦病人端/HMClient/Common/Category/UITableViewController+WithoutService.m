//
//  UITableViewController+WithoutService.m
//  HMClient
//
//  Created by lkl on 16/7/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UITableViewController+WithoutService.h"

static NSInteger withoutServiceViewTag = 0x4823;

@implementation UITableViewController (WithoutService)

- (void) showWithoutServiceView
{
    UIView* withoutServiceView = [self.tableView viewWithTag:withoutServiceViewTag];
    if (withoutServiceView) {
        [withoutServiceView setHidden:NO];
        return;
    }
    
    withoutServiceView = [[UIView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView setBackgroundView:withoutServiceView];
    [withoutServiceView setBackgroundColor:[UIColor commonBackgroundColor]];
    [withoutServiceView setTag:withoutServiceViewTag];
    
    UIImageView* ivBlank = [[UIImageView alloc]initWithFrame:CGRectMake((self.tableView.width - 100)/2, 64, 100, 141)];
    [withoutServiceView addSubview:ivBlank];
    [ivBlank setImage:[UIImage imageNamed:@"img_blank_list"]];
    
    UILabel* lbMessage = [[UILabel alloc] init];
    [withoutServiceView addSubview:lbMessage];
    [lbMessage setNumberOfLines:0];
    [lbMessage setText:@"您还没有通过实名认证哦，"];
    [lbMessage setFont:[UIFont font_32]];
    [lbMessage setTextColor:[UIColor commonTextColor]];
    [lbMessage setTextAlignment:NSTextAlignmentCenter];
    
    UILabel* lbContent = [[UILabel alloc] init];
    [withoutServiceView addSubview:lbContent];
    [lbContent setNumberOfLines:0];
    [lbContent setText:@"请到健康中心进行认证！"];
    [lbContent setFont:[UIFont font_32]];
    [lbContent setTextColor:[UIColor commonTextColor]];
    [lbContent setTextAlignment:NSTextAlignmentCenter];
    
    [lbMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.superview);
        make.top.equalTo(ivBlank.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.superview);
        make.top.equalTo(lbMessage.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    
    /*
    UIButton* orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [withoutServiceView addSubview:orderButton];
    
    [orderButton setBackgroundColor:[UIColor mainThemeColor]];
    [orderButton setTitle:@"前往订购>>" forState:UIControlStateNormal];
    [orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderButton.titleLabel setFont:[UIFont font_28]];
    [orderButton addTarget:self action:@selector(orderServiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.top.equalTo(lbMessage.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];*/
    
    if (!self.tableView.mj_header)
    {
        self.tableView.scrollEnabled = NO;
    }
}

- (void)orderServiceButtonClick
{
    //跳转到服务分类
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
}


- (void) closeWithoutServiceView
{
    UIView* withoutServiceView = [self.tableView viewWithTag:withoutServiceViewTag];
    if (withoutServiceView) {
        [withoutServiceView removeFromSuperview];
        [withoutServiceView setHidden:YES];
    }
    
    self.tableView.scrollEnabled = YES;
}
@end
