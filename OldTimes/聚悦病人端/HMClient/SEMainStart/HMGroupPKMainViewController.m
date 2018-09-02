//
//  HMGroupPKMainViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/8/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMGroupPKMainViewController.h"
#import "JWSegmentView.h"
#import "HMStepPKViewController.h"
#import "HMWeightHistoryViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define SEGMENTVIEWHEIGHT   45
#define TOPVIEW             (SEGMENTVIEWHEIGHT + 64)
@interface HMGroupPKMainViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong)  NSMutableArray  *arrayVC; // <##>
@property (nonatomic, strong) HMStepPKViewController *stepVC;
@property (nonatomic, strong) HMWeightHistoryViewController *weightVC;
@property (nonatomic, strong) JWSegmentView *segmentView;

@end

@implementation HMGroupPKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setFd_prefersNavigationBarHidden:YES];
    
    [self configElements];
   
    
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (!vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
- (void)configElements {
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PK_im_back1"]];
    [topView setUserInteractionEnabled:YES];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@TOPVIEW);
        make.top.left.right.equalTo(self.view);
    }];
    
    UIButton *popBtn = [[UIButton alloc] init];
    [popBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:popBtn];
    [popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(15);
        make.centerY.equalTo(topView.mas_top).offset(44);
    }];
    
    UILabel *titelLb = [UILabel new];
    [titelLb setText:@"集团PK榜"];
    [titelLb setFont:[UIFont boldFont_36]];
    [titelLb setTextColor:[UIColor whiteColor]];
    [topView addSubview:titelLb];
    [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(popBtn);
    }];
    
    [topView addSubview:self.segmentView];
        
    self.arrayVC = [@[self.stepVC, self.weightVC] mutableCopy];
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    // 设置UIPageViewController初始化数据, 将数据放在NSArray里面
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意viewControllers至少包含两个数据,且 doubleSided = YES
    
    
    [_pageViewController setViewControllers:@[self.stepVC]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + TOPVIEW, self.view.bounds.size.width, self.view.bounds.size.height) ;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}
#pragma mark - event Response
- (void)popClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//    NSInteger index = [self.arrayVC indexOfObject:viewController];
//    if (index > 0) {
//        return self.arrayVC[index - 1];
//    }
//    return nil;
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//    NSInteger index = [self.arrayVC indexOfObject:viewController];
//    if (index < self.arrayVC.count - 1) {
//        return self.arrayVC[index + 1];
//    }
//    return nil;
//}

//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
//    NSInteger index = [self.arrayVC indexOfObject:pageViewController.viewControllers.firstObject];
//    [self.segmentView configSelectItemWithTag:index];
//}

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (JWSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        _segmentView = [[JWSegmentView alloc] initWithFrame:CGRectMake(0, TOPVIEW - SEGMENTVIEWHEIGHT, ScreenWidth, SEGMENTVIEWHEIGHT) titelArr:@[@"步数",@"体重"] tagArr:@[@(0),@(1)] titelSelectedJWColor:[UIColor colorWithHexString:@"ffffff"] titelUnSelectedJWColor:[UIColor colorWithHexString:@"ffffff" alpha:0.5] lineJWColor:[UIColor colorWithHexString:@"fffffff"] backJWColor:[UIColor clearColor] lineWidth:60 block:^(NSInteger selectedTag) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (selectedTag) {
                // 体重
                [strongSelf.pageViewController setViewControllers:@[strongSelf.weightVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
                
            }
            else {
                // 步数
                [strongSelf.pageViewController setViewControllers:@[strongSelf.stepVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
                
            }

        }];
    }
    return _segmentView;
}

- (HMStepPKViewController *)stepVC {
    if (!_stepVC) {
        _stepVC = [HMStepPKViewController new];
    }
    return _stepVC;
}

- (HMWeightHistoryViewController *)weightVC {
    if (!_weightVC) {
        _weightVC = [HMWeightHistoryViewController new];
    }
    return _weightVC;
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
