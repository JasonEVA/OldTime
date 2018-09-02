//
//  HealthEducationStartViewController.m
//  HMClient
//
//  Created by yinquan on 16/12/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthEducationStartViewController.h"
#import "HealthyEducationColumeModel.h"
#import "HMSwitchView.h"

@interface HealthEducationStartBottomView : UIView

@property (nonatomic, readonly) UIButton* collectionButton; //收藏夹
@property (nonatomic, readonly) UIButton* fineButton;       //精品课堂

@end

@implementation HealthEducationStartBottomView

- (id) init
{
    self = [super init];
    if (self) {
        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.collectionButton];
        [self.collectionButton setTitle:@"收藏夹" forState:UIControlStateNormal];
        [self.collectionButton setTitleColor:[UIColor commonDarkGrayTextColor] forState:UIControlStateNormal];
        [self.collectionButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateHighlighted];
        [self.collectionButton.titleLabel setFont:[UIFont font_30]];
        [self.collectionButton setImage:[UIImage imageNamed:@"education_collection"] forState:UIControlStateNormal];
        [self.collectionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.equalTo(self);
        }];
        
        [self.collectionButton addTarget:self action:@selector(collectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _fineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.fineButton];
        [self.fineButton setTitle:@"精品课堂" forState:UIControlStateNormal];
        [self.fineButton setTitleColor:[UIColor commonDarkGrayTextColor] forState:UIControlStateNormal];
        [self.fineButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateHighlighted];
        [self.fineButton.titleLabel setFont:[UIFont font_30]];
        [self.fineButton setImage:[UIImage imageNamed:@"education_fine"] forState:UIControlStateNormal];
        [self.fineButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [self.fineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.top.and.bottom.equalTo(self);
            make.left.equalTo(self.collectionButton.mas_right);
            make.width.equalTo(self.collectionButton);
        }];
        [self.fineButton addTarget:self action:@selector(fineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* midLine = [[UIView alloc] init];
        [self.fineButton addSubview:midLine];
        [midLine setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fineButton);
            make.top.equalTo(self.fineButton).with.offset(8);
            make.bottom.equalTo(self.fineButton).with.offset(-8);
            make.width.mas_equalTo(@0.5);
        }];
    }
    return self;
}

- (void) collectionButtonClicked:(id) sender
{
    //跳转到收藏夹
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationCollectionStartViewController" ControllerObject:nil];
}

- (void) fineButtonClicked:(id) sender
{
    //跳转到极品课堂
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationFineViewController" ControllerObject:nil];
}
@end

#import "HealthEducationListTableViewController.h"


@interface HealthEducationStartViewController ()
<HMSwitchViewDelegate, TaskObserver>

@property (nonatomic, readonly) NSArray* educationColumes;
@property (nonatomic, readonly) UIScrollView* switchScrollView;
@property (nonatomic, readonly) HMSwitchView* switchView;
@property (nonatomic, readonly) HealthEducationStartBottomView* bottomView;

@property (nonatomic, readonly) UITabBarController* tabbarController;
//@property (nonatomic, readonly) HealthEducationListTableViewController* educationListTableViewController;

@end

@implementation HealthEducationStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康课堂"];
    
    //创建搜索按钮
    UIBarButtonItem* bbiSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_image"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:bbiSearch];
    
    _bottomView = [[HealthEducationStartBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    [self.bottomView showTopLine];
    
    _switchScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_switchScrollView];
    [self.switchScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@47);
    }];
    
    [self loadEducationColumes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadEducationColumes
{
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationColumeTask" taskParam:nil TaskObserver:self];
}

- (void) searchBarButtonClicked:(id) sender
{
    //跳转到搜索界面 HealthEducationSearchViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationSearchViewController" ControllerObject:nil];
    
}

- (void) educationColumesLoaded:(NSArray*) columes
{
    if (!columes || columes.count == 0) {
        return;
    }
    
    _educationColumes = columes;
    NSMutableArray* columeTitles = [NSMutableArray array];
    [self.educationColumes enumerateObjectsUsingBlock:^(HealthyEducationColumeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        [columeTitles addObject:model.typeName];
    }];
    
    CGFloat switchWidth = kScreenWidth;
    if (columes.count > 4)
    {
        switchWidth = (kScreenWidth/4) * columes.count;
    }
    _switchView = [[HMSwitchView alloc]initWithFrame:CGRectMake(0, 0, switchWidth, 47)];
    [self.switchScrollView addSubview:_switchView];
    [self.switchView setDelegate:self];
    [self.switchScrollView setContentSize:CGSizeMake(switchWidth, 47)];
    
    [self.switchView createCells:columeTitles];
    
//    [self.switchView setSelectedIndex:self.educationColumes.count - 1];
    
    [self createEducationListTable];
    
    [self.tabbarController setSelectedIndex:0];
}

- (void) createEducationListTable
{
    if (_tabbarController)
    {
        [_tabbarController removeFromParentViewController];
        [_tabbarController.view removeFromSuperview];
        _tabbarController = nil;
    }
    
    _tabbarController = [[UITabBarController alloc] init];
    [self addChildViewController:self.tabbarController];
    [self.view addSubview:self.tabbarController.view];
    
    [self.tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.switchScrollView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.tabbarController.tabBar setHidden:YES];
    
    //[self.educationListTableViewController setColumeId:0];
    NSMutableArray* tableViewControllers = [NSMutableArray array];
    for (HealthyEducationColumeModel* columeModel in _educationColumes) {
        HealthEducationListTableViewController* tableViewController = [[HealthEducationListTableViewController alloc] initWithColumeId:columeModel.classProgramTypeId];
        [tableViewControllers addObject:tableViewController];
    }
    
    [self.tabbarController setViewControllers:tableViewControllers];
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex
{
    [self.tabbarController setSelectedIndex:selectedIndex];
//    HealthyEducationColumeModel* model = self.educationColumes[selectedIndex];
    
    //[self.educationListTableViewController setColumeId:model.classProgramTypeId];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (taskError != StepError_None)
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
    
    if ([taskname isEqualToString:@"HealthEducationColumeTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* columes = (NSArray*) taskResult;
            [self educationColumesLoaded:columes];
        }
    }
}

@end
