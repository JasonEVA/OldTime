//
//  StaffDetailDescViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "StaffDetailDescTableViewController.h"
#import "StaffDetailDescTableViewCell.h"
typedef enum : NSUInteger {
    Desc_GoodAtSection,
    Desc_SummarySection,
    Desc_SectionCount,
} StaffDescTableSection;

@interface StaffDetailDescTableViewController ()
<TaskObserver>
{
    NSInteger goodatExpandStype;
    NSInteger summaryExpandStype;
}
@end

@implementation StaffDetailDescTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //StaffDetailTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"StaffDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return Desc_SectionCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
    [headreview setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* ivIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_list_line"]];
    [headreview addSubview:ivIcon];
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headreview);
        make.centerY.equalTo(headreview);
        make.size.mas_equalTo(CGSizeMake(2, 14));
    }];
    
    UILabel* lbName = [[UILabel alloc]init];
    [lbName setFont:[UIFont font_30]];
    [lbName setTextColor:[UIColor mainThemeColor]];
    [headreview addSubview:lbName];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(8);
        make.centerY.equalTo(headreview);
    }];
    
    switch (section)
    {
        case Desc_GoodAtSection:
            [lbName setText:@"擅长"];
            break;
        case Desc_SummarySection:
            [lbName setText:@"简介"];
            break;
        default:
            break;
    }
    [headreview showBottomLine];
    
    return headreview;
}

- (CGFloat) footerHeight:(NSInteger) section
{
    return 5;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerHeight:section];
    
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, [self footerHeight:section])];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case Desc_GoodAtSection:
        {
            if (2 == goodatExpandStype) {
                return [self staffGoodAtMaxHeight];
            }
            return [self staffGoodAtMinHeight];
        }
            break;
        case Desc_SummarySection:
        {
            if (2 == summaryExpandStype) {
                return [self staffDescMaxHeight];
            }
            return [self staffDescMinHeight];
        }
            break;
        default:
            break;
    }
    return 100;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.section)
    {
        case Desc_GoodAtSection:
        {
            cell = [self staffGoodAtCell];
        }
            break;
        case Desc_SummarySection:
        {
            cell = [self staffSummaryCell];
        }
        default:
            break;
    }
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StaffDetailDescTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

}

- (UITableViewCell*) staffGoodAtCell
{
    StaffDetailDescTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"StaffDetailGoodAtTableViewCell"];
    if (!cell)
    {
        cell = [[StaffDetailDescTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StaffDetailGoodAtTableViewCell"];
        [cell.expendbutton addTarget:self action:@selector(goodatExpandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    if (0 == goodatExpandStype)
    {
        CGFloat maxDescHeight = [self staffGoodAtMaxHeight];
        CGFloat minDescHeight = [self staffGoodAtMinHeight];
        if (maxDescHeight == minDescHeight)
        {
            goodatExpandStype = 0;
        }
        else
        {
            if (2 != goodatExpandStype) {
                goodatExpandStype = 1;
            }
            
        }
    }
    [cell setStaffDesc:_staffdetail.gootAt];
    [cell setExtendStyle:goodatExpandStype];
    
    return cell;
}

- (UITableViewCell*) staffSummaryCell
{
    StaffDetailDescTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"StaffDetailDescTableViewCell"];
    if (!cell)
    {
        cell = [[StaffDetailDescTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StaffDetailDescTableViewCell"];
        [cell.expendbutton addTarget:self action:@selector(summaryExpandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    if (0 == summaryExpandStype)
    {
        CGFloat maxDescHeight = [self staffDescMaxHeight];
        CGFloat minDescHeight = [self staffDescMinHeight];
        if (maxDescHeight == minDescHeight)
        {
            summaryExpandStype = 0;
        }
        else
        {
            if (2 != summaryExpandStype) {
                summaryExpandStype = 1;
            }
            
        }
    }
    [cell setStaffDesc:_staffdetail.staffDesc];
    [cell setExtendStyle:summaryExpandStype];
    
    return cell;
}

- (void) goodatExpandButtonClicked:(id) sender
{
    switch (goodatExpandStype)
    {
        case 0:
        {
            return;
        }
            break;
        case 1:
        {
            goodatExpandStype = 2;
        }
            break;
        case 2:
        {
            goodatExpandStype = 1;
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void) summaryExpandButtonClicked:(id) sender
{
    switch (summaryExpandStype)
    {
        case 0:
        {
            return;
        }
            break;
        case 1:
        {
            summaryExpandStype = 2;
        }
            break;
        case 2:
        {
            summaryExpandStype = 1;
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (CGFloat) staffDescMaxHeight
{
    CGFloat descHeight = [_staffdetail.staffDesc heightSystemFont:[UIFont font_24] width:(self.tableView.width - 25)] + 2;
    return descHeight + 11 + 26;
}

- (CGFloat) staffDescMinHeight
{
    CGFloat descHeight = [_staffdetail.staffDesc heightSystemFont:[UIFont font_24] width:(self.tableView.width - 25)] + 2;
    if (descHeight > 53)
    {
        descHeight = 53;
    }
    return descHeight + 11 + 26;
}

- (CGFloat) staffGoodAtMaxHeight
{
    CGFloat descHeight = [_staffdetail.gootAt heightSystemFont:[UIFont font_24] width:(self.tableView.width - 25)] + 2;
    return descHeight + 11 + 26;
}

- (CGFloat) staffGoodAtMinHeight
{
    CGFloat descHeight = [_staffdetail.gootAt heightSystemFont:[UIFont font_24] width:(self.tableView.width - 25)] + 2;
    if (descHeight > 53)
    {
        descHeight = 53;
    }
    return descHeight + 11 + 26;
}

#pragma mark - TaskObserver

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    //[self.tableView.mj_footer endRefreshing];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    
    if (!taskname || 0 == taskname)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"StaffDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[StaffDetail class]])
        {
            [self setStaffdetail:(StaffDetail*) taskResult];
            [self.tableView reloadData];
        }
    }
}
@end
