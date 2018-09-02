//
//  HomeTabBarViewController.m
//  PalmDoctorPT
//
//  Created by Andrew Shen on 15/4/3.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//    

#import "HomeTabBarViewController.h"
#import "ShapeMainViewController.h"
#import "TrainingMainViewController.h"
#import "MeMainViewController.h"
#import "BaseNavigationViewController.h"
#import "UIColor+Hex.h"
#import "unifiedUserInfoManager.h"
#import "MyDefine.h"

#define COUNT_MODULE 3

static NSString *const iconShapeNormal = @"shape_normal";
static NSString *const iconShapehighlight = @"shape_highlight";
static NSString *const iconTrainingNormal = @"training_normal";
static NSString *const iconTrainingHighlight = @"training_highlight";
static NSString *const iconMeNormal = @"me_normal";
static NSString *const iconMeHighlight = @"me_highlight";

@interface HomeTabBarViewController ()
@property (nonatomic, strong)  ShapeMainViewController  *shapeMainVC; // <##>
@property (nonatomic, strong)  TrainingMainViewController  *trainingMianVC; // <##>
@property (nonatomic, strong)  MeMainViewController  *meMainVC; // <##>

@property(nonatomic,retain) NSMutableArray *arrayNavi;
@property(nonatomic,retain) NSMutableArray *arrayItems;

@end

@implementation HomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setBackgroundImage:[UIColor switchToImageWithColor:[UIColor colorDarkBlack_1f1f1fWithAlpha:0.9] size:CGSizeMake(1, 1)]];
    // 初始化底部栏和模块框架
    [self initTabBarComponents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToModule:) name:n_switchModule object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- Private Method
// 初始化底部栏和模块框架
- (void)initTabBarComponents
{
    NSArray *arrayVC = @[self.trainingMianVC,self.shapeMainVC,self.meMainVC];
    for (UIViewController *vc in arrayVC) {
        // 主页模块
        BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self.arrayNavi addObject:navi];
    }
    
    // tabbar选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor themeOrange_ff5d2b]} forState:UIControlStateSelected];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];

    // 标题
    NSArray *arrItemTitle = @[@"训练",@"SHAPE",@"我"];
    
    // 未选中图片
    NSArray *arrItemImageNormal = @[iconShapeNormal,iconTrainingNormal,iconMeNormal];
    // 选中图片
    NSArray *arrItemImageSelected = @[iconShapehighlight,iconTrainingHighlight,iconMeHighlight];
    
    
    for (NSInteger i = 0; i < COUNT_MODULE; i++)
    {
        UIImage *imageNormal = [[UIImage imageNamed:arrItemImageNormal[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageSelected = [[UIImage imageNamed:arrItemImageSelected[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:arrItemTitle[i] image:imageNormal selectedImage:imageSelected];
        tabBarItem.tag = i;
        [self.arrayItems addObject:tabBarItem];
        
        [(BaseNavigationViewController *)self.arrayNavi[i] setTabBarItem:tabBarItem];
    }
    [self setViewControllers:self.arrayNavi];
}

#pragma mark - Notification
// 切换模块
- (void)switchToModule:(NSNotification *)notification {
    NSInteger index = [notification.object integerValue];
    if (index >= self.viewControllers.count)
    {
        return;
    }
    [self setSelectedIndex:index];
    
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item == self.arrayItems.lastObject) {
        // 个人界面
        if (![[unifiedUserInfoManager share] loginStatus]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:n_showLogin object:nil];
        }
    }
}

#pragma mark - Init
- (ShapeMainViewController *)shapeMainVC {
    if (!_shapeMainVC) {
        _shapeMainVC = [[ShapeMainViewController alloc] init];
    }
    return _shapeMainVC;
}

- (TrainingMainViewController *)trainingMianVC {
    if (!_trainingMianVC) {
        _trainingMianVC = [[TrainingMainViewController alloc] init];
    }
    return _trainingMianVC;
}

- (MeMainViewController *)meMainVC {
    if (!_meMainVC) {
        _meMainVC = [[MeMainViewController alloc] init];
    }
    return _meMainVC;
}

- (NSMutableArray *)arrayNavi {
    if (!_arrayNavi) {
        _arrayNavi = [[NSMutableArray alloc] initWithCapacity:COUNT_MODULE];
    }
    return _arrayNavi;
}

- (NSMutableArray *)arrayItems {
    if (!_arrayItems) {
        _arrayItems = [[NSMutableArray alloc] initWithCapacity:COUNT_MODULE];
    }
    return _arrayItems;

}

@end
