//
//  ECGDetectViewController.m
//  HMClient
//
//  Created by lkl on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ECGDetectViewController.h"
#import "HellofitECGViewController.h"
#import "GoodFriendViewController.h"
#import "PersonDevicesItem.h"
#import "DetectManageSelectViewController.h"

@interface ECGDetectViewController ()
{
    DeviceDetectContentViewController* vcInputContent;
}
@property (nonatomic,strong) NSString *connectDevice;
@end

@implementation ECGDetectViewController

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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"XD"])
    {
        PersonDevicesDetail *item = (PersonDevicesDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"XD"]];
        self.connectDevice = item.deviceCode;
        [self createDeviceObjectViewController];
    }else
    {
        [DetectManageSelectViewController createWithParentViewController:self deviceType:@"XD"selectblock:^(NSString *testDeviceName) {
            
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
    if ([self.connectDevice isEqualToString:@"XDY_HLF"]) {
        vcInputContent  = [[HellofitECGViewController alloc] init];
    }
    else{
        //好朋友 心电仪
        vcInputContent = [[GoodFriendViewController alloc] init];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
