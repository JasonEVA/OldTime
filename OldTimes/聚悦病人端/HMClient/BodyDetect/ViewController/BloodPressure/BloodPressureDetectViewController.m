//
//  BloodPressureDetectViewController.m
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureDetectViewController.h"
#import "YuwellBloodPressureViewController.h"
#import "U80LHBloodPressureViewController.h"
#import "MaiboboBloodPressureViewController.h"

@interface BloodPressureDetectViewController ()
{
    DeviceDetectContentViewController* vcInputContent;
}
@property (nonatomic,strong) NSString *connectDevice;
@end

@implementation BloodPressureDetectViewController

- (void) dealloc
{
    if (vcInputContent)
    {
        [vcInputContent removeObserver:self forKeyPath:@"detectResult"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getDeviceObject];
}

- (void)getDeviceObject
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"XY"])
    {
        PersonDevicesDetail *item = (PersonDevicesDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"XY"]];
        self.connectDevice = item.deviceCode;
        [self createDeviceObjectViewController];
    }else
    {
        [DetectManageSelectViewController createWithParentViewController:self deviceType:@"XY" selectblock:^(NSString *testDeviceName) {
            
            if (!testDeviceName)
            {
                return ;
            }
            self.connectDevice = testDeviceName;
            [self createDeviceObjectViewController];
        }];
    }
}

- (void) createDeviceObjectViewController
{
    if ([self.connectDevice isEqualToString:@"XYJ_YY"]) {
        vcInputContent = [[YuwellBloodPressureViewController alloc] init];
    }
    else if ([self.connectDevice isEqualToString:@"XYJ_YRN"]) {
        vcInputContent = [[U80LHBloodPressureViewController alloc] init];
    }
    else if ([self.connectDevice isEqualToString:@"XYJ_MBB"]) {
        vcInputContent = [[MaiboboBloodPressureViewController alloc] init];
    }
    [vcInputContent.view setFrame:self.view.bounds];
    [self addChildViewController:vcInputContent];
    [self.view addSubview:vcInputContent.view];
    [vcInputContent addObserver:self forKeyPath:@"detectResult" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"detectResult"])
    {
        NSDictionary* dicPost = [object valueForKey:keyPath];
        if (dicPost) {
            [self postDetectResult:dicPost];
        }
        
    }
}

/*-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"detectResult"])
    {
        [self postDetectResult:object];
    }
}*/

@end
