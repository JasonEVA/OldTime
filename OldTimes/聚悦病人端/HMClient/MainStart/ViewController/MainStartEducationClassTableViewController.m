//
//  MainStartEducationClassTableViewController.m
//  HMClient
//
//  Created by yinquan on 17/1/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "MainStartEducationClassTableViewController.h"
#import "HealthEducationTableViewCell.h"
#import "InitializationHelper.h"
#import "OnlineCustomServiceModel.h"
#import "ChatSingleViewController.h"

static NSInteger kStartEducationClassPageSize = 3;

@interface MainStartEducationClassTableViewController ()
<TaskObserver, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    
}
@property (nonatomic, readonly) NSInteger columeId;
@property (nonatomic, readonly) NSArray* educationNotes;
@end

@implementation MainStartEducationClassTableViewController

- (id) initWithColumeId:(NSInteger) columeId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _columeId = columeId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self.tableView setBackgroundColor:[UIColor greenColor]];
    [self loadHealthEducationList];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadHealthEducationList];
}

- (void) loadHealthEducationList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kStartEducationClassPageSize] forKey:@"rows"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", self.columeId] forKey:@"classProgramTypeId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationListTask" taskParam:dicPost TaskObserver:self];
}

- (void) educationNotesLoaded:(NSArray*) models
{
    _educationNotes = [NSArray arrayWithArray:models];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_educationNotes)
    {
        return _educationNotes.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthEducationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthEducationTableViewCell"];
    if (!cell)
    {
        cell = [[HealthEducationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthEducationTableViewCell"];
    }
    // Configure the cell...
    HealthEducationItem* educationModel = self.educationNotes[indexPath.row];
    
    [cell setHealthEducationItem:educationModel];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthEducationItem* educationModel = self.educationNotes[indexPath.row];
    //跳转到宣教详情
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];
}

- (BOOL) userHasService
{
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService) {
        return YES;
    }
    return NO;
}

- (void) showNoneServiceView
{
    UIView* emptyView = [[UIView alloc] init];
    [emptyView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_none_service"]];
    [emptyView addSubview:emptyImageView];
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.size.mas_equalTo(CGSizeMake(40, 36));
        make.top.equalTo(emptyView);
    }];
    
    UILabel* emptyLable = [[UILabel alloc] init];
    [emptyView addSubview:emptyLable];
    [emptyLable setText:@"您当前没有订购相关服务哦"];
    [emptyLable setFont:[UIFont systemFontOfSize:15]];
    [emptyLable setTextColor:[UIColor commonGrayTextColor]];
    [emptyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.top.equalTo(emptyImageView.mas_bottom).with.offset(15);
        make.width.equalTo(emptyView);
    }];
    
    UIButton* emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emptyView addSubview:emptyButton];
    [emptyButton setTitle:@"购买服务" forState:UIControlStateNormal];
    [emptyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [emptyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [emptyButton setBackgroundImage:[UIImage rectImage:CGSizeMake(100, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [emptyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.size.mas_equalTo(CGSizeMake(102, 30));
        make.top.equalTo(emptyLable.mas_bottom).with.offset(15);
        make.bottom.equalTo(emptyView);
    }];
    
    emptyButton.layer.cornerRadius = 3;
    emptyButton.layer.masksToBounds = YES;
    
    [emptyButton addTarget:self action:@selector(loadOnlineCustomServiceList) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.top.equalTo(self.tableView).with.offset(109);
    }];
    [self.tableView setScrollEnabled:NO];
}

- (void)loadOnlineCustomServiceList {
//    [[TaskManager shareInstance] createTaskWithTaskName:@"GetOnlineCustomServiceTask" taskParam:nil TaskObserver:self];
    //跳转到商场首页－YinQ 2017-03-28
    
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
}


#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.columeId >= 0 || [self userHasService]) {
        return [UIImage imageNamed:@"img_blank_list"];
    }
    return nil;
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.educationNotes || self.educationNotes.count == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
//    return -self.tableView.tableHeaderView.frame.size.height/2.0f;
    return -28;
}

#pragma mark - TaskObserver

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView reloadData];
    if (![self userHasService] && (!self.educationNotes || self.educationNotes.count == 0) && self.columeId < 0) {
        [self showNoneServiceView];
    }
    [self.tableView setScrollEnabled:NO];
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
    
    if ([taskname isEqualToString:@"HealthEducationListTask"])
    {
        if (!taskResult || ![taskResult isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        
        NSArray* notes = [dicResult valueForKey:@"list"];

        [self educationNotesLoaded:notes];
    }
    
#if 0   
    //Delete By YinQ at 2017-03-28
    if ([taskname isEqualToString:@"GetOnlineCustomServiceTask"]) {
        // 在线客服
        if ([taskResult isKindOfClass:[NSArray class]]) {
            NSArray *result = taskResult;
            if (result.count == 0) {
                return;
            }
            OnlineCustomServiceModel *sourceModel = result.firstObject;
            ContactDetailModel *model = [ContactDetailModel new];
            model._target = [NSString stringWithFormat:@"%ld",sourceModel.userName];
            model._nickName = sourceModel.nickName;
            model._headPic = sourceModel.avatar;
            ChatSingleViewController *VC  = [[ChatSingleViewController alloc] initWithDetailModel:model];
            UINavigationController* nvc = (UINavigationController*)[HMViewControllerManager topMostController];
            [nvc pushViewController:VC animated:YES];
        }
    }
#endif
}
@end
