//
//  HealthCenterDetectViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterDetectViewController.h"
#import "RecordHealthInfo.h"
#import "HMSwitchView.h"
#import "HealthCenterDetectRecordViewController.h"

@interface HealthCenterDetectViewController ()
<TaskObserver,
HMSwitchViewDelegate>
{
    UIScrollView* switchScrollView;
    HMSwitchView* switchview;
    
    NSArray* detectItems;
    HealthCenterDetectRecordViewController* vcDetectRecord;
    
    NSInteger detectIndex;
}
@end

@implementation HealthCenterDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    switchScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    //switchScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:switchScrollView];
    
    
//    [switchScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.view);
//        make.top.equalTo(self.view);
//        make.height.mas_equalTo(@49);
//    }];
    
    [switchScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthCenterDetectEnumTask" taskParam:nil TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (detectItems)
    {
        [self createDetectResultController:detectIndex];
    }
    
}

- (void) createDetectCells:(NSArray*) items
{
    if (switchview) {
        [switchview removeFromSuperview];
        switchview = nil;
    }
    
    if (!items || 0 == items.count)
    {
        return;
    }
    
    detectItems = [NSArray arrayWithArray:items];
    
    
    CGFloat minCellWidth = kScreenWidth/5;
    CGFloat cellWidth = kScreenWidth / items.count;
    if (cellWidth < minCellWidth)
    {
        cellWidth = minCellWidth;
    }
    
    CGFloat totalWidth = cellWidth * items.count;
    //[switchScrollView setContentSize:CGSizeMake(totalWidth, 49)];
    
    switchview = [[HMSwitchView alloc]initWithFrame:CGRectMake(0, 0, totalWidth, 49)];
    [switchScrollView setContentSize:switchview.size];
    [switchScrollView addSubview:switchview];
   
    NSArray* detectTitles = [detectItems valueForKey:@"kpiName"];
    [switchview createCells:detectTitles];
    [switchview setDelegate:self];
    UIEdgeInsets inset = switchScrollView.contentInset;
  
    inset.bottom = 0;
    [switchScrollView setContentInset:inset];
}


- (NSString*) detectRecordControllerClassName:(NSString*)kpiCode
{
    NSString* classname = nil;
    if (!kpiCode || 0== kpiCode.length)
    {
        return classname;
    }
    if ([kpiCode isEqualToString:@"XY"])
    {
        classname = @"HealthCenterBloodPressureDetectRecordViewController";
    }
    if ([kpiCode isEqualToString:@"XL"])
    {
        classname = @"HealthCenterHeartRateDetectRecordViewController";
    }
    if ([kpiCode isEqualToString:@"TZ"])
    {
        classname = @"HealthCenterBodyWeightDetectRecordViewController";
    }
    if ([kpiCode isEqualToString:@"XT"])
    {
        classname = @"HealthCenterBloodSugarDetectRecordViewController";
    }
    if ([kpiCode isEqualToString:@"XZ"])
    {
        classname = @"HealthCenterBloodFatDetectRecordViewController";
    }
    if ([kpiCode isEqualToString:@"OXY"])
    {
        classname = @"HealthCenterBloodOxygenationDetectRecordViewController";
    }
    if ([kpiCode isEqualToString:@"NL"])
    {
        classname = @"HealthCenterUrineVolumeDetectRecordViewController";
    }
    if ([kpiCode isEqualToString:@"HX"])
    {
        classname = @"HealthCenterBreathingDetectRecordViewController";
    }
    
    
    return classname;
}

- (void) createDetectResultController:(NSInteger) switchIndex
{
    detectIndex = switchIndex;
    if (!detectItems || 0 == detectItems.count)
    {
        return;
    }
    
    if (0 > switchIndex || detectItems.count <= switchIndex)
    {
        return;
    }
    
    DeviceDetectRecord* detectItem = detectItems[switchIndex];
    NSString* kpiCode = detectItem.kpiCode;
    
    if (vcDetectRecord)
    {
        if ([vcDetectRecord.kpiCode isEqualToString:kpiCode])
        {
            return;
        }
        [vcDetectRecord.view removeFromSuperview];
        [vcDetectRecord removeFromParentViewController];
        
        vcDetectRecord = nil;
    }
    
    NSString* controllerClassName = [self detectRecordControllerClassName:kpiCode];
    if (!controllerClassName || 0 == controllerClassName.length)
    {
        return;
    }
    
    vcDetectRecord = [[NSClassFromString(controllerClassName) alloc]initWithKpiCode:kpiCode];
    [self addChildViewController:vcDetectRecord];
    [self.view addSubview:vcDetectRecord.view];
    [vcDetectRecord.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(switchScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}



#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex
{
    [self createDetectResultController:selectedIndex];
}

#pragma mark TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (detectItems && 0 < detectItems.count)
    {
        [self createDetectResultController:detectIndex];
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }

    if ([taskname isEqualToString:@"HealthCenterDetectEnumTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* tempShowArray = (NSArray*) taskResult;
            
            [self createDetectCells:tempShowArray];
            
        }
    }
}

- (BOOL) detectItemNeedRefresh:(NSArray*) items
{
    if (!detectItems || detectItems.count != items.count)
    {
        return YES;
    }
    
    for (DeviceDetectRecord* record in items)
    {
        BOOL isExisted = NO;
        for (DeviceDetectRecord* existedRecord in detectItems)
        {
            if ([existedRecord.kpiCode isEqualToString:record.kpiCode])
            {
                isExisted = YES;
            }
        }
        if (!isExisted)
        {
            return YES;
        }
    }
    
    return NO;
}

@end
