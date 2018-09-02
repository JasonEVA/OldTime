//
//  ATClockViewController.m
//  Clock
//
//  Created by Dariel on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATClockViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "ATDailyAttendanceHeadView.h"
#import "ATDailyAttendanceView.h"
#import "ATDailyAttendanceAdapter.h"

#import "ATGoOutAttendanceHeadView.h"
#import "ATGoOutAttendanceView.h"
#import "ATGoOutAttendanceAdapter.h"

#import "ATSegmentedControl.h"

#import "ATClockInteractor.h"

#import "ATClockViewBL.h"
#import "ATPunchAlertView.h"

#import "ATGetClockRuleRequest.h"
#import "ATGetCurrentServerDateRequest.h"
#import "ATGetClockListRequest.h"
#import "ATPunchCardRequest.h"
#import "ATUpdateRemarkRequest.h"

#import "ATGetClockRuleModel.h"
#import "ATPunchCardModel.h"
#import "ATNoClockTitleCellModel.h"
#import "ATCheckAttendanceViewCellModel.h"


#import "ATAppSync.h"
#import "NSString+ATConverter.h"
#import "NSDictionary+ATBdEncrypt.h"
#import "UINavigationBar+ATAwesome.h"
#import "ATSharedMacro.h"
#import "UIColor+ATHex.h"
#import "UILabel+ATCreate.h"
#import "UIButton+AtCreate.h"
#
#import "ATStaticViewController.h"


#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5
static NSString *const k_Operation_Error = @"打卡异常";
static NSString *const k_Operation_Normal = @"打卡正常";
static NSString *const k_punchCard_updateTime_Notification = @"updateTime";
static NSString *const k_punchCard_updateLocation_Notificatiion = @"updateLocation";

typedef NS_ENUM(NSInteger, SignTypes)
{
    k_Sign_Unknow = 0,      //未知
    k_Sign_OnDuty,          //上班
    k_Sign_OffDuty,         //下班
    k_Sign_OutOnDuty        //外勤
};

@interface ATClockViewController() <ATHttpRequestDelegate,AMapLocationManagerDelegate,ATTableViewAdapterDelegate>
{
    NSString *_lon;
    NSString *_lat;
    NSString *_location;
    __block NSString *_signId;
    __block NSString *_remark;
    __block NSNumber *_currentTimestamp;
    ATGetClockRuleModel *_clockRuleModel;
    NSUInteger _signType;
    
    ATPunchCardModel *_goToWorkClockModel;
    ATPunchCardModel *_afterWorkClockModel;
    ATPunchCardModel *_goOutWorkClockModel;
}

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, strong) UIView *dailyAttBgView;
@property (nonatomic, strong) ATDailyAttendanceHeadView *dailyAttHeadView;
@property (nonatomic, strong) ATDailyAttendanceView *dailyAttView;
@property (nonatomic, strong) ATDailyAttendanceAdapter *dailyAttAdapter;

@property (nonatomic, strong) UIView *goOutAttBgView;
@property (nonatomic, strong) ATGoOutAttendanceHeadView *goOutAttHeadView;
@property (nonatomic, strong) ATGoOutAttendanceView *goOutAttView;
@property (nonatomic, strong) ATGoOutAttendanceAdapter *goOutAttAdapter;

@property (nonatomic, strong) ATClockInteractor *interactor;
@property (nonatomic, strong) ATClockViewBL *clockViewBL;
@property (nonatomic, strong) NSMutableArray *dailyClockArrs;

@property (nonatomic, strong) ATPunchAlertView *punchAlertView;
@property (nonatomic, assign) NSInteger segmentIndex;

//当前的地理信息
@property(nonatomic, strong) CLLocation  *currentLocation;
//当前的逆定理信息
@property(nonatomic, strong)  AMapLocationReGeocode *currentRegocode;

@end

@implementation ATClockViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dailyClockArrs = [NSMutableArray arrayWithCapacity:0];
    //防止用户请求打卡规则失败
    _clockRuleModel = [ATGetClockRuleModel decodeClockRuleModelFromUserDefault];
    
    [self createLeftItem];
    [self createRightItem];
    [self createSegmentCtl];
    [self initGaoDeMapManage];
    
    self.view = self.dailyAttBgView;
    
    //从服务器获取最新时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime) name:k_punchCard_updateTime_Notification object:nil];
    //在应用进入后台再次返回后，主动获取当前时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentLocation) name:k_punchCard_updateLocation_Notificatiion object:nil];
    //获取考勤规则
    [self getClockRuleFromServer];
    //获取列表
    [self getTodayPunchListRequestFromServer];
    //添加block
    [self actionEventOfBlock];
    //获取地理位置信息
    [self getCurrentLocation];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [self getCurrentServerDateFromServer];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.translucent = YES;
    self.hidesBottomBarWhenPushed = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar at_reset];
}

- (void)dealloc
{
    [self cleanUpAction];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.completionBlock = nil;
}

#pragma mark - private

- (void)actionEventOfBlock {
    __weak typeof(self) weakSelf = self;
    [self.dailyAttHeadView dailyClock:^(NSUInteger btnIndex, NSNumber *timestamp) {
        _currentTimestamp = timestamp;
        if (0 == btnIndex) {
            NSLog(@"上班打卡");
            _signType = 1;
        } else if (1 == btnIndex) {
            NSLog(@"下班打卡");
            _signType = 2;
        }
        [weakSelf determineWhetherToUpdateTheClock];
    }];
    
    [self.goOutAttHeadView goOutClock:^(NSNumber *timestamp) {
        _currentTimestamp = timestamp;
        _signType = 3;// 外勤打卡
        [weakSelf determineWhetherToUpdateTheClock];
    }];
    
    [self.dailyAttAdapter goToEditingRemark:^(ATPunchCardModel *model) {
        
        
    }];
}

- (void)createLeftItem {
    UIButton *backBtn = [UIButton at_createBtnWithTitle:nil fontSize:0 titleColor:nil imgName:@"back_blue_new" bgColor:nil addTarget:self selector:@selector(backBtnClicked)];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createRightItem {
    UIButton *rightButton = [UIButton at_createBtnWithTitle:@"统计" fontSize:15.0 titleColor:[UIColor at_blueColor] imgName:nil bgColor:nil addTarget:self selector:@selector(rightBarButtonClick)];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)initGaoDeMapManage
{
    [self configLocationManager];
    
}

- (void)createSegmentCtl {
    ATSegmentedControl *segCtl = [[ATSegmentedControl alloc] initWithItems:@[@"上下班",@"外出"]
                                                                   bgColor:[UIColor whiteColor]
                                                               borderColor:[UIColor at_blueColor]
                                                             selTitleColor:[UIColor whiteColor]
                                                             norTitleColor:[UIColor at_blueColor]
                                                                 tintColor:[UIColor at_blueColor]
                                                              cornerRadius:4
                                                                 addTarget:self
                                                                  selector:@selector(segmentClick:)];
    segCtl.frame = CGRectMake(0, (44 - 30) / 2.0, 75 * 2, 30);
    _segmentIndex = segCtl.selectedSegmentIndex;
    
    self.navigationItem.titleView = segCtl;
}

- (void)segmentClick:(UISegmentedControl *)segCtl {
    _segmentIndex = segCtl.selectedSegmentIndex;
    
    switch (_segmentIndex) {
        case 0:
            self.view = self.dailyAttBgView;
            break;
        case 1:
            [self getTodayPunchListRequestFromServer];
            self.view = self.goOutAttBgView;
            break;
        default:
            break;
    }
}


//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//}


- (void)loadAttendanceDataSource:(NSArray <ATPunchCardModel *>*)dataSource {
    
    if (dataSource.count) {
        if (1 == dataSource.count) {
            id model = dataSource[0];
            if ([model isKindOfClass:[ATPunchCardModel class]]) {
                ATPunchCardModel *cardModel = (ATPunchCardModel *)model;
                [cardModel determineWhetherAbnormalWithOnWorkTime:_clockRuleModel.OnWorkTime offWorkTime:_clockRuleModel.OffWorkTime];
                if (1 == cardModel.SignType.integerValue) {
                    cardModel.isFirstModel = YES;
                    _goToWorkClockModel = cardModel;
                    [self.dailyClockArrs addObject:cardModel];
                    ATNoClockTitleCellModel *titleModel = [[ATNoClockTitleCellModel alloc] init];
                    titleModel.titleStr = @"下班";
                    titleModel.dateStr = @"未打卡";
                    [self.dailyClockArrs addObject:titleModel];
                } else if (2 == cardModel.SignType.integerValue) {
                    ATNoClockTitleCellModel *titleModel = [[ATNoClockTitleCellModel alloc] init];
                    titleModel.titleStr = @"上班";
                    titleModel.isHideTopLine = YES;
                    titleModel.dateStr = @"未打卡";
                    [self.dailyClockArrs addObject:titleModel];
                    _afterWorkClockModel = cardModel;
                    [self.dailyClockArrs addObject:cardModel];
                    [self settingClockInBtnDoNotClick];
                }
            }
        } else {
            for (ATPunchCardModel *model in dataSource) {
                NSInteger index = [dataSource indexOfObject:model];
                if (0 == index) {
                    model.isFirstModel = YES;
                }
                [model determineWhetherAbnormalWithOnWorkTime:_clockRuleModel.OnWorkTime offWorkTime:_clockRuleModel.OffWorkTime];
                if (1 == model.SignType.integerValue) {
                    _goToWorkClockModel = model;
                } else if (2 == model.SignType.integerValue) {
                    _afterWorkClockModel = model;
                    [self settingClockInBtnDoNotClick];
                }
                [self.dailyClockArrs addObject:model];
            }
        }
        
        self.dailyAttAdapter.adapterArray = self.dailyClockArrs;
        [self.dailyAttView refreshTableView];
    } else {
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:2];
        NSArray *titleArr = @[@"上班",@"下班"];
        for (NSInteger i = 0; i < titleArr.count; i ++) {
            ATNoClockTitleCellModel *model = [[ATNoClockTitleCellModel alloc] init];
            model.titleStr = titleArr[i];
            model.dateStr = @"未打卡";
            if (0 == i) {
                model.isHideTopLine = YES;
            } else {
                model.isHideTopLine = NO;
            }
            [dataSource addObject:model];
        }
        self.dailyAttAdapter.adapterArray = dataSource;
        [self.dailyAttView refreshTableView];
    }
}

- (void)updateAttendanceDataSourceWithModel:(ATPunchCardModel *)cardModel {
    
    [cardModel determineWhetherAbnormalWithOnWorkTime:_clockRuleModel.OnWorkTime offWorkTime:_clockRuleModel.OffWorkTime];
    
    if (3 == cardModel.SignType.integerValue) {
        [self.goOutAttView hideFooterView];
        _goOutWorkClockModel = cardModel;
        if (!self.goOutAttAdapter.adapterArray) {
            self.goOutAttAdapter.adapterArray = [NSMutableArray arrayWithCapacity:0];
        }
        
        NSIndexPath *indexPath;
        for (ATPunchCardModel *model in self.goOutAttAdapter.adapterArray) {
            if ([model.SignId isEqualToString:cardModel.SignId]) {
                NSInteger index = [self.goOutAttAdapter.adapterArray indexOfObject:model];
                [self.goOutAttAdapter.adapterArray replaceObjectAtIndex:index withObject:cardModel];
                indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                break;
            }
        }
        if (!indexPath) {
            [self.goOutAttAdapter.adapterArray addObject:cardModel];
            indexPath = [NSIndexPath indexPathForRow:self.goOutAttAdapter.adapterArray.count - 1 inSection:0];
        }
        
        ATPunchCardModel *model = self.goOutAttAdapter.adapterArray[0];
        model.isFirstModel = YES;
        [self.goOutAttView refreshTableView];
        [self.goOutAttView.dataTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else if (1 == cardModel.SignType.integerValue || 2 == cardModel.SignType.integerValue) {
        NSInteger index = 0;
        if (1 == cardModel.SignType.integerValue) {
            index = 0;
            _goToWorkClockModel = cardModel;
        } else if (2 == cardModel.SignType.integerValue) {
            index = 1;
            _afterWorkClockModel = cardModel;
            [self settingClockInBtnDoNotClick];
        }
        if (!self.dailyAttAdapter.adapterArray) {
            self.dailyAttAdapter.adapterArray = [NSMutableArray arrayWithCapacity:2];
        }
        
        if (0 == index) {
            cardModel.isFirstModel = YES;
        }
        
        id model = self.dailyAttAdapter.adapterArray[0];
        if ([model isKindOfClass:[ATPunchCardModel class]]) {
            ATPunchCardModel *punchModel = (ATPunchCardModel *)model;
            punchModel.isFirstModel = YES;
        }
        
        [self.dailyAttAdapter.adapterArray replaceObjectAtIndex:index withObject:cardModel];
        [self.dailyAttView refreshTableView];
    }
}

- (void)loadGoOutAttDataSource:(NSArray *)dataSource {
    if (dataSource.count) {
        [self.goOutAttView hideFooterView];
        
        for (ATPunchCardModel *model in dataSource) {
            NSInteger index = [dataSource indexOfObject:model];
            if (0 == index) {
                model.isFirstModel = YES;
            }
            [model determineWhetherAbnormalWithOnWorkTime:_clockRuleModel.OnWorkTime offWorkTime:_clockRuleModel.OffWorkTime];
        }
        self.goOutAttAdapter.adapterArray = [NSMutableArray arrayWithArray:dataSource];
        [self.goOutAttView refreshTableView];
    } else {
        [self.goOutAttView showFooterView];
    }
}

/** 设置上班打卡按钮不可选 */
- (void)settingClockInBtnDoNotClick {
    if (self.dailyAttHeadView.enbleClockInBtn) {
        self.dailyAttHeadView.enbleClockInBtn = NO;
    }
}

// 进入统计页面
- (void)rightBarButtonClick {
    ATStaticViewController *staticVc = [[ATStaticViewController alloc] init];
    staticVc.userId = self.userId;
    staticVc.orgId = self.orgId;
    
    [self.navigationController pushViewController:staticVc animated:YES];
    
}

/**
 *  判断是否更新打卡
 */
- (void)determineWhetherToUpdateTheClock
{
    if (1 == _signType) {
        if (_goToWorkClockModel) {
            [self showSystemAlertView];
        } else {
            [self punchCardLogicProcessing];
        }
    } else if (2 == _signType) {
        if (_afterWorkClockModel) {
            [self showSystemAlertView];
        } else {
            [self punchCardLogicProcessing];
        }
    } else if (3 == _signType) {
        [self punchCardLogicProcessing];
    }
}

- (void)showSystemAlertView {
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"确定要更新此次打卡记录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self punchCardLogicProcessing];
    }];
    [alertCtr addAction:cancelAction];
    [alertCtr addAction:sureAction];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
}

/**
 *  处理打卡逻辑 打卡逻辑判断
 */
- (void)punchCardLogicProcessing {
    [self reGeocodeAction];
}

//更新打卡
- (void)popUpdateRemark:(NSString *)remark title:(NSString *)title location:(NSString*)location
{
    [self.view addSubview:self.punchAlertView];
    self.punchAlertView.title = title;
    self.punchAlertView.remark = remark;
    self.punchAlertView.location = location;
    __weak typeof(self) weakSelf = self;
    [self.punchAlertView writeText:^(NSString *remark) {
        _remark = remark;
        [weakSelf updateRemarkRequestFromServer];
    }];
}

//更新时间
- (void)updateTime
{
    [self getCurrentServerDateFromServer];
}

#pragma mark Requests

/** 获取考勤规则 */
- (void)getClockRuleFromServer {
    ATGetClockRuleRequest *req = [[ATGetClockRuleRequest alloc] init];
    req.orgId = self.orgId;
    req.userId = self.userId;
    [req requestWithDelegate:self];
}

- (void)getCurrentServerDateFromServer {
    ATGetCurrentServerDateRequest *req = [[ATGetCurrentServerDateRequest alloc] init];
    [req requestWithDelegate:self];
}


- (void)getTodayPunchListRequestFromServer {
    ATGetClockListRequest *req = [[ATGetClockListRequest alloc] init];
    req.userId = self.userId;
    req.orgId = self.orgId;
    NSString *startDate = [NSString at_getFormatterDateStrWithFormatterStr:@"yyyy-MM-dd" date:[NSDate date]];
    req.startTime = [NSString stringWithFormat:@"%@ 00:00:00",startDate];
    req.endTime = [NSString stringWithFormat:@"%@ 23:59:59",startDate];
    if (0 == _segmentIndex) {
        req.signType = [NSNumber numberWithInteger:1];
    } else {
        req.signType = [NSNumber numberWithInteger:3]; //外勤
    }
    
    
    [self postLoading:@"拉取列表"];
    [req requestWithDelegate:self];
}

- (void)punchCardRequestFromServer
{
    ATPunchCardRequest *req = [[ATPunchCardRequest alloc] init];
    req.orgId = self.orgId;
    req.userId = self.userId;
    req.lon = _lon;
    req.lat = _lat;
    req.location = self.punchAlertView.location;
    req.remark = _remark;
    req.networkType = @"4G";
    req.signType = [NSNumber numberWithUnsignedInteger:_signType];
    
    NSString *message = @"打卡";
    if (1 == _signType) {
        ATPunchCardModel *model;
        for (id dailyModel in self.dailyAttAdapter.adapterArray) {
            if ([dailyModel isKindOfClass:[ATPunchCardModel class]]) {
                ATPunchCardModel *cardModel = (ATPunchCardModel *)dailyModel;
                if (_signType == cardModel.SignType.integerValue) {
                    model = cardModel;
                    break;
                }
            }
        }
        if (model) {
            req.signId = model.SignId;
            message = @"更新上班打卡";
        }
    } else if (2 == _signType) {
        ATPunchCardModel *model;
        for (id dailyModel in self.dailyAttAdapter.adapterArray) {
            if ([dailyModel isKindOfClass:[ATPunchCardModel class]]) {
                ATPunchCardModel *cardModel = (ATPunchCardModel *)dailyModel;
                if (_signType == cardModel.SignType.integerValue) {
                    model = cardModel;
                    break;
                }
            }
        }
        if (model) {
            req.signId = model.SignId;
            message = @"更新下班打卡";
        }
    }
    
    [self postLoading:message];
    [req requestWithDelegate:self];
}

- (void)updateRemarkRequestFromServer
{
    ATUpdateRemarkRequest *req = [[ATUpdateRemarkRequest alloc] init];
    req.signId = _signId;
    req.remark = _remark;
    [self postLoading:@"备注修改"];
    [req requestWithDelegate:self];
}

#pragma mark - ATHttpRequestDelegate

- (void)requestSucceed:(ATHttpBaseRequest *)request withResponse:(ATHttpBaseResponse *)response
{
    [self hideLoading];
    
    if ([response isKindOfClass:[ATGetClockRuleResponse class]]) {
        ATGetClockRuleResponse *rsp = (ATGetClockRuleResponse *)response;
        _clockRuleModel = rsp.ruleModel;
        
    } else if ([response isKindOfClass:[ATGetCurrentServerDateResponse class]]) {
        ATGetCurrentServerDateResponse *rsp = (ATGetCurrentServerDateResponse *)response;
        self.dailyAttHeadView.currentTimestamp = rsp.currentTimestamp;
        self.goOutAttHeadView.currentTimestamp = rsp.currentTimestamp;
    } else if ([response isKindOfClass:[ATPunchCardResponse class]]) {
        ATPunchCardResponse *rsp = (ATPunchCardResponse *)response;
        [self updateAttendanceDataSourceWithModel:rsp.punchModel];
        _remark = @"";
    } else if ([response isKindOfClass:[ATGetClockListResponse class]]) {
        ATGetClockListResponse *rsp = (ATGetClockListResponse *)response;
        if (_segmentIndex == 0) {
            [self loadAttendanceDataSource:rsp.dataSource];
        } else {
            [self loadGoOutAttDataSource:rsp.dataSource];
        }
    } else if ([response isKindOfClass:[ATUpdateRemarkResponse class]]) {
        ATUpdateRemarkResponse *rsp = (ATUpdateRemarkResponse *)response;
        _remark = @"";
        [self postSuccess:@"修改成功"];
        [self updateAttendanceDataSourceWithModel:rsp.cardModel];
    }
}

- (void)requestFail:(ATHttpBaseRequest *)request withResponse:(ATHttpBaseResponse *)response
{
    [self hideLoading];
    
    [self postError:response.errorMsg];
    
    if ([response isKindOfClass:[ATGetClockListResponse class]]) {
    }
}

#pragma mark - ATTableViewAdapterDelegate
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    if ([cellData isKindOfClass:[ATPunchCardModel class]]) {
        ATPunchCardModel *model = (ATPunchCardModel *)cellData;
        if (1 == model.SignType.integerValue || 2 == model.SignType.integerValue) {
            _signId = model.SignId;
            [self popUpdateRemark:model.Remark title:model.isAbnormal?@"打卡异常":@"打卡正常" location:model.Location];
        } else if (3 == model.SignType.integerValue) {
            _signId = model.SignId;
            [self popUpdateRemark:model.Remark title:@"外出备注" location:model.Location];
        }
    }
}


#pragma mark - 高德
//高德基础配置
- (void)configLocationManager

{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    
    
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)cleanUpAction
{
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
}


//单次获取当前的地理信息
- (void)getCurrentLocation
{
    __weak typeof(self) weakSelf = self;
    
    
    NSLog(@"%d",[self.locationManager requestLocationWithReGeocode:YES completionBlock:nil]);
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            [self postError:@"定位错误"];
            NSLog(@"Wrong Wrong Wrong Wrong Wrong😂");
            return;
        }
        weakSelf.currentLocation = location;
        weakSelf.currentRegocode = regeocode;
    }];
}

//根据当前的地理位置，判断是否在正确的区域
- (void)reGeocodeAction
{
    if (self.currentLocation)
    {
        NSDictionary *bd_dict = [NSDictionary at_bd_encryptWithGg_lat:self.currentLocation.coordinate.latitude gg_lon:self.currentLocation.coordinate.longitude];
        NSNumber *lon = bd_dict[@"lon"];
        NSNumber *lat = bd_dict[@"lat"];
        _lon = [lon stringValue];
        _lat = [lat stringValue];
        if (self.currentRegocode.formattedAddress.length){
            //regeocode.formattedAddress;
            /**
             *  第一步，执行区域判断－－－－－－－－－－－－－－－－－
             */
            //无论是否是时间问题，首先都要进行区域判断
            BOOL isDesignated = false;
            // 遍历用户是否在指定的打卡区域
            ATGetClockLocationListModel *currnetModel;
            for (ATGetClockLocationListModel *model in _clockRuleModel.LocationList) {
                isDesignated = [self.clockViewBL calculateWhetherInDesignatedAreasWithCLat:[lat doubleValue] cLog:[lon doubleValue] designatedLat:[model.Lat doubleValue] designatedLog:[model.Lon doubleValue] distance:model.Offset.floatValue];
                if (YES == isDesignated) {//在指定区域
                    currnetModel = model;
                    break;
                }
            }
            /**
             *  第二步，执行时间判断 －－－－－－－－－－－－－－－－－
             */
            //如果时间不对，或者不在指定区域内，都显示打卡异常
            if (_signType == k_Sign_OutOnDuty) {
                self.punchAlertView.location = isDesignated?currnetModel.Location:self.currentRegocode.formattedAddress;
                [self punchCardRequestFromServer];
            }
            else{ //外勤不要弹窗
                BOOL isStatueInCorrect = !isDesignated || ![self CorrectTimeWithType:_signType];
                [self showAlterViewWithLocation:currnetModel?currnetModel.Location:self.currentRegocode.formattedAddress
                                          Title:isStatueInCorrect?k_Operation_Error:k_Operation_Normal];
            }
        }else{
            [self postError:@"没有获取到打卡地点信息，请检查是否开启网络或定位服务" duration:3];
            return;
        }
        
    }else{
        [self postError:@"为获取打卡地点信息，请检查设置" duration:3];
        return;
    }
    
    
    
}





//显示弹窗
- (void)showAlterViewWithLocation:(NSString *)locaiton Title:(NSString *)title
{
    [self.view addSubview:self.punchAlertView];
    self.punchAlertView.title = title?:@"";
    self.punchAlertView.location = locaiton?:@"";
    self.punchAlertView.remark = @"";
    self.punchAlertView.statue = [title isEqualToString:k_Operation_Normal]?k_CurrentStatus_Normal:k_CurrentStatus_Error;
    [self.punchAlertView writeText:^(NSString *remark) {
        _remark = remark;
        [self punchCardRequestFromServer];
    }];
}

- (BOOL)CorrectTimeWithType:(SignTypes)type
{
    switch (type) {
        case k_Sign_OnDuty:  //上班
        {
            //上班
            if (_clockRuleModel.OnWorkTime.longLongValue == 0 ||
                _currentTimestamp.longLongValue <= _clockRuleModel.OnWorkTime.longLongValue) {
                return YES;
            }
            return NO;
        }
            break;
        case k_Sign_OffDuty: //下班
        {
            //上班
            if (_clockRuleModel.OffWorkTime.longLongValue == 0 ||
                _currentTimestamp.longLongValue >= _clockRuleModel.OffWorkTime.longLongValue) {
                return YES;
            }
            return NO;
        }
        case k_Sign_OutOnDuty: //外勤
        {
            return YES;
        }
            break;
        case k_Sign_Unknow: //未知
        {
            
        }
            break;
    }
    return NO;
}


#pragma mark - setterAndGetter
- (UIView *)dailyAttBgView {
    if (!_dailyAttBgView) {
        _dailyAttBgView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_dailyAttBgView addSubview:self.dailyAttHeadView];
        [_dailyAttBgView addSubview:self.dailyAttView];
    }
    
    return _dailyAttBgView;
}

- (ATDailyAttendanceHeadView *)dailyAttHeadView {
    if (!_dailyAttHeadView) {
        _dailyAttHeadView = [[ATDailyAttendanceHeadView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 200)];
    }
    
    return _dailyAttHeadView;
}

- (ATDailyAttendanceView *)dailyAttView {
    if (!_dailyAttView) {
        _dailyAttView = [[ATDailyAttendanceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dailyAttHeadView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.dailyAttHeadView.frame) - 64)];
        self.dailyAttAdapter = [[ATDailyAttendanceAdapter alloc] init];
        self.dailyAttAdapter.adapterDelegate = self;
        [_dailyAttView setTableViewAdapter:self.dailyAttAdapter];
    }
    
    return _dailyAttView;
}

- (UIView *)goOutAttBgView {
    if (!_goOutAttBgView) {
        _goOutAttBgView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_goOutAttBgView addSubview:self.goOutAttHeadView];
        [_goOutAttBgView addSubview:self.goOutAttView];
    }
    
    return _goOutAttBgView;
}

- (ATGoOutAttendanceHeadView *)goOutAttHeadView {
    if (!_goOutAttHeadView) {
        _goOutAttHeadView = [[ATGoOutAttendanceHeadView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 200)];
    }
    
    return _goOutAttHeadView;
}

- (ATGoOutAttendanceView *)goOutAttView {
    if (!_goOutAttView) {
        _goOutAttView = [[ATGoOutAttendanceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goOutAttHeadView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.goOutAttHeadView.frame) - 64)];
        self.goOutAttAdapter = [[ATGoOutAttendanceAdapter alloc] init];
        self.goOutAttAdapter.adapterDelegate = self;
        
        [self.goOutAttAdapter goToEditingRemark:^(ATPunchCardModel *model) {
            
        }];
        [_goOutAttView setTableViewAdapter:self.goOutAttAdapter];
    }
    
    return _goOutAttView;
}

- (ATPunchAlertView *)punchAlertView {
    if (!_punchAlertView) {
        _punchAlertView = [[ATPunchAlertView alloc] initWithFrame:self.view.bounds];
    }
    
    return _punchAlertView;
}

- (ATClockInteractor *)interactor {
    if (!_interactor) {
        _interactor = [[ATClockInteractor alloc] init];
        _interactor.baseController = self;
    }
    
    return _interactor;
}

- (ATClockViewBL *)clockViewBL {
    if (!_clockViewBL) {
        _clockViewBL = [ATClockViewBL new];
    }
    
    return _clockViewBL;
}

@end
