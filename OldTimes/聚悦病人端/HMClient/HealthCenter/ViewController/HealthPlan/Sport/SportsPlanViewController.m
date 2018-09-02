//
//  SportsPlanViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SportsPlanViewController.h"
#import "HealthPlanDateSelectView.h"
#import "SportsPlanTableViewController.h"


@implementation SportsPlanStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"记录运动"];
    SportsPlanViewController* vcSports = [[SportsPlanViewController alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:vcSports];
    [self.view addSubview:vcSports.view];
    [vcSports.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

@end

@interface SportsPlanViewController ()
{
    HealthPlanDateSelectView* dateSelectView;
    UIButton* appendbutton;
    SportsPlanTableViewController* tvcSports;
}
@end

@implementation SportsPlanViewController

- (void) dealloc
{
    if (dateSelectView)
    {
        [dateSelectView removeObserver:self forKeyPath:@"date"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self createDateSelectView];
    appendbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:appendbutton];
    [appendbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    [appendbutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [appendbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appendbutton.titleLabel setFont:[UIFont font_30]];
    [appendbutton setTitle:@"记录运动" forState:UIControlStateNormal];
    //[appendbutton setImage:[UIImage imageNamed:@"btn_home_add"] forState:UIControlStateNormal];
    [appendbutton addTarget:self action:@selector(appendSportsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self createSportsPlanTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createDateSelectView
{
    dateSelectView = [[HealthPlanDateSelectView alloc]init];
    [self.view addSubview:dateSelectView];
    [dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(5);
        make.height.mas_equalTo(@40);
    }];
    [dateSelectView addObserver:self forKeyPath:@"date" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void) createSportsPlanTable
{
    tvcSports = [[SportsPlanTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcSports];
    [self.view addSubview:tvcSports.tableView];
    [tvcSports.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(appendbutton.mas_top);
        make.top.equalTo(dateSelectView.mas_bottom).with.offset(5);
    }];
    
    [tvcSports setDate:dateSelectView.date];
}

- (void) appendSportsButtonClicked:(id) sender
{
    //跳转记录运动界面
    [HMViewControllerManager createViewControllerWithControllerName:@"RecordSportsExecuteViewController" ControllerObject:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"date"])
    {
        NSDate* date = dateSelectView.date;
        if (tvcSports)
        {
            [tvcSports setDate:date];
        }
    }
}
@end
