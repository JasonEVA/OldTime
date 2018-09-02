//
//  HMSelectGroupsViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/6/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSelectGroupsViewController.h"
#import "HMSelectGroupTableViewCell.h"
#import "DAOFactory.h"
#import "NewPatientGroupListInfoModel.h"
#import "HMSelectPatientThirdEditionBottomView.h"

@interface HMSelectGroupsViewController ()<UITableViewDelegate,UITableViewDataSource,HMSelectPatientThirdEditionBottomViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, strong)  HMSelectPatientThirdEditionBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *selectedGroupsArray;
@property (nonatomic, copy) GroupsSelectedBlock selectedBlock;

@end

@implementation HMSelectGroupsViewController

- (instancetype)initWithSelectedGroups:(NSArray *)selectedGroup {
    if (self = [super init]) {
        self.selectedGroupsArray = [NSMutableArray arrayWithArray:selectedGroup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"选择群组"];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self startPatientRequest];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

//数据源请求
- (void)startPatientRequest {
    [self at_postLoading];
    __weak typeof(self) weakSelf = self;
    [_DAO.patientInfoListDAO requestPatientListImmediately:NO CompletionHandler:^(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf at_hideLoading];
        
        if (success) {
            NSArray* patients = results;
            __block NSMutableArray<NewPatientGroupListInfoModel *> *tempGroups = [NSMutableArray array];
            [patients enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __block BOOL isExist = NO;
                [tempGroups enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel * _Nonnull groupObj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.teamId.integerValue == groupObj.teamId) {
                        groupObj.userCount ++;
                        isExist = YES;
                        *stop = YES;
                        return;
                    }
                }];
                
                if (isExist) {
                    return;
                }
                
                NewPatientGroupListInfoModel *groupModel = [NewPatientGroupListInfoModel new];
                groupModel.teamName = obj.teamName;
                groupModel.teamId = obj.teamId.integerValue;
                [strongSelf.selectedGroupsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NewPatientGroupListInfoModel *tempModel = (NewPatientGroupListInfoModel *)obj;
                    if (tempModel.teamId == groupModel.teamId) {
                        groupModel.isAllSelected = YES;
                        [strongSelf.selectedGroupsArray replaceObjectAtIndex:idx withObject:groupModel];
                    }
                }];
                [tempGroups addObject:groupModel];
                
                
            }];
            strongSelf.dataList = tempGroups;
            [strongSelf.tableView reloadData];
            [strongSelf configBottomView];
            
        }
        else {
            [strongSelf showAlertMessage:errorMsg];
        }
        
    }];
    
}

- (NSMutableArray *)acquireTeamIdArrWithArr:(NSArray<NewPatientGroupListInfoModel *> *)array {
    NSMutableArray *tempGroup = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempGroup addObject:@(obj.teamId)];
    }];
    return tempGroup;
}

- (void)configBottomView {
    [self.bottomView.sendBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"下一步",self.selectedGroupsArray.count] forState:UIControlStateNormal];
    
    NSSet *selectedSet = [NSSet setWithArray:[self acquireTeamIdArrWithArr:self.selectedGroupsArray]];
    NSSet *groupSet = [NSSet setWithArray:[self acquireTeamIdArrWithArr:self.dataList]];
    
    [self.bottomView.selectBtn setSelected:[groupSet isSubsetOfSet:selectedSet]];
}

#pragma mark - event Response
- (void)rightClick {
    
}
#pragma mark - HMSelectPatientThirdEditionBottomViewDelegate
- (void)HMSelectPatientThirdEditionBottomViewDelegateCallBack_buttonClick:(UIButton *)button {
    if (button.tag) {
        //发送
        if (self.selectedBlock) {
            self.selectedBlock(self.selectedGroupsArray);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        //全选
        
        button.selected ^= 1;
        __weak typeof(self) weakSelf = self;

        [self.dataList enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;

            if (button.selected) {
                if (![[strongSelf acquireTeamIdArrWithArr:strongSelf.selectedGroupsArray ] containsObject:@(obj.teamId)]) {
                    [strongSelf.selectedGroupsArray addObject:obj];
                    
                    obj.isAllSelected = YES;
                    
                }
            }
            else {
                [strongSelf.selectedGroupsArray enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *patientObj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (patientObj.teamId == obj.teamId) {
                        [strongSelf.selectedGroupsArray removeObject:patientObj];
                        obj.isAllSelected = NO;

                    }
                }];
            }
            
        }];
        
        [self.bottomView.sendBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"下一步",self.selectedGroupsArray.count] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewPatientGroupListInfoModel *groupModel = self.dataList[indexPath.row];

    HMSelectGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMSelectGroupTableViewCell at_identifier]];
    [cell fillDataWith:groupModel.teamName count:groupModel.userCount isSelected:groupModel.isAllSelected];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewPatientGroupListInfoModel *groupModel = self.dataList[indexPath.row];
    groupModel.isAllSelected ^= 1;
    
    if (![[self acquireTeamIdArrWithArr:self.selectedGroupsArray ] containsObject:@(groupModel.teamId)]) {
        [self.selectedGroupsArray addObject:groupModel];
    }
    else {
        [self.selectedGroupsArray removeObject:groupModel];

    }

    
    [self.tableView reloadData];
    
    [self configBottomView];
}

#pragma mark - request Delegate

#pragma mark - Interface
- (void)getSelectedGroup:(GroupsSelectedBlock)block;
{
    self.selectedBlock = block;
}
#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:60];
        [_tableView registerClass:[HMSelectGroupTableViewCell class] forCellReuseIdentifier:[HMSelectGroupTableViewCell at_identifier]];
    }
    return _tableView;
}

- (HMSelectPatientThirdEditionBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HMSelectPatientThirdEditionBottomView alloc] init];
        [_bottomView.sendBtn setTitle:[NSString stringWithFormat:@"%@()",@"下一步"] forState:UIControlStateNormal];
        [_bottomView setDelegate:self];
    }
    return _bottomView;
}

- (NSMutableArray *)selectedGroupsArray {
    if (!_selectedGroupsArray) {
        _selectedGroupsArray = [NSMutableArray array];
    }
    return _selectedGroupsArray;
}
@end
