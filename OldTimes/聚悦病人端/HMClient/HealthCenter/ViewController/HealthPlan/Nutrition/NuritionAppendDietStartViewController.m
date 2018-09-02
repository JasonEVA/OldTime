//
//  NuritionAppendDietStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionAppendDietStartViewController.h"
#import "NuritionDetail.h"
#import "NuritionFoodListTableViewController.h"

@interface NuritionAppendDietStartViewController ()
<UISearchBarDelegate,
NuritionFoodListDelegate,
TaskObserver>
{
    NuritionDietAppendParam* appendParam;
    UIButton* inputButton;
    UISearchBar* searchBar;
    
    NuritionFoodListTableViewController* tvcFoodList;
}
@end

@implementation NuritionAppendDietStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"添加饮食"];
    if (self.paramObject && [self.paramObject isKindOfClass:[NuritionDietAppendParam class]])
    {
        appendParam = (NuritionDietAppendParam*) self.paramObject;
        NSString* title = @"添加饮食";
        switch (appendParam.dietType) {
            case 1:
                title = @"添加早餐";
                break;
            case 2:
                title = @"添加午餐";
                break;
            case 3:
                title = @"添加晚餐";
                break;
            case 4:
                title = @"添加加餐";
                break;
            default:
                break;
        }
        [self.navigationItem setTitle:title];
    }
    
    inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:inputButton];
    [inputButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [inputButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [inputButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inputButton.titleLabel setFont:[UIFont font_30]];
    [inputButton setTitle:@"手写录入" forState:UIControlStateNormal];
    [inputButton setImage:[UIImage imageNamed:@"icon_pen"] forState:UIControlStateNormal];
    [inputButton addTarget:self action:@selector(inputButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createSearchBar];
    [self createFoodListTable];
}

- (void) inputButtonClicked:(id) sender
{
    //跳转到手动录入界面
    [HMViewControllerManager createViewControllerWithControllerName:@"DietFoodInputViewController" ControllerObject:appendParam];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createSearchBar
{
    searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:searchBar];
    [searchBar setPlaceholder:@"搜索食物名称"];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@50);
    }];
    //[searchBar setShowsCancelButton:YES];
    [searchBar setDelegate:self];
}

- (void) createFoodListTable
{
    tvcFoodList = [[NuritionFoodListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcFoodList];
    [self.view addSubview:tvcFoodList.tableView];
    [tvcFoodList.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(inputButton.mas_top);
        make.top.equalTo(searchBar.mas_bottom);
    }];
    
    [tvcFoodList setSelectDelegate:self];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [aSearchBar resignFirstResponder];
    NSString* searchName = aSearchBar.text;
    
    if (!searchName || 0 == searchName.length) {
        return;
    }
    
    if (tvcFoodList)
    {
        [tvcFoodList setSearchName:searchName];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar
{
    [searchBar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar
{
    [aSearchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
    [aSearchBar resignFirstResponder];
    if (tvcFoodList)
    {
        [tvcFoodList setSearchName:nil];
    }
}

#pragma mark - NuritionFoodListDelegate
- (void) foodAndNumSelected:(FoodListItem*) food
                        Num:(NSInteger) num
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:appendParam.dietType] forKey:@"dietType"];
    if (appendParam.date)
    {
        [dicPost setValue:appendParam.date forKey:@"date"];
    }
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld", food.id] forKey:@"foodId"];
    [dicPost setValue:[NSNumber numberWithInteger:num] forKey:@"foodNum"];
    [dicPost setValue:[NSNumber numberWithInteger:1] forKey:@"foodUnit"];
    
    [self.view showWaitView];
    //AppendDietRecordTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"AppendDietRecordTask" taskParam:dicPost TaskObserver:self];
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
    
    //跳转到饮食记录
    [HMViewControllerManager createViewControllerWithControllerName:@"NuritionDietRecordsStartViewController" ControllerObject:appendParam.date];
}
@end
