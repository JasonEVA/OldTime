//
//  PatientEMRInfoViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/3.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PatientEMRInfoViewController.h"
#import "ADSSegmentedButton.h"
#import "DetectRecordsStartViewController.h"
#import "ClinicHistoryViewController.h"
#import "HospitalizationHistoryTableViewController.h"
#import "ExaminationHistoryTableViewController.h"
#import "SurveyRecordsTableViewController.h"
#import "RecipeListTableViewController.h"
#import "LifeStyleRecordsViewController.h"
#import "EvaluationRecordsTableViewController.h"
#import "RoundsRecordsTableViewController.h"
#import "AsthmaDiaryViewController.h"
#import "RecordExtendTitleModel.h"

typedef NS_ENUM(NSUInteger, EMRInfoIndex) {
    //EMR_AsthmaRecordsIndex,         //哮喘日记
    EMR_DetectRecordsIndex,         //监测记录
    EMR_SurveyRecordsIndex,         //随访记录
    EMR_RoundsRecordsIndex,         //查房记录
    EMR_EvaluationRecordsIndex,     //评估记录
    EMR_InterrogationRecordsIndex,  //问诊记录
    EMR_LifeRecordsIndex,           //生活记录
    EMR_PrescriptionIndex,          //药物处方
    EMR_ExaminationRecordsIndex,    //体检记录
    EMR_HospitalizationIndex,       //住院记录
    EMR_ClinicRecordsIndex,         //门诊记录
};

@interface PatientEMRInfoViewController ()<ADSSegmentedButtonDelegate,UIPageViewControllerDataSource, UIPageViewControllerDelegate,TaskObserver>
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, readwrite)  BOOL  needRequestEMRInfo; // <##>

@property (nonatomic, strong)  ADSSegmentedButton  *segmentedButton; // <##>
@property (nonatomic, strong)  UIPageViewController  *pageViewController; // <##>
@property (nonatomic, strong)  NSMutableArray  *arrayVC; // <##>
@property (nonatomic, assign) BOOL isShowAsthma;  //是否显示哮喘

@end

@implementation PatientEMRInfoViewController

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    if (self) {
        _userId = userID;
        _needRequestEMRInfo = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getExtRecordTitle];
    
    self.navigationItem.title = @"健康记录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取扩展标题（哮喘日志）
- (void)getExtRecordTitle
{
    [self at_postLoading];
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:_userId forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"RecordExtendTitleTask" taskParam:dicPost TaskObserver:self];
}

- (void)reloadEMRInfoWithUserID:(NSString *)userID {
    self.userId = userID;
    [self p_refreshDataWithUserID:userID];
}

#pragma mark - Interface Method

#pragma mark - Private Method

// 刷新数据
- (void)p_refreshDataWithUserID:(NSString *)userID {
    if (self.arrayVC.count == 0) {
        return;
    }
    [self.arrayVC enumerateObjectsUsingBlock:^(UIViewController *VC, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (_isShowAsthma && idx == 0) {
            //哮喘日记
            [((AsthmaDiaryViewController *)VC) refreshDataWithUserID:userID];
        }
        else{
            if (_isShowAsthma) {
                idx = idx - 1;
            }
            switch (idx) {
                case EMR_DetectRecordsIndex: {
                    //监测记录
                    [((DetectRecordsStartViewController *)VC) refreshDataWithUserID:userID];
                    break;
                }
                    
                case EMR_SurveyRecordsIndex: {
                    //随访记录
                    [((SurveyRecordsTableViewController *)VC) refreshDataWithUserID:userID];
                    
                    break;
                }
                    
                case EMR_RoundsRecordsIndex: {
                    //查房记录
                    [((RoundsRecordsTableViewController *)VC) refreshDataWithUserID:userID];
                    
                    break;
                }
                    
                case EMR_EvaluationRecordsIndex: {
                    //评估纪录
                    [((EvaluationRecordsTableViewController *)VC) refreshDataWithUserID:userID];
                    
                    break;
                }
                    
                case EMR_InterrogationRecordsIndex: {
                    //问诊纪录
                    [((InterrogationRecordsTableViewController *)VC) refreshDataWithUserID:userID];
                    
                    break;
                }
                case EMR_LifeRecordsIndex: {
                    //生活记录
                    [((LifeStyleRecordsViewController *)VC) refreshDataWithUserID:userID];
                    
                    break;
                }
                case EMR_PrescriptionIndex: {
                    //药物处方 RecipeListTableViewController
                    [((RecipeListTableViewController *)VC) refreshDataWithUserID:userID];
                    break;
                }
                case EMR_ExaminationRecordsIndex: {
                    //体检记录
                    [((ExaminationHistoryTableViewController *)VC) refreshDataWithUserID:userID];
                    
                    break;
                }
                case EMR_HospitalizationIndex: {
                    //住院记录
                    [((HospitalizationHistoryTableViewController *)VC) refreshDataWithUserID:userID];
                    
                    break;
                }
                case EMR_ClinicRecordsIndex: {
                    //门诊记录
                    [((ClinicHistoryViewController *)VC) refreshDataWithUserID:userID];
                    
                    break;
                }
            }
        }
    }];
}

// 设置元素控件
- (void)p_configElements {
    if (!self.userId || self.userId.length == 0) {
        return;
    }
    
    // 设置数据
    [self p_configData];
    
    // 设置约束
    [self p_configConstraints];
}

// 设置数据
- (void)p_configData {
    [self p_configVC];
    [self.pageViewController setViewControllers:@[self.arrayVC.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

// 设置约束
- (void)p_configConstraints {
    [self.view addSubview:self.segmentedButton];
    [self.segmentedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentedButton.mas_bottom);
    }];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];

}

- (void)p_configVC {
    
    if (_isShowAsthma) {
        //哮喘日记
        UIViewController *VC = [[AsthmaDiaryViewController alloc]initWithUserId:self.userId];
        [self.arrayVC addObject:VC];
    }
    for (NSInteger i = 0; i <= EMR_ClinicRecordsIndex; i ++ ) {
        UIViewController *VC;
        switch (i) {
            case EMR_DetectRecordsIndex: {
                //监测记录
                VC = [[DetectRecordsStartViewController alloc]initWithUserId:self.userId];
                break;
            }
            case EMR_SurveyRecordsIndex: {
                //随访记录
                VC = [[SurveyRecordsTableViewController alloc]initWithUserId:self.userId];
                break;
            }
                
            case EMR_RoundsRecordsIndex: {
                //查房记录
                VC = [[RoundsRecordsTableViewController alloc] initWithUserId:self.userId];
                break;
            }
                
            case EMR_EvaluationRecordsIndex: {
                //评估纪录
                VC = [[EvaluationRecordsTableViewController alloc] initWithUserId:self.userId];
                break;
            }
                
            case EMR_InterrogationRecordsIndex: {
                //问诊纪录
                VC = [[InterrogationRecordsTableViewController alloc]initWithUserId:self.userId];
                break;
            }
            case EMR_LifeRecordsIndex: {
                //生活记录
                VC = [[LifeStyleRecordsViewController alloc]initWithUserId:self.userId];
                break;
            }
            case EMR_PrescriptionIndex: {
                //药物处方 RecipeListTableViewController
                VC = [[RecipeListTableViewController alloc]initWithUserId:self.userId];
                break;
            }
            case EMR_ExaminationRecordsIndex: {
                //体检记录
                VC = [[ExaminationHistoryTableViewController alloc]initWithUserId:self.userId];
                break;
            }
            case EMR_HospitalizationIndex: {
                //住院记录
                VC = [[HospitalizationHistoryTableViewController alloc]initWithUserId:self.userId];
                break;
            }
            case EMR_ClinicRecordsIndex: {
                //门诊记录
                VC = [[ClinicHistoryViewController alloc]initWithUserId:self.userId];
                break;
            }
        }
        [self.arrayVC addObject:VC];
    }
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - PageViewControllerDataSource && Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.arrayVC indexOfObject:viewController];
    if (index > 0) {
        return self.arrayVC[index - 1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.arrayVC indexOfObject:viewController];
    if (index < self.arrayVC.count - 1) {
        return self.arrayVC[index + 1];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSInteger index = [self.arrayVC indexOfObject:pageViewController.viewControllers.firstObject];
    [self.segmentedButton selectedButtonWithTag:index];
}

#pragma mark - ADSSegmentedButtonDelegate

- (void)ADSSegmentedButtonDelegate:(ADSSegmentedButton *)segmentedButton btnClickedWithTag:(NSInteger)tag {
    if (tag > self.arrayVC.count - 1) {
        return;
    }
    NSInteger currentIndex = [self.arrayVC indexOfObject:self.pageViewController.viewControllers.firstObject];
    if (tag != currentIndex) {
        [self.pageViewController setViewControllers:@[self.arrayVC[tag]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    NSString *tempStr;
    switch (tag) {
        case 0:
            tempStr = @"用户－用户消息";
            break;
        case 1:
            tempStr = @"用户－监测记录";
            break;
        case 2:
            tempStr = @"用户－随访记录";
            break;
        case 3:
            tempStr = @"用户－查房记录";
            break;
        case 4:
            tempStr = @"用户－评估记录";
            break;
        case 5:
            tempStr = @"用户-问诊记录";
            break;
        case 6:
            tempStr = @"用户-生活记录";
            break;
        case 7:
            tempStr = @"用户－用药建议";
            break;
        case 8:
            tempStr = @"用户－检验检查";
            break;
        case 9:
            tempStr = @"用户－住院记录";
            break;
        case 10:
            tempStr = @"用户－门诊记录";
            break;
        default:
            break;
    }
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:tempStr];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (StepError_None != taskError) {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"RecordExtendTitleTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            NSArray *recordTitleArray = (NSArray *)taskResult;
            [recordTitleArray enumerateObjectsUsingBlock:^(RecordExtendTitleModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model.code isEqualToString:@"XCRJ"] && [model.isShow isEqualToString:@"Y"]) {
                    _isShowAsthma = YES;
                }
            }];
            
            [self p_configElements];
        }
    }
}

#pragma mark - Override

#pragma mark - Init

- (ADSSegmentedButton *)segmentedButton {
    if (!_segmentedButton) {
        
        NSArray *titles;
        if (_isShowAsthma) {
            titles = @[@"哮喘日记", @"监测记录", @"随访记录", @"查房记录", @"评估记录", @"问诊记录", @"生活记录", @"用药建议", @"检验检查", @"住院记录", @"门诊记录"];
        }
        else{
            titles = @[@"监测记录", @"随访记录", @"查房记录", @"评估记录", @"问诊记录", @"生活记录", @"用药建议", @"检验检查", @"住院记录", @"门诊记录"];
        }
        _segmentedButton = [[ADSSegmentedButton alloc] initWithTitles:titles tags:nil minimumButtonWidth:70];
        _segmentedButton.backgroundColor = [UIColor whiteColor];
        [_segmentedButton configNormalTitleColor:[UIColor commonDarkGrayColor_666666] selectedTitleColor:[UIColor mainThemeColor] titleFont:[UIFont font_26]];
        [_segmentedButton configBottomLineWithHighlightLineColor:[UIColor mainThemeColor] highlightLineHeight:1.5 backgroundLineColor:[UIColor commonSeperatorColor_dfdfdf] backgroundLineHeight:1];
        _segmentedButton.delegate = self;
    }
    return _segmentedButton;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

- (NSMutableArray *)arrayVC {
    if (!_arrayVC) {
        _arrayVC = [NSMutableArray array];
    }
    return _arrayVC;
}
@end
