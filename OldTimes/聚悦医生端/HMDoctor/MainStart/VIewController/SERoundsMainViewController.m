//
//  SERoundsMainViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SERoundsMainViewController.h"
#import "JWSegmentView.h"
#import "SERoundsMainTableViewCell.h"
#import "JWDatePickerView.h"
#import "RoundsMessionModel.h"
#import "SERoundsSearchViewController.h"
#import "HMBaseNavigationViewController.h"
#import "RoundsDetailViewController.h"

#define SEGMENTVIEWHEIGHT  40
#define DATEPICKERHEIGHT   230
#define PAGESIZE           20

@interface SERoundsMainViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UILabel *navTitelLb;
@property (nonatomic, copy) NSDate *selectedDate;
@property (nonatomic, strong) JWDatePickerView *datePicker;
@property (nonatomic, strong) JWSegmentView *segmentView;
@property (nonatomic, strong) UILabel *headLb;
@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic, copy) NSArray *titelArr;
@end

@implementation SERoundsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titelArr = @[@"有症状",@"无症状",@"待反馈"];
    self.pageNum = 1;
    self.selectedSegmentIndex = 0;
    self.selectedDate = [NSDate date];
    
    UIView *titelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 25)];
    [titelView setUserInteractionEnabled:YES];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_time"]];
    [titelView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(titelView);
        make.width.height.equalTo(@20);
    }];
    
    [titelView addSubview:self.navTitelLb];
    [self.navTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titelView);
        make.left.equalTo(image.mas_right).offset(6);
        make.right.equalTo(titelView);
    }];
    
    
    [self.navigationItem setTitleView:titelView];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1) cornerRadius:0]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(SEGMENTVIEWHEIGHT);
    }];
    
    [self.view addSubview:self.datePicker];
    [self.view addSubview:self.segmentView];
    
    [self.datePicker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, DATEPICKERHEIGHT)];
    
    [self startGetRoundsListRequest];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // Do any additional setup after loading the view.
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    [self hideDatePicker];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

- (void)hideDatePicker {
    [UIView animateWithDuration:0.2 animations:^{
        [self.datePicker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, DATEPICKERHEIGHT)];
    }];
}

- (void)startGetRoundsListRequest {
    /*
     `sendTime`: 发送日期 格式 {@code yyyy-MM-dd} ISO_8601_EXTENDED_DATE_FORMAT
     `recordStatus`: app界面的 0 有症状 1 无症状 2 待反馈
     */
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@(self.pageNum) forKey:@"pageNum"];
    [dicPost setValue:@(PAGESIZE) forKey:@"pageSize"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    
    [dicPost setValue:[self.selectedDate formattedDateWithFormat:@"yyyy-MM-dd"] forKey:@"sendTime"];
    [dicPost setValue:@(self.selectedSegmentIndex) forKey:@"recordStatus"];
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"SEGetRoundsListRequest" taskParam:dicPost TaskObserver:self];

}

#pragma mark - event Response
- (void)rightClick {
    SERoundsSearchViewController *resultVC = [SERoundsSearchViewController new];

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVC];
    [self presentViewController:nav animated:YES completion:nil];
    [self.view endEditing:YES];
    
    [self hideDatePicker];
}

- (void)selectDateClick {
    if (self.datePicker.frame.origin.y < self.view.frame.size.height) {
        [self hideDatePicker];
    }
    else {
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.2 animations:^{
            [self.datePicker setFrame:CGRectMake(0, self.view.frame.size.height - DATEPICKERHEIGHT, self.view.frame.size.width, DATEPICKERHEIGHT)];
            
        }];
        
    }

}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无内容" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"i"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (!self.dataList ||self.dataList.count == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.selectedSegmentIndex == 2 ? 80 : 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SERoundsMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SERoundsMainTableViewCell at_identifier]];
    [cell fillDateWithModel:self.dataList[indexPath.row] isShowStatusLb:self.selectedSegmentIndex == 2];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideDatePicker];

    RoundsMessionModel* mession = self.dataList[indexPath.row];
    if ([mession.status isEqualToString:@"N"]) {
        // 待反馈
        [self at_postError:@"用户未反馈"];
    }
    else if ([mession.status isEqualToString:@"0"]) {
        // 未填写
        //待查房，不能查看
        BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeRoundsMode Status:0 OperateCode:kPrivilegeEditOperate];
        if (editPrivilege)
        {
            //跳转到填写查房表界面
            RoundsDetailViewController *VC = [[RoundsDetailViewController alloc] initWithModel:mession isFilled:NO];
            __weak typeof(self) weakSelf = self;
            [VC fillFinish:^{
                weakSelf.pageNum = 1;
                [weakSelf.dataList removeAllObjects];
                [weakSelf.tableView.mj_footer resetNoMoreData];
                [weakSelf startGetRoundsListRequest];
            }];
            
            [self.navigationController pushViewController:VC animated:YES];
        }

    }
    else if ([mession.status isEqualToString:@"1"]) {
        // 已填写
        //已填写,跳转到查房详情页面
        RoundsDetailViewController *VC = [[RoundsDetailViewController alloc] initWithModel:mession isFilled:YES];
        [self.navigationController pushViewController:VC animated:YES];

    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideDatePicker];
}

#pragma mark - request Delegate
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    
    if (taskError != StepError_None) {
        [self at_hideLoading];

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
    [self at_hideLoading];

    if ([taskname isEqualToString:@"SEGetRoundsListRequest"])
    {
        if (!taskResult || ![taskResult isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        NSNumber* numCount = [dicResult valueForKey:@"count"];
        NSArray* list = [dicResult valueForKey:@"list"];
        
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            if (numCount.integerValue > 0) {
                NSString *temp = self.titelArr[self.selectedSegmentIndex];
                [self.headLb setText:[NSString stringWithFormat:@"共有%ld人%@",(long)numCount.integerValue,temp]];
            }
            else {
                [self.headLb setText:@""];
            }
            
        }
        
        if (!list || ![list isKindOfClass:[NSArray class]])
        {
            return;
        }
        
        if (list.count) {
            if (self.pageNum < 2) {
                // 第一页
                [self.dataList removeAllObjects];
            }
            
            [self.dataList addObjectsFromArray:list];
            [self.tableView reloadData];
            
            if (self.pageNum >= 2 ) {
                // 分页加载滚到原地
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataList.count - list.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            else {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
            
            if (self.pageNum >= 2) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            self.pageNum ++;


        }
        else {
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }
}

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
        [_tableView registerClass:[SERoundsMainTableViewCell class] forCellReuseIdentifier:[SERoundsMainTableViewCell at_identifier]];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [headView addSubview:self.headLb];
        [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(15);
            make.centerY.equalTo(headView);
        }];
        [_tableView setTableHeaderView:headView];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(startGetRoundsListRequest)];

    }
    return _tableView;
}

- (UILabel *)navTitelLb {
    if (!_navTitelLb) {
        _navTitelLb = [UILabel new];
        [_navTitelLb setFont:[UIFont systemFontOfSize:19]];
        [_navTitelLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_navTitelLb setUserInteractionEnabled:YES];
        [_navTitelLb setText:[self.selectedDate formattedDateWithFormat:@"yyyy年MM月dd日"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDateClick)];
        [_navTitelLb addGestureRecognizer:tap];
    }
    return _navTitelLb;
}

- (JWDatePickerView *)datePicker {
    if (!_datePicker) {
        __weak typeof(self) weakSelf = self;
        _datePicker = [[JWDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, DATEPICKERHEIGHT) dateMode:UIDatePickerModeDate backColor:[UIColor whiteColor] maxDate:[NSDate date] block:^(NSInteger clickTag) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [self hideDatePicker];
            NSDate *pickerDate = [strongSelf.datePicker.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间

            if (clickTag && ![pickerDate isSameDay:strongSelf.selectedDate]) {
                strongSelf.selectedDate = pickerDate;
                NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
                [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
                NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
                [strongSelf.navTitelLb setText:dateString];
                
                strongSelf.pageNum = 1;
                [strongSelf.dataList removeAllObjects];
                [strongSelf.tableView.mj_footer resetNoMoreData];
                [strongSelf startGetRoundsListRequest];

                
            }
        }];
    }
    return _datePicker;
}

- (JWSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        _segmentView = [[JWSegmentView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, SEGMENTVIEWHEIGHT) titelArr:self.titelArr tagArr:@[@(0),@(1),@(2)] titelSelectedJWColor:[UIColor colorWithHexString:@"ffffff"] titelUnSelectedJWColor:[UIColor colorWithHexString:@"ffffff"] lineJWColor:[UIColor colorWithHexString:@"fffffff"] backJWColor:[UIColor mainThemeColor] lineWidth:(ScreenWidth / 3.0) block:^(NSInteger selectedTag) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf hideDatePicker];

            strongSelf.selectedSegmentIndex = selectedTag;
            strongSelf.pageNum = 1;
            [strongSelf.dataList removeAllObjects];
            [strongSelf.tableView.mj_footer resetNoMoreData];
            [strongSelf startGetRoundsListRequest];
            
        }];
    }
    return _segmentView;
}


- (UILabel *)headLb {
    if (!_headLb) {
        _headLb = [UILabel new];
        [_headLb setText:@"共3人有症状"];
        [_headLb setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_headLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _headLb;
}

- (UIView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    }
    return _toolBarView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
