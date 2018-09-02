//
//  TeamDetailViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "TeamDetailViewController.h"
#import "TeamInfo.h"
#import "ServiceInfoTableViewCell.h"
#import "TeamStaffListView.h"

@interface TeamDetailTableViewController : UITableViewController
<TaskObserver>
{
    NSInteger descExpandStype;
   
}

@property (nonatomic, retain) TeamDetail* teamDetail;

- (id) initWithTeamDetail:(TeamDetail*) detail;
@end

@interface TeamDetailViewController ()
<TaskObserver>
{
    TeamInfo* teamInfo;
    UIView* navTitleView;
    TeamDetail* teamDetail;
    TeamStaffListView* staffsview;
    TeamDetailTableViewController* tvcDetail;
    
    UIButton* backButton;
    UIControl *attentionControl;
    UILabel *lbAttention;
    UIButton* moreServiceButton;
    
    UILabel* lbMainTitle;
    UILabel* lbSubTitle;
}
@property (nonatomic , assign) BOOL isFavor;

@end


@implementation TeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationItem setLeftBarButtonItem:nil];
    if (self.paramObject && [self.paramObject isKindOfClass:[TeamInfo class]])
    {
        teamInfo = (TeamInfo*) self.paramObject;
    }
    //[self loadTeamDetail];
    [self.navigationItem setHidesBackButton:YES];
    
    switch (teamInfo.teamControllerFlag)
    {
        case 0:
            
            break;
        case 1:
        {
            [self createMoreServiceButton];
        }
            break;
        default:
            break;
    }
    
    
    [self createTeamServiceTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO];
    UINavigationBar *bar = [self.navigationController navigationBar];
    CGFloat navBarHeight = 44.0f ;
    CGRect frame = CGRectMake(0.0f, 20.0f, 320.0f * kScreenScale, navBarHeight);
    [bar setFrame:frame];
    [navTitleView removeFromSuperview];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    CGFloat navBarHeight = 175;
    CGRect frame = CGRectMake(0.0f, 10, 320.0f * kScreenScale, navBarHeight);
    [bar setFrame:frame];
    navTitleView = [[UIView alloc]initWithFrame:frame];
    [bar addSubview:navTitleView];
    [navTitleView setBackgroundColor:[UIColor mainThemeColor]];
    
    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(4, 4, 44, 36)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [navTitleView addSubview:btnBack];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* titleview = [[UIView alloc]init];
    [navTitleView addSubview:titleview];
    [titleview setBackgroundColor:[UIColor clearColor]];
    [titleview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navTitleView).with.offset(40);
        make.right.equalTo(navTitleView).with.offset(-55);
        make.top.equalTo(navTitleView);
        make.height.mas_equalTo(44);
    }];
    
    lbMainTitle = [[UILabel alloc]init];
    [titleview addSubview:lbMainTitle];
    [lbMainTitle setFont:[UIFont font_30]];
    [lbMainTitle setTextColor:[UIColor whiteColor]];
    [lbMainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleview);
        make.top.equalTo(titleview).with.offset(6);
    }];
    
    [lbMainTitle setText:teamInfo.teamName];
    if (teamDetail)
    {
        [lbMainTitle setText:teamDetail.teamName];
    }
    
    lbSubTitle = [[UILabel alloc]init];
    [titleview addSubview:lbSubTitle];
    
    [lbSubTitle setFont:[UIFont systemFontOfSize:9]];
    [lbSubTitle setTextColor:[UIColor whiteColor]];
    
    [lbSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleview);
        make.top.equalTo(lbMainTitle.mas_bottom).with.offset(2.5);
    }];
    
    [lbSubTitle setText:teamInfo.orgName];
    if (teamDetail.orgName)
    {
        [lbSubTitle setText:teamDetail.orgName];
    }

    attentionControl = [[UIControl alloc] init];
    [navTitleView addSubview:attentionControl];
    [attentionControl addTarget:self action:@selector(attentionControlClick) forControlEvents:UIControlEventTouchUpInside];

    [attentionControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnBack.mas_top).with.offset(5);
        make.right.equalTo(navTitleView.mas_right).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(75, 20));
    }];
    
    lbAttention = [[UILabel alloc] init];
    [attentionControl addSubview:lbAttention];
    [lbAttention setText:@"关注"];
    [lbAttention setTextColor:[UIColor whiteColor]];
    [lbAttention setFont:[UIFont font_28]];
    
    [lbAttention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(attentionControl);
        make.right.equalTo(attentionControl.mas_right);
    }];
    
    UIButton* ivHeart = [UIButton buttonWithType:UIButtonTypeCustom];
    [attentionControl addSubview:ivHeart];
    [ivHeart setBackgroundImage:[UIImage imageNamed:@"icon_home_fans"] forState:UIControlStateNormal];
    ivHeart.userInteractionEnabled = NO;
    
    [ivHeart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbAttention.mas_left).with.offset(-2);
        make.centerY.equalTo(attentionControl);
        make.size.mas_equalTo(CGSizeMake(12, 11));
    }];
    
    staffsview = [[TeamStaffListView alloc]init];
    [navTitleView addSubview:staffsview];
    [staffsview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(navTitleView);
        make.top.equalTo(titleview.mas_bottom).with.offset(12);
        make.bottom.equalTo(navTitleView);
    }];
    
    if (!teamDetail)
    {
        [self loadTeamDetail];
    }
    else
    {
        //[staffsview setTeamStaffs:teamDetail.orgTeamDet TeamStaffId:teamDetail.teamStaffId];
        [self performSelector:@selector(setTeamStaffs) withObject:nil afterDelay:0.05];
    }
    
    [self checkTeamAttention];
}


- (void)checkTeamAttention
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    
    [dicPost setValue:@"3" forKey:@"type"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", teamInfo.teamId] forKey:@"objectId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"checkUserFavorTask" taskParam:dicPost TaskObserver:self];
}

- (void)attentionControlClick
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    
    _isFavor = !_isFavor;
    if (_isFavor){
        
        [lbAttention setText:@"取消关注"];
        [dicPost setValue:@"Y" forKey:@"isFavor"];
    }
    else{
        
        [lbAttention setText:@"关注"];
        [dicPost setValue:@"N" forKey:@"isFavor"];
    }
    
    [dicPost setValue:@"3" forKey:@"type"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", teamInfo.teamId] forKey:@"objectId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"addUserFavorTask" taskParam:dicPost TaskObserver:self];
}

- (void) setTeamStaffs
{
    [staffsview setTeamStaffs:teamDetail.orgTeamDet TeamStaffId:teamDetail.teamStaffId];
}

- (void) onBackClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) createMoreServiceButton
{
    moreServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:moreServiceButton];
    
    [moreServiceButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [moreServiceButton setTitle:@"更多医生团队" forState:UIControlStateNormal];
    [moreServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreServiceButton.titleLabel setFont:[UIFont font_30]];
    
    [moreServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    
    [moreServiceButton addTarget:self action:@selector(moreServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) createTeamServiceTable
{
    if (tvcDetail)
    {
        return;
    }
    tvcDetail = [[TeamDetailTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcDetail];
    [self.view addSubview:tvcDetail.tableView];
    
    MASViewAttribute* tableBottom = self.view.mas_bottom;
    if (moreServiceButton){
        tableBottom = moreServiceButton.mas_top;
    }
    [tvcDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(tableBottom);
        make.top.equalTo(self.view).with.offset(140);
    }];

}

- (void) loadTeamDetail
{
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", teamInfo.teamId] forKey:@"teamId"];
    //TeamListTask
    [self.view showWaitView];
    
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"TeamDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void) moreServiceButtonClicked:(id) sender
{
    //跳转到服务分类界面
    [HMViewControllerManager createViewControllerWithControllerName:@"DoctorTeamListStartViewController" ControllerObject:nil];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
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
    
    if (!taskname || 0 == taskname)
    {
        return;
    }

    if ([taskname isEqualToString:@"TeamDetailTask"])
    {
        [tvcDetail setTeamDetail:teamDetail];
        [staffsview setTeamStaffs:teamDetail.orgTeamDet TeamStaffId:teamDetail.teamStaffId];
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    
    if (!taskname || 0 == taskname)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"TeamDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[TeamDetail class]])
        {
            teamDetail = (TeamDetail*)taskResult;
            if (lbMainTitle) {
                [lbMainTitle setText:teamDetail.teamName];
            }
            if (lbSubTitle) {
                [lbSubTitle setText:teamDetail.orgName];
            }
        }
    }
    
    if ([taskname isEqualToString:@"addUserFavorTask"])
    {
       
    }
    if ([taskname isEqualToString:@"checkUserFavorTask"])
    {
        NSString* attention = (NSString*)taskResult;
        if (attention.integerValue > 0)
        {
            [lbAttention setText:@"取消关注"];
            _isFavor = YES;
        }else
        {
            [lbAttention setText:@"关注"];
        }
    }

}

@end

typedef enum : NSUInteger {
    TeamDetail_DescSection,
    TeamDetail_ServiceSection,
    TeamDetailTableSectionCount,
} TeamDetailTableSection;

#import "TeamDetailDescTableViewCell.h"

@implementation TeamDetailTableViewController

- (id) initWithTeamDetail:(TeamDetail*)detail
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _teamDetail = detail;
        
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) setTeamDetail:(TeamDetail *)teamDetail
{
    _teamDetail = teamDetail;
    [self.tableView reloadData];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return TeamDetailTableSectionCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case TeamDetail_DescSection:
        {
            if (_teamDetail)
            {
                return 1;
            }
        }
            break;
        case TeamDetail_ServiceSection:
        {
            if (_teamDetail && _teamDetail.services)
            {
                return _teamDetail.services.count;
            }
        }
        default:
            break;
    }
    return 0;
}



- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
    [headreview setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* ivIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_list_line"]];
    [headreview addSubview:ivIcon];
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headreview);
        make.centerY.equalTo(headreview);
        make.size.mas_equalTo(CGSizeMake(2, 14));
    }];
    
    UILabel* lbName = [[UILabel alloc]init];
    [lbName setFont:[UIFont font_30]];
    [lbName setTextColor:[UIColor mainThemeColor]];
    [headreview addSubview:lbName];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(8);
        make.centerY.equalTo(headreview);
    }];
    
    switch (section)
    {
        case TeamDetail_DescSection:
            [lbName setText:@"团队介绍"];
            break;
        case TeamDetail_ServiceSection:
            [lbName setText:@"提供的服务"];
            break;
        default:
            break;
    }
    [headreview showBottomLine];
    
    return headreview;
}

- (CGFloat) footerHeight:(NSInteger) section
{
    switch (section)
    {
        case TeamDetail_DescSection:
            return 5;
        break;
    }
    return 0.5;

}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerHeight:section];
   
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, [self footerHeight:section])];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case TeamDetail_DescSection:
        {
            if (2 == descExpandStype) {
                return [self teamDescMaxHeight];
            }
            return [self teamDescMinHeight];
        }
            break;
        case TeamDetail_ServiceSection:
        {
            return 155;
        }
            break;
        default:
            break;
    }
    return 90;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.section)
    {
        case TeamDetail_DescSection:
        {
            cell = [self teamDescCell];
        }
            break;
        case TeamDetail_ServiceSection:
        {
            cell = [self serviceCell:indexPath.row];
        }
        default:
            break;
    }
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TeamDetailViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UITableViewCell*) teamDescCell
{
    TeamDetailDescTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TeamDetailDescTableViewCell"];
    if (!cell)
    {
        cell = [[TeamDetailDescTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TeamDetailDescTableViewCell"];
        [cell.expendbutton addTarget:self action:@selector(descExpandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (0 == descExpandStype)
        {
            CGFloat maxDescHeight = [self teamDescMaxHeight];
            CGFloat minDescHeight = [self teamDescMinHeight];
            if (maxDescHeight == minDescHeight)
            {
                descExpandStype = 0;
            }
            else
            {
                if (2 != descExpandStype) {
                    descExpandStype = 1;
                }
                
            }
        }
    }
    
    [cell setTeamDesc:_teamDetail.teamDesc];
    [cell setExtendStyle:descExpandStype];
    
    return cell;
}



- (void) descExpandButtonClicked:(id) sender
{
    switch (descExpandStype)
    {
        case 0:
        {
            return;
        }
            break;
        case 1:
        {
            descExpandStype = 2;
        }
            break;
        case 2:
        {
            descExpandStype = 1;
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

- (UITableViewCell*) serviceCell:(NSInteger) row
{
    ServiceInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ServiceInfoTableViewCell" ];
    if (!cell)
    {
        cell = [[ServiceInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceInfoTableViewCell"];
    }
    // Configure the cell...
    ServiceInfo* service = _teamDetail.services[row];
    
    if (service.grade && service.grade > 0)
    {
        [cell setServiceInfo:service isGrade:YES];
    }else{
        [cell setServiceInfo:service isGrade:NO];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case TeamDetail_ServiceSection:
        {
            ServiceInfo* service = _teamDetail.services[indexPath.row];
            ServiceInfo* serviceInfo = [[ServiceInfo alloc]init];
            [serviceInfo setProductName:service.productName];
            [serviceInfo setClassify:service.classify];
            [serviceInfo setUpId:service.upId];
            if (![service isGoods]) {
                //服务详情
//                [HMViewControllerManager createViewControllerWithControllerName:@"ServiceDetailStartViewController" ControllerObject:serviceInfo];
                [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
                
            }
            else
            {
                //商品详情
//                [HMViewControllerManager createViewControllerWithControllerName:@"ServiceGoodsDetailStartViewController" ControllerObject:serviceInfo];
                [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
            }

        }
            break;
            
        default:
            break;
    }
    
}

- (CGFloat) teamDescMaxHeight
{
    CGFloat descHeight = [_teamDetail.teamDesc heightSystemFont:[UIFont font_24] width:(self.tableView.width - 25)] + 2;
    return descHeight + 11 + 26;
}

- (CGFloat) teamDescMinHeight
{
    CGFloat descHeight = [_teamDetail.teamDesc heightSystemFont:[UIFont font_24] width:(self.tableView.width - 25)] + 2;
    if (descHeight > 53)
    {
        descHeight = 53;
    }
    return descHeight + 11 + 26;
}

@end
