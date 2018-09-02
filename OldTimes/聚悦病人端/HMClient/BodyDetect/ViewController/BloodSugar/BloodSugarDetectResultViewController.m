//
//  BloodFatDetectResultViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarDetectResultViewController.h"
#import "BloodSugarDetectRecord.h"

#import "BloodSugarResultDetectTimeView.h"
#import "BloodSugarResultView.h"
#import "BloodSugarAddDietView.h"
#import "BloodSugarAddDietViewController.h"

static NSString *const bloodSugarNotificationName = @"bloodSugarNotification";

@interface BloodSugarDetectResultViewController ()<TaskObserver>
{
    UIScrollView* scrollview;
    UIView* contentview;
    BloodSugarResultDetectTimeView* detectTimeView;
    BloodSugarResultView* resultView;
    
    BloodSugarAddDietControl *addDietControl;
    BloodSugarAddDietView *addDietView;
    BloodSugarDietResultView *dietResultView;

    DetectAlertInterrogationControl* interrogationControl;
    DetectRecord* detectRecord;
    NSInteger surveyId;
    NSString* surveyMoudleName;
}
@property (nonatomic, retain) NSArray* photos;
@property (nonatomic, copy) NSString* dietContent;

@end

@implementation BloodSugarDetectResultViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    NSString* btiTitle = @"历史记录";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];
    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont font_30]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
    
    CGRect rtScroll = CGRectMake(0, 0, self.view.width, 504);
    scrollview = [[UIScrollView alloc]initWithFrame:rtScroll];
    [self.view addSubview:scrollview];
    
    
    contentview = [[UIView alloc]initWithFrame:scrollview.bounds];
    [scrollview addSubview:contentview];
    //[contentview setBackgroundColor:[UIColor redColor]];
    [self createResultView];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[DetectRecord class]])
    {
        detectRecord = (DetectRecord*) self.paramObject;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bloodSugarNoti:) name:bloodSugarNotificationName object:nil];
}

- (void)getResultData
{
    NSString* taskname = [self resultTaskName];
    if (taskname)
    {
        //创建任务，获取检测结果数据
        if (recordId && [recordId isKindOfClass:[NSString class]] && 0 < recordId.length)
        {
            NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
            [dicPost setValue:recordId forKey:@"testDataId"];
            
            [self.view showWaitView];
            [[TaskManager shareInstance] createTaskWithTaskName:taskname taskParam:dicPost TaskObserver:self];
        }
    }
    
}

//通知传值
- (void)bloodSugarNoti:(NSNotification *)notification
{
    [self.view closeWaitView];
    [self getResultData];
//    NSDictionary *dic = [notification userInfo];
//    if (kDictIsEmpty(dic)) {
//        [addDietControl isHasDietResult:NO];
//        [dietResultView setHidden:YES];
//        _dietContent = @"";
//        return;
//    }
    
//    [addDietControl showBottomLine];
//    [addDietControl isHasDietResult:YES];
//    [dietResultView setHidden:NO];
//    
//    BloodSugarDetectResult *result = [[BloodSugarDetectResult alloc] init];
//    BloodSugarDetectValue *value = [[BloodSugarDetectValue alloc] init];
//    NSArray *array = (NSArray *)[dic objectForKey:@"Photos"];
//    value.XT_IMGS = array;
//    result.dataDets = value;
//    result.diet = [dic objectForKey:@"diet"];
//    
//    self.photos = array;
//    
//    //dietResultView的高度
//    if (result.dataDets.XT_IMGS.count > 0) {
//        [dietResultView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo([result.diet heightSystemFont:[UIFont font_28] width:ScreenWidth-25]+ 70);
//        }];
//    }
//    else{
//        [dietResultView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo([result.diet heightSystemFont:[UIFont font_28] width:ScreenWidth-25] + 20);
//        }];
//    }
//    [dietResultView setBloodSugarDetectResult:result];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    [targetUser setUserId:curUser.userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarRecordsStartViewController" ControllerObject:targetUser];
}

- (void) createResultView
{
    detectTimeView = [[BloodSugarResultDetectTimeView alloc]init];
    [contentview addSubview:detectTimeView];
    
    resultView = [[BloodSugarResultView alloc]init];
    [contentview addSubview:resultView];
    
    interrogationControl = [[DetectAlertInterrogationControl alloc]init];
    [contentview addSubview:interrogationControl];
    [interrogationControl setHidden:YES];
    [interrogationControl addTarget:self action:@selector(interrogationControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    addDietControl = [[BloodSugarAddDietControl alloc] init];
    [contentview addSubview:addDietControl];
    
    [addDietControl addTarget:self action:@selector(addDietControlClick) forControlEvents:UIControlEventTouchUpInside];
    //[contentview setUserInteractionEnabled:YES];
    
    dietResultView = [[BloodSugarDietResultView alloc] init];
    [contentview addSubview:dietResultView];
    [dietResultView setHidden:YES];
    
    [self subviewLayout];
    
    [scrollview setContentSize:contentview.size];
}

- (void) interrogationControlClicked:(id) sender
{
    SurveyRecord *record = [[SurveyRecord alloc]init];
    
    [record setSurveyId:[NSString stringWithFormat:@"%ld", surveyId]];
    [record setSurveyMoudleName:surveyMoudleName];
    [record setUserId:[NSString stringWithFormat:@"%ld", userId]];
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
}

- (NSString*) resultTaskName
{
    return @"BloodSugarDetectResultTask";
}

#pragma mark -- init
- (void) subviewLayout
{
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.view);
        make.bottom.and.right.equalTo(self.view);
    }];
    
    [contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(scrollview);
        make.width.equalTo(scrollview);
        make.height.mas_equalTo(504 * kScreenScale);
    }];
    
    [detectTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentview);
        make.top.equalTo(contentview);
        make.height.mas_equalTo(@60);
    }];
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentview);
        make.top.equalTo(detectTimeView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@200);
    }];
    
    [interrogationControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(resultView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(45);
    }];
    
    [addDietControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentview);
        make.top.equalTo(resultView.mas_bottom).offset(5);
        make.height.mas_equalTo(@50);
    }];
    
    [dietResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentview);
        make.top.equalTo(addDietControl.mas_bottom);
        make.height.mas_equalTo(@100);
    }];
}

//弹出添加饮食界面
- (void)addDietControlClick
{
    BloodSugarAddDietViewController *addDietVC = [[BloodSugarAddDietViewController alloc] initWithDetectRecord:detectRecord photos:_photos diet:_dietContent];
    [self addChildViewController:addDietVC];
    [addDietVC.view setFrame:self.view.bounds];
    [self.view addSubview:addDietVC.view];
}

- (void) detectResultLoaded:(BloodSugarDetectResult*) result
{
    _photos = @[];
    _dietContent = @"";
    if (!result)
    {
        return;
    }

    if (result.dataDets.XT_IMGS.count > 0 || result.diet.length > 0)
    {
        [addDietControl isHasDietResult:YES];
        [addDietControl showBottomLine];
        
        [dietResultView setHidden:NO];
        [dietResultView setBloodSugarDetectResult:result];
        
        //dietResultView的高度
        if (result.dataDets.XT_IMGS.count > 0) {

            if (kStringIsEmpty(result.diet)) {
                [dietResultView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(@67);
                }];
            }
            else{
                [dietResultView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo([result.diet heightSystemFont:[UIFont font_28] width:ScreenWidth-25]+ 77);
                }];
            }
        }
        else{
            [dietResultView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo([result.diet heightSystemFont:[UIFont font_28] width:ScreenWidth-25] + 20);
            }];
        }
        
        _photos = result.dataDets.XT_IMGS;
        _dietContent = result.diet;
        
        if (![self userIsSelf])
        {
            //用户不是自己
            [addDietControl setHidden:YES];
            [dietResultView setHidden:YES];
        }
    }
    else{
        [addDietControl isHasDietResult:NO];
        [dietResultView setHidden:YES];
        if (0 < result.surveyId && result.surveyMoudleName && 0 < result.surveyMoudleName.length)
        {
            surveyId = result.surveyId;
            userId = result.userId;
            surveyMoudleName = result.surveyMoudleName;
            [interrogationControl setHidden:NO];
            [interrogationControl setSurveyModuleName:result.surveyMoudleName];
            
            [addDietControl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(contentview);
                make.top.equalTo(interrogationControl.mas_bottom).with.offset(5);
                make.height.mas_equalTo(@50);
            }];
        }
        
        if (![self userIsSelf])
        {
            //用户不是自己
            [addDietControl setHidden:YES];
            [dietResultView setHidden:YES];
        }
    
    }
    
    [detectTimeView setDetectResult:result];
    [resultView setDetectResult:result];
}

#pragma mark - TaskObserver

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
    }
    
    if (!taskId || 0 == taskId.length) {
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"UpdateUserBloodSugarDietTask"])
    {
        NSString* taskname = [self resultTaskName];
        if (taskname)
        {
            //创建任务，获取检测结果数据
            if (recordId && [recordId isKindOfClass:[NSString class]] && 0 < recordId.length)
            {
                NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                [dicPost setValue:recordId forKey:@"testDataId"];
                
                [self.view showWaitView];
                [[TaskManager shareInstance] createTaskWithTaskName:taskname taskParam:dicPost TaskObserver:self];
            }
        }
        
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
    
    if ([taskname isEqualToString:[self resultTaskName]])
    {
        if (taskResult && [taskResult isKindOfClass:[DetectResult class]])
        {
            detectResult = taskResult;
            userId = detectResult.userId;
            [self detectResultLoaded:(BloodSugarDetectResult*)detectResult];
        }
        
    }
}
@end
