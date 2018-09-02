//
//  SEDoctorSiteMessageItemViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SEDoctorSiteMessageItemViewController.h"
#import "SiteMessageSecondEditionMainListModel.h"
#import "SESiteMessageNoticeTableViewCell.h"
#import "SEDoctorSiteMessageEnmu.h"
#import "HMNoticeWindowViewController.h"
#import "SESiteMessageNLineTableViewCell.h"
#import "NewSiteMessageSystemTableViewCell.h"
#import "PatientInfo.h"
#import "AppointmentInfo.h"

#define PAGECOUNT   10

@interface SEDoctorSiteMessageItemViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) SiteMessageSecondEditionMainListModel *model;
@property (nonatomic) long long lastTimeStamp;        //最后一条时间戳

@end

@implementation SEDoctorSiteMessageItemViewController

- (instancetype)initWithSiteType:(SiteMessageSecondEditionMainListModel *)model {
    if (self = [super init]) {
        self.title = model.typeName;
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self startMessageListRequest];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

- (void)startMessageListRequest {
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    [dicPost setValue:self.model.typeCode forKey:@"typeCode"];
    [dicPost setValue:@(PAGECOUNT) forKey:@"limit"];
    [dicPost setValue:@(self.lastTimeStamp) forKey:@"timeStamp"];
    
    [self at_postLoading];

    [[TaskManager shareInstance] createTaskWithTaskName:@"SESiteMessageGetMessageListWithTypeRequest" taskParam:dicPost TaskObserver:self];
    
}


- (void)scrollToBottomWithAnimated:(BOOL)animated {
    ATLog(@"站内信0.1s后滑动到底部");
    [self scrollToBottomIfNeed:YES animated:NO];
}


- (void)scrollToBottomIfNeed:(BOOL)isNeed animated:(BOOL)animated {
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows <= 0 || !isNeed) {
        return;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}
#pragma mark - event Response
- (void)rightClick {
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"还没有收到任何消息哦" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"b"];
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
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;

    SiteMessageSecondEditionType siteMessageType = [SEDoctorSiteMessageEnmu acquireMessageTypeWithString:self.model.typeCode];

    switch (siteMessageType) {
        case SiteMessageSecondEditionType_GG:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[SESiteMessageNoticeTableViewCell at_identifier]];
            [cell fillDataWithModel:self.dataList[indexPath.row]];
            return cell;

            break;
        }
        case SiteMessageSecondEditionType_YZ:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[SESiteMessageNLineTableViewCell at_identifier]];
            [cell fillAppointmentDataWithModel:self.dataList[indexPath.row]];
            return cell;
            break;
        }

        case SiteMessageSecondEditionType_YHRZ:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[SESiteMessageNLineTableViewCell at_identifier]];
            [cell fillServiceOrderDataWithModel:self.dataList[indexPath.row]];
            return cell;
            break;
        }
        case SiteMessageSecondEditionType_JKJH:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[SESiteMessageNLineTableViewCell at_identifier]];
            [cell fillHealthPlanDataWithModel:self.dataList[indexPath.row]];
            return cell;
            break;
        }

        case SiteMessageSecondEditionType_JDPG:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[SESiteMessageNLineTableViewCell at_identifier]];
            [cell fillEvaluationDataWithModel:self.dataList[indexPath.row]];
            return cell;
            break;
        }

        case SiteMessageSecondEditionType_JKBG:
        {
            
            break;
        }

        case SiteMessageSecondEditionType_YYJY:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[SESiteMessageNLineTableViewCell at_identifier]];
            [cell fillMedicineSuggestedDataWithModel:self.dataList[indexPath.row]];
            return cell;
            break;
        }

        case SiteMessageSecondEditionType_XTXX:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageSystemTableViewCell at_identifier]];
            [cell fillDataWithModel:self.dataList[indexPath.row]];
            return cell;
            break;
        }

        default:
            break;
    }
    
    //防止脏数据，默认以文本显示
    cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SiteMessageLastMsgModel *model = self.dataList[indexPath.row];
    
    SiteMessageSecondEditionType siteMessageType = [SEDoctorSiteMessageEnmu acquireMessageTypeWithString:model.typeCode];
    
    switch (siteMessageType) {
        case SiteMessageSecondEditionType_GG:
        {
            // 公告
            SESiteMessageNoticModel *tempModel  = [SESiteMessageNoticModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];

            HMNoticeWindowViewController *VC = [[HMNoticeWindowViewController alloc] initWithUrl:tempModel.notesUrl];
            [self presentViewController:VC animated:YES completion:nil];
            break;
        }
        case SiteMessageSecondEditionType_YZ:
        {
            SESiteMessageAppointmentModel *tempModel  = [SESiteMessageAppointmentModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];

            AppointmentInfo* appointment = [AppointmentInfo new];
            appointment.appointId = tempModel.appointId;
            appointment.status = tempModel.status;
            if (!appointment.appointId) {
                return;
            }
            if (1 == appointment.status)
            {
                [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
                return;
            }
            //判断是否存在约诊查看权限
            BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:appointment.status OperateCode:kPrivilegeViewOperate];
            if (!viewPrivilege)
            {
                //没有查看权限
                return;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];

            break;
        }
        case SiteMessageSecondEditionType_JKJH:
        {
            
            break;
        }
   
        case SiteMessageSecondEditionType_YHRZ:
        {
            
            break;
        }
            
        case SiteMessageSecondEditionType_JDPG:
        {
            
            break;
        }
            
        case SiteMessageSecondEditionType_JKBG:
        {
            
            break;
        }
            
        case SiteMessageSecondEditionType_YYJY:
        {
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreatePrescriptionMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
            if (!processPrivilege)
            {
                //没有发起问诊权限
                [self at_postError:@"您的账号没有此功能权限"];
                break;
            }
            SESiteMessageMedicineSuggestedModel *tempModel  = [SESiteMessageMedicineSuggestedModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];

            PatientInfo *model = [PatientInfo new];
            model.userId = tempModel.userId;
            model.userName = tempModel.userName;
            
            [HMViewControllerManager createViewControllerWithControllerName:@"PrescribeStartViewController" ControllerObject:model];
            break;
        }
            
        case SiteMessageSecondEditionType_XTXX:
        {
            
            break;
        }
            
        default:
            break;
    }

    
}

#pragma mark TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    
    if ([taskname isEqualToString:@"SESiteMessageGetMessageListWithTypeRequest"]) {
        [self.tableView.mj_header endRefreshing];
    }
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"SESiteMessageGetMessageListWithTypeRequest"]) {
        // 先翻转数组
        NSArray *temp = [[(NSArray *)taskResult reverseObjectEnumerator] allObjects];
        if (temp.count) {
            [self.tableView.mj_header endRefreshing];
            ;
            if (self.dataList.count) {
                // 增量添加数据
                NSMutableArray *tempMubArr = [NSMutableArray array];
                [tempMubArr addObjectsFromArray:temp];
                [tempMubArr addObjectsFromArray:self.dataList];
                self.dataList = tempMubArr;
            }
            else {
                // 首次拉倒数据
                [self.dataList addObjectsFromArray:temp];
            }
            [self.tableView reloadData];
            
            if (!self.lastTimeStamp) {
                // 首次拉 滚到最下面
                [self performSelector:@selector(scrollToBottomWithAnimated:) withObject:nil afterDelay:0.1];
            }
            else {
                // 分页加载 滚到拉取数量行 以保证页面平稳
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:temp.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            // 存下最后一条
            SiteMessageLastMsgModel *model = self.dataList.firstObject;
            self.lastTimeStamp = model.createTimestamp;
        }
        else {
            [self.tableView.mj_header endRefreshing];
            if (self.dataList.count) {
                [self at_postError:@"没有更多数据了"];
            }
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
        [_tableView setEstimatedRowHeight:90];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell at_identifier]];

        [_tableView registerClass:[SESiteMessageNLineTableViewCell class] forCellReuseIdentifier:[SESiteMessageNLineTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageSystemTableViewCell class] forCellReuseIdentifier:[NewSiteMessageSystemTableViewCell at_identifier]];

        [_tableView registerClass:[SESiteMessageNoticeTableViewCell class] forCellReuseIdentifier:[SESiteMessageNoticeTableViewCell at_identifier]];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(startMessageListRequest)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _tableView.mj_header = header;
        
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


@end

