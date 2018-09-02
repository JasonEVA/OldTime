//
//  PEFSymptomSelectViewController.m
//  HMClient
//
//  Created by lkl on 2017/6/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PEFSymptomSelectViewController.h"
#import "BloodPressureSymptomsTableViewCell.h"
#import "BloodPressureThriceDetectModel.h"

static NSString *const kpiCode = @"FLSZ";
static NSString *const PEFSymptomNotify = @"PEFSymptomValue";

typedef NS_ENUM(NSInteger, SymptomsType) {
    SymptomsType_Selected,
    SymptomsType_Common,
    SymptomsTypeMaxSection,
};

@interface PEFSymptomSelectViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,TaskObserver>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *selectedListArray;
@property (nonatomic, strong) NSArray *commonListArray;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) NSString *searchName;

@end

@implementation PEFSymptomSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"选择症状"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self configElements];
    
    [self bloodPressureSymptomsRequestWithKey:nil];
}

- (void)bloodPressureSymptomsRequestWithKey:(NSString *)searchName
{
    [self.view showWaitView];
    
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    
    _searchName = searchName;
    if (!kStringIsEmpty(searchName)) {
        [dicPost setValue:searchName forKey:@"searchName"];
    }

    [dicPost setValue:kpiCode forKey:@"kpiCode"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureThriceDetectSymptomsTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Interface Method

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    UIBarButtonItem *finishButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishButtonItemClick)];
    [self.navigationItem setRightBarButtonItem:finishButtonItem];
    
    //血压
    if (self.paramObject && [self.paramObject isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)self.paramObject;
        if (!kArrayIsEmpty(array)) {
            [self.selectedListArray addObjectsFromArray:array];
        }
    }
    
    _searchBar = [[UISearchBar alloc] init];
    [self.view addSubview:_searchBar];
    [_searchBar setPlaceholder:@"请输入关键词，例如：发烧"];
    [_searchBar setShowsCancelButton:YES];
    [_searchBar setDelegate:self];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(@50);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_searchBar.mas_bottom);
    }];
}

- (void)finishButtonItemClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PEFSymptomNotify object:self.selectedListArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return SymptomsTypeMaxSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case SymptomsType_Selected:
            return self.selectedListArray.count;
            break;
            
        case SymptomsType_Common:
            return _commonListArray.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//区头的字体颜色设置
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor mainThemeColor];
    header.textLabel.font = [UIFont font_28];
    header.contentView.backgroundColor = [UIColor whiteColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case SymptomsType_Selected:
            return @"已选症状:";
            break;
            
        case SymptomsType_Common:
            return kStringIsEmpty(_searchName) ?  @"常见症状:" : @"搜索结果";
            break;
            
        default:
            break;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BloodPressureSymptomsTableViewCell *cell = [[BloodPressureSymptomsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BloodPressureSymptomsTableViewCell at_identifier]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    switch (indexPath.section) {
        case SymptomsType_Selected:
        {
            BloodPressureThriceDetectModel *model = self.selectedListArray[indexPath.row];
            [cell setSymptomTitle:model.name image:@"icon_sc_01" prompt:@"删除" color:[UIColor commonTextColor]];
            break;
        }
            
        case SymptomsType_Common:
        {
            BloodPressureThriceDetectModel *model = _commonListArray[indexPath.row];
            [cell setSymptomTitle:model.name image:@"icon_tj_01" prompt:@"添加" color:[UIColor mainThemeColor]];
            break;
        }
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SymptomsType_Selected:
        {
            BloodPressureThriceDetectModel *model = self.selectedListArray[indexPath.row];
            [self.selectedListArray removeObject:model];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SymptomsType_Selected] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
            
        case SymptomsType_Common:
        {
            BloodPressureThriceDetectModel *model = _commonListArray[indexPath.row];
            _isSelect = NO;
            
            [self.selectedListArray enumerateObjectsUsingBlock:^(BloodPressureThriceDetectModel *selectedModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([selectedModel.name isEqualToString:model.name]) {
                    [self showAlertMessage:@"您已经添加过该症状"];
                    _isSelect = YES;
                    *stop = YES;
                }
            }];
            if (!_isSelect) {
                [self.selectedListArray addObject:model];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SymptomsType_Selected] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
    // 关闭键盘
    [searchBar resignFirstResponder];
    
    [self bloodPressureSymptomsRequestWithKey:searchBar.text];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SymptomsType_Common] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (kStringIsEmpty(searchText)) {
        [searchBar resignFirstResponder];
        [self bloodPressureSymptomsRequestWithKey:searchBar.text];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SymptomsType_Common] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self bloodPressureSymptomsRequestWithKey:searchBar.text];
    
    // 关闭键盘
    [searchBar resignFirstResponder];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SymptomsType_Common] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[BloodPressureSymptomsTableViewCell class] forCellReuseIdentifier:[BloodPressureSymptomsTableViewCell at_identifier]];
    }
    return _tableView;
}

- (NSMutableArray *)selectedListArray{
    
    if (!_selectedListArray) {
        _selectedListArray = [[NSMutableArray alloc] init];
    }
    return _selectedListArray;
}

#pragma mark -- TaskObserver
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void)task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"BloodPressureThriceDetectSymptomsTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            _commonListArray = (NSArray *)taskResult;
            [self.tableView reloadData];
        }
    }
}


@end
