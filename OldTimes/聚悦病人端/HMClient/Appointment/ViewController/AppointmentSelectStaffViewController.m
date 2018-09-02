//
//  AppointmentSelectStaffViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentSelectStaffViewController.h"
//#import "AppointmentSelectStaffCell.h"
#import "AppointmentSelectStaffTableViewCell.h"
#import "AppointStaffModel.h"

@interface AppointmentSelectStaffViewController ()
<TaskObserver,UITableViewDelegate,UITableViewDataSource>
{
    UIView* headerview;
    NSInteger teamStaffId;
    //UIScrollView* scrollview;
    
    NSArray* staffs;
    NSMutableArray* staffCells;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSArray *items;

@end

@implementation AppointmentSelectStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createHeaderView];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(headerview.mas_bottom);
        make.bottom.equalTo(self.view).with.offset(-5);
    }];
    /*scrollview = [[UIScrollView alloc]init];
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(headerview.mas_bottom);
        make.bottom.equalTo(self.view).with.offset(-5);
    }];*/
    
    UIView* sepview = [[UIView alloc]init];
    [self.view addSubview:sepview];
    [sepview setBackgroundColor:[UIColor commonBackgroundColor]];
    [sepview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(_tableView.mas_bottom);
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AppointmentStaffListTask" taskParam:nil TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createHeaderView
{
    headerview = [[UIView alloc]init];
    [self.view addSubview:headerview];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [headerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    [headerview showBottomLine];
    
    UIImageView* ivFlag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_list_line"]];
    [headerview addSubview:ivFlag];
    [ivFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerview);
        make.left.equalTo(headerview).with.offset(12.5);
        make.size.mas_equalTo(CGSizeMake(2, 14));
    }];
    
    UILabel* lbHeader = [[UILabel alloc]init];
    [headerview addSubview:lbHeader];
    [lbHeader setTextColor:[UIColor mainThemeColor]];
    [lbHeader setFont:[UIFont font_30]];
    [lbHeader setText:@"请选择您要预约的医生"];
    [lbHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerview);
        make.left.equalTo(ivFlag).with.offset(5);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppointStaffModel *staffModel = [_items objectAtIndex:indexPath.row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"AppointmentSelectStaffTableViewCell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    AppointmentSelectStaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AppointmentSelectStaffTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (staffModel.remainNum > 0) {
        [cell setIsSelected:(self.selectedStaff == staffModel)];
    }
    
    [cell setStaffInfo:staffModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppointStaffModel *staffModel = [_items objectAtIndex:indexPath.row];
    if (staffModel.remainNum == 0) {
        [self.view showAlertMessage:@"温馨提示：您要预约的医生没有约诊次数了，请重新选择！"];
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [formatter dateFromString:staffModel.endTime];
    if ([endDate compare:[NSDate date]] == NSOrderedAscending)
    {
        [self.view showAlertMessage:@"温馨提示：预约有效期已过，请重新选择！"];
        return;
    }
    
    AppointmentSelectStaffTableViewCell *cell = (AppointmentSelectStaffTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
//    _selectedStaff = [_items objectAtIndex:indexPath.row];
    [self setSelectedStaff:self.items[indexPath.row]];
    [cell setIsSelected:YES];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    AppointmentSelectStaffTableViewCell *cell = (AppointmentSelectStaffTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    [cell setIsSelected:NO];
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

/*- (void) teamStaffItemLoaded:(NSArray*) items
{
    if (!items || 0 == items.count)
    {
        return;
    }
//    NSMutableArray* staffItems = [NSMutableArray arrayWithArray:items];
//    StaffInfo* teamLeaderStaff = nil;
//    for (StaffInfo* staff in staffItems)
//    {
//        if (staff.staffId == teamStaffId)
//        {
//            teamLeaderStaff = staff;
//            [staffItems removeObject:staff];
//            break;
//        }
//    }
//    if (teamLeaderStaff)
//    {
//        [staffItems insertObject:teamLeaderStaff atIndex:0];
//    }
    
    staffs = [NSArray arrayWithArray:items];
    
    NSArray* subviews = [scrollview subviews];
    for (UIView* sub in subviews)
    {
        [sub removeFromSuperview];
    }
    staffCells = [NSMutableArray array];
    CGFloat cellWidth = kScreenWidth / 4;
    for (NSInteger index = 0; index < staffs.count; ++index)
    {
        AppointmentSelectStaffCell* cell = [[AppointmentSelectStaffCell alloc]initWithFrame:CGRectMake(cellWidth * index, 0, cellWidth, scrollview.height)];
        [scrollview addSubview:cell];
        AppointStaffModel* staff = [staffs objectAtIndex:index];
        [cell setStaffInfo:staff];
        [cell setIsTeamLeader:(teamStaffId == staff.staffId)];
        [staffCells addObject:cell];
        [cell addTarget:self action:@selector(staffCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [scrollview setContentSize:CGSizeMake(cellWidth * staffs.count, scrollview.height)];
}

- (void) staffCellClicked:(id) sender
{
    if (![sender isKindOfClass:[AppointmentSelectStaffCell class]])
    {
        return;
    }
    AppointmentSelectStaffCell* selCell = (AppointmentSelectStaffCell*) sender;
    NSInteger clickedIndex = [staffCells indexOfObject:selCell];
    if (NSNotFound == clickedIndex)
    {
        return;
    }
    
    for (AppointmentSelectStaffCell* cell in staffCells)
    {
        [cell setIsSelected:(cell == selCell)];
    }
    _selectedStaff = [staffs objectAtIndex:clickedIndex];
}*/

#pragma mark - TaskObserver
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (taskError != StepError_None) {
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"AppointmentStaffListTask"])
    {
        if (self.items.count == 1) {
            //只有一个医生，默认选择
            AppointStaffModel* appointStaff = [self.items firstObject];
            if (appointStaff.remainNum == 0) {
                //没有约诊次数
                return;
            }
            
            [self setSelectedStaff:[self.items firstObject]];
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            AppointmentSelectStaffTableViewCell* cell = (AppointmentSelectStaffTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell setIsSelected:YES];
        }
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"AppointmentStaffListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            _items = (NSArray*)taskResult;
            [self.tableView reloadData];
            
        }
        
    }
}

@end
