//
//  NewbieGuideMainViewController.m
//  HMClient
//
//  Created by Andrew Shen on 2016/11/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewbieGuideMainViewController.h"
#import "NewbieGuideBaseSubViewController.h"


static NSString *const kNewbieGuideAddBloodPressureShowedKey = @"kNewbieGuideAddBloodPressureShowedKey";


@interface NewbieGuideMainViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, assign)  NewbieGuidePageType  guideType; // <##>
@property (nonatomic, strong)  UIPageViewController  *pageVC; // <##>
@property (nonatomic, copy)  NSArray<NSString *>  *pageNamesArray; // 页面类名
@end

@implementation NewbieGuideMainViewController

+ (BOOL)newbieGuideShowedForGuideType:(NewbieGuidePageType)guideType {
    switch (guideType) {
        case NewbieGuidePageTypeAddBloodPressure: {
            id value = [[NSUserDefaults standardUserDefaults] objectForKey:kNewbieGuideAddBloodPressureShowedKey];
            BOOL showed = [value boolValue];
            return showed;
            break;
        }
    }
}

- (instancetype)initWithNewbieGuideType:(NewbieGuidePageType)guideType
{
    self = [super init];
    if (self) {
        _guideType = guideType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *key = @"";
    switch (self.guideType) {
        case NewbieGuidePageTypeAddBloodPressure: {
            key = kNewbieGuideAddBloodPressureShowedKey;
            break;
        }
    }
    // 标记通过新手教程
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:key];
}

#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)p_configElements {
    self.view.backgroundColor = [UIColor yellowColor];
    // 设置数据
    [self p_configData];
    
    // 设置约束
    [self p_configConstraints];
}

// 设置数据
- (void)p_configData {
    switch (self.guideType) {
        case NewbieGuidePageTypeAddBloodPressure: {
            self.pageNamesArray = @[@"NewbieGuideAddPressureVCOne",@"NewbieGuideAddPressureVCTwo",@"NewbieGuideAddPressureVCThree",@"NewbieGuideAddPressureVCFour",@"NewbieGuideAddPressureVCFive"];
            break;
        }
    }
    if (!self.pageNamesArray || self.pageNamesArray.count == 0) {
        return;
    }
    [self.pageVC setViewControllers:@[[self p_viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

// 设置约束
- (void)p_configConstraints {
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    self.pageVC.view.frame = self.view.frame;
    [self.pageVC didMoveToParentViewController:self];
}

- (NSUInteger)p_indexOfViewController:(UIViewController *)controller {
    NSString *className = NSStringFromClass(controller.class);
    return [self.pageNamesArray indexOfObject:className];
}

- (NewbieGuideBaseSubViewController *)p_viewControllerAtIndex:(NSUInteger)index {
    Class class = NSClassFromString(self.pageNamesArray[index]);
    NewbieGuideBaseSubViewController *VC = [[class alloc] init];
    VC.view.backgroundColor = [UIColor colorWithRed:arc4random() % 10 * 0.1 green:arc4random() % 10 * 0.1 blue:arc4random() % 10 * 0.1 alpha:1.0];
    [VC addNotiSkipCompletion:^{
        [self p_closeAlertWithCancelButton:YES];
    }];
    [VC addPushNextCompletion:^(NSString *currentClassName) {
        NSUInteger index = [self.pageNamesArray indexOfObject:currentClassName];
        if (index != self.pageNamesArray.count - 1) {
            [self.pageVC setViewControllers:@[[self p_viewControllerAtIndex:index + 1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        else {
            [self p_closeAlertWithCancelButton:NO];
        }
    }];
    return VC;
}

- (void)p_closeAlertWithCancelButton:(BOOL)cancelButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出引导" message:@"您将退出引导过程，您填写的数据将不保存。\n从设置-->新手引导，可以再现以上步骤" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [alert addAction:action];

    if (cancelButton) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - PageViewControllerDataSource && Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [self p_indexOfViewController:viewController];
    if (currentIndex != self.pageNamesArray.count - 1) {
        return [self p_viewControllerAtIndex:currentIndex + 1];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
}

#pragma mark - Override


#pragma mark - Init

- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.delegate = self;
        _pageVC.dataSource = self;
        [_pageVC.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scrollView = (UIScrollView *)obj;
                [scrollView setScrollEnabled:NO];
                *stop = YES;
            }
        }];
        
    }
    return _pageVC;
}

@end
