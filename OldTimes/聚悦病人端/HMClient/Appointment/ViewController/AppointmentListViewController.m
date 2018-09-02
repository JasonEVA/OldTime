//
//  AppointmentListViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentListViewController.h"
#import "HMSwitchView.h"
#import "AppointmentListTableViewController.h"

@interface AppointmentListViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* switchview;
    AppointmentListTableViewController* tvcAppointments;
}
@end

@implementation AppointmentListViewController

- (void) dealloc
{
    if (tvcAppointments)
    {
        [tvcAppointments removeObserver:self forKeyPath:@"totalCount"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"我的约诊"];
    [self createSwitchView];
    
    tvcAppointments = [[AppointmentListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [tvcAppointments addObserver:self forKeyPath:@"totalCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    [self addChildViewController:tvcAppointments];
    [self.view addSubview:tvcAppointments.tableView];
    [tvcAppointments.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [tvcAppointments setAppointStatus:@"2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview createCells:@[@"待就诊", @"全部"]];
    [switchview setDelegate:self];
    
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    
}

- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex
{
    switch (selectedIndex)
    {
        case 0:
        {
            [tvcAppointments setAppointStatus:@"2"];
        }
            break;
        case 1:
        {
            [tvcAppointments setAppointStatus:nil];
        }
            break;
        default:
            break;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"totalCount"])
    {
        NSNumber* numCount = [object valueForKey:keyPath];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            NSInteger count = numCount.integerValue;
            if (0 == switchview.selectedIndex) {
                [switchview setTitle:[NSString stringWithFormat:@"待就诊(%ld)", count] forIndex:0];
            }
        }
    }
}

@end
