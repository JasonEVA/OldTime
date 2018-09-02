//
//  FSRKTemperatureDetectViewController.m
//  HMClient
//
//  Created by yinquan on 17/4/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "FSRKTemperatureDetectViewController.h"
#import "FSRKTemperatureDeviceControl.h"

#import "FSRKTemperatureDeviceConnectingView.h"
#import "FSRKTemperatureDeviceDetectingView.h"

@interface FSRKTemperatureDetectViewController ()
<BodyTemperatureResultDelegate>
{
    FSRKTemperatureDeviceControl* bleControl;
    NSTimer* detectingTimer;
    NSTimer* detectErrorTimer;
    CGFloat lastTemperature;
    
    
}

@property (nonatomic, readonly) UIView* guidView;
@property (nonatomic, readonly) UIView* contentView;

@property (nonatomic, assign) NSInteger deviceError;
@end

@implementation FSRKTemperatureDetectViewController

@synthesize contentView = _contentView;

- (void)dealloc
{
    if (bleControl)
    {
        [bleControl removeObserver:self forKeyPath:@"devicesState"];
        //断开蓝牙设备连接
        [bleControl disConnectPeripheral];
    }
    
    if (detectingTimer) {
        [detectingTimer invalidate];
        detectingTimer = nil;
    }
    
    if (detectErrorTimer) {
        [detectErrorTimer invalidate];
        detectErrorTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.guidview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(@30);
    }];
    
    [self.guidView setHidden:YES];
    
    FSRKTemperatureDeviceConnectingView* connectingView = (FSRKTemperatureDeviceConnectingView*)self.contentView;
    [connectingView setDeviceStatus:CentralManager_PoweredOFF];
    
    [self createDeviceObject];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (bleControl && bleControl.devicesState != CentralManager_PoweredOFF){
         [bleControl connectPeripheralsTimeout:30];
    }
   
    if (detectingTimer) {
        [detectingTimer invalidate];
        detectingTimer = nil;
    }
    
    if (detectErrorTimer) {
        [detectErrorTimer invalidate];
        detectErrorTimer = nil;
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (bleControl) {
        [bleControl disConnectPeripheral];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createDeviceObject
{
    if (!bleControl)
    {
        bleControl = [[FSRKTemperatureDeviceControl alloc] init];
        [bleControl addObserver:self forKeyPath:@"devicesState" options:NSKeyValueObservingOptionNew context:nil];
        [bleControl setResultdelegate:self];
    }
    
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
            NSInteger deviceStatusCode = numValue.integerValue;
            [self dealDeviceStatusCode:deviceStatusCode];
        }
    }
}

- (void) dealDeviceStatusCode:(NSInteger)deviceStatusCode
{
    NSLog(@"dealDeviceStatusCode %ld", deviceStatusCode);
    switch (deviceStatusCode)
    {
        case CentralManager_PoweredOFF:
        {
            //没有开启蓝牙
            FSRKTemperatureDeviceConnectingView* connectingView = (FSRKTemperatureDeviceConnectingView*)self.contentView;
            [connectingView setDeviceStatus:deviceStatusCode];
            break;
        }
        case CentralManager_PoweredON:
        {
            //开启蓝牙进行连接
            FSRKTemperatureDeviceConnectingView* connectingView = (FSRKTemperatureDeviceConnectingView*)self.contentView;
            [connectingView setDeviceStatus:deviceStatusCode];
            [bleControl connectPeripheralsTimeout:30];
            break;
        }
        case CentralManager_ConnectTimeOut:
        {
            [self showAlertMessage:@"设备连接超时。" clicked:^{
                if (self.navigationController) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];

            break;
        }
            
        case CentralManager_Disconnect:
        {
            //设备连接断开
            FSRKTemperatureDeviceConnectingView* connectingView = (FSRKTemperatureDeviceConnectingView*)self.contentView;
            [connectingView setDeviceStatus:deviceStatusCode];
            

            if (!self.isAppear) {
                return;
            }
            [self showAlertMessage:@"设备连接断开。" clicked:^{
                if (self.navigationController) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
            break;
        }
        case CentralManager_ConnectSussess:
        {
            //设备连接成功
            FSRKTemperatureDeviceDetectingView* connectedView = (FSRKTemperatureDeviceDetectingView*)self.contentView;
            
            break;

           
        }
        default:
            break;
    }
}

#pragma mark - setterAndGetter
- (UIView*) guidview
{
    if (_guidView) {
        return _guidView;
    }
    
    _guidView = [[UIView alloc] init];
    [self.view addSubview:_guidView];
    UIButton* guidButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_guidView addSubview:guidButton];
    [guidButton setTitle:@"使用向导" forState:UIControlStateNormal];
    [guidButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [guidButton setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
    
    [guidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_guidView).with.offset(-12.5);
        make.centerY.equalTo(_guidView);
    }];
    
    UIImageView* questionIcon = [[UIImageView alloc] init];
    [questionIcon setImage:[UIImage imageNamed:@"icon_question"]];
    [_guidView addSubview:questionIcon];
    
    [questionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_guidView);
        make.right.equalTo(guidButton.mas_left).with.offset(-3);
    }];
    
    return _guidView;
}

- (UIView*) contentView
{
    if (_contentView)
    {
        switch (bleControl.devicesState) {
            case CentralManager_PoweredOFF:
            case CentralManager_PoweredON:
            case CentralManager_Disconnect:
            {
                if ([_contentView isKindOfClass:[FSRKTemperatureDeviceConnectingView class]])
                {
                    break;
                }
                else
                {
                    [_contentView removeFromSuperview];
                    _contentView = [[FSRKTemperatureDeviceConnectingView alloc]init];
                    [self.view addSubview: _contentView];
                    
                    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.bottom.equalTo(self.view);
                        make.top.equalTo(self.guidView.mas_bottom);
                    }];
                }
                break;
            }
            case CentralManager_ConnectSussess:
            {
                if ([_contentView isKindOfClass:[FSRKTemperatureDeviceDetectingView class]]) {
                    break;
                }
                else
                {
                    [_contentView removeFromSuperview];
                    _contentView = [[FSRKTemperatureDeviceDetectingView alloc]init];
                    [self.view addSubview: _contentView];
                    
                    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.bottom.equalTo(self.view);
                        make.top.equalTo(self.guidView.mas_bottom);
                    }];

                }
                break;
            }
            default:
                break;
        }
    }
    else
    {
        switch (bleControl.devicesState) {
            case CentralManager_PoweredOFF:
            case CentralManager_PoweredON:
            case CentralManager_Disconnect:
            {
                _contentView = [[FSRKTemperatureDeviceConnectingView alloc]init];
                [self.view addSubview: _contentView];
                
                [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.top.equalTo(self.guidView.mas_bottom);
                }];
                break;
            }
            case CentralManager_ConnectSussess:
            {
                _contentView = [[FSRKTemperatureDeviceDetectingView alloc]init];
                [self.view addSubview: _contentView];
                
                [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.top.equalTo(self.guidView.mas_bottom);
                }];
                break;
            }
        }
    }
    
    
    return _contentView;
}

#pragma mark - BodyTemperatureResultDelegate
- (void) temperature:(CGFloat) temperature error:(BodyTemperatureErrorCode) errorCode
{
    if (errorCode == Error_None)
    {
        //获取到体温数据成功
        lastTemperature = temperature;
        
        if (!detectingTimer)
        {
            //避免重复接收数据后响应
//            __weak typeof(self) weakSelf = self;
//            detectingTimer = [NSTimer scheduledscheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
//                if (!weakSelf) {
//                    return ;
//                }
//                [weakSelf detectingTimerFunc];
//            }];
            
            detectingTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(detectingTimerFunc) userInfo:nil repeats:NO];
        }
        else
        {
            return;
        }
//
        return;
    }
    
    //获取体温数据失败
    [self showAlertMessage:@"读取体温计数据失败，请重新测量。"];
}

- (void) temperature:(CGFloat)temperature error:(BodyTemperatureErrorCode)errorCode deviceError:(NSInteger)deviceError
{
    if (errorCode != Error_DeviceError) {
        return;
    }
    
    if (_deviceError == deviceError) {
        return;
    }
    _deviceError = deviceError;
    if (detectErrorTimer) {
        return;
    }
    
    detectErrorTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(detecterrorTimerFunc) userInfo:nil repeats:NO];
    
    }

- (void) detectingTimerFunc
{
    if (!lastTemperature)
    {
        return;
    }
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicResult setValue:@"TEM" forKey:@"kpiCode"];
    
    [dicValue setValue:[NSString stringWithFormat:@"%.1f",lastTemperature] forKey:@"TEM_SUB"];
    [dicResult setValue:dicValue forKey:@"testValue"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicResult setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
    
    //上传体温监测数据
    [self postDetectResult:dicResult];
    [detectingTimer invalidate];
    detectingTimer = nil;
}

- (void) detecterrorTimerFunc
{
    switch (_deviceError)
    {
        case 1:
        {
            [self showAlertMessage:@"体温过低，请检查测量方式是否正确，或请立即就医"];
            break;
        }
        case 2:
        {
            [self showAlertMessage:@"体温过高，请检查测量方式是否正确，或请立即就医"];
            break;
        }
        case 3:
        {
            [self showAlertMessage:@"环境温度过低，请稍后重试。"];
            break;
        }
        case 4:
        {
            [self showAlertMessage:@"环境温度过高，请稍后重试。"];
            break;
        }
        case 5:
        {
            [self showAlertMessage:@"设备电压过低，请更换电池后再试。"];
            break;
        }
        case 6:
        {
            [self showAlertMessage:@"测量错误，请重试。"];
            break;
        }
        default:
            break;
    }

    _deviceError = 0;
    
    [detectErrorTimer invalidate];
    detectErrorTimer = nil;
}
@end
