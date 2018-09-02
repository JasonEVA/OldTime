//
//  BloodPressureThreeDetectViewController.m
//  HMClient
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodPressureThreeDetectViewController.h"
#import "BloodPressureDetectSetUpTableViewCell.h"
#import "BloodPressureThreeDetectTableViewCell.h"
#import "BloodPressurePeriodSelectViewController.h"
#import "BloodPressureThriceDetectModel.h"
#import "BodyPressureDetectStartViewController.h"
#import "BloodPressureThriceDetectSuggestTableViewCell.h"

#import "UIBarButtonItem+BackExtension.h"
#import "DetectRecord.h"
#import "HealthRecodUpLoadSuccessView.h"

#import "DetectSceneSelectViewController.h"


static NSString *const BloodPressureDetectResultNotify = @"BloodPressureDetectResultValue";
static NSString *const BloodPressureSymptomNotify = @"BloodPressureSymptomValue";

static NSString *const BloodPressureDetectTimeCompare = @"onceDetectTime";
static NSString *const BloodPressureUploadNumbers = @"BloodPressureDetectTimes";

#define tableHeaderViewHeight 95

typedef NS_ENUM(NSInteger, ThreeDetectTpye) {
    ThreeDetectTpye_SuggestSection,
    ThreeDetectTpye_DataSection,
    ThreeDetectTpye_DetectSection,
    ThreeDetectTpye_SetUpSection,
    ThreeDetectTpyeMaxSection,
};

typedef NS_ENUM(NSInteger, ThreeDetectSetUpTpye) {
    ThreeDetectSetUpTpye_period,
    ThreeDetectSetUpTpye_Status,
    ThreeDetectSetUpTpye_symptom,
    ThreeDetectSetUpTpye_scene,     //测量环境
    ThreeDetectSetUpTpyeMaxIndex,
};


@interface BloodPressureThreeDetectViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
{
    int detectTimes;
    DetectRecord *record;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) NSArray *symptomArray;
@property (nonatomic, strong) NSMutableArray *symptomNameArray;
@property (nonatomic, strong) NSMutableArray *symptomIDArray;
@property (nonatomic, strong) NSMutableArray *detectDataArray;

@property (nonatomic, copy) NSString *periodStr;
@property (nonatomic, copy) NSString *testTimeId;
@property (nonatomic, copy) NSString *bodyStatusStr;
@property (nonatomic, copy) NSString *bodyStatusId;
@property (nonatomic, copy) NSString *symptomsStr;

@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, strong) HealthRecodUpLoadSuccessView *upLoadSuccessView;

@property (nonatomic, copy) NSString *onceDetectTime;
@property (nonatomic, strong) DetectSceneModel* sceneModel;
@property (nonatomic, copy) NSString *userId;
@end

@implementation BloodPressureThreeDetectViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"测血压"];
    
    //测量状态取值
    [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureThriceDetectBodyStatusTask" taskParam:nil TaskObserver:self];
    _sceneModel = [[DetectSceneModel alloc] init];
    self.sceneModel.name = @"义诊";
    self.sceneModel.id = @"4";
    
    [self configElements];
    
    //监听点击返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(bloodPressurePageBackUp)];
}

#pragma mark - Interface Method
- (void)bloodPressurePageBackUp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //上传成功和放弃数据时删除保存的时间
    if ([defaults objectForKey:BloodPressureDetectTimeCompare]) {
        [defaults removeObjectForKey:BloodPressureDetectTimeCompare];
        [defaults synchronize];
    }
    
    //上传成功和放弃数据时删除，手动录入or设备
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"XYManualInputTpye"]) {
        [userDefaults removeObjectForKey:@"XYManualInputTpye"];
        [userDefaults synchronize];
    }
    
    [self showAlertMessage:@"您的数据尚未提交，是否离开此页面" cancelTitle:@"取消" cancelClicked:nil confirmTitle:@"确定" confirmClicked:^{
            [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Private Method
- (void)configElements {
    
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置通知
- (void)configData {
    
    //第一次进入本页面
    if (self.paramObject && [self.paramObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dicBloodPressureResult = (NSDictionary *)self.paramObject;
        [self detectDataWithDictionary:dicBloodPressureResult];
        
        //把第一次进入页面的测量页面删除
//        NSArray *vcs = self.navigationController.viewControllers;
//        NSMutableArray *mutvcs = [NSMutableArray arrayWithArray:vcs];
//        [mutvcs enumerateObjectsUsingBlock:^(HMBasePageViewController *VC, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([VC isKindOfClass:[BodyPressureDetectStartViewController class]]) {
//                [mutvcs removeObject:VC];
//            }
//        }];
//        [self.navigationController setViewControllers:[NSArray arrayWithArray:mutvcs] animated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BloodPressureDetectResultNotification:) name:BloodPressureDetectResultNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BloodPressureSymptomsNotification:) name:BloodPressureSymptomNotify object:nil];
}

#pragma mark -- Notification
//通知传值 症状值
- (void)BloodPressureSymptomsNotification:(NSNotification *)notification
{
    self.symptomArray = notification.object;

    if (kArrayIsEmpty(self.symptomArray)) {
        _symptomsStr = @"";
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:ThreeDetectSetUpTpye_symptom inSection:ThreeDetectTpye_SetUpSection], nil] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    if (!_symptomIDArray) {
        _symptomIDArray = [[NSMutableArray alloc] init];
    }
    
    if (!_symptomNameArray) {
        _symptomNameArray = [[NSMutableArray alloc] init];
    }
    
    [_symptomIDArray removeAllObjects];
    [_symptomNameArray removeAllObjects];
    
    [self.symptomArray enumerateObjectsUsingBlock:^(BloodPressureThriceDetectModel *symptomModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.symptomNameArray addObject:symptomModel.name];
        [self.symptomIDArray addObject:symptomModel.ID];
    }];
    
    _symptomsStr = [self.symptomNameArray componentsJoinedByString:@"、"];
    [self.tableView reloadData];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:ThreeDetectSetUpTpye_symptom inSection:ThreeDetectTpye_SetUpSection], nil] withRowAnimation:UITableViewRowAnimationNone];
}

//通知传值 血压值
- (void)BloodPressureDetectResultNotification:(NSNotification *)notification
{
    NSDictionary *dicBloodPressureResult = [notification userInfo];
    [self detectDataWithDictionary:dicBloodPressureResult];
}

//测量数据
- (void)detectDataWithDictionary:(NSDictionary *)dicBloodPressureResult
{
    if (kDictIsEmpty(dicBloodPressureResult)) {
        return;
    }
    
    self.userId = dicBloodPressureResult[@"userId"];
    
    NSDate *excDate = [NSDate dateWithString:dicBloodPressureResult[@"testTime"] formatString:@"yyyy-MM-dd HH:mm:ss"];
    _onceDetectTime = [excDate formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_onceDetectTime forKey:BloodPressureDetectTimeCompare];
    [defaults synchronize];

    if (!_detectDataArray) {
        _detectDataArray = [[NSMutableArray alloc] init];
    }
    [_detectDataArray addObject:dicBloodPressureResult];
    
    if (detectTimes < 3) {
        detectTimes ++;
        //动画刷新某些区
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ThreeDetectTpye_DataSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ThreeDetectTpye_DetectSection] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// 设置约束
- (void)configConstraints {
    
    [self.view addSubview:self.submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(_submitButton.mas_top);
    }];
}

#pragma mark - ButtonClick
- (void)submitButtonClick
{
    if (kStringIsEmpty(_periodStr)) {
        [self showAlertMessage:@"请选择时段"];
        return;
    }
    
    if (kStringIsEmpty(_bodyStatusStr)) {
        [self showAlertMessage:@"请选择测量状态"];
        return;
    }
    
    if (kArrayIsEmpty(_detectDataArray))
    {
        [self showAlertMessage:@"请点击按钮，进行血压测量"];
    }
    
    //上传
    [self BloodPressureThriceDetectTaskRequest];
//    if (detectTimes >= 2) {
//
//    }
//    else{
//        [self showAlertMessage:@"经医生建议，为保证血压数据的准确性，最好测量3次血压！确认提交吗" cancelTitle:@"提交" cancelClicked:^{
//            //上传
//            [self BloodPressureThriceDetectTaskRequest];
//            
//        } confirmTitle:@"继续测量" confirmClicked:^{
//            //跳转测量页面
//            [HMViewControllerManager createViewControllerWithControllerName:@"BodyPressureDetectStartViewController" ControllerObject:nil];
//        }];
//    }
}
//上传数据
- (void)BloodPressureThriceDetectTaskRequest
{
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    
    [dicPost setValue:_testTimeId forKey:@"testTimeId"];
    [dicPost setValue:_bodyStatusId forKey:@"bodyStatusId"];
    
    if (self.userId) {
        [dicPost setObject:self.userId forKey:@"userId"];
    }
    if (!kArrayIsEmpty(self.symptomIDArray)) {
        [dicPost setValue:self.symptomIDArray forKey:@"symptomList"];
    }
    [dicPost setValue:_detectDataArray forKey:@"testValue"];
    [dicPost setValue:@"XY" forKey:@"kpiCode"];
    
    if (self.sceneModel && self.sceneModel.id &&
        self.sceneModel.id.length > 0)
    {
        [dicPost setValue:self.sceneModel.id forKey:@"testEnvId"];
    }
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureThriceDetectTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return ThreeDetectTpyeMaxSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
            
        case ThreeDetectTpye_DataSection:
            return _detectDataArray.count;
            break;
        
        case ThreeDetectTpye_DetectSection:
        case ThreeDetectTpye_SuggestSection:
            return 1;
            break;
            
        case ThreeDetectTpye_SetUpSection:
            return ThreeDetectSetUpTpyeMaxIndex;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == ThreeDetectTpye_DataSection) {
        return 0.001;
    }
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case ThreeDetectTpye_SuggestSection:
            return 80 * kScreenScale;
            break;
            
        case ThreeDetectTpye_DetectSection:
            return detectTimes>=3 ? 0 : 65 * kScreenScale;
            break;
            
        case ThreeDetectTpye_DataSection:
            return  65 * kScreenScale;
            break;
            
        case ThreeDetectTpye_SetUpSection:
            return 45 * kScreenScale;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == ThreeDetectTpye_DetectSection || section == ThreeDetectTpye_SuggestSection) {
        return 0.001;
    }
    return 40 * kScreenScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40 * kScreenScale)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [headerView addSubview:lbtitle];
    [lbtitle setFont:[UIFont font_30]];
    [lbtitle setTextColor:[UIColor commonTextColor]];
    
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(12.5);
        make.centerY.mas_equalTo(headerView);
    }];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    [headerView addSubview:promptLabel];
    [promptLabel setFont:[UIFont font_28]];
    [promptLabel setTextColor:[UIColor colorWithHexString:@"f6a623"]];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-12.5);
        make.centerY.mas_equalTo(headerView);
    }];
    
    switch (section) {
        case ThreeDetectTpye_DataSection:
        {
            [lbtitle setText:@"测血压"];
            [promptLabel setText:@"测量3次结果更精准"];
            break;
        }
            
        case ThreeDetectTpye_SetUpSection:
        {
            [lbtitle setText:@"填写测量信息"];
            break;
        }

        default:
            break;
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    switch (indexPath.section) {
            
        case ThreeDetectTpye_SuggestSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[BloodPressureThriceDetectSuggestTableViewCell at_identifier]];
            break;
        }
            
        case ThreeDetectTpye_DataSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[BloodPressureThriceDetectDataTableViewCell at_identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell setBloodPressureValue:_detectDataArray[indexPath.row]];
            break;
        }
            
        case ThreeDetectTpye_DetectSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[BloodPressureThreeDetectTableViewCell at_identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if (detectTimes > 0) {
                [cell setDetectButtonTitle:@"再次测量"];
            }
            if (detectTimes >= 3) {
                [cell setDetectButtonHidden];
            }
            
            break;
        }
            
        case ThreeDetectTpye_SetUpSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[BloodPressureDetectSetUpTableViewCell at_identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            switch (indexPath.row) {
                case ThreeDetectSetUpTpye_period:
                {
                    [cell setTitleContent:@"选择时段"];
                    if (kStringIsEmpty(_periodStr)) {
                        [cell setPromptContent:@"请选择测量时段" color:[UIColor commonGrayTextColor]];
                    }else{
                        [cell setPromptContent:_periodStr color:[UIColor commonTextColor]];
                    }
                    
                    break;
                }
                    
                case ThreeDetectSetUpTpye_Status:
                {
                    [cell setTitleContent:@"选择状态"];
                    if (kStringIsEmpty(_bodyStatusStr)) {
                        [cell setPromptContent:@"请选择测量状态" color:[UIColor commonGrayTextColor]];
                    }else{
                        [cell setPromptContent:_bodyStatusStr color:[UIColor commonTextColor]];
                    }
                    
                    break;
                }
                    
                case ThreeDetectSetUpTpye_symptom:
                {
                    [cell setTitleContent:@"选择症状"];
                    
                    if (kStringIsEmpty(_symptomsStr)){
                        _symptomsStr = @"无症状";
                        [cell setPromptContent:_symptomsStr color:[UIColor commonTextColor]];
                    }else{
                        [cell setPromptContent:_symptomsStr color:[UIColor commonTextColor]];
                    }
                    break;
                }
                case ThreeDetectSetUpTpye_scene:
                {
                    [cell setTitleContent:@"测量环境"];
                    [cell setPromptContent:self.sceneModel.name color:[UIColor commonTextColor]];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            
        case ThreeDetectTpye_DetectSection:         //测量血压
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"BodyPressureDetectStartViewController" ControllerObject:self.userId];
            break;
        }
            
        case ThreeDetectTpye_SetUpSection:
        {
            switch (indexPath.row) {
                case ThreeDetectSetUpTpye_period:   //时段选择
                {
                    [BloodPressurePeriodSelectViewController createWithParentViewController:self setUpType:@"period" selectblock:^(BloodPressureThriceDetectModel *model) {
                        
                        if (kStringIsEmpty(model.name)) {
                            return ;
                        }
                        _periodStr = model.name;
                        _testTimeId = model.ID;
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:ThreeDetectSetUpTpye_period inSection:ThreeDetectTpye_SetUpSection], nil] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    break;
                }
                    
                case ThreeDetectSetUpTpye_Status:   //状态选择
                {
                    [BloodPressurePeriodSelectViewController createWithParentViewController:self setUpType:@"stauts" selectblock:^(BloodPressureThriceDetectModel *model) {
                        
                        if (kStringIsEmpty(model.name)) {
                            return ;
                        }
                        _bodyStatusStr = model.name;
                        _bodyStatusId = model.ID;
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:ThreeDetectSetUpTpye_Status inSection:ThreeDetectTpye_SetUpSection], nil] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    break;
                }
                    
                case ThreeDetectSetUpTpye_symptom:  //症状选择
                {
                    [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureSymptomSelectViewController" ControllerObject:self.symptomArray];
                    break;
                }
                case ThreeDetectSetUpTpye_scene:
                {
                    //选择测量环境
                    __weak typeof(self) weakSelf = self;
                    [DetectSceneSelectViewController showWithSelectHandle:^(DetectSceneModel *sceneModel)
                     {
                         if (weakSelf)
                         {
                             weakSelf.sceneModel = sceneModel;
                             
                             NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ThreeDetectTpye_SetUpSection inSection:ThreeDetectSetUpTpye_scene];
                             
                             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                         }
                     }];
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[BloodPressureThriceDetectSuggestTableViewCell class] forCellReuseIdentifier:[BloodPressureThriceDetectSuggestTableViewCell at_identifier]];
        [_tableView registerClass:[BloodPressureDetectSetUpTableViewCell class] forCellReuseIdentifier:[BloodPressureDetectSetUpTableViewCell at_identifier]];
        [_tableView registerClass:[BloodPressureThreeDetectTableViewCell class] forCellReuseIdentifier:[BloodPressureThreeDetectTableViewCell at_identifier]];
        [_tableView registerClass:[BloodPressureThriceDetectDataTableViewCell class] forCellReuseIdentifier:[BloodPressureThriceDetectDataTableViewCell at_identifier]];
    }
    return _tableView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont font_28]];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:[UIColor mainThemeColor]];
        [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (HealthRecodUpLoadSuccessView *)upLoadSuccessView {
    if (!_upLoadSuccessView) {
        _upLoadSuccessView =[HealthRecodUpLoadSuccessView new];
    }
    return _upLoadSuccessView;
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
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
    
    if ([taskname isEqualToString:@"BloodPressureThriceDetectBodyStatusTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            NSArray *BodyStatusList = (NSArray *)taskResult;
            if (!kArrayIsEmpty(BodyStatusList)) {
                BloodPressureThriceDetectModel *model = [BodyStatusList objectAtIndex:0];
                _bodyStatusStr = model.name;
                _bodyStatusId = model.ID;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:ThreeDetectSetUpTpye_Status inSection:ThreeDetectTpye_SetUpSection], nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    
    if (taskResult && [taskResult isKindOfClass:[NSDictionary class]]) {
        // 监测结果上传成功，监测图表刷新通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOADTESTSUCCESSED" object:nil];

        _recordId = [(NSString*) taskResult valueForKey:@"testDataId"];
        
        if (kStringIsEmpty(_recordId)) {
            return;
        }
        
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        NSString* kpiCode = nil;
        if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
        {
            kpiCode = [dicParam valueForKey:@"kpiCode"];
        }
        if (kStringIsEmpty(kpiCode)){
            return;
        }
        
        record = [[DetectRecord alloc]init];
        [record setTestDataId:_recordId];
        
        //上传成功和放弃数据时删除保存的时间
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:BloodPressureDetectTimeCompare]) {
            [userDefaults removeObjectForKey:BloodPressureDetectTimeCompare];
            [userDefaults synchronize];
        }
        
        //上传成功和放弃数据时删除，手动录入or设备
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"XYManualInputTpye"]) {
            [userDefaults removeObjectForKey:@"XYManualInputTpye"];
            [userDefaults synchronize];
        }
        
        [self.upLoadSuccessView showSuccessView];
        [self.upLoadSuccessView jumpToNextStep:^{
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
            }];
        }];
        
    }
}

@end
