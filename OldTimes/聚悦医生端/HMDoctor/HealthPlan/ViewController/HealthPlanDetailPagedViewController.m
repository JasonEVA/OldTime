//
//  HealthPlanDetailPagedViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanDetailPagedViewController.h"
#import "HealthPlanDetailPageView.h"

#import "HealthPlanDetectDetailViewController.h"
#import "HealthFillFormDetailViewController.h"
#import "HealthPlanNutritionDetailViewController.h"

#import "HealthPlanMentailitDetailViewController.h"
#import "HealthPlanSportsDetailViewController.h"
#import "HealthPlanReviewDetailViewController.h"
#import "HealthPlanMedicineDetailViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface HealthPlanDetailPagedViewController ()
{
    NSMutableArray* viewControllers;
}
@property (nonatomic, strong) HealthPlanDetailModel* detailModel;
@property (nonatomic, assign) NSInteger defaultIndex;
@property (nonatomic, strong) UIPageViewController* pageViewContrller;
@property (nonatomic, strong) HealthPlanDetailPageView* pageView;

@end

@implementation HealthPlanDetailPagedViewController

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) initWithDetailModel:(HealthPlanDetailModel*) detailModel
              defaultIndex:(NSInteger) defaultIndex
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _detailModel = detailModel;
        _defaultIndex = defaultIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutElements];
    [self createHealthPlanDetViewControllers];
    
    [self.pageViewContrller setViewControllers:@[viewControllers[self.defaultIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    HealthPlanDetailSectionModel* sectionModel = self.detailModel.dets[self.defaultIndex];
    [self.pageView setHealthPlanDetailSectionModel:sectionModel];
    self.navigationItem.title = sectionModel.title;
    
    [self.pageView setPageCount:viewControllers.count];
    [self.pageView setCurrentPage:self.defaultIndex];
    
    [self refreshDetailValid];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(healthPlanEditHandle:) name:kHealthPlanEditedNotificationName object:nil];
    
    UISwipeGestureRecognizer *rightrecognizer;
    rightrecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [rightrecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.pageView addGestureRecognizer:rightrecognizer];
    
    UISwipeGestureRecognizer *leftrecognizer;
    leftrecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [leftrecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.pageView addGestureRecognizer:leftrecognizer];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (void) healthPlanEditHandle:(NSNotification*) notification
{
    [self refreshDetailValid];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft ) {
        NSLog(@"Left");
        [self handleSwipeFromLeft];
    }
    if (recognizer.direction==UISwipeGestureRecognizerDirectionRight ) {
        NSLog(@"Right");
        [self handleSwipeFromRight];
    }
}

- (NSInteger) currentPageIndex
{
    UIViewController* currentViewController = [self.pageViewContrller.viewControllers firstObject];
    NSInteger curIndex = [viewControllers indexOfObject:currentViewController];

    return curIndex;
}

- (void) handleSwipeFromLeft
{
    
    NSInteger curIndex = [self currentPageIndex];
    if (curIndex >= viewControllers.count - 1) {
        return;
    }
    
    UIViewController* controller = viewControllers[curIndex + 1];
    __weak typeof(self) weakSelf = self;
    [self.pageViewContrller setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished)
    {
        
        NSInteger index = [weakSelf currentPageIndex];
        [weakSelf.pageView setCurrentPage:index];
        
        HealthPlanDetailSectionModel* sectionModel = weakSelf.detailModel.dets[index];
        [weakSelf.navigationItem setTitle:sectionModel.title];
        [weakSelf.pageView setHealthPlanDetailSectionModel:sectionModel];
    }];
}

- (void) handleSwipeFromRight
{
    
    NSInteger curIndex = [self currentPageIndex];
    if (curIndex == 0) {
        return;
    }
    
    UIViewController* controller = viewControllers[curIndex - 1];
    __weak typeof(self) weakSelf = self;
    [self.pageViewContrller setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished)
     {
         NSInteger index = [weakSelf currentPageIndex];
         [weakSelf.pageView setCurrentPage:index];
         HealthPlanDetailSectionModel* sectionModel = weakSelf.detailModel.dets[index];
         [weakSelf.navigationItem setTitle:sectionModel.title];
         [weakSelf.pageView setHealthPlanDetailSectionModel:sectionModel];
     }];
}

- (void) layoutElements
{
    [self.pageViewContrller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64);
    }];
    
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@70);
    }];
}



- (void) createHealthPlanDetViewControllers
{
    viewControllers = [NSMutableArray array];
    [self.detailModel.dets enumerateObjectsUsingBlock:^(HealthPlanDetailSectionModel* sectionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController* controller = nil;
        if ([sectionModel.code isEqualToString:@"medicine"]) {
            //用药
            controller = [[HealthPlanMedicineDetailViewController alloc] initWithUserId:self.detailModel.userIdStr detailModel:sectionModel];
        }
        if ([sectionModel.code isEqualToString:@"test"])
        {
            //监测
            controller = [[HealthPlanDetectDetailViewController alloc] initWithDetailModel:sectionModel status:self.detailModel.status];
        }
        else if ([sectionModel.code isEqualToString:@"survey"] ||
                 [sectionModel.code isEqualToString:@"assessment"] ||
                 [sectionModel.code isEqualToString:@"wards"]) {
            //随访、评估、查房
            controller = [[HealthFillFormDetailViewController alloc] initWithDetailModel:sectionModel status:self.detailModel.status];
        }
        else if ([sectionModel.code isEqualToString:@"nutrition"])
        {
            //营养
            controller = [[HealthPlanNutritionDetailViewController alloc] initWithDetailModel:sectionModel status:self.detailModel.status];
        }
        else if ([sectionModel.code isEqualToString:@"live"])
        {
            //生活
            controller = [[HealthPlanNutritionDetailViewController alloc] initWithDetailModel:sectionModel status:self.detailModel.status];
        }
        else if ([sectionModel.code isEqualToString:@"mentality"])
        {
            //心理
            controller = [[HealthPlanMentailitDetailViewController alloc] initWithDetailModel:sectionModel status:self.detailModel.status];
        }
        
        else if ([sectionModel.code isEqualToString:@"sports"])
        {
            //运动
            controller = [[HealthPlanSportsDetailViewController alloc] initWithDetailModel:sectionModel status:self.detailModel.status];
            
        }
        else if ([sectionModel.code isEqualToString:@"review"])
        {
            //复查
            controller = [[HealthPlanReviewDetailViewController alloc] initWithDetailModel:sectionModel status:self.detailModel.status];
        }
        [viewControllers addObject:controller];
    }];
}

- (void) refreshDetailValid
{
    [self.detailModel.dets enumerateObjectsUsingBlock:^(HealthPlanDetailSectionModel* detModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.pageView setPage:idx isValid:[detModel planDetIsValid]];
    }];
}


#pragma mark - settingAndGetting
- (UIPageViewController*) pageViewContrller
{
    if (!_pageViewContrller) {
        _pageViewContrller = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        [self addChildViewController:_pageViewContrller];
        [self.view addSubview:_pageViewContrller.view];
    }
    return _pageViewContrller;
}

- (HealthPlanDetailPageView*) pageView
{
    if (!_pageView) {
        _pageView = [[HealthPlanDetailPageView alloc] init];
        [self.view addSubview:_pageView];
    }
    return _pageView;
}

@end
