//
//  HMSEHealthPlanMainViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEHealthPlanMainViewController.h"
#import "HMUserMissionViewController.h"
#import "HMSupervisePlanViewController.h"
#import "InitializationHelper.h"

@interface HMSEHealthPlanMainViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) HMUserMissionViewController *todayMissionVC;
@property (nonatomic, strong) HMSupervisePlanViewController *superViseVC;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong)  NSMutableArray  *arrayVC; // <##>
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIScrollView *backScrollView;
@end

@implementation HMSEHealthPlanMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"今日任务",@"监测计划"]];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:self.segmentedControl];
    

    self.rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"总览" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:self.rightBtn];

    self.arrayVC = [@[self.todayMissionVC, self.superViseVC] mutableCopy];
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    // 设置UIPageViewController初始化数据, 将数据放在NSArray里面
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意viewControllers至少包含两个数据,且 doubleSided = YES
    
    
    [_pageViewController setViewControllers:@[self.todayMissionVC]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = self.view.bounds;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    [self.view addSubview:self.backScrollView];
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];
    
    [self.backScrollView addSubview:self.emptyImageView];
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.top.equalTo(self.backScrollView);
    }];
    
    [self.backScrollView addSubview:self.buyBtn];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.emptyImageView.mas_bottom).offset(-20);
        make.width.equalTo(@250);
        make.height.equalTo(@40);
    }];


    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configViewWithIsHaveHealthPlan];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

- (void)configViewWithIsHaveHealthPlan {
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService && [UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_HealthPlan]) {
        [self.navigationItem setTitleView:self.segmentedControl];
        self.navigationItem.rightBarButtonItem = self.rightBtn;
        [self.todayMissionVC.view setHidden:NO];
        [self.superViseVC.view setHidden:NO];
        [self.backScrollView setHidden:YES];
        [self.buyBtn setHidden:YES];
        [self.emptyImageView setHidden:YES];

    }
    else {
        [self.navigationItem setTitleView:nil];
        [self.navigationItem setTitle:@"健康计划"];
        self.navigationItem.rightBarButtonItem = nil;
        [self.todayMissionVC.view setHidden:YES];
        [self.superViseVC.view setHidden:YES];
        [self.backScrollView setHidden:NO];
        [self.buyBtn setHidden:NO];
        [self.emptyImageView setHidden:NO];

    }
}
#pragma mark - event Response
- (void)rightClick {
    //跳转到健康计划界面
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthPlanStartViewController" ControllerObject:nil];
}

- (void)segmentClick:(UISegmentedControl *)sender {
    if (self.segmentedControl.selectedSegmentIndex) {
        [self.pageViewController setViewControllers:@[self.superViseVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    else {
        [self.pageViewController setViewControllers:@[self.todayMissionVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
 
}

- (void)buyClick {
    //跳转到服务分类

//  [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
    
    NSString *phone = @"4008332616";
    
    NSString *phoneCall =[NSString stringWithFormat:@"tel:%@",phone];
    NSURL *url = [NSURL URLWithString:phoneCall];
    [[UIApplication sharedApplication] openURL:url];
    
    
    
    
}
#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

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
    self.segmentedControl.selectedSegmentIndex = index;
}

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (HMUserMissionViewController *)todayMissionVC {
    if (!_todayMissionVC) {
        _todayMissionVC = [HMUserMissionViewController new];
        __weak typeof(self) weakSelf = self;

//        [_todayMissionVC checkIsHaveHealthPlan:^(BOOL isHave) {
//            [weakSelf configViewWithIsHaveHealthPlan:isHave];
//        }];
    }
    return _todayMissionVC;
}

- (HMSupervisePlanViewController *)superViseVC {
    if (!_superViseVC) {
        _superViseVC = [HMSupervisePlanViewController new];
    }
    return _superViseVC;
}

- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_back"]];
    }
    return _emptyImageView;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton new];
        [_buyBtn.layer setCornerRadius:20];
        [_buyBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_buyBtn setTitle:@"咨询客服" forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_buyBtn.titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] init];
        [_backScrollView setBackgroundColor:[UIColor whiteColor]];
        _backScrollView.scrollEnabled = YES;
        _backScrollView.directionalLockEnabled = YES;
        _backScrollView.delegate = self;
        _backScrollView.alwaysBounceHorizontal = NO;
        _backScrollView.alwaysBounceVertical = YES;
        _backScrollView.bounces = YES;
        [_backScrollView setContentSize:CGSizeMake(kScreenWidth, 600)];

//        [_backScrollView setContentSize:CGSizeMake(ScreenWidth, 550)];
    }
    return _backScrollView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
