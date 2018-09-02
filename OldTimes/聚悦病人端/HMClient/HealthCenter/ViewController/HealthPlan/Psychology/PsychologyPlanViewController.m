//
//  PsychologyPlanViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PsychologyPlanViewController.h"
#import "HealthPlanDateSelectView.h"
#import "PsychologyPlanTableViewController.h"

@interface PsychologyPlanStartViewController ()
{
    PsychologyPlanViewController* vcPlan;
}
@end

@implementation PsychologyPlanStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"记录心情"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    vcPlan = [[PsychologyPlanViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", user.userId]];
    [self addChildViewController:vcPlan];
    [self.view addSubview:vcPlan.view];
    [vcPlan.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

- (void)rightClick{
    //跳转到更多心情记录界面
    [HMViewControllerManager createViewControllerWithControllerName:@"UserMoodRecordsStartViewController" ControllerObject:nil];
}

@end

@interface PsychologyPlanViewController ()
{
    NSString* userId;
    PsychologyPlanTableViewController* tvcPsychology;
}
@end

@implementation PsychologyPlanViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        userId = aUserId;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self createPsychologyPlanTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createPsychologyPlanTable
{
    tvcPsychology = [[PsychologyPlanTableViewController alloc]initWithUserId:userId];
    [self addChildViewController:tvcPsychology];
    [self.view addSubview:tvcPsychology.tableView];
    [tvcPsychology.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
        //make.top.equalTo(dateSelectView.mas_bottom).with.offset(5);
    }];
    
    //[tvcSports setDate:dateSelectView.date];
}

@end
