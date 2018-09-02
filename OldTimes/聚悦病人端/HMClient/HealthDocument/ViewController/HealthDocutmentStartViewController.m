//
//  HealthDocutmentStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthDocutmentStartViewController.h"
#import "HMSwitchView.h"

#import "DetectRecordsStartViewController.h"
#import "ClinicHistoryViewController.h"
#import "HospitalizationHistoryTableViewController.h"
#import "ExaminationHistoryTableViewController.h"
#import "SurveyRecordsTableViewController.h"
#import "RecipeListTableViewController.h"
#import "LifeStyleRecordsTableViewController.h"
#import "EvaluationRecordsTableViewController.h"
#import "RoundsRecordsTableViewController.h"
#import "AsthmaDiaryViewController.h"
#import "RecordExtendTitleModel.h"

typedef enum : NSUInteger {
    DetectRecordsIndex,         //监测记录
    SurveyRecordsIndex,         //随访记录
    RoundsRecordsIndex,         //查房记录
    EvaluationRecordsIndex,     //评估记录
    InterrogationRecordsIndex,  //问诊记录
    LifeRecordsIndex,           //生活记录
    PrescriptionIndex,          //药物处方
    ExaminationRecordsIndex,    //体检记录
    HospitalizationIndex,       //住院记录
    ClinicRecordsIndex,         //门诊记录
} HealthDocutmentSwitchIndex;

@interface HealthDocutmentStartViewController ()<HMSwitchViewDelegate,TaskObserver>
{
    UIScrollView* scrollview;
    HMSwitchView* docSwitchView;
    UIViewController* vcContent;
}
@property (nonatomic, assign) BOOL isShowAsthma;  //是否显示哮喘
@end

@implementation HealthDocutmentStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"我的档案"];
    
    [self getExtRecordTitle];
    
    NSString* btiTitle = @"基本信息";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];
    
    [historybutton setTitle:@"基本信息" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont font_30]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    if (!vcContent)
    //    {
    //        [self createDocumentViewController:DetectRecordsIndex];
    //    }
    
    //获取用户认证信息
    [self getUserAuthenticationInfo];
}

- (void) entryRecordHistoryViewController:(id) sender
{
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthBaseInfoStartViewController" ControllerObject:nil];
}


//获取扩展标题（哮喘日志）
- (void)getExtRecordTitle
{
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"RecordExtendTitleTask" taskParam:nil TaskObserver:self];
}

//获取用户认证信息 (是否可以查看住院记录)
- (void)getUserAuthenticationInfo{
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAuthenticationInfoTask" taskParam:nil TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) createSwitchView
{
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 47)];
    [scrollview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scrollview];
    [scrollview setShowsHorizontalScrollIndicator:NO];
    
    docSwitchView = [[HMSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.width * 2.5, scrollview.height)];
    [scrollview addSubview:docSwitchView];
    
    if (_isShowAsthma) {
        [docSwitchView createCells:@[@"哮喘日记",@"监测记录", @"随访记录", @"查房记录", @"评估记录", @"问诊记录",@"生活记录", @"用药建议", @"检验检查", @"住院记录", @"门诊记录"]];
    }
    else{
        [docSwitchView createCells:@[@"监测记录", @"随访记录", @"查房记录", @"评估记录", @"问诊记录",@"生活记录", @"用药建议", @"检验检查", @"住院记录", @"门诊记录"]];
    }
    [scrollview setContentSize:docSwitchView.size];
    [docSwitchView setDelegate:self];
}

- (void) createDocumentViewController:(NSInteger) index
{
    if (vcContent)
    {
        [vcContent.view removeFromSuperview];
        [vcContent removeFromParentViewController];
        vcContent = nil;
    }
    
    CGRect rtContent = self.view.bounds;
    rtContent.origin.y = scrollview.bottom;
    rtContent.size.height -= scrollview.bottom;
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    /*
     DetectRecordsIndex,         //监测记录
     SurveyRecordsIndex,         //随访记录
     InterrogationRecordsIndex,  //问诊记录
     LifeRecordsIndex,           //生活记录
     PrescriptionIndex,          //药物处方
     ExaminationRecordsIndex,    //体检记录
     HospitalizationIndex,       //住院记录
     ClinicRecordsIndex,         //门诊记录
     */
    
    if (_isShowAsthma && index == 0) {
        //哮喘日记
        vcContent = [[AsthmaDiaryViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
        [self addChildViewController:vcContent];
        [vcContent.view setFrame:rtContent];
        [self.view addSubview:vcContent.view];
    }
    else
    {
        if (_isShowAsthma) {
            index = index - 1;
        }
        switch (index)
        {
            case DetectRecordsIndex:
            {
                //监测记录
                vcContent = [[DetectRecordsStartViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
                [self addChildViewController:vcContent];
                [vcContent.view setFrame:rtContent];
                [self.view addSubview:vcContent.view];
            }
                break;
            case SurveyRecordsIndex:
            {
                //随访记录
                vcContent = [[SurveyRecordsTableViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
                [self addChildViewController:vcContent];
                [vcContent.view setFrame:rtContent];
                [self.view addSubview:vcContent.view];
            }
                break;
            
            case RoundsRecordsIndex:
            {
                //查房记录
                vcContent = [[RoundsRecordsTableViewController alloc]init];
                [self addChildViewController:vcContent];
                [self.view addSubview:vcContent.view];
                [vcContent.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.view);
                    make.bottom.equalTo(self.view);
                    make.top.equalTo(scrollview.mas_bottom);
                }];
                
                break;
            }
                
            case EvaluationRecordsIndex:
            {
                //评估纪录
                vcContent = [[EvaluationRecordsTableViewController alloc]init];
                [self addChildViewController:vcContent];
                [self.view addSubview:vcContent.view];
                [vcContent.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.view);
                    make.bottom.equalTo(self.view);
                    make.top.equalTo(scrollview.mas_bottom);
                }];
                
                break;
            }
                
            case InterrogationRecordsIndex:
            {
                //问诊纪录
                vcContent = [[InterrogationRecordsTableViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
                [self addChildViewController:vcContent];
                [vcContent.view setFrame:rtContent];
                [self.view addSubview:vcContent.view];
            }
                break;
            case LifeRecordsIndex:
            {
                //生活方式 LifeStyleRecordsViewController
                vcContent = [[LifeStyleRecordsViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
                [self addChildViewController:vcContent];
                [vcContent.view setFrame:rtContent];
                [self.view addSubview:vcContent.view];
            }
                break;
            case PrescriptionIndex:
            {
                //药物处方
                vcContent = [[RecipeListTableViewController alloc]init];
                [self addChildViewController:vcContent];
                [self.view addSubview:vcContent.view];
                [vcContent.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.view);
                    make.bottom.equalTo(self.view);
                    make.top.equalTo(scrollview.mas_bottom);
                }];
            }
                break;
            
            case ExaminationRecordsIndex:
            {
                //体检记录
                rtContent.origin.y += 5;
                rtContent.size.height -= 5;
                vcContent = [[ExaminationHistoryTableViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
                [self addChildViewController:vcContent];
                [vcContent.view setFrame:rtContent];
                [self.view addSubview:vcContent.view];
            }
                break;
            case HospitalizationIndex:
            {
                //住院记录
                rtContent.origin.y += 5;
                rtContent.size.height -= 5;
                vcContent = [[HospitalizationHistoryTableViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
                [self addChildViewController:vcContent];
                [vcContent.view setFrame:rtContent];
                [self.view addSubview:vcContent.view];
            }
                break;
            case ClinicRecordsIndex:
            {
                //门诊记录
                rtContent.origin.y += 5;
                rtContent.size.height -= 5;
                vcContent = [[ClinicHistoryViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
                [self addChildViewController:vcContent];
                [vcContent.view setFrame:rtContent];
                [self.view addSubview:vcContent.view];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSInteger)selectedIndex
{
    
    [self createDocumentViewController:selectedIndex];
    
    
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
            
            [self createSwitchView];
            //默认第一个
            [self createDocumentViewController:0];
        }
    }
    
    if ([taskname isEqualToString:@"UserAuthenticationInfoTask"]) {
        
        if (taskResult && [taskResult isKindOfClass:[NSString class]]) {
            UserInfo *userInfo = [[UserInfoHelper defaultHelper] currentUserInfo];
            userInfo.authenticationType = taskResult;
        }
    }
}

@end
