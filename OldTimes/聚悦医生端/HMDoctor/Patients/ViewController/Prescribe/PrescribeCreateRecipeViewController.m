//
//  PrescribeCreateRecipeViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeCreateRecipeViewController.h"
#import "PrescribeCreateRecipeTableViewController.h"
#import "PrescribeDrugsUsageSelectViewController.h"
#import "PrescribeDosageUnitSelectViewControl.h"
#import "PrescrbeDrugsView.h"
#import "DrugInfo.h"
#import "PrescribeInfo.h"
#import "UserAlertInfo.h"

#import "PrescribeDetailTableViewCell.h"
#import "PrescribeChoosePharmacyTemplateViewController.h"
#import "PrescribeSearchDrugViewController.h"
#import "HMThirdEditionPatitentInfoModel.h"

@interface PrescribeCreateRecipeViewController ()<TaskObserver,UISearchBarDelegate,PrescribeSearchDrugViewControllerDelegate>
{
    PrescribeCreateRecipeTableViewController *tvcPrescribeCreateRecipeTable;
    UISearchBar* searchBar;
    
    UIButton* saveButton;
    NSMutableArray *dosageUnitArray;
    
    DrugInfo *drug;
    PatientInfo *patientinfo;
    
    PrescribeInfo *prescribeinfo;
    NSString *userRecipeId;
    NSMutableArray *prescribeDetailItem;
}
@property (nonatomic, retain) NSString *testResulId;
@property (nonatomic, strong)  UIButton  *saveTemplate; // 保存模板按钮
@end



@implementation PrescribeCreateRecipeViewController

- (void)dealloc
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    
    searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:searchBar];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@56);
    }];
    //[searchBar setDelegate:self];
    [searchBar setPlaceholder:@"请输入药品名称，如感冒冲剂"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"选择模板" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    UIControl *searchControl = [[UIControl alloc] init];
    [self.view addSubview:searchControl];
    [searchControl addTarget:self action:@selector(searchControllerClick) forControlEvents:UIControlEventTouchUpInside];
    
    [searchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@56);
    }];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSArray class]])
    {
        // 复制处方
        NSArray* resultArr = (NSArray *)self.paramObject;
        prescribeinfo = [resultArr objectAtIndex:0];
        userRecipeId = prescribeinfo.userRecipeId;
        
        patientinfo = [resultArr objectAtIndex:1];
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@(%@ , %ld)",patientinfo.userName,patientinfo.sex,patientinfo.age]];
        self.testResulId = patientinfo.testResulId;
        self.saveTemplate.hidden = NO;

         [self initWithCopyPost];
    }
    
    if (self.paramObject && ([self.paramObject isKindOfClass:[PatientInfo class]] || [self.paramObject isKindOfClass:[UserAlertInfo class]]))
    {
        patientinfo = (PatientInfo *)self.paramObject;
        self.testResulId = patientinfo.testResulId;
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@(%@ , %ld)",patientinfo.userName,patientinfo.sex,patientinfo.age]];
        
        [self initWithCopyPost];
        //[self initWithSearch];
        [saveButton setHidden:YES];
        [tvcPrescribeCreateRecipeTable.tableView setHidden:YES];
        
    }
    
    //判断是否有患者信息
    if(kStringIsEmpty(patientinfo.userName)){
        [self startPatientInfoRequest];
    }
}

- (void)startPatientInfoRequest {
    //获取患者的信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",patientinfo.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMThirdEditionPatitentInfoRequest" taskParam:dicPost TaskObserver:self];
}

- (void)addDrugInfo
{
    [saveButton setHidden:NO];
    self.saveTemplate.hidden = NO;
    [tvcPrescribeCreateRecipeTable.tableView setHidden:NO];
}

- (void)rightClick {
    PrescribeChoosePharmacyTemplateViewController *VC = [PrescribeChoosePharmacyTemplateViewController new];
    __weak typeof(self) weakSelf = self;
    [VC cellClick:^(NSString *modelID) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf addDrugInfo];
        [tvcPrescribeCreateRecipeTable selectDrugTemplate:modelID];
    }];
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (void)initWithCopyPost
{
    tvcPrescribeCreateRecipeTable = [[PrescribeCreateRecipeTableViewController alloc]initWithStyle:UITableViewStylePlain];
    tvcPrescribeCreateRecipeTable.patientinfo = patientinfo;
    tvcPrescribeCreateRecipeTable.userRecipeId = userRecipeId;
    tvcPrescribeCreateRecipeTable.testResulId = self.testResulId;
    
    [tvcPrescribeCreateRecipeTable deleteCallBack:^{
        [self.saveTemplate setHidden:!tvcPrescribeCreateRecipeTable.prescribeDetailList.count];
        [saveButton setHidden:!tvcPrescribeCreateRecipeTable.prescribeDetailList.count];
    }];
    [self addChildViewController:tvcPrescribeCreateRecipeTable];
    [self.view addSubview:tvcPrescribeCreateRecipeTable.tableView];
    
    [self.view addSubview:self.saveTemplate];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage at_imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont font_30]];
    [saveButton.layer setCornerRadius:5.0f];
    [saveButton.layer setMasksToBounds:YES];
    
    [saveButton addTarget:self action:@selector(saveCopyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveTemplate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(saveButton);
        make.bottom.equalTo(saveButton.mas_top).offset(-5);
    }];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    [tvcPrescribeCreateRecipeTable.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBar.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.saveTemplate.mas_top).with.offset(-5);
    }];
}

- (void)searchControllerClick
{
    PrescribeSearchDrugViewController *VC = [PrescribeSearchDrugViewController new];
    [VC setDelegate:self];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)PrescribeSearchDrugViewControllerDelegateCallBack_cellClick:(DrugInfo *)model {
    [self addDrugInfo];
    [tvcPrescribeCreateRecipeTable addDrug:model];
}

- (void)saveCopyButtonClick
{
    [tvcPrescribeCreateRecipeTable saveButtonClick];
}


// 保存为模板
- (void)saveToTemplate {
    
    [tvcPrescribeCreateRecipeTable saveToTemplateBtnClicked];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Init

- (UIButton *)saveTemplate {
    if (!_saveTemplate) {
        _saveTemplate = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveTemplate setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_saveTemplate setTitle:@"保存并保存为我的模板" forState:UIControlStateNormal];
        [_saveTemplate.titleLabel setFont:[UIFont font_30]];
        [_saveTemplate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveTemplate.layer setCornerRadius:5.0f];
        [_saveTemplate.layer setMasksToBounds:YES];
        _saveTemplate.hidden = YES;
        [_saveTemplate addTarget:self action:@selector(saveToTemplate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveTemplate;
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
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
    
    if ([taskname isEqualToString:@"HMThirdEditionPatitentInfoRequest"])
    {
        HMThirdEditionPatitentInfoModel *model = (HMThirdEditionPatitentInfoModel *)taskResult;
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (%@, %ld)", model.userInfo.userName, model.userInfo.sex, model.userInfo.age]];
    }
}
@end

