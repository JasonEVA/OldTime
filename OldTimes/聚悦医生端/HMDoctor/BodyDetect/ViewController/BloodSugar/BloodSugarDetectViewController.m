//
//  BloodSugarDetectViewController.m
//  HMClient
//
//  Created by lkl on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarDetectViewController.h"
#import "BeneCheckBloodSugarViewController.h"
#import "OnetouchUltraEasyBloodSugarViewController.h"
#import "DetectManageSelectViewController.h"
#import "YuwellBloodSugarDetectViewController.h"
#import "PersonDevicesItem.h"

@interface BloodSugarDetectViewController ()
{
    DeviceDetectContentViewController* vcInputContent;
}
@property (nonatomic,strong) NSString *connectDevice;
@end

@implementation BloodSugarDetectViewController

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
    [self getDeviceObject];
}

- (void)getDeviceObject
{
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"XT"])
//    {
//         PersonDevicesDetail *item = (PersonDevicesDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"XT"]];
//        self.connectDevice = item.deviceCode;
//        [self createDeviceObjectViewController];
//    }else
//    {
        [DetectManageSelectViewController createWithParentViewController:self deviceType:@"XT" selectblock:^(NSString *testDeviceName) {
            
            if (!testDeviceName)
            {
                return ;
            }
            self.connectDevice = testDeviceName;
            [self createDeviceObjectViewController];
        }];
//    }
}

- (void) createDeviceObjectViewController
{
    if ([self.connectDevice isEqualToString:@"XTY_BJ"]) {
        //百捷血糖仪
        vcInputContent = [[BeneCheckBloodSugarViewController alloc] init];
    }
    else if([self.connectDevice isEqualToString:@"XTY_QS"])
    {
        //强生血糖仪
        vcInputContent = [[OnetouchUltraEasyBloodSugarViewController alloc] init];
    }
    else if ([self.connectDevice isEqualToString:@"XTY_YY"])
    {
        //鱼跃血糖仪
        vcInputContent = [[YuwellBloodSugarDetectViewController alloc] init];
    }
    [vcInputContent.view setFrame:self.view.bounds];
    [self addChildViewController:vcInputContent];
    [self.view addSubview:vcInputContent.view];
    
    [vcInputContent addObserver:self forKeyPath:@"detectResult" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

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

@end
