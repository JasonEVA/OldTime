//
//  HealthFillFormDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/23.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthFillFormDetailViewController.h"
#import "HealthFillFormDetailTableViewCell.h"
#import "HealthFillFormTemplateListViewController.h"

@interface HealthFillFormDetailViewController ()
<UITableViewDelegate, UITableViewDataSource>
{
    NSIndexPath* editIndexPath;
}
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) UITableView* planTableView;
@property (nonatomic, strong) HealthPlanDetailSectionModel* detailModel;

@end

@implementation HealthFillFormDetailViewController

- (id) initWithDetailModel:(HealthPlanDetailSectionModel*) detailModel status:(NSString*) status 
{
    self = [super init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) appendDetectButtonClicked:(id) sender
{
    __weak typeof(self) weakSelf = self;
    HealthFillFormTemplateListViewController* templatelistViewController = [[HealthFillFormTemplateListViewController alloc] initWithCode:self.detailModel.code handle:^(HealthPlanFillFormTemplateModel *model) {
        if (!weakSelf) {
            return ;
        }
        
        __block BOOL isExisted = NO;
        [weakSelf.detailModel.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* existedmodel, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* surveyMoudleId = [NSString stringWithFormat:@"%ld", model.surveyMoudleId];
            if ([existedmodel.surveyMoudleId isEqualToString:surveyMoudleId]) {
                isExisted = YES;
                *stop = YES;
                return ;
            }
        }];
        if (isExisted) {
//            [weakSelf showAlertMessage:@"不能添加重复模版。"];
            [weakSelf performSelector:@selector(showAlertMessage:) withObject:@"不能添加重复模版。" afterDelay:0.5];
            return;
        }
        
        HealthPlanDetCriteriaModel* criteriaModel = [HealthPlanDetCriteriaModel alloc];
        criteriaModel.surveyMoudleId = [NSString stringWithFormat:@"%ld", model.surveyMoudleId];
        criteriaModel.surveyMoudleName = model.surveyMoudleName;
        criteriaModel.periodValue = @"1";
        criteriaModel.periodType = @"2";
        
        NSMutableArray* criteriaModels = [NSMutableArray arrayWithArray:self.detailModel.criterias];
        [criteriaModels addObject:criteriaModel];
        self.detailModel.criterias = criteriaModels;
        
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.planTableView reloadData];
        [HealthPlanUtil postEditNotification];
        
    }];
    HMBaseNavigationViewController* templatelistNavigationController = [[HMBaseNavigationViewController alloc] initWithRootViewController:templatelistViewController];
    
    [self presentViewController:templatelistNavigationController animated:YES completion:nil];
}

- (NSDictionary*) controllerParamDictionary
{
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    if (self.detailModel && self.detailModel.planId) {
        [paramDictionary setValue:self.detailModel.planId forKey:@"planId"];
    }
    
    return paramDictionary;
}
- (void) layoutElements
{
    [self.planTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.detailModel.criterias)
    {
        return self.detailModel.criterias.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HealthFillFormDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthFillFormDetailTableViewCell"];
    if (!cell) {
        cell = [[HealthFillFormDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthFillFormDetailTableViewCell"];
    }
    
    HealthPlanDetCriteriaModel* model = self.detailModel.criterias[indexPath.row];
    [cell setHealthPlanDetCriteriaModel:model];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return;
    }
    HealthPlanDetCriteriaModel* model = self.detailModel.criterias[indexPath.row];
    editIndexPath = indexPath;
    [HealthPlanViewControllerManager createHealthPlanFillFormEditViewController:model code:self.detailModel.code handel:^(HealthPlanDetCriteriaModel *model) {
        NSMutableArray* criterias = [NSMutableArray arrayWithArray:self.detailModel.criterias];
        [criterias replaceObjectAtIndex:editIndexPath.row withObject:model];
        self.detailModel.criterias = criterias;

        [self.planTableView reloadData];
        [HealthPlanUtil postEditNotification];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
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
    [self.planTableView reloadData];
    [HealthPlanUtil postEditNotification];
}
#pragma mark - settingAndGetting
- (UITableView*) planTableView
{
    if (!_planTableView) {
        _planTableView = [[UITableView alloc] init];
        [self.view addSubview:_planTableView];
        [_planTableView setBackgroundColor:[UIColor whiteColor]];
        
        [self.planTableView setDataSource:self];
        [self.planTableView setDelegate:self];
    }
    return _planTableView;
}

@end
