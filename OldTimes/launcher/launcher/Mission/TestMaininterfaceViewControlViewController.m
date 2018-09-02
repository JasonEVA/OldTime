//
//  TestMaininterfaceViewControlViewController.m
//  launcher
//
//  Created by Conan Ma on 15/8/28.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TestMaininterfaceViewControlViewController.h"
#import "TaskAddNewProgressViewController.h"
#import "TaskWithTwoLabelsTableViewCell.h"
#import "TaskAddNewTagViewController.h"
#import "MissionMianViewController.h"
#import "GetProjectListRequest.h"
#import "ProjectSearchDefine.h"
#import <Masonry/Masonry.h>
#import "UIImage+Manager.h"
#import "ProjectModel.h"
#import "Category.h"
#import "MyDefine.h"

@interface TestMaininterfaceViewControlViewController () <UITableViewDataSource, UITableViewDelegate, BaseRequestDelegate>

@property (nonatomic, strong) UITableView *tableviewProject;
@property (nonatomic, strong) UITableView *tableviewTaskList;

@property (nonatomic, strong) UIButton *btnAddProgress;
@property (nonatomic, strong) UIButton *btnfilter;
@property (nonatomic, strong) UIButton *btnTag;
@property (nonatomic, strong) UIButton *btnTagAdd;

/** 项目 */
@property (nonatomic, strong) NSMutableArray *projectArray;
/** 下面的tableview 公用的数据数组 */
@property (nonatomic, strong) NSArray *filterArray;
/** 下面的tableview 的tag数组 */
@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, assign) NSInteger selectedPro;
@property (nonatomic, assign) NSInteger seletedFilter;
@property (nonatomic, assign) NSInteger selectedTag;

@property (nonatomic, assign) BOOL showTag;

@property (nonatomic, strong) GetProjectListRequest *projectListRequest;

@end

@implementation TestMaininterfaceViewControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self popGestureDisabled:YES];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton setImage:[UIImage imageNamed:@"Mission_Three_lines_Selected"] forState:UIControlStateNormal];
    
    [leftButton setTitle:LOCAL(MISSION_PROJECT) forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    leftButton.userInteractionEnabled = NO;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIBarButtonItem *btnright = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"disclosureIndicator"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setRightBarButtonItem:btnright];
    
    [self createFrames];
    [self getNewRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableviewTaskList reloadData];
}

- (void)createFrames {
    [self.view addSubview:self.btnAddProgress];
    
    [self.btnAddProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY).offset(-10);
        make.height.equalTo(@(30));
    }];
    [self.view addSubview:self.tableviewProject];
    
    [self.tableviewProject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.btnAddProgress.mas_top).offset(-10);
    }];
    [self.view addSubview:self.btnfilter];
    [self.btnfilter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY);
        make.left.right.equalTo(self.view);
//        make.width.equalTo(@(self.view.frame.size.width/2));
        make.height.equalTo(@(40));
    }];
//    [self.view addSubview:self.btnTag];
//    [self.btnTag mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.btnfilter);
//        make.left.equalTo(self.btnfilter.mas_right);
//        make.right.equalTo(self.view);
//        make.height.equalTo(self.btnfilter);
//    }];
    [self.view addSubview:self.btnTagAdd];
    [self.btnTagAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(- 10);
        make.height.width.equalTo(self.btnAddProgress);
    }];
    [self.view addSubview:self.tableviewTaskList];
    [self.tableviewTaskList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnfilter.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnTagAdd.mas_top).offset(-10);
    }];
}

#pragma mark - Button Click
- (void)back {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)addNewProject {
    TaskAddNewProgressViewController *vc = [[TaskAddNewProgressViewController alloc] initWithCompletion:^(ProjectModel *project) {
        [self.projectArray insertObject:project atIndex:0];
        [self.tableviewProject insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addTagAction {
    TaskAddNewTagViewController *vc = [[TaskAddNewTagViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnFilterandTagClick:(UIButton *)sender
{
    self.showTag = (sender == self.btnTag);
    self.btnTag.selected    = self.showTag;
    self.btnfilter.selected = !self.showTag;
    
    [self.btnTagAdd setHidden:(sender == self.btnfilter)];
    
    [self.tableviewTaskList reloadData];
}

#pragma mark - Privite Methods
- (void)getNewRequest {
    [self postLoading];
    self.projectListRequest = [[GetProjectListRequest alloc] initWithDelegate:self];
    [self.projectListRequest getNewList];
}

- (NSUInteger)allProjectTask {
    NSUInteger allTask = 0;
    for (ProjectModel *project in self.projectArray) {
        allTask += project.taskCounts;
    }
    return allTask;
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[GetProjectListRequest class]]) {
        [self hideLoading];
        NSArray *array = [(GetProjectListResponse *)response arrayProjects];
        [self.projectArray addObjectsFromArray:array];
        [self.tableviewProject reloadData];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableviewProject) {
        return self.projectArray.count;
    }

    if (self.showTag) {
        return self.tagArray.count;
    }
    
    return self.filterArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"idntifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell textLabel].font = [UIFont mtc_font_30];
        [cell detailTextLabel].font = [UIFont mtc_font_30];
    }
    
    NSInteger selectedIndex = 0;
    
    ProjectModel *model = [[ProjectModel alloc] init];
    
    if (tableView == self.tableviewProject) {
        model = [self.projectArray objectAtIndex:indexPath.row];
        selectedIndex = self.selectedPro;
    }
    else if (self.showTag){
        // tag
        model = [self.tagArray objectAtIndex:indexPath.row];
        selectedIndex = self.selectedTag;
    } else {
        // 过滤
        model = [self.filterArray objectAtIndex:indexPath.row];
        selectedIndex = self.seletedFilter;
    }
    
    [cell textLabel].text = model.name;
    [cell detailTextLabel].text = model.taskCountsString;
    
    if (selectedIndex == indexPath.row) {
        [cell textLabel].textColor = [UIColor themeBlue];
        [cell detailTextLabel].textColor = [UIColor themeBlue];
    } else {
        [cell textLabel].textColor = [UIColor blackColor];
        [cell detailTextLabel].textColor = [UIColor minorFontColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MissionMianViewController *VC = nil;
    
    if (tableView == self.tableviewProject) {
        self.selectedPro = indexPath.row;
        
        VC = [[MissionMianViewController alloc] initWithProject:[self.projectArray objectAtIndex:indexPath.row]];
    }
    else {
        if (self.showTag) {
            self.selectedTag = indexPath.row;
        } else {
            self.seletedFilter = indexPath.row;
            
            NSInteger index = indexPath.row;
            if (index > 0) {
                index ++;
            }
            VC = [[MissionMianViewController alloc] initWithSearchType:index];
        }
    }
    [tableView reloadData];
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - create
- (UIButton *)createButtonTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] init];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor mtc_colorWithHex:0x959595] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0xebebeb]] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor themeBlue] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
    
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor grayBackground].CGColor;
    
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(btnFilterandTagClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - init
- (UITableView *)tableviewProject
{
    if (!_tableviewProject)
    {
        _tableviewProject = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableviewProject.backgroundColor = [UIColor whiteColor];
        _tableviewProject.delegate = self;
        _tableviewProject.dataSource = self;
    }
    return _tableviewProject;
}

- (UITableView *)tableviewTaskList
{
    if (!_tableviewTaskList)
    {
        _tableviewTaskList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableviewTaskList.backgroundColor = [UIColor whiteColor];
        _tableviewTaskList.delegate = self;
        _tableviewTaskList.dataSource = self;
    }
    return _tableviewTaskList;
}

- (UIButton *)btnAddProgress
{
    if (!_btnAddProgress)
    {
        _btnAddProgress = [UIButton new];
        _btnAddProgress.titleLabel.font = [UIFont mtc_font_30];
        [_btnAddProgress setImage:[UIImage imageNamed:@"Cross_Add_Gray"] forState:UIControlStateNormal];
        [_btnAddProgress setTitle:LOCAL(MISSION_PROJECT) forState:UIControlStateNormal];
        [_btnAddProgress setTitleColor:[UIColor mtc_colorWithHex:0x959595] forState:UIControlStateNormal];
        
        [_btnAddProgress setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
        [_btnAddProgress setImage:[[UIImage imageNamed:@"Cross_Add_Gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];

        [_btnAddProgress setTintColor:[UIColor themeBlue]];
        [_btnAddProgress setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
        
        _btnAddProgress.clipsToBounds = YES;
        _btnAddProgress.layer.cornerRadius = 5;
        _btnAddProgress.layer.borderWidth = 1.0f;
        _btnAddProgress.layer.borderColor = [UIColor borderColor].CGColor;
        [_btnAddProgress addTarget:self action:@selector(addNewProject) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAddProgress;
}

- (UIButton *)btnfilter
{
    if (!_btnfilter)
    {
        _btnfilter = [self createButtonTitle:LOCAL(MISSION_PASS)];
        _btnfilter.selected = YES;
    }
    return _btnfilter;
}

- (UIButton *)btnTag
{
    if (!_btnTag)
    {
        _btnTag = [self createButtonTitle:@"tag"];
    }
    return _btnTag;
}

- (UIButton *)btnTagAdd
{
    if (!_btnTagAdd)
    {
        _btnTagAdd = [[UIButton alloc] init];
        [_btnTagAdd setImage:[UIImage imageNamed:@"Cross_Add_Gray"] forState:UIControlStateNormal];
        [_btnTagAdd setTitle:@"tag" forState:UIControlStateNormal];
        [_btnTagAdd setTitleColor:[UIColor mtc_colorWithHex:0x959595] forState:UIControlStateNormal];
        
        _btnTagAdd.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnTagAdd.layer.cornerRadius = 6.0f;
        _btnTagAdd.layer.borderWidth = 1.0f;
        _btnTagAdd.layer.borderColor = [UIColor grayBackground].CGColor;
        
        [_btnTagAdd addTarget:self action:@selector(addTagAction) forControlEvents:UIControlEventTouchUpInside];
        [_btnTagAdd setHidden:YES];
    }
    return _btnTagAdd;
}

- (NSArray *)filterArray {
    if (!_filterArray) {
        _filterArray =  @[[[ProjectModel alloc] initWithName:LOCAL(MISSION_MYTASK) count:-1],
                          [[ProjectModel alloc] initWithName:LOCAL(MISSION_MYATTENDTASK) count:-1],
                          [[ProjectModel alloc] initWithName:LOCAL(MISSION_MYSENDTASK) count:-1],
                          [[ProjectModel alloc] initWithName:LOCAL(MISSION_ENDTODAY) count:-1],
                          [[ProjectModel alloc] initWithName:LOCAL(MISSION_ENDWEEK) count:-1]];
    }
    return _filterArray;
}

- (NSMutableArray *)projectArray {
    if (!_projectArray) {
        _projectArray = [NSMutableArray array];
    }
    return _projectArray;
}

- (NSMutableArray *)tagArray {
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}

@end
