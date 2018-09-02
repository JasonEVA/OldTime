//
//  BillInfoViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BillInfoViewController.h"
#import "BillInfoTableViewCell.h"
#import "PlantformConfig.h"
#import "DeviceSelectTestTimeView.h"

#define kBillPageSize         20

typedef enum : NSInteger{
    BillInfoTotalMoneySection,
    BillInfoListSection,
    BillInfoConfirmSection,
    BillInfoSectionCount,
}BillInfoSection;

@interface BillInfoViewController ()
{
    BillInfoTableViewController *tvcBillInfo;
}

@end

@implementation BillInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"账单明细"];
    
    tvcBillInfo = [[BillInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcBillInfo];
    [self.view addSubview:tvcBillInfo.tableView];
    [tvcBillInfo.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@interface BillInfoTableViewController ()<TaskObserver>
{
    DeviceSelectTestTimeView *testTimeView;
    
    NSString *queryDate;
    
    NSString *priceSum;
    NSArray* billinfoList;
}
@end

@implementation BillInfoTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    queryDate = [formatter stringFromDate:[NSDate date]];
    
    [self setPostqueryDate];
}

- (void) setPostqueryDate
{
    //获取账单总金额
    NSMutableDictionary *dicTotalMoneyPost = [[NSMutableDictionary alloc] init];
    
    [dicTotalMoneyPost setValue:@"4" forKey:@"type"];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (curStaff)
    {
        NSArray *recordId = @[[NSString stringWithFormat:@"%ld",curStaff.staffId]];
        
        [dicTotalMoneyPost setValue:recordId forKey:@"recordIds"];
    }
    [dicTotalMoneyPost setValue:queryDate forKey:@"time"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"BillSumPriceTask" taskParam:dicTotalMoneyPost TaskObserver:self];
    
    
    //账单明细列表
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:@"4" forKey:@"type"];
    
    if (curStaff)
    {
        NSArray *recordId = @[[NSString stringWithFormat:@"%ld",curStaff.staffId]];
        
        [dicPost setValue:recordId forKey:@"recordIds"];
    }
    
    [dicPost setValue:queryDate forKey:@"time"];
    
    [dicPost setValue:[NSNumber numberWithLong:0] forKey:@"startRow"];
    
    NSInteger rows = kBillPageSize;
    [dicPost setValue:[NSNumber numberWithLong:rows] forKey:@"rows"];
    
    //[dicPost setValue:[NSString stringWithFormat:@"%ld",curStaff.staffId] forKey:@"divideRecordId"];
    
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"BillInfoPageListTask" taskParam:dicPost TaskObserver:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return BillInfoSectionCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case BillInfoTotalMoneySection:
        case BillInfoConfirmSection:
            return 1;
            break;
            
        case BillInfoListSection:
            return billinfoList.count;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case BillInfoTotalMoneySection:
        case BillInfoConfirmSection:
            return 45;
            break;
            
        case BillInfoListSection:
            return 60;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case BillInfoTotalMoneySection:
        case BillInfoListSection:
            return 15;
            break;
            
        case BillInfoConfirmSection:
            return 45;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case BillInfoTotalMoneySection:
            cell = [self setTotalBillCell];
            break;
            
        case BillInfoListSection:
            cell = [self setBillInfoListCell:indexPath];
            break;
            
        case BillInfoConfirmSection:
        {
            /*if (billinfoList.count <= 0) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setBackgroundColor:[UIColor commonBackgroundColor]];
                    [cell setSelected:NO];
                }
                
                return cell;
            }*/
            cell = [self setBillConfirmCell];
            
        }
            break;
            
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (BillConfirmTableViewCell*) setBillConfirmCell
{
    BillConfirmTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillConfirmTableViewCell"];
    if (!cell)
    {
        cell = [[BillConfirmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillConfirmTableViewCell"];
    }
    
    return cell;
}

- (TotalBillTableViewCell*) setTotalBillCell
{
    TotalBillTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalBillTableViewCell"];
    
    if (!cell)
    {
        cell = [[TotalBillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TotalBillTableViewCell"];
    }
    
    [cell setTime:queryDate];
    [cell setBillSum:priceSum];
    
    [cell.iconBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)selectTime:(TotalBillTableViewCell *)cell
{
    testTimeView = [[DeviceSelectTestTimeView alloc] init];
    [testTimeView setBackgroundColor:[UIColor mainThemeColor]];
    [self.view addSubview:testTimeView];
    [testTimeView setPickerMode:YES];
    
    __weak BillInfoTableViewController *weakSelf = self;
    //__weak NSString *weakQueryDate = queryDate;
    testTimeView.testTimeBlock = ^(NSString *testTime){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *inputDate = [formatter dateFromString:testTime];
        
        [formatter setDateFormat:@"yyyy-MM"];
        queryDate = [formatter stringFromDate:inputDate];
        
        [weakSelf setPostqueryDate];
    };
    
    [testTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.superview.mas_bottom).with.offset(-260);
        make.left.and.right.equalTo(self.tableView.superview);
        make.height.mas_equalTo(260);
    }];
}

- (BillInfoTableViewCell*) setBillInfoListCell:(NSIndexPath*)indexPath
{
    BillInfo *billinfo = [billinfoList objectAtIndex:indexPath.row];
    BillInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillInfoTableViewCell"];
    
    if (!cell)
    {
        cell = [[BillInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillInfoTableViewCell"];
    }
    [cell setBillInfoValue:billinfo];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case BillInfoListSection:
        {
            BillInfo *billinfo = [billinfoList objectAtIndex:indexPath.row];
            [HMViewControllerManager createViewControllerWithControllerName:@"BillDetailViewController" ControllerObject:billinfo];
        }
            break;
            
        case BillInfoConfirmSection:
        {
            //确定账单
            if (billinfoList.count <= 0)
            {
                [self.view showAlertMessage:@"本月还没有账单列表"];
                return;
            }
            
            NSMutableDictionary *dicTotalMoneyPost = [[NSMutableDictionary alloc] init];
            
            [dicTotalMoneyPost setValue:@"4" forKey:@"type"];
            StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];

            if (curStaff)
            {
                NSArray *recordIds = @[[NSString stringWithFormat:@"%ld",curStaff.staffId]];
                
                [dicTotalMoneyPost setValue:recordIds forKey:@"recordIds"];
            }

            [dicTotalMoneyPost setValue:queryDate forKey:@"time"];
            
            [[TaskManager shareInstance] createTaskWithTaskName:@"BillSubmitTask" taskParam:dicTotalMoneyPost TaskObserver:self];
        
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.superview closeWaitView];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    //总账单
    if ([taskname isEqualToString:@"BillSumPriceTask"])
    {
        priceSum = taskResult[@"price"];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    //账单明细
    if ([taskname isEqualToString:@"BillInfoPageListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            billinfoList = taskResult[@"list"];
        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    //账单确定
    if ([taskname isEqualToString:@"BillSubmitTask"])
    {
        //NSLog(@"%@",taskResult);
        [self.view showAlertMessage:@"账单已确认"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
