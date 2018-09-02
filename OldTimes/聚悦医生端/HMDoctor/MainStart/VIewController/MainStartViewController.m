//
//  MainStartViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartViewController.h"
#import "MainStartStaffInfoView.h"
#import "MainStartConsoleView.h"
#import "MainStartTaskSwichView.h"

#import "MainStartMessionTableViewController.h"
#import "UserLoginViewController.h"

#import "MainStartOperateCollectionViewController.h"
#import "SiteMessageViewController.h"
#import "GetJKGWListRequest.h"
#import "ChatSingleViewController.h"
#import "JKGWModel.h"
#import "ATModuleInteractor+CoordinationInteractor.h"

#import "MainStartFuncViewController.h"
#import "GetMessageListCount.h"

#import "StartFuncInfo.h"

@interface MainStartViewController ()
<HMSwitchViewDelegate,TaskObserver>
{
    MainStartStaffInfoView* staffview;
    //MainStartConsoleView* consoleview;
    //MainStartTaskSwichView* switchview;
    UITableViewController* tvcMession;
    //MainStartMessionTableViewController* tvcMession;
    
//    MainStartOperateCollectionViewController* cvcOperation;
    MainStartFuncViewController* vcFuncs;
    
    UIImageView *navBarHairlineImageView;

    UIPageControl *pageControl;
    NSString* patientCount;
    NSArray *JKGWList;
    UIImageView *redImage;
    
    StartFuncInfoHelper* funcHelper;
    NSArray* startFuncItems;
    NSInteger showPageNum;
}
@end

@implementation MainStartViewController

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMessageListCountAction];
    
    [self createPageControl];
}

//在页面消失的时候就让出现
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (void)createPageControl
{
    funcHelper = [[StartFuncInfoHelper defaultHelper] init];
    startFuncItems = [funcHelper startFuncItems];
    if (!pageControl)
    {
        pageControl = [[UIPageControl alloc] init];
        [self.view addSubview:pageControl];
    }
    
    [self calculationOfPageNum];
    
    if (showPageNum > 1) {
        
        [pageControl setHidden:NO];
        pageControl.numberOfPages = showPageNum;
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [pageControl addTarget:self action:@selector(pageControlChange:) forControlEvents:UIControlEventValueChanged];
        
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(150*kScreenScale);
            make.size.mas_equalTo(CGSizeMake(50, 20));
        }];
        
    }else{
        
        [pageControl setHidden:YES];
    }
}

#pragma mark -计算scrollView显示几页
-(void)calculationOfPageNum
{
    if ((startFuncItems.count+1)%8 != 0)
    {
        showPageNum = (startFuncItems.count+1)/8+1;
    }else
    {
        showPageNum = (startFuncItems.count+1)/8;
    }
}

//找到导航条下面的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogined) name:kUserLoginSuccessNotificationName object:nil];
    
    //[self.view setHeight:self.view.height - 49];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithHexString:kHMContentViewBackgroundColor]];
    
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (curStaff)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"StaffPatientCountTask" taskParam:dicPost TaskObserver:self];
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetJKGWListRequest" taskParam:dicPost TaskObserver:self];
    
    staffview = [[MainStartStaffInfoView alloc]initWithFrame:CGRectMake(0, 0, 320 * kScreenScale, 25 * kScreenWidth)];
    [self.view addSubview:staffview];
    [staffview setBackgroundColor:[UIColor mainThemeColor]];
    [staffview setStaffInfo];
    
    vcFuncs = [[MainStartFuncViewController alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:vcFuncs];
    [self.view addSubview:vcFuncs.view];
    

    
//    UICollectionViewFlowLayout* fl = [[UICollectionViewFlowLayout alloc]init];
//    [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    cvcOperation = [[MainStartOperateCollectionViewController alloc]initWithCollectionViewLayout:fl];
//    [self addChildViewController:cvcOperation];
//    
//    [cvcOperation.collectionView setBackgroundColor:[UIColor mainThemeColor]];
//    [self.view addSubview:cvcOperation.collectionView];
//    [cvcOperation.collectionView setTop:staffview.bottom];
//    [cvcOperation.collectionView setShowsHorizontalScrollIndicator:NO];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collectionViewScroll) name:@"scroll" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collectionViewScroll) name:@"MainStartScroll" object:nil];
//    consoleview = [[MainStartConsoleView alloc]initWithFrame:CGRectMake(0, 0, 320, 96)];
//    [self.view addSubview:consoleview];

    
    [self subviewsLayout];
    
    UIImageView * rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_alert"]];
    [rightImage setUserInteractionEnabled:YES];
    redImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_redPoint"]];
    [redImage setUserInteractionEnabled:YES];
    [redImage setHidden:YES];
    [rightImage addSubview:redImage];
    
    [redImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImage.mas_right);
        make.centerY.equalTo(rightImage.mas_top);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navAlertButtonClicked:)];
    [rightImage addGestureRecognizer:tap];
    UIBarButtonItem* bbiAlert = [[UIBarButtonItem alloc] initWithCustomView:rightImage];
    [self.navigationItem setRightBarButtonItem:bbiAlert];
   
    
    UIBarButtonItem* bbiAssist = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_assist"] style:UIBarButtonItemStylePlain target:self action:@selector(navAssistButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:bbiAssist];
    
    [self createContentView:0];
}
- (void)getMessageListCountAction
{
    //暂时废弃根据接口判断红点状态，改用session
//    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    
//    [dict setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
//    /**
//     *  user_push_msg: 推送消息 XTXX：系统信息  YYGG: 医院公告 YZXX：医嘱消息
//     */
//    [dict setValue:@[@"user_push_msg",@"XTXX",@"YYGG",@"YZXX"] forKey:@"msgTypeCode"];
//
//    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetMessageListCount class]) taskParam:dict TaskObserver:self];
    
    //获取推送类型的session，根据未读数判断红点显示
    [[MessageManager share] querySessionDataWithUid:@"PUSH@SYS" completion:^(ContactDetailModel *model) {
        [redImage setHidden:!model._countUnread];
    }];
}
- (void)pageControlChange:(UIPageControl *)sender
{
    //[cvcOperation.collectionView setContentOffset:CGPointMake(sender.currentPage*kScreenWidth, 0) animated:YES];
}

- (void)collectionViewScroll
{
    UIScrollView* scrollview = (UIScrollView*)vcFuncs.view;
    NSInteger currentPage = scrollview.contentOffset.x/kScreenWidth;
    pageControl.currentPage = currentPage;
}


- (NSString*) contentClassname:(NSInteger) index
{
    NSString* classname = @"UITableViweController";
    switch (index) {
        case 0:
        {
            classname = @"MainStartMessionTableViewController";
        }
            break;
            case 1:
        {
            classname = @"MainStartAlertTableViewController";
        }
            break;
        default:
            break;
    }
    
    return classname;
}

- (void) createContentView:(NSInteger) index
{
    NSString* classname = [self contentClassname:index];
    if (tvcMession)
    {
        if ([NSStringFromClass([tvcMession class]) isEqualToString:classname])
        {
            return;
        }
        
        [tvcMession.view removeFromSuperview];
        [tvcMession removeFromParentViewController];
    }
    
    tvcMession = [[NSClassFromString(classname) alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcMession];
    [self.view addSubview:tvcMession.tableView];

    [tvcMession.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.width.equalTo(self.view.mas_width);
        make.top.equalTo(vcFuncs.view.mas_bottom);
        //make.size.mas_equalTo(CGSizeMake(320 * kScreenScale, self.view.height - switchview));
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-49);
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //同样的在界面出现时候开启隐藏
    navBarHairlineImageView.hidden = YES;
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper]currentStaffInfo];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", curStaff.staffName]];
    
    //获取监测预警总数
    //[self startLoadAlertCount];
}

- (void) startLoadAlertCount
{
    //创建任务，获取未处理的预警数量 UserAlertCountTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (curStaff)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAlertCountTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) subviewsLayout
{
    [staffview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(25 * kScreenScale);
        make.width.equalTo(self.view);
        //make.size.mas_equalTo(staffview.size);
    }];
    
    [vcFuncs.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(CGSizeMake(320 * kScreenScale, 144 * kScreenScale));
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(staffview.mas_bottom);
        make.height.mas_equalTo(145 * kScreenScale);
        //make.centerX.equalTo(self.view);
    }];
    
    
    //return;
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) userLogined
{
    NSLog(@"MainStartViewController::userLogined ... ");

}

- (void) navAlertButtonClicked:(id) sender
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－站内信"];
    NSLog(@"点击站内信了");
    SiteMessageViewController *VC = [[SiteMessageViewController alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

//医学顾问
- (void) navAssistButtonClicked:(id) sender
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－我的顾问"];
    JKGWModel *model = [JKGWModel new];
    if (JKGWList.count > 0) {
        model = JKGWList.firstObject;
    }
    ContactDetailModel *tempModel = [[ContactDetailModel alloc]init];
    tempModel._target = [NSString stringWithFormat:@"%ld",model.USER_ID];
    tempModel._nickName = model.STAFF_NAME;
    [[ATModuleInteractor sharedInstance] goToJKGWChhatVC:tempModel list:JKGWList];
    
    NSLog(@"点击左上角头像了");
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex
{
    [self createContentView:selectedIndex];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (StepError_None != taskError)
    {
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
    
    if ([taskname isEqualToString:@"StaffPatientCountTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSNumber class]])
        {
            patientCount = [NSString stringWithFormat:@"%@",taskResult];
            
            [staffview setStaffPatientCount:patientCount];
        }

    }
    else if ([taskname isEqualToString:@"GetJKGWListRequest"]) {
        //健康顾问列表
        JKGWList = [NSArray new];
        JKGWList = (NSArray *)taskResult;
    }
    else if ([taskname isEqualToString:@"GetMessageListCount"]) {
        //站内信未读条数
        [redImage setHidden:![[(NSDictionary *)taskResult objectForKey:@"wdcount"] integerValue]];
    }
    
}

@end
