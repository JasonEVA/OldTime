//
//  PatientTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientTableViewController.h"
#import "PatientListTableViewCell.h"
#import "SingleChartViewController.h"
#import "ATModuleInteractor+PatientChat.h"

@interface PatientGroupHeaderView : UIControl
{
    UIImageView* ivArrow;
    UILabel* lbGroupname;
    UILabel *countLb;
    
}

- (void) setGroupName:(NSString*) name;
- (void) setIsExpanded:(BOOL) isExpanded;
- (void)fillCount:(NSString *)count;

@end

@implementation PatientGroupHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c_grayArrow"]];
        [self addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(@10);
            make.height.mas_equalTo(@10);
        }];
        
        countLb = [[UILabel alloc] init];
        [self addSubview:countLb];
        [countLb setFont:[UIFont systemFontOfSize:15]];
        [countLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        
        [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
        }];
        
        lbGroupname = [[UILabel alloc]init];
        [self addSubview:lbGroupname];
        [lbGroupname setFont:[UIFont systemFontOfSize:15]];
        [lbGroupname setTextColor:[UIColor commonTextColor]];
        
        [lbGroupname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(ivArrow.mas_right).with.offset(7.5);
            make.right.lessThanOrEqualTo(countLb.mas_left).offset(-10);
        }];
        

    }
    return self;
}

- (void) setGroupName:(NSString*) name
{
    [lbGroupname setText:name];
}

- (void)fillCount:(NSString *)count {
    [countLb setText:count];
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

@interface PatientTableViewController ()
<TaskObserver>
{
   
    
}
@end

@implementation PatientTableViewController

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
    self.patientGroups = [NSArray arrayWithArray:groups];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PatientGroupHeaderView* headerview = [[PatientGroupHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 45)];

    
    PatientGroupInfo* group = self.patientGroups[section];
    [headerview setGroupName:group.teamName];
    [headerview fillCount:[NSString stringWithFormat:@"%ld",group.users.count]];
    [headerview setTag:0x410 + section];
    [headerview setIsExpanded:group.isExpanded];
    [headerview addTarget:self action:@selector(expendHeaderViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return headerview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.patientGroups)
    {
        return self.patientGroups.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PatientGroupInfo* group = self.patientGroups[section];
    if (!group.isExpanded)
    {
        return 0;
    }
    
    NSArray* patientItems = group.users;
    if (patientItems)
    {
        return patientItems.count;
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
    PatientGroupInfo* group = self.patientGroups[indexPath.section];
    
    NSArray* patientItems = group.users;
    [cell setPatientInfo:[patientItems objectAtIndex:indexPath.row]];
    return cell;
}

- (PatientInfo*) patientInfoWithIndex:(NSIndexPath *)indexPath
{
    PatientGroupInfo* group = self.patientGroups[indexPath.section];
    NSArray* patientItems = group.users;
    PatientInfo* patientInfo = [patientItems objectAtIndex:indexPath.row];
    return patientInfo;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientGroupInfo* group = self.patientGroups[indexPath.section];
    
    NSArray* patientItems = group.users;
    PatientInfo* patientInfo = [patientItems objectAtIndex:indexPath.row];
    switch (_intent)
    {
        case PatientTableIntent_None:
        {
            [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)patientInfo.userId]];
        }
            break;
        case PatientTableIntent_Survey:
        {
            //跳转到随访模版列表
            [HMViewControllerManager createViewControllerWithControllerName:@"SurveyMoudlesStartViewController" ControllerObject:patientInfo];
        }
            break;
        default:
            break;
    }
    
    
    
//    ContactDetailModel* patientContract = [[ContactDetailModel alloc]init];
//    PatientInfo* patientInfo = [patientItems objectAtIndex:indexPath.row];
//    [patientContract set_sqlId:patientInfo.userId];
//    [patientContract set_nickName:patientInfo.userName];
//    [patientContract set_target:patientInfo.userName];
//    
//    SingleChartViewController* vcSingleChart = [[SingleChartViewController alloc]initWithDetailModel:patientContract];
//    [self.navigationController pushViewController:vcSingleChart animated:YES];
}

#pragma mark - HeaderViewExpend
- (void) expendHeaderViewClicked:(id) sender
{
    if (![sender isKindOfClass:[PatientGroupHeaderView class]])
    {
        return;
    }
    PatientGroupHeaderView* headerview = (PatientGroupHeaderView*)sender;
    NSInteger section = (headerview.tag - 0x410);
    PatientGroupInfo* group = self.patientGroups[section];
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
            [groups enumerateObjectsUsingBlock:^(PatientGroupInfo *groupObj, NSUInteger idx, BOOL * _Nonnull stop) {
                [groupObj.users enumerateObjectsUsingBlock:^(PatientInfo *patientObj, NSUInteger idx, BOOL * _Nonnull stop) {
                    patientObj.teamId = groupObj.teamId;
                }];
            }];
            self.groupArr = [NSMutableArray arrayWithArray:groups];
            [self patientGroupLoaded:groups];
        }
    }
}
@end
