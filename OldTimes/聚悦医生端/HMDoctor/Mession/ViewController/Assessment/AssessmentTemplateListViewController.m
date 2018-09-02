//
//  AssessmentTempleteListViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AssessmentTemplateListViewController.h"
#import "AssessmentMessionModel.h"

@interface AssessmentTemplateHeaderView : UIView
{
    UIControl* headerControl;
    UILabel* lbTitle;
    UIImageView* ivArrow;
}

@property (nonatomic, assign) BOOL isExtended;

@property (nonatomic, copy) void(^selectSelectedBlock)(NSInteger selSection);

- (void)setHeaderTitle:(NSString *)title;
- (void)setSelectIndex:(NSInteger)index;
- (void)setIsExtended:(BOOL)isExtended;
@end

@implementation AssessmentTemplateHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        headerControl = [[UIControl alloc]init];
        [self addSubview:headerControl];
        [headerControl addTarget:self action:@selector(headerControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.size.mas_equalTo(CGSizeMake(self.width, 30));
            make.centerY.equalTo(self);
        }];
        
        ivArrow = [[UIImageView alloc] init];
        [headerControl addSubview:ivArrow];
        
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@15);
            make.width.mas_equalTo(@15);
            make.centerY.equalTo(headerControl);
            make.left.equalTo(headerControl).with.offset(2);
        }];
        
        lbTitle = [[UILabel alloc]init];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle setFont:[UIFont systemFontOfSize:14]];
        [headerControl addSubview:lbTitle];
        
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivArrow.mas_right).with.offset(5);
            make.centerY.equalTo(headerControl);
        }];
        
    }
    return self;
}

- (void)setHeaderTitle:(NSString *)title
{
    [lbTitle setText:title];
}

- (void)setSelectIndex:(NSInteger)index
{
    [headerControl setTag:(0x100 + index)];
}

- (void)headerControlClicked:(id) sender
{
    NSInteger section = headerControl.tag - 0x100;
    if (_selectSelectedBlock)
    {
        _selectSelectedBlock(section);
    }
}

- (void)setIsExtended:(BOOL)isExtended
{
    //_isExtended = isExtended;
    
    if (isExtended){
        
        [ivArrow setImage:[UIImage imageNamed:@"im-retract"]];
    }
    else{
        [ivArrow setImage:[UIImage imageNamed:@"im-spread"]];
    }
}

@end


@interface AssessmentTemplateCategoryTableViewController : UITableViewController<TaskObserver>
{

}
//患者的UserId
@property (nonatomic, readonly) NSString* patientUserId;
@property (nonatomic, assign) BOOL *isOpen;

@property (nonatomic, retain) NSArray *templateCategoryArr;

- (id) initWithTargetUserId:(NSString*) targetUserId;
@end

@interface AssessmentTemplateCategoryListViewController ()
{
    AssessmentTemplateCategoryTableViewController* tvcTemplateCategory;
}
//患者的UserId
@property (nonatomic, readonly) NSString* patientUserId;
@end




@implementation AssessmentTemplateCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"选择评估表分类"];
    //[self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        _patientUserId = self.paramObject;
    }
    
    [self createTemplateCategoryTable];
}

//创建评估表分类列表
- (void) createTemplateCategoryTable
{
    tvcTemplateCategory = [[AssessmentTemplateCategoryTableViewController alloc]initWithTargetUserId:self.patientUserId];
    [self addChildViewController:tvcTemplateCategory];
    [self.view addSubview:tvcTemplateCategory.tableView];

    [tvcTemplateCategory.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

@end

@implementation AssessmentTemplateCategoryTableViewController

- (id) initWithTargetUserId:(NSString*) targetUserId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _patientUserId = targetUserId;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AssessmentCategoryTask" taskParam:nil TaskObserver:self];
}

#pragma mark -- UITableViewDelegate And UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _templateCategoryArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isOpen[section]) {
        
        return [[[_templateCategoryArr objectAtIndex:section] details] count];
    }
    else{
        
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [footerview showTopLine];
    return footerview;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AssessmentCategoryModel *model = [_templateCategoryArr objectAtIndex:section];
    
    AssessmentTemplateHeaderView *headerview = [[AssessmentTemplateHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 47)];
    [headerview setHeaderTitle:model.deptName];
    [headerview setSelectIndex:section];
    [headerview setIsExtended:_isOpen[section]];
    [headerview showTopLine];
    [headerview showBottomLine];
    __weak typeof(self) weakSelf = self;
    [headerview setSelectSelectedBlock:^(NSInteger selSection) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        _isOpen[selSection] = !_isOpen[selSection];

        //动画刷新某些区
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];

    }];
    
    return headerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssessmentCategoryDetailsModel *detailModel = [[[_templateCategoryArr objectAtIndex:indexPath.section] details] objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //[cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[UIColor commonTextColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setText:detailModel.categoryName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssessmentCategoryDetailsModel *detailModel = [[[_templateCategoryArr objectAtIndex:indexPath.section] details] objectAtIndex:indexPath.row];
    detailModel.patientUserId = _patientUserId;
    [HMViewControllerManager createViewControllerWithControllerName:@"AssessmentTemplateSelectViewController" ControllerObject:detailModel];
}


#pragma mark -- TaskObserver

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView closeWaitView];
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
    
    if ([taskname isEqualToString:@"AssessmentCategoryTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            _templateCategoryArr = (NSArray *)taskResult;
            
            //创建BOOL数组
            _isOpen = malloc(sizeof(BOOL)*_templateCategoryArr.count);
            
            //初始化BOOL数组。
            memset(_isOpen, 0, sizeof(BOOL)*_templateCategoryArr.count);
            
            [self.tableView reloadData];
        }
    }
}


@end





@interface AssessmentTemplateListViewController ()


@end

@implementation AssessmentTemplateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
