//
//  HealthPlanMedicineCurrentRecipeTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/14.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanMedicineCurrentRecipeTableViewController.h"
#import "HealthPlanMedicineRecipeRecordTableViewCell.h"
@interface HealthPlanMedicineCurrentRecipeTableViewController ()
<TaskObserver>
{
    NSArray* drugList;
}

@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) HealthPlanDetailSectionModel* detailModel;

@end

@implementation HealthPlanMedicineCurrentRecipeTableViewController

- (id) initWithUserId:(NSString*) userId detailModel:(HealthPlanDetailSectionModel*) detailModel
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _userId = userId;
        _detailModel = detailModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadUserRecipeRecords];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadUserRecipeRecords
{
    //UserRecipeRecordsTask
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:self.userId forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserRecipeRecordsTask" taskParam:paramDictionary TaskObserver:self];
    
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (drugList) {
        return drugList.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthPlanMedicineRecipeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthPlanMedicineRecipeRecordTableViewCell" ];
    if (!cell) {
        cell = [[HealthPlanMedicineRecipeRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthPlanMedicineRecipeRecordTableViewCell"];
    }
    
    // Configure the cell...
    PrescribeTempInfo* drug = drugList[indexPath.row];
    
    [cell setDrugInfo:drug];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
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
    
    if ([taskname isEqualToString:@"UserRecipeRecordsTask"]) {
        [self.tableView reloadData];
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
    
    if ([taskname isEqualToString:@"UserRecipeRecordsTask"]) {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            drugList = taskResult;
        }
    }
}

@end
