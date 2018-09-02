//
//  HealthPlanNutritionDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/25.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanNutritionDetailViewController.h"
#import "HealthPlanNutritionSuggestionTableViewCell.h"

@interface HealthPlanNutritionDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) HealthPlanDetailSectionModel* detailModel;

@property (nonatomic, strong) UIView* suggestView;
@property (nonatomic, strong) UILabel* suggestLabel;
@property (nonatomic, strong) UITableView* planTableView;

//@property (nonatomic, strong) NSArray* suggestStrings;
@property (nonatomic, strong) HealthPlanDetCriteriaModel* criteriaModel;

@end

@implementation HealthPlanNutritionDetailViewController

- (id) initWithDetailModel:(HealthPlanDetailSectionModel*) detailModel status:(NSString*) status
{
    self = [super init];
    if (self) {
        _detailModel = detailModel;
        
        _criteriaModel = [self.detailModel.criterias firstObject];
        if (!_criteriaModel) {
            _criteriaModel = [[HealthPlanDetCriteriaModel alloc] init];
            _criteriaModel.suggest = @"";
        }
        _status = status;
    }
    return self;
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

- (void) layoutElements
{
    [self.suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(34);
    }];
    
    [self.suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.suggestView).offset(12.5);
        make.centerY.equalTo(self.suggestView);
    }];
    
    [self.planTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.suggestView.mas_bottom);
    }];
}

#pragma mark - click event
- (void) appendDetectButtonClicked:(id) sender
{
    __weak typeof(self) weakSelf = self;
    [HealthPlanViewControllerManager createHealthPlanNutritionEditViewController:self.detailModel.code editHandle:^(NSArray *criterias) {
        if (!weakSelf) {
            return ;
        }
        __strong typeof(self) strongSelf = weakSelf;
        [criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (strongSelf.criteriaModel.suggest && self.criteriaModel.suggest.length > 0)
            {
                strongSelf.criteriaModel.suggest = [strongSelf.criteriaModel.suggest stringByAppendingFormat:@"\n%@", model.suggest];
                
            }
            else
            {
                strongSelf.criteriaModel.suggest = model.suggest;
            }
        }];
//        NSMutableArray* existedcriterias = [NSMutableArray arrayWithArray:strongSelf.detailModel.criterias];
//        [existedcriterias addObjectsFromArray:criterias];
//        strongSelf.detailModel.criterias = existedcriterias;
        [strongSelf.planTableView reloadData];
        [HealthPlanUtil postEditNotification];
    }];
}

#pragma mark - UITableView data source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.detailModel && self.detailModel.criterias) {
//        return self.detailModel.criterias.count;
        return 1;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanNutritionSuggestionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthPlanNutritionSuggestionTableViewCell"];
    if (!cell) {
        cell = [[HealthPlanNutritionSuggestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthPlanNutritionSuggestionTableViewCell"];
    }
    
    HealthPlanDetCriteriaModel* model = self.detailModel.criterias[indexPath.row];
    [cell setSuggestion:model.suggest];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanDetCriteriaModel* model = self.detailModel.criterias[indexPath.row];
    NSString* suggestString = model.suggest;
//    CGFloat cellHeight = [suggestString heightSystemFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 25)] + 23;
    CGFloat cellHeight = [suggestString heightSystemFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 25) lineSpace:5 paragraphSpacing:10] + 23;
    
    if (cellHeight < 45) {
        cellHeight = 45;
    }
    
    return cellHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanDetCriteriaModel* model = self.detailModel.criterias[indexPath.row];
    [HealthPlanViewControllerManager createHealthPlanEditSuggestWith:model editHanle:^(HealthPlanDetCriteriaModel *model) {
        [self.planTableView reloadData];
        [HealthPlanUtil postEditNotification];
    }];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
//    if (!staffPrivilege) {
//        return NO;
//    }
//    
//    if (self.detailModel.criterias.count > 1) {
//        return YES;
//    }
//
//    return NO;
//}
//
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableArray* criterias = [NSMutableArray arrayWithArray: self.detailModel.criterias];
//    [criterias removeObjectAtIndex:indexPath.row];
//    self.detailModel.criterias = criterias;
//    
//    [self.planTableView reloadData];
//    [HealthPlanUtil postEditNotification];
//}

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

- (UIView*) suggestView
{
    if (!_suggestView) {
        _suggestView = [[UIView alloc] init];
        [self.view addSubview:_suggestView];
        [_suggestView setBackgroundColor:[UIColor whiteColor]];
        [_suggestView showBottomLine];
    }
    return _suggestView;
}

- (UILabel*) suggestLabel
{
    if (!_suggestLabel) {
        _suggestLabel = [[UILabel alloc] init];
        [self.suggestView addSubview:_suggestLabel];
        [_suggestLabel setText:@"建议"];
        [_suggestLabel setTextColor:[UIColor commonTextColor]];
        [_suggestLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _suggestLabel;
}

@end
