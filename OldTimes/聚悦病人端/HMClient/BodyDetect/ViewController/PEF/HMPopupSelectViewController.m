//
//  HMPopupSelectViewController.m
//  HMClient
//
//  Created by lkl on 2017/6/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMPopupSelectViewController.h"
#import "BloodPressureThriceDetectModel.h"

@interface HMPopupSelectViewController ()<UITableViewDataSource,UITableViewDelegate,TaskObserver>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HMPopupSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    UIControl* closeControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void) closeControlClicked
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


+ (HMPopupSelectViewController *)createWithParentViewController:(UIViewController*) parentviewcontroller kpiCode:(NSString *)kpiCode dataList:(NSArray *)dataList selectblock:(PopupSelectBlock)block
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    
    HMPopupSelectViewController *selectVC = [[HMPopupSelectViewController alloc] initWithNibName:nil bundle:nil];
    [parentviewcontroller addChildViewController:selectVC];
    [selectVC.view setFrame:parentviewcontroller.view.bounds];
    [parentviewcontroller.view addSubview:selectVC.view];
    
    [selectVC setSelectblock:block];
    
    if (!kArrayIsEmpty(dataList)) {
        selectVC.dataList = dataList;
        [selectVC createTableView];
    }
    
//    if (!kStringIsEmpty(kpiCode)) {
//        //请求数据
//        [selectVC requestDataList:kpiCode];
//    }
    
    return selectVC;
}

//- (void)requestDataList:(NSString *)kpiCode
//{
//    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
//    [dicPost setValue:kpiCode forKey:@"kpiCode"];
//    
//    [self.view showWaitView];
//    //以前调用的接口 PostUserTestPeriodTask
//    [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureThriceDetectPeriodTask" taskParam:dicPost TaskObserver:self];
//}

- (void)createTableView
{
    if (_dataList.count == 0) {
        return;
    }
    
    float tableheight = _dataList.count * 45;
    if (tableheight > self.view.height - 50)
    {
        tableheight = self.view.height - 50;
    }
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(tableheight);
    }];
    
}

#pragma mark - tableViewDatasouceAndDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SelectTestDeviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont font_28]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"535353"]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    BloodPressureThriceDetectModel *model = _dataList[indexPath.row];
    [cell.textLabel setText:model.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectblock)
    {
        _selectblock(_dataList[indexPath.row]);
    }
    
    [self closeTestTimeView];
}


#pragma mark - Init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView.layer setCornerRadius:10.0f];
        [_tableView.layer setMasksToBounds:YES];
    }
    return _tableView;
}

#pragma mark - TaskObserver
//- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
//{
//    [self.view closeWaitView];
//    if (StepError_None != taskError)
//    {
//        [self showAlertMessage:errorMessage];
//        return;
//    }
//}
//
//- (void) task:(NSString *)taskId Result:(id) taskResult
//{
//    if (!taskId || 0 == taskId.length)
//    {
//        return;
//    }
//    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
//    if (!taskname || 0 == taskname.length)
//    {
//        return;
//    }
//    
//    if ([taskname isEqualToString:@"BloodPressureThriceDetectPeriodTask"])
//    {
//        if ([taskResult isKindOfClass:[NSArray class]]) {
//            _dataList = (NSArray *)taskResult;
//            [self createTableView];
//        }
//    }
//}

@end
