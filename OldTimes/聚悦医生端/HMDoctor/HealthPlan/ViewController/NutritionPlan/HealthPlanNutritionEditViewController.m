//
//  HealthPlanNutritionEditViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/25.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanNutritionEditViewController.h"
#import "HealthPlanNutrionSelectSuggestionTableViewCell.h"



@interface HealthPlanNutritionEditViewController ()
<TaskObserver,
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) HeathPlanNutritionEditHandle editHandle;

@property (nonatomic, strong) UIView* commitView;
@property (nonatomic, strong) UIButton* commitButton;

@property (nonatomic, strong) UITableView* suggestionTableView;

@property (nonatomic, strong) NSString* typeCode;

@property (nonatomic, strong) NSMutableArray* criterias;
@property (nonatomic, strong) NSMutableArray* selectedCriterias;

@end

@implementation HealthPlanNutritionEditViewController

- (id) initWithTypeCode:(NSString*) typeCode
             editHandle:(HeathPlanNutritionEditHandle)handle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _typeCode = typeCode;
        _editHandle = handle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"常用建议";
    
    UIBarButtonItem* appendSuggestButton = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(appendSuggestButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:appendSuggestButton];
    
    [self layoutElements];
    
    [self loadSuggestionList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.suggestionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64);
    }];
    
    [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@59);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commitView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
    }];
}

- (void) loadSuggestionList
{
    //HealthPlanNutritionSuggestionListTask
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    _selectedCriterias = [NSMutableArray array];
    
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:self.typeCode forKey:@"typeCode"];
    [paramDictionary setValue:[NSString stringWithFormat:@"%ld", (long)staff.staffId] forKey:@"staffId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanSuggestionListTask" taskParam:paramDictionary TaskObserver:self];
}

- (void) commitButtonClicked:(id) sender
{
    if (self.selectedCriterias.count == 0) {
        [self showAlertMessage:@"请选择至少一个建议。"];
        return;
    }
    if (self.editHandle) {
        self.editHandle(self.selectedCriterias);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) appendSuggestButtonClicked:(id) sender
{
    //新建建议
    HealthPlanDetCriteriaModel* newModel = [[HealthPlanDetCriteriaModel alloc] init];
    [HealthPlanViewControllerManager createHealthPlanEditSuggestWith:newModel editHanle:^(HealthPlanDetCriteriaModel *model) {
        [self.criterias addObject:model];
        [self.suggestionTableView reloadData];
        [HealthPlanUtil postEditNotification];
    }];
}

#pragma mark - settingAndGetting
- (UITableView*) suggestionTableView
{
    if (!_suggestionTableView) {
        _suggestionTableView = [[UITableView alloc] init];
        [self.view addSubview:_suggestionTableView];
        [_suggestionTableView setBackgroundColor:[UIColor whiteColor]];
        [_suggestionTableView setDataSource:self];
        [_suggestionTableView setDelegate:self];
    }
    return _suggestionTableView;
}

- (UIView*) commitView
{
    if (!_commitView) {
        _commitView = [[UIView alloc] init];
        [self.view addSubview:_commitView];
        [_commitView setBackgroundColor:[UIColor whiteColor]];
    }
    return _commitView;
}

- (UIButton*) commitButton
{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commitView addSubview:_commitButton];
        
        [_commitButton setTitle:@"保存" forState:UIControlStateNormal];
        [_commitButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        _commitButton.layer.cornerRadius = 4;
        _commitButton.layer.masksToBounds = YES;
        [_commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.criterias) {
        return self.criterias.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanNutrionSelectSuggestionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthPlanNutrionSelectSuggestionTableViewCell"];
    if (!cell) {
        cell = [[HealthPlanNutrionSelectSuggestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthPlanNutrionSelectSuggestionTableViewCell"];
    }
    HealthPlanDetCriteriaModel* model = self.criterias[indexPath.row];
    [cell setHealthPlanDetCriteriaModel:model];
    [cell setIsSelected:( [self.selectedCriterias indexOfObject:model] !=NSNotFound)];
   ;
    
    return cell;
}

#pragma mark - uITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanDetCriteriaModel* model = self.criterias[indexPath.row];
    
    CGFloat cellHeight = [model.suggest heightSystemFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 55)] + 24;
    if (cellHeight < 45)
    {
        cellHeight = 45;
    }
    return cellHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanDetCriteriaModel * model = self.criterias[indexPath.row];
    if ([self.selectedCriterias indexOfObject:model] == NSNotFound) {
        [self.selectedCriterias addObject:model];
    }
    else
    {
        [self.selectedCriterias removeObject:model];
    }
    
    
    [self.suggestionTableView reloadData];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self.suggestionTableView reloadData];
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
    
    if ([taskname isEqualToString:@"HealthPlanSuggestionListTask"])
    {
        if ([taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* suggestions = (NSArray*) taskResult;
            _criterias = [NSMutableArray array];
            
            [suggestions enumerateObjectsUsingBlock:^(NSString* suggest, NSUInteger idx, BOOL * _Nonnull stop) {
                HealthPlanDetCriteriaModel* model = [[HealthPlanDetCriteriaModel alloc] init];
                model.suggest = suggest;
                [_criterias addObject:model];
                
            }];
            
        }
    }
}
@end
