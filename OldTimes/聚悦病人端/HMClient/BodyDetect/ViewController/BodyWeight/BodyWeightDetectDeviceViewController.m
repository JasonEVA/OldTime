//
//  BodyWeightDetectDeviceViewController.m
//  HMClient
//
//  Created by lkl on 2017/4/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyWeightDetectDeviceViewController.h"
#import "CommonDeviceDetectHomePageView.h"
#import "BodyWeightBLEDevice.h"

@interface BodyWeightDetectDeviceViewController ()
{
    CommonDeviceDetectHomePageView *homePageView;
    UIImageView *deviceImg;
    UIButton *measureButton;
    
    BodyWeightBLEDevice *bleControl;
}
@property (nonatomic,copy) NSString *heightStr;
//@property (nonatomic,assign) BOOL isResult;
@end

@implementation BodyWeightDetectDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithHomePage];
    
    [self createDeviceObject];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    UserInfo *user = [[UserInfoHelper defaultHelper] currentUserInfo];
    _heightStr = [NSString stringWithFormat:@"%.f", user.userHeight * 100];
    
    if (homePageView) {
        [homePageView.button setTitle:[NSString stringWithFormat:@"当前身高为%@cm,是否进行修改？ >>",_heightStr] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    if (bleControl) {
        //停止扫描并断开连接
        [bleControl disConnectPeripheral];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (bleControl && bleControl.devicesState != CentralManager_PoweredOFF){
        [bleControl connectPeripheralsTimeout:30];
    }
}

#pragma mark -- UI init
- (void)initWithHomePage
{
    homePageView = [[CommonDeviceDetectHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView hiddenGuideButton];
    [homePageView setDeviceImg:@"pic_weight_ceshi"];
    [homePageView setRemindContent:@"请站上体脂秤"];
    [homePageView.button setBackgroundColor:[UIColor whiteColor]];
    [homePageView.button setTitle:[NSString stringWithFormat:@"当前身高为%@cm,是否进行修改？ >>",_heightStr] forState:UIControlStateNormal];
    [homePageView.button setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
    [homePageView.button addTarget:self action:@selector(heightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}

#pragma mark -- Method

- (void)heightButtonClicked:(id)sender
{
    //修改用户身高
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonBodyHeightEditViewController" ControllerObject:nil];
}

- (void) createDeviceObject
{
    if (!bleControl)
    {
        bleControl = [[BodyWeightBLEDevice alloc] init];
    }
    [bleControl addObserver:self forKeyPath:@"devicesState" options:NSKeyValueObservingOptionNew context:nil];
    [bleControl addObserver:self forKeyPath:@"bodyWeightResult" options:NSKeyValueObservingOptionNew context:nil];
    
    [bleControl controlSetup];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"devicesState"])
    {
        id value = [object valueForKey:keyPath];
        if (value && [value isKindOfClass:[NSNumber class]])
        {
            NSNumber* numValue = (NSNumber*)value;
            switch (numValue.intValue)
            {
                case CentralManager_PoweredOFF:
                {
                    [homePageView setRemindContent:@"请开启手机蓝牙"];
                    break;
                }
                    
                case CentralManager_PoweredON:
                {
                    [homePageView setRemindContent:@"请站上体脂秤"];
                    [homePageView startBluetoothConnectAnimationPlay];
                    [bleControl connectPeripheralsTimeout:30];
                    break;
                }
                    
                case CentralManager_ConnectTimeOut:
                {
                    [self showAlertMessage:@"设备连接超时，您可以手动上传数据,或者重新测量" clicked:^{
                        if (self.navigationController) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }];
                    
                    break;
                }
                    
                case CentralManager_ConnectSussess:
                {
                    //[self initWithDetectLayoutView];
                    [homePageView setRemindContent:@"请站上体脂秤"];
                    break;
                }
                    
                case CentralManager_Disconnect:
                {
                    
                    if (!self.isAppear) {
                        return;
                    }
                    [self showAlertMessage:@"设备连接断开" clicked:^{
                        if (self.navigationController) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                    
                    break;
                }
                    
                default:
                    break;
            }
        }
    }
    
    if([keyPath isEqualToString:@"bodyWeightResult"])
    {
        //_isResult = YES;
        
        NSDictionary *dicBodyWeight = [object valueForKey:@"bodyWeightResult"];
        if (dicBodyWeight && [dicBodyWeight isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary* dicParams = [NSMutableDictionary dictionaryWithDictionary:dicBodyWeight];
            
            CGFloat height = _heightStr.floatValue/100;
            [dicParams setValue:[NSString stringWithFormat:@"%.2f",height] forKey:@"SG_OF_TZ"];
            
            NSMutableDictionary* dicDetectResult = [NSMutableDictionary dictionary];
            [dicDetectResult setValue:@"TZ" forKey:@"kpiCode"];
            [dicDetectResult setValue:dicParams forKey:@"testValue"];
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dicParams setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
            
            [self setDetectResult:dicDetectResult];
        }
    }
}

- (void)dealloc
{
    [bleControl removeObserver:self forKeyPath:@"devicesState"];
    [bleControl removeObserver:self forKeyPath:@"bodyWeightResult"];
}

@end
