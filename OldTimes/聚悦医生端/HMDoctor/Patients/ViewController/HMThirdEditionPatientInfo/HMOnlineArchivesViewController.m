//
//  HMOnlineArchivesViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMOnlineArchivesViewController.h"
#import "ADSSegmentedButton.h"
#import "HMOnlineArchivesAdmitHospitalViewController.h"
#import "HMOnlineArchivesMedictionsViewController.h"
#import "HMOnlineArchivesReportViewController.h"
#import "CoordinationFilterView.h"
#import "HMAdmissionAssessDateView.h"

typedef NS_ENUM(NSUInteger, OnlineArchivesIndex) {
    OnlineArchives_admitHospitalIndex, //入院录
    OnlineArchives_reportIndex,        //疾病风险评估
    OnlineArchives_medicationsIndex,   //近期用药
};

@interface HMOnlineNoArchivesView : UIView

@end

@implementation HMOnlineNoArchivesView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        UIImageView *imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];
        [imgView setImage:[UIImage imageNamed:@"ic_nocase"]];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-100);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        UILabel *promptLabel = [[UILabel alloc] init];
        [self addSubview:promptLabel];
        [promptLabel setText:@"对不起，该用户暂无在院档案或录入中"];
        [promptLabel setTextColor:[UIColor commonTextColor]];
        [promptLabel setFont:[UIFont font_34]];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(15);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

@end

@interface HMOnlineArchivesViewController () <TaskObserver,ADSSegmentedButtonDelegate,UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    UIBarButtonItem *dateValueButtonItem;
}

@property (nonatomic, strong)  ADSSegmentedButton  *segmentedButton;
@property (nonatomic, strong)  UIPageViewController  *pageViewController;
@property (nonatomic, strong)  NSMutableArray  *arrayVC;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *useADMISSION_ID;
@property (nonatomic, strong)  CoordinationFilterView  *filterView;

@property (nonatomic, copy) NSArray *dateList;
@property (nonatomic, strong) HMOnlineNoArchivesView *noArchivesView;

@end

@implementation HMOnlineArchivesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"在院档案"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]]) {
        self.userId = (NSString *)self.paramObject;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.userId forKey:@"userId"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"getAdmissionAssessDateListTask" taskParam:dic TaskObserver:self];
}

//请求时间列表
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:self.userId forKey:@"userId"];
//    
//    [self.view showWaitView];
//    [[TaskManager shareInstance] createTaskWithTaskName:@"getAdmissionAssessDateListTask" taskParam:dic TaskObserver:self];
//}

- (void)dateButtonItemClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    HMAdmissionAssessDateView *dateView = [[HMAdmissionAssessDateView alloc] initWithUserID:self.userId dateList:self.dateList];
    [window addSubview:dateView];
    [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    __weak typeof(self) weakSelf = self;
    [dateView setDateSelectBlock:^(HMAdmissionAssessDateListModel *DateList) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [dateValueButtonItem setTitle:DateList.CREATE_DATE];
        strongSelf.useADMISSION_ID = DateList.ADMISSION_ID;
        [strongSelf.segmentedButton selectedButtonWithTag:0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlineArchivesDateChangedNotification" object:strongSelf.useADMISSION_ID];
    }];
}

// 设置元素控件
- (void)p_configElements {
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
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    UIBarButtonItem *dateButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"patient_historyMsg"] style:UIBarButtonItemStylePlain target:self action:@selector(dateButtonItemClick)];
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"YYYY-MM-dd"];
    //    NSDate *currentDate = [NSDate date];
    //    NSString *dateStr = [formatter stringFromDate:currentDate];
    dateValueButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:nil];
    [dateValueButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItems:@[dateButtonItem,dateValueButtonItem]];
    
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
    for (NSInteger i = 0; i <= OnlineArchives_medicationsIndex; i ++ ) {
        UIViewController *VC;
        switch (i) {
            case OnlineArchives_admitHospitalIndex:
            {
                //入院录
                VC = [[HMOnlineArchivesAdmitHospitalViewController alloc] initWithUserID:self.userId admissionId:self.useADMISSION_ID];
                break;
            }

            case OnlineArchives_reportIndex:
            {
                //疾病风险评估
                VC = [[HMOnlineArchivesReportViewController alloc] initWithUserID:self.userId admissionId:self.useADMISSION_ID];
                break;
            }
                
            case OnlineArchives_medicationsIndex:
            {
                //近期用药
                VC = [[HMOnlineArchivesMedictionsViewController alloc] initWithUserID:self.userId admissionId:self.useADMISSION_ID];
                break;
            }
            
        }
        [self.arrayVC addObject:VC];
    }
}

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
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    
    if ([taskname isEqualToString:@"getAdmissionAssessDateListTask"])
    {
        if ([taskResult isKindOfClass:[NSArray class]]) {
            _dateList = (NSArray *)taskResult;
            
            
            if (kArrayIsEmpty(_dateList)) {
                [self.view addSubview:self.noArchivesView];
                return;
            }
            
            [dateValueButtonItem setTitle:[[_dateList objectAtIndex:0] CREATE_DATE]];
            self.useADMISSION_ID = [[_dateList objectAtIndex:0] ADMISSION_ID];
            
            [self p_configElements];
        }
    }
}

#pragma mark - Init

- (ADSSegmentedButton *)segmentedButton {
    if (!_segmentedButton) {
        _segmentedButton = [[ADSSegmentedButton alloc] initWithTitles:@[@"入院录",@"疾病风险评估",@"近期用药"] tags:nil minimumButtonWidth:100];
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

- (NSArray *)dateList{
    if (!_dateList) {
        _dateList = [NSArray array];
    }
    return _dateList;
}

- (HMOnlineNoArchivesView *)noArchivesView{

    if (!_noArchivesView) {
        _noArchivesView = [[HMOnlineNoArchivesView alloc] init];
        [_noArchivesView setFrame:self.view.bounds];
    }
    return _noArchivesView;
}
@end
