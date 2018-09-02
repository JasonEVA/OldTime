//
//  BraceletScanViewController.m
//  HMClient
//
//  Created by lkl on 2017/9/21.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BraceletScanViewController.h"
#import "BraceletScanView.h"
#import "BraceletConnectedViewController.h"
#import <BLE3Framework/BLE3Framework.h>

typedef NS_ENUM(NSInteger, ScanState) {
    ScanStateScaning = 0,    //正在扫描
    ScanStateScaned,         //扫描到设备
    ScanStateNull,           //搜索失败
};

@interface BraceletScanViewController () <UITableViewDelegate,UITableViewDataSource,BleDiscoverDelegate , BleConnectDelegate>

@property (nonatomic, strong) BraceletScanView *scanView;         //正在搜索
@property (nonatomic, strong) BraceletScanView *connectingView;   //正在连接
@property (nonatomic, strong) BraceletScanView *connectFailView;  //连接失败

@property (nonatomic, strong) NSTimer *scanTimer;

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *deviceArray;
@property (nonatomic, strong) UILabel *promptLb;

@end

@implementation BraceletScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"搜索"];

    [self configElements];
    
    [self scanDevice];
}

#pragma mark - Interface Method

//设置搜索状态
- (void)setScanState:(ScanState)state{
    switch (state) {
        case ScanStateScaning:
        {
            //正在扫描
            [self scanAnimation];
            [self.scanView.scanLb setText:@"搜索中…"];
            [self.scanView.reScanBtn setHidden:YES];
            [self.promptLb setHidden:YES];
            [self.tableView setHidden:YES];
        }
            break;
        case ScanStateScaned:
        {
            //扫描到设备,scanView更新布局，加载tableView
            [self.scanView setHidden:NO];
            [self.scanView.reScanBtn setHidden:YES];
            [self.scanView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.view);
                make.height.mas_equalTo(@260);
            }];
            
            [self.promptLb setHidden:YES];
            
            [self.tableView setHidden:NO];
            [self.tableView reloadData];
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scanView.mas_bottom);
                make.left.right.bottom.equalTo(self.view);
            }];
        }
            break;
        case ScanStateNull:
        {
            //搜索失败
            [self.scanView.reScanBtn setHidden:NO];
            [self.scanView.scanLb setText:@"搜索失败"];
            [self.promptLb setHidden:NO];
            [self.tableView setHidden:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    self.deviceArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.view addSubview:self.scanView];
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-80);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@260);
    }];
    
    [self.view addSubview:self.promptLb];
    [self.promptLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Event Response
//重新搜索
- (void)reScanBtnClick:(UIButton *)sender{
    [self scanDevice];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//区头的字体颜色设置
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor commonGrayTextColor];
    header.textLabel.font = [UIFont font_28];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"可用设备";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45 * kScreenScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    ZeronerBlePeripheral *device = self.dataList[indexPath.row];
    cell.textLabel.text = device.deviceName;
    cell.detailTextLabel.text = NSLocalizedString(@"点击连接", nil);
    cell.detailTextLabel.textColor = [UIColor mainThemeColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击连接，停止搜索
    [self scanBraceletTimer];
    
    self.connectingView = [BraceletScanView new];
    [self.connectingView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.connectingView];
    [self.connectingView setBracelectViewWithImage:@"icon_connecting" promptMsg:@"连接中…"];
    [self.connectingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(@200);
    }];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZeronerBlePeripheral *device = self.dataList[indexPath.row];
    [[BLELib3 shareInstance] connectDevice:device];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Override

#pragma mark - Action
- (void)scanAnimation{
    //初始化，添加定时器前先移除
    [self.scanTimer invalidate];
    self.scanTimer = nil;
    
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(scanBraceletTimer) userInfo:nil repeats:NO];
    
    
//    __block int timeNum=0;
//    //    __block UILabel *__safe_scan = _scanState;
//    __block BraceletScanViewController *__safe_self = self;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.5*NSEC_PER_SEC, 0);
//    dispatch_source_set_event_handler(_timer, ^{
//        
//        //如果在15s内点击连接，停止扫描
//        if (self.isConnecting) {
//            [self scanStop];
//            return ;
//        }
//
//        if (timeNum >= 15) {    //蓝牙搜索15s
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [__safe_self scanStop];
//            });
//        }else{
////            NSString *str = @"・";
////            for (int i = 0; i < timeNum%3; i ++) {
////                str = [str stringByAppendingString:@"・"];
////            }
//            timeNum ++;
//            dispatch_async(dispatch_get_main_queue(), ^{
////                [self.scanView.scanLb setText:[NSLocalizedString(@"搜索中", nil) stringByAppendingString:str]];
//                [self.scanView.scanLb setText:@"搜索中…"];
//                NSLog(@"%d",timeNum);
//                [self getDevice];
//            });
//        }
//    });
//    dispatch_resume(_timer);
}

- (void)scanBraceletTimer{
    [self.scanTimer invalidate];
    self.scanTimer = nil;
    
    [self scanStop];
}

#pragma mark -BLEaction
- (void)scanDevice{
    [self setScanState:ScanStateScaning];
    
    //设置代理
    [BLELib3 shareInstance].connectDelegate = self;
    [BLELib3 shareInstance].discoverDelegate = self;
    
    //扫描
    [[BLELib3 shareInstance] scanDevice];
}

- (void)getDevice{

    [self.dataList removeAllObjects];

    [self.deviceArray enumerateObjectsUsingBlock:^(ZeronerBlePeripheral *device, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataList addObject:device];
    }];
    
    if (self.dataList.count != 0) {
        [self setScanState:ScanStateScaned];
    }
}

- (void)scanStop{

    [[BLELib3 shareInstance] stopScan];
    
    if (self.dataList.count == 0) {
        [self setScanState:ScanStateNull];
    }
    else{
        [self.promptLb setHidden:NO];
        
        [self.promptLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-30);
        }];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

#pragma mark - Init
- (BraceletScanView *)scanView{
    if (!_scanView) {
        _scanView = [BraceletScanView new];
        [_scanView setBackgroundColor:[UIColor whiteColor]];
        [_scanView.reScanBtn addTarget:self action:@selector(reScanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanView;
}

- (UILabel *)promptLb{
    if (!_promptLb) {
        _promptLb = [UILabel new];
        [_promptLb setText:@"找不到设备？\n\n 试试重启手机蓝牙或者重启手环"];
        [_promptLb setNumberOfLines:0];
        [_promptLb setTextAlignment:NSTextAlignmentCenter];
        [_promptLb setFont:[UIFont font_26]];
        [_promptLb setTextColor:[UIColor commonGrayTextColor]];
    }
    return _promptLb;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataList;
}

#pragma mark - BleDiscoverDelegate
- (void)IWBLEDidDiscoverDeviceWithMAC:(ZeronerBlePeripheral *)iwDevice{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deviceArray addObject:iwDevice];
        
        [self getDevice];
    });
}

#pragma mark - BleConnectDelegate
- (void)IWBLEDidConnectDevice:(ZeronerBlePeripheral *)device{

    dispatch_async(dispatch_get_main_queue(), ^{
        //先移除连接View
        [self.connectingView removeFromSuperview];
        self.connectingView = nil;
        
        [HMViewControllerManager createViewControllerWithControllerName:@"BraceletConnectedViewController" ControllerObject:@"Y"];
    });
}

//Disconnect 未连接，当设备断开时也执行该方法
- (void)IWBLEDidDisConnectWithDevice:(ZeronerBlePeripheral *)device andError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self at_postError:@"手环连接已断开"];
    });
}

//连接失败
- (void)IWBLEDidFailToConnectDevice:(ZeronerBlePeripheral *)device andError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.connectFailView = [BraceletScanView new];
        [self.connectFailView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.connectFailView];
        [self.connectFailView setBracelectViewWithImage:@"icon_connectingfail" promptMsg:@"连接失败"];
        [self.connectFailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.height.mas_equalTo(@200);
        }];
    });
}

- (void)deviceDidDisConnectedWithSystem:(NSString *)deviceName {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

//蓝牙未开启，提示用户设置蓝牙
- (void)centralManagerStatePoweredOff {
//    [self showAlertMessage:@"打开蓝牙来允许APP连接到配件" cancelTitle:@"取消" cancelClicked:nil confirmTitle:@"去设置" confirmClicked:^{
//        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
//        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self at_postError:@"请打开蓝牙" duration:2.0f];
    });
}

@end
