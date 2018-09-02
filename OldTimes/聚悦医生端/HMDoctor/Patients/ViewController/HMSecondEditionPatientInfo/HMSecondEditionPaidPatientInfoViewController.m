//
//  HMSecondEditionPaidPatientInfoViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionPaidPatientInfoViewController.h"
#import "HMSecondEditionPationInfoModel.h"
#import "HMSecondEditionPatientInfoExtensibleTableViewCell.h"
#import "HMSecondEditionPaidPatientReportModel.h"

typedef NS_ENUM(NSUInteger, SecondEditionPaidPatientInfoCellType) {
    
    SecondEditionPaidPatientInfoCellType_name,                  //姓名
    
    SecondEditionPaidPatientInfoCellType_sex,                   //性别
    
    SecondEditionPaidPatientInfoCellType_phone,                 //电话
    
    SecondEditionPaidPatientInfoCellType_age,                   //年龄
    
    SecondEditionPaidPatientInfoCellType_groupNumber,           //入组编号
    
    SecondEditionPaidPatientInfoCellType_diagnosis = 10,        //诊断
    
    SecondEditionPaidPatientInfoCellType_reports = 20,          //评估
    
};

@interface HMSecondEditionPaidPatientInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HMSecondEditionPationInfoModel *model;
@property (nonatomic, copy) NSString *mainStr;
@property (nonatomic, copy) NSString *subStr;
@property (nonatomic, strong) NSMutableDictionary *showMultiDict;
@property (nonatomic, copy) NSString *tempReqortString;
@end

@implementation HMSecondEditionPaidPatientInfoViewController

- (instancetype)initWithPatientModel:(HMSecondEditionPationInfoModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.showMultiDict = [NSMutableDictionary new];
    [self.showMultiDict setObject:@NO forKey:@"SecondEditionPaidPatientInfoCellType_diagnosis"];
    __weak typeof(self) weakSelf = self;
    [self.model.paidAdmissionData.reports enumerateObjectsUsingBlock:^(HMSecondEditionPaidPatientReportModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!idx) {
            [strongSelf.showMultiDict setObject:@YES forKey:obj.groupName];
        }
        else {
            [strongSelf.showMultiDict setObject:@NO forKey:obj.groupName];
        }
    }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}
- (SecondEditionPaidPatientInfoCellType)cellTypeWithIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

- (NSString *)getDiagnosis {
    __weak typeof(self) weakSelf = self;
    [self.model.paidAdmissionData.admissionDiagnosesList enumerateObjectsUsingBlock:^(HMSecondEditionFreePatientInfoDiagnosesModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([obj.diseaseOrder isEqualToString:@"1"]) {
            strongSelf.mainStr = obj.diseaseTitle;
        }
        else {
            if (strongSelf.subStr.length) {
                strongSelf.subStr = [strongSelf.subStr stringByAppendingString:[NSString stringWithFormat:@",%@",obj.diseaseTitle]];
            }
            else {
                strongSelf.subStr = [strongSelf.subStr stringByAppendingString:obj.diseaseTitle];
            }
        }
    }];
    return [NSString stringWithFormat:@"主要诊断：%@\n次要诊断：%@",self.mainStr?:@"暂无",self.subStr?:@"暂无"];
}

- (NSString *)getStringWithArr:(NSArray *)arr {
    self.tempReqortString = @"";
    __weak typeof(self) weakSelf = self;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!idx) {
            strongSelf.tempReqortString = [strongSelf.tempReqortString stringByAppendingString:obj];
        }
        else {
            strongSelf.tempReqortString = [strongSelf.tempReqortString stringByAppendingString:[NSString stringWithFormat:@"\n%@",obj]];
        }
    }];
    return self.tempReqortString;
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return self.model.paidAdmissionData.reports.count + 1;
            break;
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    SecondEditionPaidPatientInfoCellType cellType = [self cellTypeWithIndexPath:indexPath];
    switch (cellType) {
        case SecondEditionPaidPatientInfoCellType_name:
        case SecondEditionPaidPatientInfoCellType_age:
        case SecondEditionPaidPatientInfoCellType_sex:
        case SecondEditionPaidPatientInfoCellType_phone:
        case SecondEditionPaidPatientInfoCellType_groupNumber:
        {
            height = 45;
            break;
        }
        case SecondEditionPaidPatientInfoCellType_reports:
        {
            if (self.model.paidAdmissionData.reports.count) {
                height = 45;
            }
            else {
                height = 0.0001;
            }
            break;
        }
        default:
        {
            static HMSecondEditionPatientInfoExtensibleTableViewCell *templateCell;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                templateCell = [self.tableView dequeueReusableCellWithIdentifier:[HMSecondEditionPatientInfoExtensibleTableViewCell at_identifier]];
                if (!templateCell) {
                    templateCell = [[HMSecondEditionPatientInfoExtensibleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HMSecondEditionPatientInfoExtensibleTableViewCell at_identifier]];
                }
            });
            switch (cellType) {
                case SecondEditionPaidPatientInfoCellType_diagnosis:
                    [templateCell fillDataWithTitel:@"诊断" content:[self getDiagnosis] showMutiLines:[self.showMultiDict[@"SecondEditionFreePatientInfoCellType_diagnosis"] integerValue]];
                    if (self.model.paidAdmissionData.admissionDiagnosesList.count) {
                      height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
                        //无奈的偏移量
                        height += 30;
                    }
                    else {
                        height = 0.00001;
                    }
                    
                    break;
                default:
                {
                    HMSecondEditionPaidPatientReportModel *model = self.model.paidAdmissionData.reports[indexPath.row - 1];
                    [templateCell fillDataWithTitel:model.groupName content:[self getStringWithArr:model.groupData] showMutiLines:[self.showMultiDict[model.groupName] integerValue]];
                    height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
                    //无奈的偏移量
                    height += 30;
                    if (indexPath.row == 1) {
                        //一般性评估要隐藏下方按钮高度
                        height -= 30;
                    }
                }
                    break;
            }
            
           
            break;
        }
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 1:
            if (!self.model.paidAdmissionData.admissionDiagnosesList.count) {
                return 0.0001;
                break;
            }
        default:
            break;
    }
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    SecondEditionPaidPatientInfoCellType cellType = [self cellTypeWithIndexPath:indexPath];
    switch (cellType) {
        case SecondEditionPaidPatientInfoCellType_name:
        case SecondEditionPaidPatientInfoCellType_age:
        case SecondEditionPaidPatientInfoCellType_sex:
        case SecondEditionPaidPatientInfoCellType_phone:
        case SecondEditionPaidPatientInfoCellType_groupNumber:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [[cell textLabel] setTextColor:[UIColor colorWithHexString:@"666666"]];
            [[cell textLabel] setFont:[UIFont font_32]];
            [[cell detailTextLabel] setTextColor:[UIColor colorWithHexString:@"333333"]];
            [[cell detailTextLabel] setFont:[UIFont font_32]];
            
            NSString *titel;
            NSString *content;
            switch (cellType) {
                case SecondEditionPaidPatientInfoCellType_name:
                {
                    titel = @"姓名";
                    content = self.model.userInfo.userName;
                    break;
                }
                case SecondEditionPaidPatientInfoCellType_sex:
                {
                    titel = @"性别";
                    content = self.model.userInfo.sex;
                    break;
                }
                case SecondEditionPaidPatientInfoCellType_phone:
                {
                    titel = @"手机号";
                    content = self.model.userInfo.mobile;
                    break;
                }
                case SecondEditionPaidPatientInfoCellType_age:
                {
                    titel = @"年龄";
                    content = [NSString stringWithFormat:@"%ld",self.model.userInfo.age];
                    break;
                }
                case SecondEditionPaidPatientInfoCellType_groupNumber:
                {
                    titel = @"入组编号";
                    content = self.model.userInfo.joinCode;
                    break;
                }
                    
                default:
                    break;
            }
            [[cell textLabel] setText:titel];
            [[cell detailTextLabel] setText:content];
            
            break;
        }
            case SecondEditionPaidPatientInfoCellType_reports:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SecondEditionPaidPatientInfoCellType_reports"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SecondEditionPaidPatientInfoCellType_reports"];
            }
            [[cell textLabel] setTextColor:[UIColor colorWithHexString:@"333333"]];
            [[cell textLabel] setFont:[UIFont font_32]];
            if (self.model.paidAdmissionData.reports.count) {
                [[cell textLabel] setText:@"评估"];
            }
            break;
        }
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMSecondEditionPatientInfoExtensibleTableViewCell class])];
            if (!cell)
            {
                cell = [[HMSecondEditionPatientInfoExtensibleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HMSecondEditionPatientInfoExtensibleTableViewCell class])];
            }
            switch (cellType) {
                case SecondEditionPaidPatientInfoCellType_diagnosis:
                {
                    if (self.model.paidAdmissionData.admissionDiagnosesList.count) {
                        [cell fillDataWithTitel:@"诊断" content:[self getDiagnosis] showMutiLines:[self.showMultiDict[@"SecondEditionFreePatientInfoCellType_diagnosis"] integerValue]];
                    }
                   __weak typeof(self) weakSelf = self;
                    [cell extentClick:^{
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        strongSelf.showMultiDict[@"SecondEditionFreePatientInfoCellType_diagnosis"] = @([cell extentBtn].selected);
                        [strongSelf.tableView reloadData];
                    }];

                }
                    break;
                    
                default:
                {
                    HMSecondEditionPaidPatientReportModel *model = self.model.paidAdmissionData.reports[indexPath.row - 1];
                    if (indexPath.row == 1) {
                        //一般性评估不显示下方展开按钮
                        [[cell extentBtn] setHidden:YES];
                    }
                    [cell fillDataWithTitel:model.groupName content:[self getStringWithArr:model.groupData] showMutiLines:[self.showMultiDict[model.groupName] integerValue]];
                    __weak typeof(self) weakSelf = self;
                    [cell extentClick:^{
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        strongSelf.showMultiDict[model.groupName] = @([cell extentBtn].selected);
                        [strongSelf.tableView reloadData];
                    }];

                }
                    break;
            }

        }
            break;
    }
    
    return cell;
}


#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.estimatedRowHeight = 60;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorColor:[UIColor systemLineColor_c8c7cc]];
        [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    }
    return _tableView;
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
