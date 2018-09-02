//
//  HMSecondEditionFreePatientInfoViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionFreePatientInfoViewController.h"
#import "HMSecondEditionPatientInfoExtensibleTableViewCell.h"
#import "HMSecondEditionPatientInfoCollectTableViewCell.h"
#import "HMSecondEditionPatientInfoDrugTableViewCell.h"
#import "HMSecondEditionPationInfoModel.h"
#import <MWPhotoBrowser-ADS/MWPhotoBrowser.h>
#import "HMSecondEditionPatientInfoRequest.h"

typedef NS_ENUM(NSUInteger, SecondEditionFreePatientInfoCellType) {
    
    SecondEditionFreePatientInfoCellType_name,                  //姓名
    
    SecondEditionFreePatientInfoCellType_sex,                   //性别
    
    SecondEditionFreePatientInfoCellType_phone,                 //电话
    
    SecondEditionFreePatientInfoCellType_age,                   //年龄
    
    SecondEditionFreePatientInfoCellType_groupNumber,           //入组编号
    
    SecondEditionFreePatientInfoCellType_selfDescription = 10,  //主诉

    SecondEditionFreePatientInfoCellType_medicalHistory = 20,   //现病史
    
    SecondEditionFreePatientInfoCellType_diagnosis = 30,        //诊断
    
    SecondEditionFreePatientInfoCellType_chaeck = 40,           //辅助检查
    
    SecondEditionFreePatientInfoCellType_drug = 50,             //用药



};

@interface HMSecondEditionFreePatientInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HMSecondEditionPatientInfoCollectTableViewCellDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *showMultiDict;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, copy) NSString *mainStr;
@property (nonatomic, copy) NSString *subStr;
@property (nonatomic, strong) HMSecondEditionPationInfoModel *model;
@property (nonatomic, copy) NSArray<HMSecondEditionFreePatientInfoCheckModel* > *showPhotoArray;
@end

@implementation HMSecondEditionFreePatientInfoViewController

- (instancetype)initWithPatientModel:(HMSecondEditionPationInfoModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本信息";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.showMultiDict = [NSMutableDictionary new];
    [self.showMultiDict setObject:@NO forKey:@"SecondEditionFreePatientInfoCellType_selfDescription"];
    [self.showMultiDict setObject:@NO forKey:@"SecondEditionFreePatientInfoCellType_medicalHistory"];
    [self.showMultiDict setObject:@NO forKey:@"SecondEditionFreePatientInfoCellType_diagnosis"];
    // Do any additional setup after loading the view.

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method


- (void)configElements {
}
- (SecondEditionFreePatientInfoCellType)cellTypeWithIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

/** 点击查看照片 */
- (void)selectShowImageAtIndex:(NSUInteger)selectedIndex {
    self.photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.photoBrowser.displayActionButton = YES;
    self.photoBrowser.alwaysShowControls = YES;
    self.photoBrowser.zoomPhotosToFill = YES;
    self.photoBrowser.enableGrid = NO;
    self.photoBrowser.enableSwipeToDismiss = YES;
    [self.photoBrowser showNextPhotoAnimated:YES];
    [self.photoBrowser showPreviousPhotoAnimated:YES];
    [self.navigationController pushViewController:self.photoBrowser animated:YES];
    [self.photoBrowser setCurrentPhotoIndex:selectedIndex];
}

- (NSString *)getDiagnosis {
    self.subStr = @"";
    __weak typeof(self) weakSelf = self;
    [self.model.freeAdmission.admissionDiagnosesList enumerateObjectsUsingBlock:^(HMSecondEditionFreePatientInfoDiagnosesModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([obj.diseaseOrder isEqualToString:@"1"]) {
            strongSelf.mainStr = obj.diseaseTitle;
        }
        else {
            if (strongSelf.subStr.length) {
                strongSelf.subStr = [strongSelf.subStr stringByAppendingString:[NSString stringWithFormat:@",%@",obj.diseaseTitle]];
            }
            else {
                strongSelf.subStr = obj.diseaseTitle;
            }
        }
    }];
    return [NSString stringWithFormat:@"主要诊断：%@\n次要诊断：%@",self.mainStr?:@"暂无",self.subStr?:@"暂无"];
}
#pragma mark - event Response
#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.showPhotoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.showPhotoArray.count) {
        return [MWPhoto photoWithURL:[NSURL URLWithString:self.showPhotoArray[index].imgUrl]];
    }
    return nil;
}
#pragma mark - HMSecondEditionPatientInfoCollectTableViewCellDelegate
//图片点击回调
- (void)HMSecondEditionPatientInfoCollectTableViewCellDelegateCallBack_imageClick:(NSIndexPath *)index groupName:(NSString *)groupName{
    __weak typeof(self) weakSelf = self;
    [self.model.freeAdmission.admissionCheckList enumerateObjectsUsingBlock:^(HMSecondEditionFreeCheckGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([groupName isEqualToString:obj.groupName]) {
            strongSelf.showPhotoArray = obj.groupData;
        }
    }];
    
    [self selectShowImageAtIndex:index.row];
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0://基本信息
            return 5;
            break;
        case 4: //辅助检查
            return self.model.freeAdmission.admissionCheckList.count + 1;
            break;
        case 5: //用药
            return self.model.freeAdmission.admissionDrugList.count + 1;
            break;
            
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    SecondEditionFreePatientInfoCellType cellType = [self cellTypeWithIndexPath:indexPath];
    switch (cellType) {
        case SecondEditionFreePatientInfoCellType_name:
        case SecondEditionFreePatientInfoCellType_age:
        case SecondEditionFreePatientInfoCellType_sex:
        case SecondEditionFreePatientInfoCellType_phone:
        case SecondEditionFreePatientInfoCellType_groupNumber:
        {
            height = 45;
            break;
        }
        case SecondEditionFreePatientInfoCellType_selfDescription:
        case SecondEditionFreePatientInfoCellType_diagnosis:
        case SecondEditionFreePatientInfoCellType_medicalHistory:
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
                case SecondEditionFreePatientInfoCellType_selfDescription:
                {
                    [templateCell fillDataWithTitel:@"主诉" content:self.model.freeAdmission.symptoms showMutiLines:[self.showMultiDict[@"SecondEditionFreePatientInfoCellType_selfDescription"] integerValue]];
                    if (self.model.freeAdmission.symptoms.length) {
                        height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                        //无奈的偏移量
                        height += 30;
                    }
                    else {
                        height = 0.000001;
                    }
                    
                    break;
                }
                case SecondEditionFreePatientInfoCellType_diagnosis:
                {
                    [templateCell fillDataWithTitel:@"诊断" content:[self getDiagnosis] showMutiLines:[self.showMultiDict[@"SecondEditionFreePatientInfoCellType_diagnosis"] integerValue]];
                    if (self.model.freeAdmission.admissionDiagnosesList.count) {
                        height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
                        //无奈的偏移量
                        height += 30;
                    }
                    else {
                        height = 0.000001;
                    }

                    break;
                }
                case SecondEditionFreePatientInfoCellType_medicalHistory:
                {
                    [templateCell fillDataWithTitel:@"现病史" content:self.model.freeAdmission.hpi showMutiLines:[self.showMultiDict[@"SecondEditionFreePatientInfoCellType_medicalHistory"] integerValue]];
                    if (self.model.freeAdmission.hpi.length) {
                        height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
                        //无奈的偏移量
                        height += 30;
                    }
                    else {
                        height = 0.000001;
                    }

                    break;
                }
                default:
                    break;
            }
            
            
            break;
        }
        case SecondEditionFreePatientInfoCellType_chaeck:
        {
            if (self.model.freeAdmission.admissionCheckList.count) {
                height = 45;
            }
            else {
                height = 0.000001;
            }
            break;
        }
        case SecondEditionFreePatientInfoCellType_drug:
        {
            if (self.model.freeAdmission.admissionDrugList.count) {
                height = 45;
            }
            else {
                height = 0.000001;
            }
            break;
        }
        default:
            if (indexPath.section == 5) {
                //用药情况
                static HMSecondEditionPatientInfoDrugTableViewCell *templateCell;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    templateCell = [self.tableView dequeueReusableCellWithIdentifier:[HMSecondEditionPatientInfoDrugTableViewCell at_identifier]];
                    if (!templateCell) {
                        templateCell = [[HMSecondEditionPatientInfoDrugTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HMSecondEditionPatientInfoDrugTableViewCell at_identifier]];
                    }
                });
                
                [templateCell fillDataWithModel:self.model.freeAdmission.admissionDrugList[indexPath.row - 1]];
                height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
                //无奈的偏移量 UITableViewCell的高度要比它的contentView要高1,也就是它的分隔线的高度
                height += 1;
            }
            else {
                //辅助检查（图片cell）
                height = 115;
            }
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0.0000001;
            break;
        case 1:
            if (!self.model.freeAdmission.symptoms.length) {
                return 0.0001;
            }
            break;
        case 2:
            if (!self.model.freeAdmission.hpi.length) {
                return 0.0001;
            }
            break;
        case 3:
            if (!self.model.freeAdmission.admissionDiagnosesList.count) {
                return 0.0001;
            }
            break;
        case 4:
            if (!self.model.freeAdmission.admissionCheckList.count) {
                return 0.0001;
            }
            break;
        case 5:
            if (!self.model.freeAdmission.admissionDrugList.count) {
                return 0.0001;
            }
            break;
        default:
            break;
    }
    return 10;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    SecondEditionFreePatientInfoCellType cellType = [self cellTypeWithIndexPath:indexPath];
    switch (cellType) {
        case SecondEditionFreePatientInfoCellType_name:
        case SecondEditionFreePatientInfoCellType_age:
        case SecondEditionFreePatientInfoCellType_sex:
        case SecondEditionFreePatientInfoCellType_phone:
        case SecondEditionFreePatientInfoCellType_groupNumber:
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
                case SecondEditionFreePatientInfoCellType_name:
                {
                    titel = @"姓名";
                    content = self.model.userInfo.userName;
                    break;
                }
                case SecondEditionFreePatientInfoCellType_sex:
                {
                    titel = @"性别";
                    content = self.model.userInfo.sex;
                    break;
                }
                case SecondEditionFreePatientInfoCellType_phone:
                {
                    titel = @"手机号";
                    content = self.model.userInfo.mobile;
                    break;
                }
                case SecondEditionFreePatientInfoCellType_age:
                {
                    titel = @"年龄";
                    content = [NSString stringWithFormat:@"%ld",self.model.userInfo.age];
                    break;
                }
                case SecondEditionFreePatientInfoCellType_groupNumber:
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
            case SecondEditionFreePatientInfoCellType_selfDescription:
            case SecondEditionFreePatientInfoCellType_diagnosis:
            case SecondEditionFreePatientInfoCellType_medicalHistory:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMSecondEditionPatientInfoExtensibleTableViewCell class])];
            if (!cell)
            {
                cell = [[HMSecondEditionPatientInfoExtensibleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HMSecondEditionPatientInfoExtensibleTableViewCell class])];
            }
            switch (cellType) {
                case SecondEditionFreePatientInfoCellType_selfDescription:
                {
                    if (self.model.freeAdmission.symptoms.length) {
                        [cell fillDataWithTitel:@"主诉" content:self.model.freeAdmission.symptoms showMutiLines:[self.showMultiDict[@"SecondEditionFreePatientInfoCellType_selfDescription"] integerValue]];
                    }
            __weak typeof(self) weakSelf = self;
                    [cell extentClick:^{
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        strongSelf.showMultiDict[@"SecondEditionFreePatientInfoCellType_selfDescription"] = @([cell extentBtn].selected);
                        [strongSelf.tableView reloadData];
                    }];

                 break;
                }
                case SecondEditionFreePatientInfoCellType_diagnosis:
                {
                    if (self.model.freeAdmission.admissionDiagnosesList.count) {
                        [cell fillDataWithTitel:@"诊断" content:[self getDiagnosis] showMutiLines:[self.showMultiDict[@"SecondEditionFreePatientInfoCellType_diagnosis"] integerValue]];
                    }
                    __weak typeof(self) weakSelf = self;
                    [cell extentClick:^{
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        strongSelf.showMultiDict[@"SecondEditionFreePatientInfoCellType_diagnosis"] = @([cell extentBtn].selected);
                        [strongSelf.tableView reloadData];

                    }];
                    
                    break;
                }
                case SecondEditionFreePatientInfoCellType_medicalHistory:
                {
                    if (self.model.freeAdmission.hpi.length) {
                        [cell fillDataWithTitel:@"现病史" content:self.model.freeAdmission.hpi showMutiLines:[self.showMultiDict[@"SecondEditionFreePatientInfoCellType_medicalHistory"] integerValue]];
                    }
                    __weak typeof(self) weakSelf = self;
                    [cell extentClick:^{
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        strongSelf.showMultiDict[@"SecondEditionFreePatientInfoCellType_medicalHistory"] = @([cell extentBtn].selected);
                        [strongSelf.tableView reloadData];
                    }];
                    
                    break;
                }
                default:
                    break;
            }

            break;
        }
        case SecondEditionFreePatientInfoCellType_chaeck:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SecondEditionFreePatientInfoCellType_chaeck"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SecondEditionFreePatientInfoCellType_chaeck"];
            }
            [[cell textLabel] setTextColor:[UIColor colorWithHexString:@"333333"]];
            [[cell textLabel] setFont:[UIFont font_32]];
            if (self.model.freeAdmission.admissionCheckList.count) {
                [[cell textLabel] setText:@"辅助检查"];
            }
            break;
        }

        case SecondEditionFreePatientInfoCellType_drug:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SecondEditionFreePatientInfoCellType_drug"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SecondEditionFreePatientInfoCellType_drug"];
            }
            [[cell textLabel] setTextColor:[UIColor colorWithHexString:@"333333"]];
            [[cell textLabel] setFont:[UIFont font_32]];
            if (self.model.freeAdmission.admissionDrugList.count) {
                [[cell textLabel] setText:@"用药情况"];
            }
            break;
        }

        default:
            if (indexPath.section == 4) {
                // 辅助检查cell
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMSecondEditionPatientInfoCollectTableViewCell class])];
                if (!cell)
                {
                    cell = [[HMSecondEditionPatientInfoCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HMSecondEditionPatientInfoCollectTableViewCell class])];
                }
                if (self.model.freeAdmission.admissionCheckList.count) {
                    HMSecondEditionFreeCheckGroupModel *model = self.model.freeAdmission.admissionCheckList[indexPath.row - 1];
                    [cell fillDataWithModel:model];
                }
                [cell setDelegate:self];
                
                break;

            }
            else if (indexPath.section == 5) {
                //用药cell
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMSecondEditionPatientInfoDrugTableViewCell class])];
                if (!cell)
                {
                    cell = [[HMSecondEditionPatientInfoDrugTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([HMSecondEditionPatientInfoDrugTableViewCell class])];
                }
                [cell fillDataWithModel:self.model.freeAdmission.admissionDrugList[indexPath.row - 1]];

                break;
            }
    }
    
     return cell;
}

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
- (HMSecondEditionPationInfoModel *)model {
    if (!_model) {
        _model = [HMSecondEditionPationInfoModel new];
    }
    return _model;
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
