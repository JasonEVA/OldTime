//
//  HealthPlanReviewDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanReviewDetailViewController.h"
#import "HealthPlanReviewTableViewCell.h"
#import "HealthPlanReviewIndicesTableViewController.h"

@interface HealthPlanReviewDetailViewController ()
<UITableViewDelegate, UITableViewDataSource>
{
    NSIndexPath* editIndexPath;
}
@property (nonatomic, strong) NSString* status;

@property (nonatomic, strong) HealthPlanDetailSectionModel* detailModel;
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation HealthPlanReviewDetailViewController

- (id) initWithDetailModel:(HealthPlanDetailSectionModel*) detailModel
                    status:(NSString*) status

{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _detailModel = detailModel;
        _status = status;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:self.detailModel.title];
    [self layoutElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return;
    }
    
    UIBarButtonItem* appendButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(appendDetectButtonClicked:)];
    UINavigationItem* topNavigationItem = [HMViewControllerManager topMostController].navigationItem;
    [topNavigationItem setRightBarButtonItem:appendButton];
}

- (void) layoutElements
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void) appendDetectButtonClicked:(id) sender
{
    HealthPlanReviewIndicesTableViewController* tableViewController =  [[HealthPlanReviewIndicesTableViewController alloc] initWithHandle:^(HealthPlanReviewIndicesModel *model) {
        NSMutableArray* criterias = [NSMutableArray arrayWithArray:self.detailModel.criterias];
        HealthPlanDetCriteriaModel* criteriaModel = [HealthPlanDetCriteriaModel alloc];
        criteriaModel.indicesCode = model.id;
        criteriaModel.indicesName = model.name;
        criteriaModel.periodType = @"2";
        criteriaModel.periodValue = @"1";
        [criterias addObject:criteriaModel];
        self.detailModel.criterias = criterias;
        [self.tableView reloadData];
        [HealthPlanUtil postEditNotification];
    }];
    HMBaseNavigationViewController* navigationController = [[HMBaseNavigationViewController alloc] initWithRootViewController:tableViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UITableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.detailModel && self.detailModel.criterias) {
        return self.detailModel.criterias.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanReviewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthPlanReviewTableViewCell"];
    if (!cell) {
        cell = [[HealthPlanReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthPlanReviewTableViewCell"];
    }
    
    HealthPlanDetCriteriaModel* model = self.detailModel.criterias[indexPath.row];
    [cell setHealthPlanDetCriteriaModel:model];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableView delegate
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return;
    }
    editIndexPath = indexPath;
    HealthPlanDetCriteriaModel* model = self.detailModel.criterias[indexPath.row];
    //createHealthPlanReviewEditView
    [HealthPlanViewControllerManager createHealthPlanReviewEditView:model handel:^(HealthPlanDetCriteriaModel *model) {
        NSMutableArray* criterias = [NSMutableArray arrayWithArray:self.detailModel.criterias];
        [criterias replaceObjectAtIndex:editIndexPath.row withObject:model];
        self.detailModel.criterias = criterias;
        
        [self.tableView reloadData];
        
        [HealthPlanUtil postEditNotification];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return NO;
    }
    if (self.detailModel.criterias && self.detailModel.criterias.count > 1) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* criterias = [NSMutableArray arrayWithArray:self.detailModel.criterias];
    [criterias removeObjectAtIndex:indexPath.row];
    self.detailModel.criterias = criterias;
    [self.tableView reloadData];
    
    [HealthPlanUtil postEditNotification];
}

#pragma mark - settingAndGetting
- (UITableView*) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}


@end
