//
//  PrescribeCreateRecipeTableViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeCreateRecipeTableViewController.h"
#import "PrescribeDrugsUsageSelectViewController.h"
#import "PrescribeDosageUnitSelectViewControl.h"
#import "DrugInfo.h"
#import "PrescribeInfo.h"

#import "PrescribeDetailTableViewCell.h"
#import "GetPatientDrugTemplateDetailRequest.h"
#import "DrugUseTemplateDetailModel.h"


@interface PrescribeCreateRecipeTableViewController ()<TaskObserver,UITextFieldDelegate>
{
    float cellLocation;
}

@property (nonatomic, copy)  NSString  *templateName; // 模版名
@property (nonatomic, copy)  NSString  *healthyID; // 健康计划ID
@property (nonatomic, copy)  deleteClick block;
@end

@implementation PrescribeCreateRecipeTableViewController

- (void)dealloc
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    if (_userRecipeId)
    {
        NSMutableDictionary *dicShowRecipePost = [[NSMutableDictionary alloc] init];
        [dicShowRecipePost setValue:_userRecipeId forKey:@"userRecipeId"];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"showRecipeListTask" taskParam:dicShowRecipePost TaskObserver:self];
    }

}


// 保存为模板通知事件
- (void)saveToTemplateBtnClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入模板名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        // 名称
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 确定保存
        UITextField *textFields = alert.textFields.firstObject;
        if (textFields.text.length == 0) {
            [strongSelf showAlertMessage:@"请输入模板名称"];
        }
        else {
            [strongSelf saveToTemplateWithTemplateName:textFields.text];
        }
    }];
    [alert addAction:actionCancel];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

// 保存为模板
- (void)saveToTemplateWithTemplateName:(NSString *)templateName {
    self.templateName = templateName ?: @"";
    self.healthyID = @"";
    if ([self.patientinfo isKindOfClass:[PatientInfo class]]) {
        self.healthyID = self.patientinfo.healthId ?: @"";
    }
    [self saveButtonClick];
    
}

- (void)saveButtonClick
{
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *recipeDets = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.prescribeDetailList.count; i++)
    {
        NSString* singleDosage = [[self.prescribeDetailList objectAtIndex:i] singleDosage];
        NSString* drugUnit = [[self.prescribeDetailList objectAtIndex:i] drugUnit];
        NSString* drugsFrequencyCode = [[self.prescribeDetailList objectAtIndex:i] drugsFrequencyCode];
        NSString* drugsUsageCode = [[self.prescribeDetailList objectAtIndex:i] drugsUsageCode];
        NSString* drugId = [[self.prescribeDetailList objectAtIndex:i] drugId];
        NSString* medicationDays = [[self.prescribeDetailList objectAtIndex:i] medicationDays];
        NSString* allDosage = [[self.prescribeDetailList objectAtIndex:i] allDosage];
        NSString* allUnit = [[self.prescribeDetailList objectAtIndex:i] allUnit];
        
        NSString* remarks = [[self.prescribeDetailList objectAtIndex:i] remarks] ? : @"";

        if (!singleDosage || singleDosage.floatValue <= 0)
        {
            [self.view showAlertMessage:@"请输入单次剂量"];
            return;
        }
        
        if (!drugUnit || drugUnit.length <= 0)
        {
            [self.view showAlertMessage:@"请选择剂量单位"];
            return;
        }
        
        if (!drugsFrequencyCode || drugsFrequencyCode.length <= 0)
        {
            [self.view showAlertMessage:@"请选择频次"];
            return;
        }
        
        if (!drugsUsageCode || drugsUsageCode.length <= 0)
        {
            [self.view showAlertMessage:@"请选择用法"];
            return;
        }
        
        if (!drugId || drugId.length <= 0)
        {
            [self.view showAlertMessage:@"ID为空"];
            return;
        }
        
        if (!medicationDays || medicationDays.integerValue <= 0)
        {
            [self.view showAlertMessage:@"请输入用药天数"];
            return;
        }
        
        if (!allDosage || allDosage.length <= 0)
        {
            [self.view showAlertMessage:@"请输入总量"];
            return;
        }
        if (!allUnit || allUnit.length <= 0)
        {
            [self.view showAlertMessage:@"总量单位为空，不能保存"];
            return;
        }
        NSDictionary *det = @{
                              @"frequencyCode":drugsFrequencyCode,
                              @"usageCode":drugsUsageCode,
                              @"drugId":drugId,
                              @"medicationDays":medicationDays,
                              @"singleDosage":singleDosage,
                              @"singleUnit":drugUnit,
                              @"allDosage":allDosage,
                              @"allUnit":allUnit,
                              @"remarks":remarks,
                              };
        [recipeDets addObject:det];
    }
    NSString* str = [recipeDets objectJsonString];
    [dicPost setValue:str forKey:@"recipeDets"];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", _patientinfo.userId] forKey:@"userId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"opUserId"];
    
    //预警处理 传testResulId
    if (_testResulId && 0 < _testResulId.length)
    {
        [dicPost setValue:_testResulId forKey:@"testResulId"];
    }
    // 保存模板
    dicPost[@"tempName"] = self.templateName ?: @"";
    dicPost[@"healthyId"] = self.healthyID ?: @"";
    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateRecipeTask" taskParam:dicPost TaskObserver:self];
    //
}

- (void)selectDrugTemplate:(NSString *)modelID {
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:modelID forKey:@"medicinePlanTempId"];
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetPatientDrugTemplateDetailRequest" taskParam:dicPost TaskObserver:self];
}

- (void)addDrug:(DrugInfo *)drug
{
    if (!self.prescribeDetailList) {
        self.prescribeDetailList = [[NSMutableArray alloc] init];
    }
    
    //判断是否已添加该药品
    for (int i = 0; i < self.prescribeDetailList.count; i++)
    {
        NSString* drugId = [[self.prescribeDetailList objectAtIndex:i] drugId];
        
        if (drug.drugId == drugId)
        {
            [self.view showAlertMessage:@"您已添加过该药品"];
            return;
        }
    }
    
    PrescribeTempInfo *tempInfo = [[PrescribeTempInfo alloc] init];
    tempInfo.drugBagSpec = drug.drugBagSpec;
    tempInfo.drugId = drug.drugId;
    tempInfo.drugName = drug.drugName;
    tempInfo.allUnit = drug.drugBagUnit;
    tempInfo.drugOneSpec = drug.drugOneSpec;
    tempInfo.drugUnit = drug.drugOneSpecUnit;
    tempInfo.drugOneSpecUnit = drug.drugOneSpecUnit;
    tempInfo.drugCompany = drug.drugOrg;
    tempInfo.singleDosage = drug.drugOneSpec;
//    tempInfo.drugSpecifications = [NSString stringWithFormat:@"%@%@/%@",drug.drugSpec,drug.drugOneSpecUnit,drug.drugBagUnit];
    tempInfo.drugSpecifications = drug.drugBagSpec;
    tempInfo.drugsUsageName = @"口服";
    tempInfo.drugsUsageCode = @"KF";
    [self.prescribeDetailList addObject:tempInfo];
    
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 304;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.prescribeDetailList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrescribeTempInfo *detailDrugsInfo = [self.prescribeDetailList objectAtIndex:indexPath.section];
    //NSLog(@"%@",detailDrugsInfo.drugSpecifications);
    
    PrescribeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrescribeDetailTableViewCell"];
    
    if (!cell) {
        cell = [[PrescribeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrescribeDetailTableViewCell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }

    [cell setTag:indexPath.section];
    [cell.drugselectView.frequencyControl setTag:indexPath.section + 0x400];
    [cell.drugselectView.usageControl setTag:indexPath.section + 0x500];
    [cell.drugselectView.unitControl setTag:indexPath.section + 0x600];
    
    [cell.drugselectView.tfDosage setTag:indexPath.section + 0x100];
    [cell.drugselectView.tfDosage setDelegate:self];
    [cell.drugselectView.tfDosage addTarget:self
                                     action:@selector(singleDosageDidChangeValue:)
                           forControlEvents:UIControlEventEditingChanged];
    
    [cell.drugsDaysView.tfUsages setTag:indexPath.section + 0x200];
    [cell.drugsDaysView.tfUsages setDelegate:self];
    [cell.drugsDaysView.tfUsages addTarget:self
                                    action:@selector(daysDidChangeValue:)
                          forControlEvents:UIControlEventEditingChanged];
    
    [cell.drugsTotalView.tfUsages setTag:indexPath.section + 0x300];
    [cell.drugsTotalView.tfUsages setDelegate:self];
    [cell.drugsTotalView.tfUsages addTarget:self
                                     action:@selector(allDosageDidChangeValue:)
                           forControlEvents:UIControlEventEditingChanged];
    
    [cell.remarkTF setTag:indexPath.section + 0x800];
    [cell.remarkTF setDelegate:self];
    [cell.remarkTF addTarget:self action:@selector(remarkChangeValue:) forControlEvents:UIControlEventEditingChanged];

    [cell setPrescribeDetailDrugsInfo:detailDrugsInfo];
    
    [cell.addDrugsView.deleteBtn setTag:indexPath.section + 0x700];
    [cell.addDrugsView.deleteBtn addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.drugselectView.frequencyControl addTarget:self action:@selector(frequencyControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.drugselectView.usageControl addTarget:self action:@selector(usageControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.drugselectView.unitControl addTarget:self action:@selector(unitControlClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f",scrollView.contentOffset.y);
    cellLocation = scrollView.contentOffset.y;
}

//单次剂量
- (void)singleDosageDidChangeValue:(id)sender
{
    PrescribeDetailDrugsInfo* detailInfo = [self.prescribeDetailList objectAtIndex:((UITextField *)sender).tag - 0x100];
    detailInfo.singleDosage = ((UITextField *)sender).text;
    
    [self.prescribeDetailList replaceObjectAtIndex:((UITextField *)sender).tag- 0x100 withObject:detailInfo];
    
    //NSLog(@"---%@",[[prescribeDetailList objectAtIndex:((UITextField *)sender).tag- 0x100] singleDosage]);
    
}

//用药天数
- (void)daysDidChangeValue:(id)sender
{
    PrescribeDetailDrugsInfo* detailInfo = [self.prescribeDetailList objectAtIndex:((UITextField *)sender).tag - 0x200];
    detailInfo.medicationDays = ((UITextField *)sender).text;
    
    [self.prescribeDetailList replaceObjectAtIndex:((UITextField *)sender).tag- 0x200 withObject:detailInfo];
    
}

//总量
- (void)allDosageDidChangeValue:(id)sender
{
    PrescribeDetailDrugsInfo* detailInfo = [self.prescribeDetailList objectAtIndex:((UITextField *)sender).tag - 0x300];
    detailInfo.allDosage = ((UITextField *)sender).text;
    
    [self.prescribeDetailList replaceObjectAtIndex:((UITextField *)sender).tag- 0x300 withObject:detailInfo];
}

//备注
- (void)remarkChangeValue:(id)sender {
    PrescribeDetailDrugsInfo* detailInfo = [self.prescribeDetailList objectAtIndex:((UITextField *)sender).tag - 0x800];
    detailInfo.remarks = ((UITextField *)sender).text;
    
    [self.prescribeDetailList replaceObjectAtIndex:((UITextField *)sender).tag- 0x800 withObject:detailInfo];
}
- (void)deleteButtonClick:(UIControl *)sender
{
    [self.prescribeDetailList removeObjectAtIndex:sender.tag - 0x700];
    [self.tableView reloadData];
    if (self.block) {
        self.block();
    }
}

//剂量单位
- (void)unitControlClick:(UIControl *)sender
{
    [self.view endEditing:YES];
    
    PrescribeDetailTableViewCell *cell = (PrescribeDetailTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag - 0x600]];
    
    PrescribeDetailDrugsInfo* detailInfo = [self.prescribeDetailList objectAtIndex:sender.tag - 0x600];
    
    //UIControl* control = (UIControl*)sender;
    //CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [sender.superview convertRect:sender.frame toView:self.view];

    [PrescribeDosageUnitSelectViewControl createWithParentViewController:self drugId:detailInfo.drugId                                                                         cellLocationY:rectInSuperview.origin.y+40-cellLocation cellLocationX:rectInSuperview.origin.x selectblock:^(NSString* dosageUnit) {
        
        if (dosageUnit)
        {
            [cell.drugselectView.unitControl setContent:dosageUnit];

            detailInfo.drugUnit = dosageUnit;
            //detailInfo.drugOneSpecUnit = dosageUnit;
            
            [self.prescribeDetailList replaceObjectAtIndex:sender.tag - 0x600 withObject:detailInfo];
            
            //NSLog(@"%@",[[prescribeDetailList objectAtIndex:sender.tag - 0x600] drugUnit]);
        }
        
    }];
}

//频次
- (void)frequencyControlClick:(UIControl *)sender
{
    [self.view endEditing:YES];
    
    PrescribeDetailTableViewCell *cell = (PrescribeDetailTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag - 0x400]];
    
    [PrescribeDrugsUsageSelectViewController createWithParentViewController:self drugsUsage:@"frequency" selectblock:^(DrugsFrequencyInfo* drugUsage) {
        
        if (drugUsage)
        {
            [cell.drugselectView.frequencyControl setContent:drugUsage.drugsFrequencyCode];
            
            PrescribeDetailDrugsInfo* detailInfo = [self.prescribeDetailList objectAtIndex:sender.tag - 0x400];
            detailInfo.drugsFrequencyCode = drugUsage.drugsFrequencyCode;
            detailInfo.drugsFrequencyName = drugUsage.drugsFrequencyName;
            
            [self.prescribeDetailList replaceObjectAtIndex:sender.tag - 0x400 withObject:detailInfo];
            
            //NSLog(@"%@",[[prescribeDetailList objectAtIndex:sender.tag - 0x400] drugsFrequencyName]);
        }
    }];
    
}

//用法
- (void)usageControlClick:(UIControl *)sender
{
    [self.view endEditing:YES];
    
    PrescribeDetailTableViewCell *cell = (PrescribeDetailTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag - 0x500]];
    
    [PrescribeDrugsUsageSelectViewController createWithParentViewController:self drugsUsage:@"usage" selectblock:^(DrugsUsagesInfo* drugUsage) {
        
        if (drugUsage)
        {
            [cell.drugselectView.usageControl setContent:drugUsage.drugsUsageName];
            
            PrescribeDetailDrugsInfo* detailInfo = [self.prescribeDetailList objectAtIndex:sender.tag - 0x500];
            detailInfo.drugsUsageCode = drugUsage.drugsUsageCode;
            detailInfo.drugsUsageName = drugUsage.drugsUsageName;
            
            [self.prescribeDetailList replaceObjectAtIndex:sender.tag - 0x500 withObject:detailInfo];
            
            // NSLog(@"%@",[[prescribeDetailList objectAtIndex:sender.tag - 0x500] drugsFrequencyName]);
        }
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)deleteCallBack:(deleteClick)block {
    self.block = block;
}
#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"CreateRecipeTask"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([taskname isEqualToString:@"GetPatientDrugTemplateDetailRequest"])
    {
        if (!self.prescribeDetailList) {
            self.prescribeDetailList = [[NSMutableArray alloc] init];
        }
        [self.prescribeDetailList removeAllObjects];
        for (DrugUseTemplateDetailModel *drug in taskResult) {
            PrescribeTempInfo *tempInfo = [[PrescribeTempInfo alloc] init];
            tempInfo.drugId = drug.drugId;
            tempInfo.drugName = drug.drugName;
            tempInfo.allUnit = drug.allDosageUnit;
            tempInfo.allDosage = drug.allDosage;
            tempInfo.drugOneSpec = drug.drugOneSpec;
            tempInfo.drugUnit = drug.drugDosageUnit;
            tempInfo.drugOneSpecUnit = drug.drugOneSpecUnit;
            tempInfo.drugCompany = drug.drugOrg;
            tempInfo.singleDosage = [NSString stringWithFormat:@"%@",drug.drugDosage];
            tempInfo.medicationDays = [NSString stringWithFormat:@"%ld",drug.drugUseDay];
            tempInfo.drugSpecifications = drug.drugSpe;

//            tempInfo.drugSpecifications = [NSString stringWithFormat:@"%@%@/%@",drug.drugSpec,drug.drugDosageUnit,drug.allDosageUnit];
            tempInfo.drugsFrequencyName = drug.drugsFrequencyName;
            tempInfo.drugsUsageName = drug.drugsUsageName;
            tempInfo.drugsUsageCode = drug.drugsUsageCode;
            tempInfo.drugsFrequencyCode = drug.drugsFrequencyCode;

            [self.prescribeDetailList addObject:tempInfo];
        }
        [self.tableView reloadData];
        
    }
    
    if ([taskname isEqualToString:@"showRecipeListTask"])
    {
        if (!self.prescribeDetailList) {
            self.prescribeDetailList = [[NSMutableArray alloc] init];
        }
        
        NSArray* items = [taskResult valueForKey:@"recipeDets"];
        
        if (items && [items isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicTemp in items)
            {
                PrescribeDetailDrugsInfo* detailInfo = [PrescribeDetailDrugsInfo mj_objectWithKeyValues:dicTemp];
                [self.prescribeDetailList addObject:detailInfo];
            }
            
            [self.tableView reloadData];
        }
    }
    
}
@end


