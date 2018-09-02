//
//  SEMainStartTodayStepsView.m
//  HMClient
//
//  Created by lkl on 2017/10/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SEMainStartTodayStepsView.h"
#import "UIView+Util.h"
#import "BraceletDeviceInfo.h"
#import "HMStepUploadManager.h"
#import "HMSEGetTodayUserStepModel.h"
#import "PersonDevicesInfo.h"
#import "PersonDevicesItem.h"
#import <BLE3Framework/BLE3Framework.h>
#import "DeviceDefine.h"

typedef NS_ENUM(NSInteger, BraceletState) {
    BraceletState_DisConnect = 0,    //未绑定
    BraceletState_Connect,           //已绑定
    BraceletState_InSync,            //同步中
    BraceletState_SyncSuccess,       //同步完成
    BraceletState_SyncFail,          //同步失败
    BraceletState_PowerOff,          //蓝牙未开启
};

@interface SEMainStartTodayStepsView ()<BleConnectDelegate,BLELib3Delegate,TaskObserver>
{
    PersonDevicesItem *devicesItem;
}

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UIImageView *syncImgView;
@property (nonatomic, strong) SEMainStartSyncDataView *syncStartView;

@property (nonatomic, strong) UILabel *promptLb;
@property (nonatomic, assign) BraceletState braceletstate;

@end

@implementation SEMainStartTodayStepsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLb = [UILabel new];
        [self.titleLb setText:@"今日步数：0"];
        [self.titleLb setTextColor:[UIColor commonTextColor]];
        [self.titleLb setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:self.titleLb];
        [self.titleLb setUserInteractionEnabled:YES];
        
        //今日步数，跳转到步数记录
        [self.titleLb addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HMViewControllerManager createViewControllerWithControllerName:@"HMStepHistoryViewController" ControllerObject:nil];
        }];
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        
        self.syncImgView = [UIImageView new];
        [self addSubview:self.syncImgView];
        [self.syncImgView setImage:[UIImage imageNamed:@"icon_flush"]];
        [self.syncImgView setUserInteractionEnabled:YES];
        
        [self.syncImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
        }];
        
        self.connectBtn = [UIButton new];
        [self addSubview:self.connectBtn];
        [self.connectBtn setTitle:@"绑定手环 >" forState:UIControlStateNormal];
        [self.connectBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.connectBtn setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
        [self.connectBtn addTarget:self action:@selector(syncBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(self);
            make.right.equalTo(self).offset(-10);
        }];
        
        self.syncStartView = [SEMainStartSyncDataView new];
        [self addSubview:self.syncStartView];
        [self.syncStartView setHidden:YES];
        [self.syncStartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.width.mas_equalTo(100);
            make.height.equalTo(self);
        }];
        
        self.promptLb = [UILabel new];
        [self addSubview:self.promptLb];
        [self.promptLb setFont:[UIFont systemFontOfSize:15]];
        [self.promptLb setTextColor:[UIColor commonGrayTextColor]];
        [self.promptLb setHidden:YES];
        [self.promptLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
        }];
        
        //初始化，同步数据
        [self syncBraceletData];
    }
    return self;
}

#pragma mark -- 手环
//设置手环状态
- (void)setBraceletState:(BraceletState)state{
    self.braceletstate = state;
    switch (state) {
        case BraceletState_DisConnect: //未绑定
        {
            [self setSyncStartViewHidden:YES syncImgViewHidden:YES connect:NO promptHidden:YES];
            break;
        }
            
        case BraceletState_Connect:   //已绑定
        {
            [self setSyncStartViewHidden:YES syncImgViewHidden:NO connect:YES promptHidden:YES];
            break;
        }
            
        case BraceletState_InSync:  //同步中
        {
            [self setSyncStartViewHidden:NO syncImgViewHidden:YES connect:YES promptHidden:YES];
            [self performSelector:@selector(inSync15) withObject:nil afterDelay:15.0f];
            break;
        }
            
        case BraceletState_SyncSuccess:  //同步成功
        {
            [self setSyncStartViewHidden:YES syncImgViewHidden:YES connect:YES promptHidden:NO];
            [self.promptLb setText:@"同步成功"];
            [self performSelector:@selector(syncFinsh) withObject:nil afterDelay:2.0f];
            break;
        }
            
        case BraceletState_SyncFail:   //同步失败
        {
            [self setSyncStartViewHidden:YES syncImgViewHidden:YES connect:YES promptHidden:NO];
            [self.promptLb setText:@"同步失败"];
            [self performSelector:@selector(syncFinsh) withObject:nil afterDelay:2.0f];
            break;
        }
            
        case BraceletState_PowerOff:   //蓝牙未开启
        {
            [self setSyncStartViewHidden:YES syncImgViewHidden:YES connect:YES promptHidden:NO];
            [self.promptLb setText:@"请检查蓝牙状态"];
            [self performSelector:@selector(syncFinsh) withObject:nil afterDelay:2.0f];
            break;
        }
        default:
            break;
    }
}

//未绑定／同步中／同步／同步结果
- (void)setSyncStartViewHidden:(BOOL)start syncImgViewHidden:(BOOL)sync connect:(BOOL)connect promptHidden:(BOOL)prompt{
    [self.syncStartView setHidden:start];
    [self.syncImgView setHidden:sync];
    [self.connectBtn setHidden:connect];
    [self.promptLb setHidden:prompt];
    
    //如果在同步中，开始转圈动画
    if (!start) {
        [self.syncStartView.viewIndicator startAnimating];
    }
    else{
        [self.syncStartView.viewIndicator stopAnimating];
    }
}

//同步结束（成功／失败）
- (void)syncFinsh{
    if ([self isConnectBracelet]){
        [self setBraceletState:BraceletState_Connect];
    }
    else{
        [self setBraceletState:BraceletState_DisConnect];
    }
}

- (void)inSync15{
    if (self.braceletstate == BraceletState_InSync) {
        [self setBraceletState:BraceletState_SyncFail];
    }
}
//手环是否绑定
- (BOOL)isConnectBracelet{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[userdefault objectForKey:@"SH"]);
    if ([userdefault objectForKey:@"SH"]) {
        return YES;
    }
    return NO;
}

#pragma mark -- Private Method
//绑定手环,跳转
- (void)syncBtnClick{
    
    [[PersonDevicesInfo getDevicesInfo] enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        PersonDevicesItem *deviceItem = [PersonDevicesItem mj_objectWithKeyValues:dic];
        
        if ([deviceItem.type isEqualToString:@"SH"]) {
            devicesItem = deviceItem;
            
            [HMViewControllerManager createViewControllerWithControllerName:@"DeviceSelectDeviceViewController" ControllerObject:devicesItem];
            *stop = YES;
        }
    }];
}

//请求步数
- (void)getTodayUserStep{
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSEGetTodayUserStepRequest" taskParam:nil TaskObserver:self];
}

//同步数据
- (void)syncBraceletData{
    
    //请求步数
    [self getTodayUserStep];
    
    //1.先查看本地是否已绑定，同步中
    if ([self isConnectBracelet]){
        [self setBraceletState:BraceletState_InSync];
    }
    else{
        [self setBraceletState:BraceletState_DisConnect];
        return;
    }
    
    //2.再检查手环是否绑定
    [self braceletReConnectDevice];

    [BLELib3 shareInstance].connectDelegate = self;
    [BLELib3 shareInstance].delegate = self;
    [[BLELib3 shareInstance] getCurrentSportData];
    
    //点击同步，数据同步一次
    __weak typeof(self) weakSelf = self;
    [self.syncImgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        [weakSelf setBraceletState:BraceletState_InSync];
        [weakSelf braceletReConnectDevice];
        [[BLELib3 shareInstance] getCurrentSportData];
    }];
}

#pragma mark -- 蓝牙状态、设备重连
- (void)braceletReConnectDevice{

    if ([BLELib3 shareInstance].centralBluetoothState == CBCentralManagerStatePoweredOff) {
        [self centralManagerStatePoweredOff];
        return ;
    }
    
    if ([BLELib3 shareInstance].centralBluetoothState == CBCentralManagerStatePoweredOn) {
        [self.promptLb setHidden:YES];
    }
    
    //2.再检查手环是否绑定
    NSInteger state = [[BLELib3 shareInstance] state];
    if (state == kBLEstateDidConnected) {
        [self setBraceletState:BraceletState_InSync];
    }else {
        //重连
        [[BLELib3 shareInstance] reConnectDevice];
    }
}

#pragma mark - BLELib3ConnectDelegate
- (void)IWBLEDidConnectDevice:(ZeronerBlePeripheral *)device{

}
//蓝牙未开启，提示用户设置蓝牙
- (void)centralManagerStatePoweredOff {

    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBraceletState:BraceletState_PowerOff];
    });
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"打开蓝牙来允许APP连接到配件" preferredStyle:UIAlertControllerStyleAlert];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
//        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }]];
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    UIViewController *topMostViewController = keyWindow.rootViewController;
//
//    [topMostViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BLELib3Delegate
- (void)setBLEParameterAfterConnect {
    
}

- (void)updateSportData:(NSDictionary *)dict{

}

- (void)updateWholeDaySportData:(NSDictionary *)dict{

}

- (void)updateCurrentWholeDaySportData:(NSDictionary *)dict {

    dispatch_async(dispatch_get_main_queue(), ^{
        if (!kDictIsEmpty(dict)) {
            
            [self setBraceletState:BraceletState_Connect];
            
            BraceletDeviceInfo *deviceInfo = [BraceletDeviceInfo mj_objectWithKeyValues:dict];
            
            //上传步数
            [[HMStepUploadManager shareInstance] startUploadStepRequest:deviceInfo.steps];
            
            //保存手环信息
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM月dd日 HH:mm"];
            NSString *dateStr = [formatter stringFromDate:deviceInfo.date];
            
            BraceletConnectDeviceInfo *connectInfo = [[BraceletConnectDeviceInfo alloc] init];
            connectInfo.date = dateStr;
            connectInfo.data_from = deviceInfo.data_from;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:connectInfo];
            [userDefault setObject:data forKey:@"SH_IWINfo"];
            [userDefault synchronize];
        }
    });
}

//同步数据状态
- (void)syscDataFinishedStateChange:(KSyscDataState)ksdState{
    if (ksdState == KSyscDataStateBegin) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"同步开始");
            [self setBraceletState:BraceletState_InSync];
        });
    }
    if (ksdState == KSyscDataState29End) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"同步29结束");
            
            [self setBraceletState:BraceletState_SyncSuccess];
//            [self performSelector:@selector(syncFinsh) withObject:nil afterDelay:2.0f];
            
            //请求步数
            [self getTodayUserStep];
        });
    }
}

//获取小时心率
- (void)updateHeartRateData_hours:(NSDictionary *)dict{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",dict);
        //上传心率
        NSArray *detailHRData = dict[@"detail_data"];
        NSMutableArray *arr = [NSMutableArray array];
        [detailHRData enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:[NSString stringWithFormat:@"%@", obj]];
        }];
        
        NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:arr forKey:@"testValueList"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"AddUserBraceletDataTask" taskParam:dicPost TaskObserver:self];
    });
}
#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length){
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMSEGetTodayUserStepRequest"]) {
        if (taskResult && [taskResult isKindOfClass:[HMSEGetTodayUserStepModel class]]) {
            HMSEGetTodayUserStepModel *model = taskResult;
            [self.titleLb setText:[NSString stringWithFormat:@"今日步数：%ld",(long)model.stepCount]];
        }
    }
}
@end




/***同步中**/
@interface SEMainStartSyncDataView ()

@end

@implementation SEMainStartSyncDataView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *syncLb = [UILabel new];
        [syncLb setText:@"同步中"];
        [syncLb setTextColor:[UIColor commonGrayTextColor]];
        [syncLb setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:syncLb];
        
        [syncLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo(self);
        }];
        
        self.viewIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.viewIndicator];
        self.viewIndicator.color = [UIColor lightGrayColor];
        [self.viewIndicator startAnimating];
        
        [self.viewIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(syncLb.mas_left).offset(-10);
        }];
    }
    return self;
}

@end
