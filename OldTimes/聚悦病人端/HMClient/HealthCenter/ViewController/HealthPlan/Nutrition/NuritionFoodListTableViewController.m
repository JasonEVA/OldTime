//
//  NuritionFoodListTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionFoodListTableViewController.h"
#import "FoodVolumeSelectViewController.h"
#import "UIImage+EX.h"

#define kNuritionFoodListPageSize           20

@interface NuritionFoodListTableViewController ()
<TaskObserver,UISearchBarDelegate>
{
    NSMutableArray* foodItems;
    NSInteger totalCount;
    NSInteger foodVolume;
    UISearchBar *searchBar;
}
@end

@implementation NuritionFoodListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFoodList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;

    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setSearchName:(NSString *)searchName
{
    _searchName = searchName;
    [self.tableView.mj_header beginRefreshing];
}

- (void) loadFoodList
{
    foodItems = [NSMutableArray array];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kNuritionFoodListPageSize] forKey:@"rows"];
    if (_searchName)
    {
        [dicPost setValue:_searchName forKey:@"name"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"NuritionFoodListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreFoodList
{
    if (!foodItems)
    {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:foodItems.count] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kNuritionFoodListPageSize] forKey:@"rows"];
    if (_searchName)
    {
        [dicPost setValue:_searchName forKey:@"name"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"NuritionFoodListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (foodItems)
    {
        return foodItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
  
    UILabel* lbTitle = [[UILabel alloc]init];
    [headerview addSubview:lbTitle];
    //[lbTitle setBackgroundColor:[UIColor colorWithHexString:@"FFCC11"]];
    [lbTitle setTextColor:[UIColor commonTextColor]];
    [lbTitle setFont:[UIFont font_30]];
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview).with.offset(12.5);
        make.centerY.equalTo(headerview);
    }];
    
    [lbTitle setText:@"常见食物"];
    
    searchBar = [[UISearchBar alloc]init];
    [headerview addSubview:searchBar];
    [searchBar setPlaceholder:@"搜索食物名称"];
    [searchBar setDelegate:self];
    [searchBar setBackgroundImage:[UIImage at_imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth/2, 35)]];
    [searchBar.layer setBorderColor:[UIColor commonGrayTextColor].CGColor];
    [searchBar.layer setBorderWidth:1.0f];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerview).offset(-12.5);
        make.centerY.equalTo(headerview);
        make.height.mas_equalTo(@35);
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    
    
    if (_searchName && 0 < _searchName.length)
    {
        [lbTitle setText:_searchName];
    }
    
    [headerview showBottomLine];
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 83;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NuritionFoodListTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"NuritionFoodListTableViewCell"];
    if (!cell)
    {
        cell = [[NuritionFoodListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NuritionFoodListTableViewCell"];
    }
    
    FoodListItem* food = foodItems[indexPath.row];
    [cell setFood:food];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodListItem* food = foodItems[indexPath.row];
    //弹出食物食用计量界面
    UIViewController* vcTop = [UIViewController topViewController];
    
    //点击将要弹出FoodVolumeSelectViewController，让键盘落下
    if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(popupFoodVolumeSelectVC)]){
        [_selectDelegate popupFoodVolumeSelectVC];
    }
    
    [FoodVolumeSelectViewController showInParentController:vcTop FoodInfo:food FoodVolumeSelectBlock:^(NSInteger vol) {
        foodVolume = vol;
        [self performSelector:@selector(updateUserDiet:) withObject:food afterDelay:0.3];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchBar resignFirstResponder];
    //滑动时，让键盘落下
    if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(popupFoodVolumeSelectVC)]){
        [_selectDelegate popupFoodVolumeSelectVC];
    }
}
- (void) updateUserDiet:(FoodListItem*) food
{
    if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(foodAndNumSelected:Num:)])
    {
        [_selectDelegate foodAndNumSelected:food Num:foodVolume];
    }
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [aSearchBar resignFirstResponder];
    NSString* searchName = aSearchBar.text;
    
    if (!searchName || 0 == searchName.length) {
        return;
    }
    self.searchName = searchName;
    [self.tableView reloadData];
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
    self.searchName = nil;
}

#pragma mark - TaskObserver

- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.mj_header endRefreshing];
    if (self.tableView.mj_footer)
    {
        if (foodItems.count >= totalCount)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData ];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFoodList)];
        }
    }
    
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    [self.tableView reloadData];
    
    if (!foodItems ||0 == foodItems.count) {
        [self showBlankView];
    }
    else
    {
        [self closeBlankView];
    }
    
    if (foodItems.count < totalCount)
    {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFoodList)];
    }

}

- (void) task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"NuritionFoodListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]]) {
                totalCount = numCount.integerValue;
            }
            
            NSArray* items = (NSArray*) [dicResult valueForKey:@"list"];
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载更多。。。
                if (!foodItems)
                {
                    foodItems = [NSMutableArray array];
                }
                
                [foodItems addObjectsFromArray:items];
            }
            else
            {
                foodItems = [NSMutableArray arrayWithArray:items];
                
            }
            
            
        }
    }
}
@end
