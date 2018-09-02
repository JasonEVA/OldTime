//
//  MainStartServiceTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartServiceTableViewCell.h"
#import "InitializationHelper.h"
#import "ServiceTeamConversationViewController.h"
@interface MainStartServiceCell : UIControl
{
    UILabel* lbTitle;
}

- (id) initWithTitle:(NSString*) title;
@end

@implementation MainStartServiceCell

- (id) initWithTitle:(NSString*) title
{
    self = [super init];
    if (self)
    {
        self.layer.borderColor = [UIColor mainThemeColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 2.5;
        self.layer.masksToBounds = YES;
        
        lbTitle = [[UILabel alloc]init];
        [self addSubview:lbTitle];
        [lbTitle setTextColor:[UIColor mainThemeColor]];
        [lbTitle setText:title];
        [lbTitle setFont:[UIFont font_30]];
        
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

@end

@interface MainStartServiceTableViewCell ()
{
    NSMutableArray* serviceCells;
}

@end

@implementation MainStartServiceTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        serviceCells = [NSMutableArray array];
        NSArray* serviceTitles = @[@"问医生", @"约专家", @"健康档案", @"健康报告"];
        for (NSString* serviceTitle in serviceTitles)
        {
            MainStartServiceCell* cell = [[MainStartServiceCell alloc]initWithTitle:serviceTitle];
            [self.contentView addSubview:cell];
            [serviceCells addObject:cell];
            [cell addTarget:self action:@selector(serviceCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self subviewLayout];
    }
    
    
    return self;
}

- (void) subviewLayout
{
    for (MainStartServiceCell* cell in serviceCells)
    {
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.height.mas_equalTo(@53);
            
            if (cell == [serviceCells firstObject])
            {
                make.left.equalTo(self.contentView).with.offset(13);
            }
            else
            {
                MainStartServiceCell* perCell = nil;
                NSInteger perIndex = [serviceCells indexOfObject:cell] - 1;
                if (0 <= perIndex)
                {
                    perCell = serviceCells[perIndex];
                }
                
                if (perCell)
                {
                    make.left.equalTo(perCell.mas_right).with.offset(7.5);
                    make.width.equalTo(perCell);
                }
            }
           
            if (cell == [serviceCells lastObject])
            {
                make.right.equalTo(self.contentView).with.offset(-13);
            }
        }];
    }
    
}

- (void) serviceCellClicked:(id) sender
{
    if (![sender isKindOfClass:[MainStartServiceCell class]])
    {
        return;
    }
    
    MainStartServiceCell* clickedcell = (MainStartServiceCell*)sender;
    NSInteger clickedIndex = [serviceCells indexOfObject:clickedcell];
    if (NSNotFound == clickedIndex)
    {
        return;
    }
    
    switch (clickedIndex)
    {
        case 0:
        {
            //问医生
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页-问医生"];
//            if (![self userHasService])
            if (![UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Conversation])
            {
                [self showAlertMessage:@"您还没有购买服务。"];
                //[self showAlertWithoutServiceMessage];
                return;
            }
            if ([self.delegate respondsToSelector:@selector(MainStartServiceTableViewCellDelegateCallBack_askDoctorClick)]) {
                [self.delegate MainStartServiceTableViewCellDelegateCallBack_askDoctorClick];
            }
            
        }
            break;
        case 1:
        {
            //约专家
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页-约专家"];
            if (![UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Appoint])
            {
                [self showAlertMessage:@"您还没有购买服务。"];
                //[self showAlertWithoutServiceMessage];
                return;
            }
            
            if (![UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Appoint])
            {
                //没有约诊权限
                [self showAlertWithoutServiceMessage];
                return;
            }
            
            //
            [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentStartViewController" ControllerObject:nil];
        }
            break;
        case 2:
        {
            //健康档案
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页-健康档案"];
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthDocutmentStartViewController" ControllerObject:nil];
        }
            break;
        case 3:
        {
            //健康报告
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页-健康报告"];
            if (![self userHasService])
            {
                [self showAlertMessage:@"您还没有购买服务。"];
                //[self showAlertWithoutServiceMessage];
                return;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportListStartViewController" ControllerObject:nil];
        }
            break;
        default:
            break;
    }
}

- (BOOL) userHasService
{
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService) {
        return YES;
    }
    return NO;
}


@end
