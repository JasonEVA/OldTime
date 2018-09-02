//
//  MedicationPlanViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MedicationPlanViewController.h"
#import "HealthPlanDateSelectView.h"
#import "MedicationPlanTableViewController.h"

@interface MedicationPlanViewStartController ()
{
    MedicationPlanViewController* vcMedication;
    NSString* dateString;
}

@end


@interface MedicationPlanViewController ()
{
    HealthPlanDateSelectView* dateSelectView;
    MedicationPlanTableViewController* tvcMedication;
    NSString* dateString;
    NSString* userId;
}

- (id) initWithDateString:(NSString*) dateStr
                   UserId:(NSString*) aUserId;
@end

@implementation MedicationPlanViewStartController



- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"记录用药"];
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        dateString = self.paramObject;
    }
    
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    vcMedication = [[MedicationPlanViewController alloc]initWithDateString:dateString UserId:[NSString stringWithFormat:@"%ld", user.userId]];
    [self addChildViewController:vcMedication];
    [self.view addSubview:vcMedication.view];
    [vcMedication.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

@end



@implementation MedicationPlanViewController

- (id) initWithDateString:(NSString*) dateStr
                   UserId:(NSString*) aUserId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        dateString = dateStr;
        userId = aUserId;
    }
    return self;
}

- (void) dealloc
{
    if (dateSelectView)
    {
        [dateSelectView removeObserver:self forKeyPath:@"date"];
    }
}

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
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    // Do any additional setup after loading the view.
    
    [self createDateSelectView];
    [self createMedicationPlanTable];
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
    if (dateString)
    {
        NSDate* date = [NSDate dateWithString:dateString formatString:@"yyyy-MM-dd"];
        [dateSelectView setDate:date];
    }
    [dateSelectView addObserver:self forKeyPath:@"date" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
}

- (void) createMedicationPlanTable
{
    tvcMedication = [[MedicationPlanTableViewController alloc]initWithUserId:userId];
    [self addChildViewController:tvcMedication];
    [self.view addSubview:tvcMedication.tableView];
    [tvcMedication.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(dateSelectView.mas_bottom).with.offset(5);
    }];
    
    [tvcMedication setDate:dateSelectView.date];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"date"])
    {
        NSDate* date = dateSelectView.date;
        if (tvcMedication)
        {
            [tvcMedication setDate:date];
        }
    }
}
@end
