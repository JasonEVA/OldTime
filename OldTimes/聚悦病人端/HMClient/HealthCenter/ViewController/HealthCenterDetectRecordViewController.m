//
//  HealthCenterDetectRecordViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterDetectRecordViewController.h"
#import "LastDetectRecord.h"
#import "CenterDetectDegreeView.h"

@interface HealthCenterDetectRecordViewController ()
<TaskObserver>
{
    
    UILabel* lbDetectDate;
    UILabel* lbDetectTime;
    
    
    
}
@end

@implementation HealthCenterDetectRecordViewController

- (void) loadView
{
    UIControl* detectControl = [[UIControl alloc]init];
    [self setView:detectControl];
    [detectControl addTarget:self action:@selector(detectControlClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) detectControlClicked:(id) sender
{
    [self entryDetectController];
}

- (void) entryDetectController
{
    
}

- (id) initWithKpiCode:(NSString*) code
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _kpiCode = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSubviews];
    [self.view showBottomLine];
    
    
    

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //加载数据
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    [dicResult setValue:_kpiCode forKey:@"kpiCode"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"LastDetectRecordTask" taskParam:dicResult TaskObserver:self];
}

- (void) createSubviews
{
    degreeview = [[CenterDetectDegreeView alloc]init];
    [self.view addSubview:degreeview];
    [degreeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.left.equalTo(self.view).with.offset(12.5);
    }];
    //[degreeview setBackgroundColor:[UIColor redColor]];
    [degreeview setUserInteractionEnabled:NO];
    lbKpiName = [[UILabel alloc]init];
    [self.view addSubview:lbKpiName];
    [lbKpiName setFont:[UIFont font_28]];
    [lbKpiName setTextColor:[UIColor commonGrayTextColor]];
    
    [lbKpiName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(degreeview.mas_right).with.offset(18);
        make.top.equalTo(self.view).with.offset(22);
    }];
    
    lbDetectValue = [[UILabel alloc]init];
    [self.view addSubview:lbDetectValue];
    [lbDetectValue setFont:[UIFont systemFontOfSize:23]];
    [lbDetectValue setTextColor:[UIColor commonTextColor]];
    [lbDetectValue setText:@"--"];
    [lbDetectValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbKpiName);
        make.top.equalTo(lbKpiName.mas_bottom).with.offset(10);
    }];
    
    lbDetectUnit = [[UILabel alloc]init];
    [self.view addSubview:lbDetectUnit];
    [lbDetectUnit setFont:[UIFont font_22]];
    [lbDetectUnit setTextColor:[UIColor commonGrayTextColor]];
    
    [lbDetectUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDetectValue.mas_right).with.offset(2);
        make.bottom.equalTo(lbDetectValue).with.offset(-4);
    }];
    
    [self createDetectTimeLable];
}

- (void) createDetectTimeLable
{
    lbDetectTime = [[UILabel alloc]init];
    [self.view addSubview:lbDetectTime];
    [lbDetectTime setFont:[UIFont font_22]];
    [lbDetectTime setTextColor:[UIColor commonGrayTextColor]];
    
    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.view).with.offset(22);
    }];
    
    lbDetectDate = [[UILabel alloc]init];
    [self.view addSubview:lbDetectDate];
    [lbDetectDate setFont:[UIFont font_22]];
    [lbDetectDate setTextColor:[UIColor commonGrayTextColor]];
    
    [lbDetectDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbDetectTime.mas_left).with.offset(-8);
        make.top.equalTo(self.view).with.offset(22);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) detectRecordLoaded:(LastDetectRecord*)record
{
    NSString* detectDate = [record dateStr];
    NSString* detectTime = [record timeStr];
    
    [lbDetectDate setText:detectDate];
    [lbDetectTime setText:detectTime];
    
    [lbKpiName setText:record.kpiTitle];
    [self setRecordValue:record];
    [self setRecordUnit:record];
}

- (void) setRecordUnit:(LastDetectRecord*) record
{
    [lbDetectUnit setText:record.unit];
}

- (void) setRecordValue:(LastDetectRecord*) record
{
    
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        //[self showAlertMessage:errorMessage];
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
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if (taskResult && [taskResult isKindOfClass:[LastDetectRecord class]])
    {
        LastDetectRecord* lastRecord = (LastDetectRecord*) taskResult;
        [self detectRecordLoaded:lastRecord];
    }
}

@end

@implementation HealthCenterBloodPressureDetectRecordViewController

- (void) setRecordValue:(LastDetectRecord*) record
{
    LastBloodPressureDetectRecord* lastRecord = (LastBloodPressureDetectRecord*) record;
    
    [lbDetectValue setText:[NSString stringWithFormat:@"%ld/%ld", lastRecord.SSY, lastRecord.SZY]];
    
    NSString* imageName = [NSString stringWithFormat:@"血压_%@", record.alertResultGrade];
    [degreeview setImageName:imageName];
}

- (void) entryDetectController
{
    //健康计划－滚动区域－血压
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－滚动区域－血压"];
    //跳转到血压监测界面
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyPressureDetectStartViewController" ControllerObject:nil];
}

@end

@implementation HealthCenterHeartRateDetectRecordViewController

- (void) setRecordValue:(LastDetectRecord*) record
{
    LastHeartRateDetectRecord* lastRecord = (LastHeartRateDetectRecord*) record;
    
    [lbDetectValue setText:[NSString stringWithFormat:@"%ld", lastRecord.heartRate]];
    
    NSString* imageName = [NSString stringWithFormat:@"心率_%@", record.alertResultGrade];
    [degreeview setImageName:imageName];
    
}

- (void) entryDetectController
{
    //健康计划－滚动区域－心率
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－滚动区域－心率"];
    //跳转到心率监测界面
    [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectStartViewController" ControllerObject:nil];
}

@end

@interface HealthCenterBodyWeightDetectRecordViewController ()
{
    UILabel* lbBMIValue;
}
@end

@implementation HealthCenterBodyWeightDetectRecordViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    lbBMIValue = [[UILabel alloc]init];
    [self.view addSubview:lbBMIValue];
    
    [lbBMIValue setFont:[UIFont font_26]];
    [lbBMIValue setTextColor:[UIColor commonGrayTextColor]];
    [lbBMIValue setText:@"(BMI:--)"];
    [lbBMIValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-12.5);
        make.bottom.equalTo(lbDetectUnit);
    }];
}

- (void) setRecordValue:(LastDetectRecord*) record
{
    LastBodyWeightDetectRecord* lastRecord = (LastBodyWeightDetectRecord*) record;
    
    [lbDetectValue setText:[NSString stringWithFormat:@"%.1f", lastRecord.bodyWeight]];
    
    [lbBMIValue setText:[NSString stringWithFormat:@"(BMI:%.1f)", lastRecord.bodyBMI]];
    
    NSString* imageName = [NSString stringWithFormat:@"体重_%@", record.alertResultGrade];
    [degreeview setImageName:imageName];
}

- (void) entryDetectController
{
    //健康计划－滚动区域－体重
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－滚动区域－体重"];
    //跳转到体重监测界面
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightDetectStartViewController" ControllerObject:nil];
}

@end

@implementation HealthCenterBloodSugarDetectRecordViewController

- (void) setRecordValue:(LastDetectRecord*) record
{
    LastBloodSugarDetectRecord* lastRecord = (LastBloodSugarDetectRecord*) record;
    
    [lbDetectValue setText:[NSString stringWithFormat:@"%.1f", lastRecord.bloodSugar]];
    NSString* imageName = [NSString stringWithFormat:@"血糖_%@", record.alertResultGrade];
    [degreeview setImageName:imageName];
}

- (void) entryDetectController
{
    
    //跳转到血糖监测界面
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectStartViewController" ControllerObject:nil];
}

@end

@interface HealthCenterBloodFatDetectRecordViewController ()
{
    UILabel* lbTGName;
    UILabel* lbTGValue;
    UILabel* lbTGUnit;
    
    UILabel* lbTCName;
    UILabel* lbTCValue;
    UILabel* lbTCUnit;
    
    UILabel* lbHDLCName;
    UILabel* lbHDLCValue;
    UILabel* lbHDLCUnit;
    
    UILabel* lbLDLCName;
    UILabel* lbLDLCValue;
    UILabel* lbLDLCUnit;
}
@end


@implementation HealthCenterBloodFatDetectRecordViewController

- (void) createSubviews
{
    [self createDetectTimeLable];
    
    lbKpiName = [[UILabel alloc]init];
    [self.view addSubview:lbKpiName];
    [lbKpiName setFont:[UIFont font_28]];
    [lbKpiName setTextColor:[UIColor commonGrayTextColor]];
    
    [lbKpiName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.top.equalTo(self.view).with.offset(10);
    }];

    lbTGName = [[UILabel alloc]init];
    [self.view addSubview:lbTGName];
    [lbTGName setFont:[UIFont font_26]];
    [lbTGName setTextColor:[UIColor commonGrayTextColor]];
    [lbTGName setText:@"TG:"];
    [lbTGName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbKpiName);
        make.top.equalTo(lbKpiName.mas_bottom).with.offset(11);
    }];
    
    lbTGValue = [[UILabel alloc]init];
    [self.view addSubview:lbTGValue];
    [lbTGValue setFont:[UIFont font_34]];
    [lbTGValue setTextColor:[UIColor commonTextColor]];
    [lbTGValue setText:@"--"];
    [lbTGValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTGName.mas_right).with.offset(2);
        make.bottom.equalTo(lbTGName.mas_bottom).with.offset(2);
    }];
       
    lbTGUnit = [[UILabel alloc]init];
    [self.view addSubview:lbTGUnit];
    [lbTGUnit setFont:[UIFont font_26]];
    [lbTGUnit setTextColor:[UIColor commonGrayTextColor]];
    [lbTGUnit setText:@"mmol/L"];
    [lbTGUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTGValue.mas_right).with.offset(2);
        make.bottom.equalTo(lbTGName.mas_bottom);
    }];
    
    lbTCName = [[UILabel alloc]init];
    [self.view addSubview:lbTCName];
    [lbTCName setFont:[UIFont font_26]];
    [lbTCName setTextColor:[UIColor commonGrayTextColor]];
    [lbTCName setText:@"TC:"];
    [lbTCName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kScreenWidth/2);
        make.top.equalTo(lbKpiName.mas_bottom).with.offset(8);
    }];
    
    lbTCValue = [[UILabel alloc]init];
    [self.view addSubview:lbTCValue];
    [lbTCValue setFont:[UIFont font_34]];
    [lbTCValue setTextColor:[UIColor commonTextColor]];
    [lbTCValue setText:@"--"];
    [lbTCValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTCName.mas_right).with.offset(2);
        make.bottom.equalTo(lbTCName.mas_bottom).with.offset(2);
    }];
    
    lbTCUnit = [[UILabel alloc]init];
    [self.view addSubview:lbTCUnit];
    [lbTCUnit setFont:[UIFont font_26]];
    [lbTCUnit setTextColor:[UIColor commonGrayTextColor]];
    [lbTCUnit setText:@"mmol/L"];
    [lbTCUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTCValue.mas_right).with.offset(2);
        make.bottom.equalTo(lbTCName.mas_bottom);
    }];
    
    lbHDLCName = [[UILabel alloc]init];
    [self.view addSubview:lbHDLCName];
    [lbHDLCName setFont:[UIFont font_26]];
    [lbHDLCName setTextColor:[UIColor commonGrayTextColor]];
    [lbHDLCName setText:@"HDL-C:"];
    [lbHDLCName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbKpiName);
        make.top.equalTo(lbTGName.mas_bottom).with.offset(11);
    }];
    
    lbHDLCValue = [[UILabel alloc]init];
    [self.view addSubview:lbHDLCValue];
    [lbHDLCValue setFont:[UIFont font_34]];
    [lbHDLCValue setTextColor:[UIColor commonTextColor]];
    [lbHDLCValue setText:@"--"];
    [lbHDLCValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbHDLCName.mas_right).with.offset(2);
        make.bottom.equalTo(lbHDLCName.mas_bottom).with.offset(2);
    }];
    
    lbHDLCUnit = [[UILabel alloc]init];
    [self.view addSubview:lbHDLCUnit];
    [lbHDLCUnit setFont:[UIFont font_26]];
    [lbHDLCUnit setTextColor:[UIColor commonGrayTextColor]];
    [lbHDLCUnit setText:@"mmol/L"];
    [lbHDLCUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbHDLCValue.mas_right).with.offset(2);
        make.bottom.equalTo(lbHDLCName.mas_bottom);
    }];
    
    lbLDLCName = [[UILabel alloc]init];
    [self.view addSubview:lbLDLCName];
    [lbLDLCName setFont:[UIFont font_26]];
    [lbLDLCName setTextColor:[UIColor commonGrayTextColor]];
    [lbLDLCName setText:@"LDL-C:"];
    [lbLDLCName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kScreenWidth/2);
        make.top.equalTo(lbTGName.mas_bottom).with.offset(11);
    }];
    
    lbLDLCValue = [[UILabel alloc]init];
    [self.view addSubview:lbLDLCValue];
    [lbLDLCValue setFont:[UIFont font_34]];
    [lbLDLCValue setTextColor:[UIColor commonTextColor]];
    [lbLDLCValue setText:@"--"];
    [lbLDLCValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbLDLCName.mas_right).with.offset(2);
        make.bottom.equalTo(lbLDLCName.mas_bottom).with.offset(2);
    }];
    
    lbLDLCUnit = [[UILabel alloc]init];
    [self.view addSubview:lbLDLCUnit];
    [lbLDLCUnit setFont:[UIFont font_26]];
    [lbLDLCUnit setTextColor:[UIColor commonGrayTextColor]];
    [lbLDLCUnit setText:@"mmol/L"];
    [lbLDLCUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbLDLCValue.mas_right).with.offset(2);
        make.bottom.equalTo(lbLDLCName.mas_bottom);
    }];

}

- (void) setRecordValue:(LastDetectRecord*) record
{
    LastBloodFatDetectRecord* lastRecord = (LastBloodFatDetectRecord*) record;
    
    [lbTGValue setText:[NSString stringWithFormat:@"%.1f", lastRecord.TG]];
    [lbTCValue setText:[NSString stringWithFormat:@"%.1f", lastRecord.TC]];
    [lbHDLCValue setText:[NSString stringWithFormat:@"%.1f", lastRecord.HDL_C]];
    [lbLDLCValue setText:[NSString stringWithFormat:@"%.1f", lastRecord.LDL_C]];
}

- (void) entryDetectController
{
    //跳转到血脂监测界面
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectStartViewController" ControllerObject:nil];
}


@end


@implementation HealthCenterBloodOxygenationDetectRecordViewController

- (void) setRecordValue:(LastDetectRecord*) record
{
    LastBloodOxygenationDetectRecord* lastRecord = (LastBloodOxygenationDetectRecord*) record;
    
    [lbDetectValue setText:[NSString stringWithFormat:@"%ld", lastRecord.OXY_SUB]];
    
    NSString* imageName = [NSString stringWithFormat:@"血氧_%@", record.alertResultGrade];
    [degreeview setImageName:imageName];
}

- (void) entryDetectController
{
    //跳转到血氧监测界面
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenDetectStartViewController" ControllerObject:nil];
}
@end

@interface HealthCenterUrineVolumeDetectRecordViewController ()
{
    UILabel* lbTimeType;
}
@end

@implementation HealthCenterUrineVolumeDetectRecordViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    lbTimeType = [[UILabel alloc]init];
    [self.view addSubview:lbTimeType];
    
    [lbTimeType setFont:[UIFont font_26]];
    [lbTimeType setTextColor:[UIColor commonGrayTextColor]];
    [lbTimeType setText:@"--"];
    [lbTimeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-12.5);
        make.bottom.equalTo(lbDetectUnit);
    }];
    
   
}

- (void) setRecordValue:(LastDetectRecord*) record
{
    LastUrineVolumeDetectRecord* lastRecord = (LastUrineVolumeDetectRecord*) record;
    
    [lbDetectValue setText:[NSString stringWithFormat:@"%ld", lastRecord.NL_SUB_DAY + lastRecord.NL_SUB_NIGHT]];
    
    [lbTimeType setText:[NSString stringWithFormat:@"(日/夜: %ld/%ld)", lastRecord.NL_SUB_DAY, lastRecord.NL_SUB_NIGHT]];
    
    NSString* imageName = [NSString stringWithFormat:@"尿量_%@", record.alertResultGrade];
    [degreeview setImageName:imageName];

}

- (void) entryDetectController
{
    //跳转到尿量监测界面
    [HMViewControllerManager createViewControllerWithControllerName:@"UrineVolumeDetectStartViewController" ControllerObject:nil];
}
@end

@implementation HealthCenterBreathingDetectRecordViewController

- (void) setRecordValue:(LastDetectRecord*) record
{
    LastBreathingDetectRecord* lastRecord = (LastBreathingDetectRecord*) record;
    
    [lbDetectValue setText:[NSString stringWithFormat:@"%ld", lastRecord.breathrate]];
    
    NSString* imageName = [NSString stringWithFormat:@"呼吸_%@", record.alertResultGrade];
    [degreeview setImageName:imageName];
}

- (void) entryDetectController
{
    //跳转到呼吸监测界面
    [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectStartViewController" ControllerObject:nil];
}
@end
