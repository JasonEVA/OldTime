//
//  PrescribeDosageUnitSelectViewControl.m
//  HMDoctor
//
//  Created by lkl on 16/6/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeDosageUnitSelectViewControl.h"


@interface PrescribeDosageUnitSelectViewControl ()<TaskObserver,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView* prescribeDrugsUsageTableView;

}
@property (nonatomic, strong) NSMutableArray *drugUnitList;
@end

@implementation PrescribeDosageUnitSelectViewControl

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIControl* closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    if (self.drugId)
    {
        [dicPost setValue:_drugId forKey:@"drugId"];
    }
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"DrugUnitListTask" taskParam:dicPost TaskObserver:self];
}

+ (PrescribeDosageUnitSelectViewControl*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                                    drugId:(NSString *)drugId
                                                           cellLocationY:(float)locationY
                                                           cellLocationX:(float)locationX
                                                             selectblock:(DosageUnitSelectBlock)block;
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    PrescribeDosageUnitSelectViewControl* vcPrescribeDrugsUsage = [[PrescribeDosageUnitSelectViewControl alloc]initWithNibName:nil bundle:nil];
    //vcPrescribeDrugsUsage.dosageUnitItem = item;
    vcPrescribeDrugsUsage.drugId = drugId;
    vcPrescribeDrugsUsage.tableViewLocationX = locationX;
    vcPrescribeDrugsUsage.tableViewLocationY = locationY;
    [parentviewcontroller addChildViewController:vcPrescribeDrugsUsage];
    [vcPrescribeDrugsUsage.view setFrame:parentviewcontroller.view.bounds];
    [parentviewcontroller.view addSubview:vcPrescribeDrugsUsage.view];
    
    [vcPrescribeDrugsUsage setSelectblock:block];
    
    return vcPrescribeDrugsUsage;
}


- (void) closeControlClicked:(id) sender
{
    if (_selectblock)
    {
        _selectblock(nil);
    }
    [self closeTestTimeView];
}

- (void) closeTestTimeView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dosageUnitItem)
    {
        return _dosageUnitItem.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell setBackgroundColor:[UIColor commonBackgroundColor]];
    }
    
    [cell.textLabel setText:[_dosageUnitItem objectAtIndex:indexPath.row]];

    return cell;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dosageUnitStr = [_dosageUnitItem objectAtIndex:indexPath.row];

    if (_selectblock)
    {
        _selectblock(dosageUnitStr);
    }
    
    [self closeTestTimeView];
    
}
- (void) createPrescribeDrugsUsageTableView
{
    if (!_dosageUnitItem)
    {
        return;
    }
    float tableheight = _dosageUnitItem.count * 44;
    if (tableheight > self.view.height - 50)
    {
        tableheight = self.view.height- 50;
    }
    
    prescribeDrugsUsageTableView = [[UITableView alloc]init];
    [self.view addSubview:prescribeDrugsUsageTableView];
    [prescribeDrugsUsageTableView setDataSource:self];
    [prescribeDrugsUsageTableView setDelegate:self];
    [prescribeDrugsUsageTableView.layer setCornerRadius:5.0f];
    [prescribeDrugsUsageTableView.layer setMasksToBounds:YES];
    
    [prescribeDrugsUsageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_tableViewLocationX);
        make.top.equalTo(self.view).with.offset(_tableViewLocationY);
        make.size.mas_equalTo(CGSizeMake(141*kScreenScale, tableheight));
    }];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
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
    
    if ([taskname isEqualToString:@"DrugUnitListTask"])
    {
        _dosageUnitItem = [[NSArray alloc] init];
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            _dosageUnitItem = taskResult;
            [self createPrescribeDrugsUsageTableView];
        }
    }
}


@end
