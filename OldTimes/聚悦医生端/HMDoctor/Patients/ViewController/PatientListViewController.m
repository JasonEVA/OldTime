//
//  PatientListViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientListViewController.h"
#import "PatientTableViewController.h"
#import "PatientListTableViewCell.h"
#import "RowButtonGroup.h"
#import "PatientLetterOrderTableViewController.h"
#import "PatientSearchResultTableViewController.h"
#import "ATModuleInteractor+PatientChat.h"

typedef NS_ENUM(NSUInteger, PatientsOrderType) {
    PatientsOrderTypeByGroup,
    PatientsOrderTypeByLetter,
};

@interface PatientListViewController ()
<UIPageViewControllerDelegate,UIPageViewControllerDataSource,RowButtonGroupDelegate,TaskObserver,UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic, strong)  RowButtonGroup  *rowButton; // <##>
@property (nonatomic, strong)  UIPageViewController  *pageViewController; //
@property (nonatomic, strong)  PatientTableViewController  *groupOrderVC; // <##>
@property (nonatomic, strong)  PatientLetterOrderTableViewController  *letterOrderVC; // <##>
@property (nonatomic, strong)  PatientSearchResultTableViewController  *resultVC; // <##>
@property (nonatomic, strong)  UITableView  *tableView; //

@property (nonatomic, strong)  UISearchController  *searchVC; // <##>

@property (nonatomic, strong)  NSMutableArray  *sourcePatients; // <##>

@end

@implementation PatientListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"用户列表"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configElements];
    [self requestPatientsList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchVC.active) {
        self.searchVC.active = NO;
        [self.searchVC.searchBar removeFromSuperview];
    }
}

#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置数据
- (void)configData {
    [self.pageViewController setViewControllers:@[self.groupOrderVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.rowButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];

    [self.rowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom).offset(-1);
        make.height.mas_equalTo(45);
    }];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.rowButton.mas_bottom);
    }];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)requestPatientsList {
    StaffInfo *currentStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (!currentStaff) {
        return;
    }
    NSDictionary *dictParam = @{
                                @"staffId" : [NSString stringWithFormat:@"%ld", currentStaff.staffId]
                                };

    [[TaskManager shareInstance] createTaskWithTaskName:@"PatientListTask" taskParam:dictParam TaskObserver:self];
    [self at_postLoading];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - RowButtonDelegate

- (void)RowButtonGroupDelegateCallBack_btnClickedWithTag:(NSInteger)tag {
    PatientsOrderType type = (PatientsOrderType)tag;
    switch (type) {
        case PatientsOrderTypeByGroup: {
            [self.pageViewController setViewControllers:@[self.groupOrderVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

            break;
        }
            
        case PatientsOrderTypeByLetter: {
            [self.pageViewController setViewControllers:@[self.letterOrderVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

            break;
        }

    }
}

#pragma mark - PageViewControllerDataSource && Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == self.letterOrderVC) {
        return self.groupOrderVC;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (viewController == self.groupOrderVC) {
        return self.letterOrderVC;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if ([previousViewControllers containsObject:self.groupOrderVC] && self.rowButton.selectedBtn.tag != PatientsOrderTypeByLetter) {
        [self.rowButton setBtnSelectedWithTag:PatientsOrderTypeByLetter];
    }
    else if ([previousViewControllers containsObject:self.letterOrderVC] && self.rowButton.selectedBtn.tag != PatientsOrderTypeByGroup) {
        [self.rowButton setBtnSelectedWithTag:PatientsOrderTypeByGroup];
    }
}

#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"-------------->%@",[NSThread currentThread]);
    if (searchController.searchBar.text.length > 0) {
        PatientSearchResultTableViewController *VC = (PatientSearchResultTableViewController *)searchController.searchResultsController;
        [VC updateResultsWithKeywords:searchController.searchBar.text resultClicked:^(id resultData) {
            if ([resultData isKindOfClass:[PatientInfo class]]) {
                [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)[resultData userId]]];
            }

        }];
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self at_hideLoading];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"PatientListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* groups = (NSArray*) taskResult;
            [self.sourcePatients removeAllObjects];
            [self.sourcePatients addObjectsFromArray:groups];
            NSMutableArray *array = [NSMutableArray array];
            [groups enumerateObjectsUsingBlock:^(PatientGroupInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObjectsFromArray:obj.users];
            }];
            [self.letterOrderVC configPatientsData:array];
            [self.resultVC configWithSourceData:array];
            
        }
    }
}

#pragma mark - <UIBarPositioningDelegate>

// Make sure NavigationBar is properly top-aligned to Status bar,自定义searcontroller的searBar会有位置偏移不正常的情况
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    if (bar == self.searchVC.searchBar) {
        return UIBarPositionTopAttached;
    }
    else { // Handle other cases
        return UIBarPositionAny;
    }
}
#pragma mark - Override

#pragma mark - Init

- (RowButtonGroup *)rowButton {
    if (!_rowButton) {
        _rowButton = [[RowButtonGroup alloc] initWithTitles:@[@"按服务组",@"按字母"] tags:@[@(PatientsOrderTypeByGroup),                                       @(PatientsOrderTypeByLetter)] normalTitleColor:[UIColor commonLightGrayColor_999999] selectedTitleColor:[UIColor mainThemeColor] font:[UIFont font_32] lineColor:[UIColor mainThemeColor]];
        _rowButton.delegate = self;
        _rowButton.backgroundColor = [UIColor whiteColor];
    }
    return _rowButton;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

- (PatientTableViewController *)groupOrderVC {
    if (!_groupOrderVC) {
        _groupOrderVC = [[PatientTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _groupOrderVC;
}

- (PatientLetterOrderTableViewController *)letterOrderVC {
    if (!_letterOrderVC) {
        _letterOrderVC = [[PatientLetterOrderTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _letterOrderVC.tableView.sectionIndexColor = [UIColor mainThemeColor];
        _letterOrderVC.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    return _letterOrderVC;
}

- (NSMutableArray *)sourcePatients {
    if (!_sourcePatients) {
        _sourcePatients = [NSMutableArray array];
    }
    return _sourcePatients;
}

- (UISearchController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
        _searchVC.searchResultsUpdater = self;
        _searchVC.searchBar.delegate = self;
        _searchVC.searchBar.placeholder = @"输入姓名搜索";
        [_searchVC.searchBar setBarTintColor: [UIColor colorWithHexString:@"f0f0f0"]];
        [_searchVC.searchBar sizeToFit];
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        self.definesPresentationContext = YES;
    }
    return _searchVC;
}

- (PatientSearchResultTableViewController *)resultVC {
    if (!_resultVC) {
        _resultVC = [[PatientSearchResultTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _resultVC;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView setTableHeaderView:self.searchVC.searchBar];
    }
    return _tableView;
}
@end
