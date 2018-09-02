//
//  PrescribePatientsTableViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribePatientsTableViewController.h"
#import "PatientListTableViewCell.h"
#import "SingleChartViewController.h"

@interface PatientHeaderView : UIControl
{
    UIImageView* ivArrow;
    UILabel* lbGroupname;
    
}

- (void) setGroupName:(NSString*) name;
- (void) setIsExpanded:(BOOL) isExpanded;
@end

@implementation PatientHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self showBottomLine];
        
        //
        
        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c_grayArrow"]];
        [self addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(@10);
            make.height.mas_equalTo(@10);
        }];
        
        lbGroupname = [[UILabel alloc]init];
        [self addSubview:lbGroupname];
        [lbGroupname setFont:[UIFont systemFontOfSize:15]];
        [lbGroupname setTextColor:[UIColor commonTextColor]];
        
        [lbGroupname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(ivArrow.mas_right).with.offset(7.5);
        }];
    }
    return self;
}

- (void) setGroupName:(NSString*) name
{
    [lbGroupname setText:name];
}

- (void) setIsExpanded:(BOOL) isExpanded
{
    //icon_down_list_arrow
    [ivArrow setImage:[UIImage imageNamed:@"c_grayArrow"]];
    if (!isExpanded)
    {
        [ivArrow setImage:[UIImage imageNamed:@"r_grayArrow"]];
    }
}
@end


@interface PrescribePatientsTableViewController ()
<TaskObserver>
{
    NSArray* patientGroups;
    
}
@end

@implementation PrescribePatientsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSMutableDictionary* dictParam = [NSMutableDictionary dictionary];
    if (curStaff)
    {
        [dictParam setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"PatientListTask" taskParam:dictParam TaskObserver:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) patientGroupLoaded:(NSArray*) groups
{
    patientGroups = [NSArray arrayWithArray:groups];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PatientHeaderView* headerview = [[PatientHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 45)];
    
    PatientGroupInfo* group = patientGroups[section];
    [headerview setGroupName:group.teamName];
    [headerview setIsExpanded:group.isExpanded];
    [headerview setTag:section];
    [headerview addTarget:self action:@selector(expendHeaderViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    return headerview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    if (patientGroups)
    {
        return patientGroups.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    PatientGroupInfo* group = patientGroups[section];
    
    NSArray* patientItems = group.users;
    if (patientItems)
    {
        if (group.isExpanded) {
            return patientItems.count;
        }
        else {
            return 0;
        }
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [footerview setBackgroundColor:[UIColor commonControlBorderColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSString*) cellClassName
{
    NSString* classname = @"PatientListTableViewCell";
    return classname;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellClassName = [self cellClassName];
    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell)
    {
        cell = [[NSClassFromString(cellClassName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
    }
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    PatientGroupInfo* group = patientGroups[indexPath.section];
    
    NSArray* patientItems = group.users;
    [cell setPatientInfo:[patientItems objectAtIndex:indexPath.row]];
    return cell;
}

- (PatientInfo*) patientInfoWithIndex:(NSIndexPath *)indexPath
{
    PatientGroupInfo* group = patientGroups[indexPath.section];
    NSArray* patientItems = group.users;
    PatientInfo* patientInfo = [patientItems objectAtIndex:indexPath.row];
    return patientInfo;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientGroupInfo* group = patientGroups[indexPath.section];
    
    NSArray* patientItems = group.users;
    PatientInfo* patientInfo = [patientItems objectAtIndex:indexPath.row];
    switch (_intent)
    {
        case PatientTableIntent_None:
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"PrescribeStartViewController" ControllerObject:patientInfo];
        }
            break;

        default:
            break;
    }
}

#pragma mark - HeaderViewExpend
- (void) expendHeaderViewClicked:(id) sender
{
    if (![sender isKindOfClass:[PatientHeaderView class]])
    {
        return;
    }
    PatientHeaderView* headerview = (PatientHeaderView*)sender;
    NSInteger section = (headerview.tag);
    PatientGroupInfo* group = patientGroups[section];
    group.isExpanded = !group.isExpanded;
    [self.tableView reloadData];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
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
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"PatientListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* groups = (NSArray*) taskResult;
            [self patientGroupLoaded:groups];
        }
    }
}
@end
