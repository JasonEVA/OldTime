//
//  ServiceNeedMessageViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceNeedMessageViewController.h"
#import "ServiceNeedMsg.h"
#import "ServiceNeedMsgTableViewCell.h"
#import "ServiceOrderConfrimTableViewController.h"
#import "ServiceOrder.h"
#import "ZJKDatePickerSheet.h"
#import "HMSecondEditionServiceOrderConfrimViewController.h"

@interface ServiceNeedMessageViewController ()
<TaskObserver>
{
    NSMutableArray* needMsgItems;
    
    UIView* noticeHeaderView;
    UILabel* lbNotice;
    UIView* seqview;
    
    ServiceOrder* serviceOrder;
    
    ServiceNeedMessageTableViewController* tvcNeedMsgs;
    UIButton* commitButton;
}
@end

@implementation ServiceNeedMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"服务必备信息"];
    if (self.paramObject && [self.paramObject isKindOfClass:[NSArray class]])
    {
        NSArray* lstDict = (NSArray*) self.paramObject;
        needMsgItems = [NSMutableArray array];
        for (NSDictionary* dic in lstDict)
        {
            ServiceNeedMsg* needMsg = [ServiceNeedMsg mj_objectWithKeyValues:dic];
            [needMsgItems addObject:needMsg];
        }
    }
    
    noticeHeaderView = [[UIView alloc]init];
    [self.view addSubview:noticeHeaderView];
    [noticeHeaderView setBackgroundColor:[UIColor whiteColor]];
    
    lbNotice = [[UILabel alloc]init];
    [lbNotice setTextColor:[UIColor commonRedColor]];
    [lbNotice setFont:[UIFont font_22]];
    [lbNotice setText:@"*请务必如实填写一下信息，以便制定您的服务内容"];
    [noticeHeaderView addSubview:lbNotice];
    
    seqview = [[UIView alloc]init];
    [self.view addSubview:seqview];
    [seqview setBackgroundColor:[UIColor commonBackgroundColor]];
    
    tvcNeedMsgs = [[ServiceNeedMessageTableViewController alloc]initWithNeedMsgItems:needMsgItems];
    [self addChildViewController:tvcNeedMsgs];
    [tvcNeedMsgs.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tvcNeedMsgs.tableView];
    
    commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:commitButton];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitle:@"保存" forState:UIControlStateNormal];
    [commitButton.titleLabel setFont:[UIFont font_30]];
    [commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [commitButton.layer setCornerRadius:2.5];
    [commitButton.layer setMasksToBounds:YES];
    
    [commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self subviewLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) subviewLayout
{
    [noticeHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    [lbNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(noticeHeaderView);
        make.left.equalTo(noticeHeaderView).with.offset(12.5);
    }];
    
    [seqview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(noticeHeaderView.mas_bottom);
        make.height.mas_equalTo(@5);
    }];
    
    [tvcNeedMsgs.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(seqview.mas_bottom);
        make.bottom.equalTo(commitButton.mas_top).with.offset(-30);
    }];
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        //make.top.equalTo(tvcNeedMsgs.tableView.mas_bottom).with.offset(30);
        make.height.mas_equalTo(@45);
        make.bottom.lessThanOrEqualTo(self.view);
    }];
}

- (void) commitButtonClicked:(id) sender
{
    NSArray* needMsgs = [tvcNeedMsgs makeNeedMsgItems];
    if (!needMsgs)
    {
        return;
    }
    
    if (0 == _serviceDetail.salePrice)
    {
        //免费服务，不需要跳转到订单确认页面
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSNumber numberWithInteger:_serviceDetail.UP_ID]  forKey:@"upId"];
        [dicPost setValue:@"SERVICE" forKey:@"orderTypeCode"];
        [dicPost setValue:@"IOS" forKey:@"sourceCode"];
        NSMutableArray* options = [NSMutableArray array];
        
        if (_serviceDetail.isMustYes)
        {
            for (ServiceDetailOption* option in _serviceDetail.isMustYes)
            {
                NSDictionary* dicOption = [option mj_keyValues];
                [options addObject:dicOption];
            }
        }
        if (_serviceDetail.selectMust)
        {
            for (ServiceDetailOption* option in _serviceDetail.selectMust)
            {
                NSDictionary* dicOption = [option mj_keyValues];
                [options addObject:dicOption];
            }
        }
        
        if (0 < options.count) {
            [dicPost setValue:options forKey:@"orderBusinessDets"];
        }
        
        NSMutableArray* needMsgDictItems = [NSMutableArray array];
        if (needMsgs)
        {
            for (ServiceNeedMsg* needMsg in needMsgs)
            {
                NSDictionary* dicMsg = [needMsg mj_keyValues];
                [needMsgDictItems addObject:dicMsg];
            }
        }
        if (0 < needMsgDictItems.count) {
            [dicPost setValue:needMsgDictItems forKey:@"needMsgData"];
        }
        
        [self.view showWaitView];
        //直接创建订单
        [[TaskManager shareInstance] createTaskWithTaskName:@"CreateServiceOrderTask" taskParam:dicPost TaskObserver:self];
        return;
    }
    
    //跳转到订单确认界面 ServiceOrderConfrimStartViewController
//    ServiceOrderConfrimStartViewController* vcOrderConfirm = (ServiceOrderConfrimStartViewController*)[HMViewControllerManager createViewControllerWithControllerName:@"ServiceOrderConfrimStartViewController" ControllerObject:nil];
//    [vcOrderConfirm setNeedMsgItems:needMsgs];
//    [vcOrderConfirm setServiceDetail:_serviceDetail];
//    
    HMSecondEditionServiceOrderConfrimViewController *VC = [[HMSecondEditionServiceOrderConfrimViewController alloc] initWithServiceDetail:_serviceDetail];
    [VC setNeedMsgItems:needMsgItems];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
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
    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[ServiceOrder class]])
        {
            serviceOrder = (ServiceOrder*) taskResult;
        }
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        if (serviceOrder)
        {
            //跳转到订单详情页面
            [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController"
                                                           FromControllerId:nil
                                                           ControllerObject:[NSString stringWithFormat:@"%ld", serviceOrder.orderId]];
        }
        
        //刷新用户服务
        [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
    }
}

@end

@interface ServiceNeedMessageTableViewController ()
<ZJKPickerSheetDelegate>
{
    NSArray* needMsgItems;
}
@end

@implementation ServiceNeedMessageTableViewController

- (id) initWithNeedMsgItems:(NSArray*) msgItems
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        needMsgItems = [NSArray arrayWithArray:msgItems];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
    
    CGFloat tablehegiht = self.tableView.height;
    CGFloat maxTableHeight = needMsgItems.count * 45;
    [self.tableView setScrollEnabled:(maxTableHeight > tablehegiht)];
    if (maxTableHeight > tablehegiht)
    {
        maxTableHeight = tablehegiht;
    }

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([NSNumber numberWithFloat:maxTableHeight]);
    }];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (needMsgItems)
    {
        return needMsgItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceNeedMsgTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceNeedMsgTableViewCell"];
    if (!cell)
    {
        cell = [[ServiceNeedMsgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceNeedMsgTableViewCell"];
    }
    
    ServiceNeedMsg* needMsg = needMsgItems[indexPath.row];
    [cell setServiceNeedMsg:needMsg];
   // [cell setSeparatorInset:UIEdgeInsetsZero];
    //[cell setIndentationWidth:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceNeedMsg* needMsg = needMsgItems[indexPath.row];
    if (3 == needMsg.msgItemDataType)
    {
        [self closeKeyboard];
        //弹出日期选择界面
        ZJKDatePickerSheet* datePicker = [[ZJKDatePickerSheet alloc]init];
        [datePicker setTag:0x200 + indexPath.row];
        [datePicker setDelegate:self];
        [datePicker show];
        
    }
    
}

- (void) closeKeyboard
{
    for (NSInteger index = 0; index < needMsgItems.count; ++index)
    {
        ServiceNeedMsgTableViewCell* cell = (ServiceNeedMsgTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [cell.tfValue resignFirstResponder];
    }
}

- (void) pickersheet:(id)sheet selectedResult:(NSString*) result
{
    ZJKDatePickerSheet* datePicker = (ZJKDatePickerSheet*) sheet;
    NSInteger row = datePicker.tag - 0x200;
    ServiceNeedMsgTableViewCell* cell = (ServiceNeedMsgTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
    [cell.tfValue setText:result];
}

- (NSArray*) makeNeedMsgItems
{
    for (NSInteger index = 0; index < needMsgItems.count; ++index)
    {
        ServiceNeedMsgTableViewCell* cell = (ServiceNeedMsgTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        ServiceNeedMsg* needMsg = needMsgItems[index];
        NSString* txt = cell.tfValue.text;
        if (needMsg.isRequired && (!txt || 0 == txt.length)) {
            [self showAlertMessage:[NSString stringWithFormat:@"请输入%@", needMsg.msgItemName]];
            return nil;
        }
        
        if (2 == needMsg.msgItemDataType && ![txt isPureFloat] && ![txt isPureInt])
        {
            [self showAlertMessage:[NSString stringWithFormat:@"%@输入不正确，必须为整数或小数", needMsg.msgItemName]];
            return nil;
        }
        
        [needMsg setMsgValue:txt];
    }
    
    return needMsgItems;
}
@end
