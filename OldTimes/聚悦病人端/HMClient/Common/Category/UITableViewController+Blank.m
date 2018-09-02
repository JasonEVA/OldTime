//
//  UITableViewController+Blank.m
//  HMClient
//
//  Created by yinqaun on 16/4/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UITableViewController+Blank.h"

static NSInteger blankviewTag = 0x4821;

@implementation UITableViewController (Blank)

- (void) showBlankView
{
    UIView* blankviwe = [self.tableView viewWithTag:blankviewTag];
    if (blankviwe) {
        [blankviwe setHidden:NO];
        return;
    }
    
    blankviwe = [[UIView alloc]initWithFrame:self.tableView.bounds];
    [self.tableView setBackgroundView:blankviwe];
    [blankviwe setBackgroundColor:[UIColor commonBackgroundColor]];
    [blankviwe setTag:blankviewTag];
    
    UIImageView* ivBlank = [[UIImageView alloc]initWithFrame:CGRectMake((self.tableView.width - 100)/2, 64, 100, 141)];
    [blankviwe addSubview:ivBlank];
    [ivBlank setImage:[UIImage imageNamed:@"img_blank_list"]];
    
    if (!self.tableView.mj_header)
    {
        self.tableView.scrollEnabled = NO;
    }
    
}

- (void) closeBlankView
{
    UIView* blankviwe = [self.tableView viewWithTag:blankviewTag];
    if (blankviwe) {
        [blankviwe removeFromSuperview];
        [blankviwe setHidden:YES];
    }
    
    self.tableView.scrollEnabled = YES;
}
@end
