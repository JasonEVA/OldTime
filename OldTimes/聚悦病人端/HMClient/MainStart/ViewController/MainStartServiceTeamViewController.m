//
//  MainStartServiceTeamViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartServiceTeamViewController.h"
#import "MainStartTeamStaffCell.h"
#import "UserCareInfo.h"

@interface MainStartServiceTeamViewController ()
<TaskObserver>
{
    UIScrollView* stafflistView;
    
    UIView* dialogview;
    UIImageView* ivDialog;
    UILabel* lbMessage;
    NSArray* staffs;
    NSMutableArray* staffCells;
    
    UserCareInfo* userCareInfo;
    NSInteger teamStaffId;
    
    NSTimer* myTimer;
    NSArray* cares;
    NSInteger flag;
}

@property (nonatomic,strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic,strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@end

@implementation MainStartServiceTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor mainThemeColor]];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    
    //ServiceStaffTeamTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceStaffTeamTask" taskParam:nil TaskObserver:self];
    stafflistView = [[UIScrollView alloc]init];
    [self.view addSubview:stafflistView];
    [stafflistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@115);
    }];
    [stafflistView setPagingEnabled:YES];
    
    dialogview = [[UIView alloc]init];
    [self.view addSubview:dialogview];
    
    [dialogview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.top.equalTo(stafflistView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
    }];
    
    ivDialog = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainstart_bg_dialogue"]];
    [dialogview addSubview:ivDialog];
    [self addSwipeGestureRecognizer];
    
    [ivDialog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(dialogview);
        make.center.equalTo(dialogview);
    }];
    
    lbMessage = [[UILabel alloc]init];
    [lbMessage setNumberOfLines:2];
    [lbMessage setFont:[UIFont font_30]];
//    [lbMessage setTextColor:[UIColor colorWithHexString:@"009082"]];
    [lbMessage setTextColor:[UIColor blackColor]];
    [dialogview addSubview:lbMessage];
    
    [lbMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dialogview).with.offset(17);
        make.right.equalTo(dialogview).with.offset(-17);
        make.top.equalTo(dialogview).with.offset(15);
        make.bottom.lessThanOrEqualTo(dialogview).with.offset(-13);
    }];
    
    [lbMessage setText:@"您好！请按时监测和吃药哦。有问题随时联系我。"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //关闭定时器
    [myTimer setFireDate:[NSDate distantFuture]];
    //myTimer = nil;
    //[myTimer invalidate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //开启定时器
    [myTimer setFireDate:[NSDate distantPast]];
}

- (void)scrollTimer
{
    flag++;
    if (flag >= cares.count) {
        flag = 0;
    }
    
    userCareInfo = (UserCareInfo*) [cares objectAtIndex:flag];
    [lbMessage setText:userCareInfo.careCon];
}

//系统问候手动滑动
- (void)addSwipeGestureRecognizer
{
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [dialogview addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [dialogview addGestureRecognizer:self.rightSwipeGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self nextPage];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self previousPage];
    }
}

- (void)nextPage
{
    flag++;
    if (flag >= cares.count) {
        flag = cares.count-1;
    }

    userCareInfo = (UserCareInfo*) [cares objectAtIndex:flag];
    [lbMessage setText:userCareInfo.careCon];
}

- (void)previousPage
{
    flag--;
    if (flag <= 0) {
        flag = 0;
    }

    userCareInfo = (UserCareInfo*) [cares objectAtIndex:flag];
    [lbMessage setText:userCareInfo.careCon];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //SystemUserCareTask
    [[TaskManager shareInstance]createTaskWithTaskName:@"SystemUserCareTask" taskParam:nil TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) teamStaffItemLoaded:(NSArray*) items
{
    if (!items || 0 == items.count)
    {
        return;
    }
    NSMutableArray* staffItems = [NSMutableArray arrayWithArray:items];
    StaffInfo* teamLeaderStaff = nil;
    for (StaffInfo* staff in staffItems)
    {
        if (staff.staffId == teamStaffId)
        {
            teamLeaderStaff = staff;
            [staffItems removeObject:staff];
            break;
        }
    }
    if (teamLeaderStaff)
    {
        [staffItems insertObject:teamLeaderStaff atIndex:0];
    }
    
    staffs = [NSArray arrayWithArray:staffItems];
    
    NSArray* subviews = [stafflistView subviews];
    for (UIView* sub in subviews)
    {
        [sub removeFromSuperview];
    }
    staffCells = [NSMutableArray array];
    CGFloat cellWidth = stafflistView.width / 4;
    for (NSInteger index = 0; index < staffs.count; ++index)
    {
        MainStartTeamStaffCell* cell = [[MainStartTeamStaffCell alloc]initWithFrame:CGRectMake(cellWidth * index, 0, cellWidth, stafflistView.height)];
        [stafflistView addSubview:cell];
        StaffInfo* staff = [staffs objectAtIndex:index];
        [cell setStaffInfo:staff];
        [cell setIsTeamLeader:(teamStaffId == staff.staffId)];
        [staffCells addObject:cell];
        [cell addTarget:self action:@selector(staffCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [stafflistView setContentSize:CGSizeMake(cellWidth * staffs.count, stafflistView.height)];
}

- (void) staffCellClicked:(id) sender
{
    if (![sender isKindOfClass:[MainStartTeamStaffCell class]])
    {
        return;
    }
    MainStartTeamStaffCell* cell = (MainStartTeamStaffCell*) sender;
    NSInteger clickedIndex = [staffCells indexOfObject:cell];
    if (NSNotFound == clickedIndex)
    {
        return;
    }
    StaffInfo* staff = [staffs objectAtIndex:clickedIndex];
    //跳转到医生详情
    [HMViewControllerManager createViewControllerWithControllerName:@"StaffDetailViewController" ControllerObject:staff];
}

#pragma mark - TaskObserver
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"ServiceStaffTeamTask"])
    {
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"ServiceStaffTeamTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numTeamStaffId = [dicResult valueForKey:@"teamStaffId"];
            if (numTeamStaffId && [numTeamStaffId isKindOfClass:[NSNumber class]])
            {
                teamStaffId = numTeamStaffId.integerValue;
            }
            NSArray* items = [dicResult valueForKey:@"list"];
            if (items && [items isKindOfClass:[NSArray class]])
            {
                [self teamStaffItemLoaded:items];
            }
            
        }
        
    }
    
    if ([taskname isEqualToString:@"SystemUserCareTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            //TODO:首页系统关怀
            cares = (NSArray*) taskResult;
            userCareInfo = (UserCareInfo*) [cares firstObject];
            [lbMessage setText:userCareInfo.careCon];
            flag = 0;
        }
        
    }
}

@end
