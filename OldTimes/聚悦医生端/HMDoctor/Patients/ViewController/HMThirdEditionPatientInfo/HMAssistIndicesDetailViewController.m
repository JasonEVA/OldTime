//
//  HMAssistIndicesDetailViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/7/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMAssistIndicesDetailViewController.h"
#import "HMGetCheckImgListModel.h"
#import "HMAssistIndicesDetailTableViewCell.h"
#import "MWPhotoBrowser.h"

typedef NS_ENUM(NSUInteger, AssistDetailType) {
    AssistDetailType_assistInfo,
    AssistDetailType_assistDetail,
    AssistDetailTypeMaxSection,
};

@interface HMAssistIndicesDetailViewController ()<TaskObserver,UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>
{
    
}
@property (nonatomic, copy) NSString *checkId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger fillType;//1 图片   2 电子表格
@property (nonatomic, assign) NSInteger indicesType;  //2 网格  1和3 项目显示
@property (nonatomic, strong) CheckItemDetailModel *detailModel;
@property (nonatomic, strong) CheckIteminsepecJsonDetailModel *insepecCheckJsonModel;

@property (nonatomic, strong) NSArray *imgList;
@property (nonatomic, strong) NSArray *checkIndexList;
@property (nonatomic, strong) NSMutableArray *showPhotos;
@end

@implementation HMAssistIndicesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.paramObject && [self.paramObject isKindOfClass:[HMGetCheckImgListModel class]]) {
        HMGetCheckImgListModel *model = self.paramObject;
        [self.navigationItem setTitle:model.indicesName];
        _checkId = model.checkId;
    }
    
    [self configElements];
}
#pragma mark - Interface Method

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {

    // 设置约束
    [self configConstraints];
    
    // 设置数据
    [self configData];
}

// 设置数据
- (void)configData {
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:_checkId forKey:@"checkId"];
    
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"getCheckDetailTask" taskParam:dicPost TaskObserver:self];
}

// 设置约束
- (void)configConstraints {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Event Response

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return AssistDetailTypeMaxSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case AssistDetailType_assistInfo:
            return _fillType == 1 ? 2 : 3;
            break;
        
        case AssistDetailType_assistDetail:
        {
            if (_fillType == 1) {
                return self.imgList.count;
            }
            else if(_fillType == 2){
                return 1;
                //return _indicesType == 2 ? self.checkIndexList.count : 1;
            }
            break;
        }
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case AssistDetailType_assistInfo:
            return 50;
            break;
        
        case AssistDetailType_assistDetail:
        {
            if (_fillType == 1) {
                return 200;  //图片
            }
            else if(_fillType == 2){
                CGFloat cellHeight = [HMAssistDetailItemTableViewCell cellHegith:self.insepecCheckJsonModel];
                return _indicesType == 2 ? (self.checkIndexList.count+1) * 45 : cellHeight;
            }
            break;
        }
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    switch (indexPath.section) {
        case AssistDetailType_assistInfo:
        {
            cell = [[HMAssistIndicesDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HMAssistIndicesDetailTableViewCell at_identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAssistDetail:self.detailModel index:indexPath.row];
            break;
        }
        case AssistDetailType_assistDetail:
        {
            if (_fillType == 1) {
                cell = [self.tableView dequeueReusableCellWithIdentifier:[HMAssistDetailImgTableViewCell at_identifier]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                HMImgListModel *imgModel = [self.imgList objectAtIndex:indexPath.row];
                [cell setDetailImageUrl:imgModel.bigImg];
            }
            else if(_fillType == 2){
                if (_indicesType == 2) {
                    cell = [self.tableView dequeueReusableCellWithIdentifier:[HMAssistDetailGridTableViewCell at_identifier]];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setDetailGridArray:self.checkIndexList];
                }
                else{
                    cell = [self.tableView dequeueReusableCellWithIdentifier:[HMAssistDetailItemTableViewCell at_identifier]];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setCheckIteminsepecJsonDetail:self.insepecCheckJsonModel];
                    return cell;
                    
                }

            }
            
            break;
        }
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == AssistDetailType_assistDetail && _fillType == 1) {
        
        NSMutableArray *bigImgArray = [NSMutableArray array];
        [self.imgList enumerateObjectsUsingBlock:^(HMImgListModel *imgModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [bigImgArray addObject:imgModel.bigImg];
        }];
        
        NSMutableArray *photos = [NSMutableArray array];
        for (int i=0; i<bigImgArray.count; i++) {
            
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:bigImgArray[i]]]];
        }
        self.showPhotos = photos;
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [browser setCurrentPhotoIndex:indexPath.row];
        [self.navigationController pushViewController:browser animated:YES];
    }
}

#pragma mark -MWPhotoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.showPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < self.showPhotos.count) {
        return [self.showPhotos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - Override

#pragma mark - Action


#pragma mark - Init

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self at_hideLoading];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
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
    
    if ([taskname isEqualToString:@"getCheckDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[CheckItemDetailModel class]]) {
            self.detailModel = (CheckItemDetailModel *)taskResult;
            
            _fillType = self.detailModel.fillType.integerValue;
            _indicesType = self.detailModel.indicesType.integerValue;
            if (_fillType == 1) {
                //图片
                self.imgList = [HMImgListModel mj_objectArrayWithKeyValuesArray:self.detailModel.imgList];
            }
            else if (_fillType == 2){
                //表格
                if (!kDictIsEmpty(self.detailModel.insepecCheckJsonObject)) {
                    self.insepecCheckJsonModel = [CheckIteminsepecJsonDetailModel mj_objectWithKeyValues:self.detailModel.insepecCheckJsonObject];
                }
                if (!kArrayIsEmpty(self.insepecCheckJsonModel.checkIndexList)) {
                    self.checkIndexList = [CheckItemIndexDetailModel mj_objectArrayWithKeyValuesArray:self.insepecCheckJsonModel.checkIndexList];
                }
            }
            [self.tableView reloadData];
        }
    }
}

#pragma mark - init UI

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[HMAssistIndicesDetailTableViewCell class] forCellReuseIdentifier:[HMAssistIndicesDetailTableViewCell at_identifier]];
        [_tableView registerClass:[HMAssistDetailImgTableViewCell class] forCellReuseIdentifier:[HMAssistDetailImgTableViewCell at_identifier]];
        [_tableView registerClass:[HMAssistDetailGridTableViewCell class] forCellReuseIdentifier:[HMAssistDetailGridTableViewCell at_identifier]];
        [_tableView registerClass:[HMAssistDetailItemTableViewCell class] forCellReuseIdentifier:[HMAssistDetailItemTableViewCell at_identifier]];
    }
    return _tableView;
}

@end
