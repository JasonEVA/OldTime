//
//  HMOnlineArchivesAdmitHospitalViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMOnlineArchivesAdmitHospitalViewController.h"
#import "ADSSegmentedButton.h"
#import "HMMedicalHistoryViewController.h"
#import "HMHealthCheckupViewController.h"
#import "HMAssistantExaminationViewController.h"

typedef NS_ENUM(NSUInteger, AdmitHospitalIndex) {
    AdmitHospitalIndex_MedicalHistoryIndex,       //病史信息
    AdmitHospitalIndex_HealthCheckupIndex,        //体格检查
    AdmitHospitalIndex_AssistantExaminationIndex,  //辅助检查
};

@interface HMOnlineArchivesAdmitHospitalViewController ()<ADSSegmentedButtonDelegate,UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong)  ADSSegmentedButton  *segmentedButton;
@property (nonatomic, strong)  UIPageViewController  *pageViewController;
@property (nonatomic, strong)  NSMutableArray  *arrayVC;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *admissionId;
@end

@implementation HMOnlineArchivesAdmitHospitalViewController

- (instancetype)initWithUserID:(NSString *)userID  admissionId:(NSString *)admissionId
{
    self = [super init];
    if (self) {
        _userId = userID;
        _admissionId = admissionId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_configElements];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createDateChanged:) name:@"OnlineArchivesDateChangedNotification" object:nil];
}

- (void)createDateChanged:(NSNotification *)notification
{
    [self.segmentedButton selectedButtonWithTag:0];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置元素控件
- (void)p_configElements {
    // 设置数据
    [self p_configData];
    
    // 设置约束
    [self p_configConstraints];
    
    //禁止滑动
    for (UIView *view in self.pageViewController.view.subviews ) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scroll = (UIScrollView *)view;
            scroll.bounces = NO;
            scroll.scrollEnabled = NO;
        }
    }
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
        make.left.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(@5);
        make.bottom.equalTo(self.segmentedButton.mas_top).offset(-5);
    }];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(_segmentedButton.mas_top).with.offset(-1);
        make.height.mas_equalTo(@1);
    }];
    
    [self.arrayVC enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *midView = [UIView new];
        [midView setBackgroundColor:[UIColor commonLightGrayTextColor]];
        [self.segmentedButton addSubview:midView];
        [midView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScreenWidth/self.arrayVC.count*idx);
            make.top.equalTo(self.segmentedButton).offset(5);
            make.bottom.equalTo(self.segmentedButton).offset(-5);
            make.width.mas_equalTo(@1);
        }];
    }];
}

- (void)p_configVC {
    for (NSInteger i = 0; i <= AdmitHospitalIndex_AssistantExaminationIndex; i ++ ) {
        UIViewController *VC;
        switch (i) {
            case AdmitHospitalIndex_MedicalHistoryIndex:
            {
                //病史信息
                VC = [[HMMedicalHistoryViewController alloc] initWithUserID:self.userId admissionId:self.admissionId];
                break;
            }
                
            case AdmitHospitalIndex_HealthCheckupIndex:
            {
                //体格检查
                VC = [[HMHealthCheckupViewController alloc] initWithUserID:self.userId admissionId:self.admissionId];
                break;
            }
                
            case AdmitHospitalIndex_AssistantExaminationIndex:
            {
                //辅助检查
                VC = [[HMAssistantExaminationViewController alloc] initWithUserID:self.userId admissionId:self.admissionId];
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

#pragma mark - Init

- (ADSSegmentedButton *)segmentedButton {
    if (!_segmentedButton) {
        _segmentedButton = [[ADSSegmentedButton alloc] initWithTitles:@[@"病史信息",@"体格检查",@"辅助检查"] tags:nil minimumButtonWidth:100];
        _segmentedButton.backgroundColor = [UIColor whiteColor];
        [_segmentedButton configNormalTitleColor:[UIColor commonDarkGrayColor_666666] selectedTitleColor:[UIColor mainThemeColor] titleFont:[UIFont font_26]];
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

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UIColor commonLightGrayTextColor]];
    }
    return _lineView;
}

@end
