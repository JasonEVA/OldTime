//
//  ContactBookDeptmentViewController.m
//  launcher
//
//  Created by williamzhang on 15/10/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactBookDeptmentViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ContactDepartmentImformationModel+UserForSelect.h"
#import "ContactBookDetailViewController.h"
#import "ContactBookDeptTableViewCell.h"
#import "ContactBookNameTableViewCell.h"

#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "ContactBookGetDeptListRequest.h"
#import "ContactBookGetUserListRequest.h"
#import "ContactBookGetCompanyDeptUpDateTimeRequest.h"
#import "ContactBookGetCompanyUserUpDateTimeRequest.h"
#import "ContactBookMag.h"


@interface ContactBookDeptmentViewController () <UITableViewDataSource, UITableViewDelegate,BaseRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, readonly) SelectContactTabbarView *tabbar;

@property (nonatomic, strong) NSArray *arrayTable;

@property (nonatomic, strong) ContactDepartmentImformationModel *currentModel;
@property (nonatomic, strong) NSArray *deptmentsArray;

@property (nonatomic, strong) UILabel *allSelectLabel;
@property (nonatomic, strong) UIImageView *allSelectImage;
@property (nonatomic) BOOL isSelectAll;
@property (nonatomic) BOOL isAllCanNotSelect;
@property (nonatomic, strong) NSMutableArray *deptArray;//部门列表
@property (nonatomic, strong) NSMutableArray *contactArray;//人员列表
/// 防止推出2层VC
@property (nonatomic) BOOL doubleclick;
@property (nonatomic, copy) void (^reloadBlock)();

@property (nonatomic, strong) UIView *emptyPageView; //空白页

@property (nonatomic, assign) long long deptTimeLong;
@property (nonatomic, assign) long long userTimeLong;

@end

@implementation ContactBookDeptmentViewController

- (instancetype)initWithCurrentDeptment:(ContactDepartmentImformationModel *)currenModel{
    return [self initWithCurrentDeptment:currenModel tabbar:nil];
}

- (instancetype)initWithCurrentDeptment:(ContactDepartmentImformationModel *)currenModel tabbar:(SelectContactTabbarView *)tabbar {
    self = [super init];
    if (self) {
        _currentModel = currenModel;
        //_deptmentsArray = deptmentsArray;
        _tabbar = tabbar;
        [_tabbar addObserver:self forKeyPath:@"arraycount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.currentModel.D_NAME];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:[self CustomRightView]];
    
    [self.navigationItem setRightBarButtonItem:btn];


    if (self.tabbar) {
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44);
    }
   
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.isAllCanNotSelect = NO;
    [self handleDataForTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.doubleclick = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Interface Method
- (void)beginData:(void (^)())handle {
    if (handle) {
        handle();
    }
    [self.tableView reloadData];
}

- (void)reloadData:(void (^)())reloadBlock {
    _reloadBlock = reloadBlock;
}

#pragma mark - Private Method

// 是否显示空白页
- (void)isShowEmptyPage
{
    if (self.deptArray.count == 0 && self.contactArray.count == 0) {
        [self.emptyPageView setHidden:NO];
    } else {
        [self.emptyPageView setHidden:YES];
    }
    
    
}

// 处理tableView显示数据
- (void)handleDataForTableView {
    
    [self getDeptData];
    [self getUserData];
    
}

// 获取 当下部门 的更新时间戳
- (void)getCompanyDeptUpDateTimeRequest
{
    ContactBookGetCompanyDeptUpDateTimeRequest * request = [[ContactBookGetCompanyDeptUpDateTimeRequest alloc] initWithDelegate:self];
    request.parentId = self.currentModel.ShowID;
    [request requestData];
}
// 获取 当下部门成员 的更新时间戳
- (void)getCompanyUserUpDateTimeRequest
{
    ContactBookGetCompanyUserUpDateTimeRequest * request= [[ContactBookGetCompanyUserUpDateTimeRequest alloc] initWithDelegate:self];
    request.deptId = self.currentModel.ShowID;
    [request requestData];
}

- (void)getDeptData
{
    NSArray * array = [[ContactBookMag share] getBranchDataWithParentId:self.currentModel.ShowID];
    if (array.count) {
        self.deptArray = [NSMutableArray arrayWithArray:array];
        self.arrayTable = @[self.deptArray, self.contactArray];
        self.isSelectAll = [self checkState];
        [self isShowEmptyPage];
        [self.tableView reloadData];
        [self getCompanyDeptUpDateTimeRequest];
    }else {
        if (self.currentModel.D_AVAILABLE_COUNT == 0) {
            self.deptArray = [NSMutableArray arrayWithArray:array];
            self.arrayTable = @[self.deptArray, self.contactArray];
            self.isSelectAll = [self checkState];
            [self isShowEmptyPage];
            [self.tableView reloadData];
            [self getCompanyDeptUpDateTimeRequest];
        }else {
            [self getCompanyDeptUpDateTimeRequest];
//            ContactBookGetDeptListRequest *request = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
//            [request getCompanyDeptWithParentId:self.currentModel.ShowID];
//            [self postLoading];
        }
    }
}
- (void)getUserData
{
    NSArray * array = [[ContactBookMag share] getMemberWithDeptId:self.currentModel.ShowID];
    if (array && array.count) {
        self.contactArray = [NSMutableArray arrayWithArray:array];
        self.arrayTable = @[self.deptArray, self.contactArray];
        self.isSelectAll = [self checkState];
        [self isShowEmptyPage];
        [self.tableView reloadData];
        [self getCompanyUserUpDateTimeRequest];
    }else {
        //[self getCompanyUserUpDateTimeRequest];
        //获取人员数据
        ContactBookGetUserListRequest *request = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
        [request getUserWithDepartID:self.currentModel.ShowID];
        [self postLoading];
    }
}



- (void)setCountForModel:(ContactDepartmentImformationModel *)deptmentModel {
//    NSInteger count = 0;
//    for (ContactDepartmentImformationModel *deptModel in self.deptmentsArray) {
//        if ([deptModel.D_PARENTID_SHOW_ID isEqualToString:deptmentModel.ShowID]) {
//            count = count + deptModel.subObjCount;
//        }
//    }
//    
//    NSMutableDictionary *dictRelateContacts = [NSMutableDictionary dictionary];
//    for (ContactPersonDetailInformationModel *userModel in [[UnifiedSqlManager share] findAllContactPeople]) {
//        if ([userModel.u_dept_id containsObject:deptmentModel.ShowID]) {
//            count ++;
//        }
//        
//        if ([userModel.d_path_name containsObject:deptmentModel.D_NAME]) {
//            [dictRelateContacts setObject:@1 forKeyedSubscript:userModel.show_id];
//        }
//    }
//    
//    deptmentModel.dictRelateContacts = [NSDictionary dictionaryWithDictionary:dictRelateContacts];
//    deptmentModel.subObjCount = count;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self checkState];
    [self.tableView reloadData];
}
//全选按钮点击事件
- (void)allSelectClickAction
{
    //非单选状态才响应全选事件
    if (!self.tabbar.singleSelectable && !self.isAllCanNotSelect) {
        self.isSelectAll ^= 1;
        [self changeState:self.isSelectAll];
        self.currentModel.isSelect ^= 1;
        if (self.reloadBlock) {
            self.reloadBlock();
        }
        [self.tabbar addOrDeleteDepartment:self.currentModel contactsArray:self.contactArray];
        [self.tableView reloadData];
    }
}
//改变选中状态
- (void)changeState:(BOOL)state
{
    if (state) {
		
        [self.allSelectImage setImage:[UIImage imageNamed:@"Me_check"]];
        self.allSelectLabel.textColor = [UIColor mtc_colorWithHex:0x2d9efa];
    } else {
        [self.allSelectImage setImage:[UIImage imageNamed:@"toRead_icon_unselected"]];
        self.allSelectLabel.textColor = [UIColor mtc_colorWithHex:0xa4a4a4];
    }
    if (self.isAllCanNotSelect) {
        //全不可选，禁用全选按钮
        [self.allSelectLabel setEnabled:NO];
        [self.allSelectImage setImage:[UIImage imageNamed:@"check_gray"]];

    }
}
//检查是否为全选状态
- (BOOL)checkState
{
    if (self.tabbar) {
        BOOL isSelect;
        NSArray *arr = self.contactArray;
        NSArray *unableSelectShIDArr = [self.tabbar.dictUnableSelected allKeys];
        NSInteger num = 0;//列表人员在已选数组中的数量
        NSInteger unableSelectNum = 0;//列表人员在不可选数组中的数量
        for (NSInteger i = 0 ; i < arr.count ; i ++ ) {
            ContactPersonDetailInformationModel *model1 = arr[i];
            //遍历判断是否全不可选
            for (NSString *shID in unableSelectShIDArr) {
                if ([model1.show_id isEqualToString:shID]) {
                    unableSelectNum ++;
                    break;
                }
            }
            //遍历判断是否已全选
            if (self.tabbar.dictSelected[model1.show_id] != nil) {
                num ++;
            }
            
            //自己不可选模式下，自己在当前列表下时，数量加1
            if (!self.tabbar.selfSelectable && [model1.show_id isEqualToString:[UnifiedUserInfoManager share].userShowID]) {
                //num ++ ;
                unableSelectNum ++;
            }
            
            
        }
        
        if (unableSelectNum + num != arr.count) {
            //非全选状态
            isSelect = NO;
			self.isAllCanNotSelect = NO;
        } else {
            if (num == 0) {
                //全不可选，禁用全选按钮
                self.isAllCanNotSelect = YES;
            } else {
                //全选状态
                isSelect = YES;
            }
        }
        
        //设置当前部门的全选状态
        self.currentModel.isSelect = isSelect;
        //改版按钮状态
        [self changeState:isSelect];
        return isSelect;

    } else {
        return NO;
    }
    
}


//自定义右侧全选按钮
- (UIView *)CustomRightView
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 20)];
    _allSelectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toRead_icon_unselected"]];
    _allSelectLabel = [[UILabel alloc] init];
    [self.allSelectLabel setText:LOCAL(CONTACTBOOK_SELECTALL)];
    self.allSelectLabel.font = [UIFont systemFontOfSize:15];
    [self.allSelectLabel setTextColor:[UIColor mtc_colorWithHex:0xa4a4a4]];
    [self.allSelectImage setHidden:YES];
    [self.allSelectLabel setHidden:YES];
    [rightView addSubview:self.allSelectImage];
    [rightView addSubview:self.allSelectLabel];
    
    [self.allSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightView);
        make.right.equalTo(rightView);
    }];
    
    [self.allSelectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.allSelectLabel.mas_left).offset(-5);
        make.centerY.equalTo(rightView);
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allSelectClickAction)];
    [rightView addGestureRecognizer:tap];
    
    return rightView;
    
}

#pragma mark - BaseRequestDelegate

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self hideLoading];
    if ([request isKindOfClass:[ContactBookGetCompanyDeptUpDateTimeRequest class]])
    {
        ContactBookGetDeptListRequest *request = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
        [request getCompanyDeptWithParentId:self.currentModel.ShowID];
        [self postLoading];
        return;
    }
    else if ([request isKindOfClass:[ContactBookGetCompanyUserUpDateTimeRequest class]])
    {
        ContactBookGetUserListRequest *request = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
        [request getUserWithDepartID:self.currentModel.ShowID];
        [self postLoading];
        return;
    }else {
        [self postError:errorMessage];
    }
}

- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[ContactBookGetDeptListRequest class]]) {
        // 部门列表
        self.deptArray = [(id)response arrResult];
        self.arrayTable = @[self.deptArray, self.contactArray];
        self.isSelectAll = [self checkState];
        [self isShowEmptyPage];
        [self hideLoading];
        [self.tableView reloadData];
        
        [[NSUserDefaults standardUserDefaults] setValue:@(self.deptTimeLong) forKey:[[ContactBookMag share] getDeptTimeWithDict:self.currentModel.ShowID]];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } else if ([request isKindOfClass:[ContactBookGetUserListRequest class]]){
        
        self.contactArray = [(id)response modelArr];
        self.arrayTable = @[self.deptArray, self.contactArray];
        self.isSelectAll = [self checkState];
        [self isShowEmptyPage];
        [self hideLoading];
        [self.tableView reloadData];
        [[NSUserDefaults standardUserDefaults] setValue:@(self.userTimeLong) forKey:[[ContactBookMag share] getUserTimeWithDict:self.currentModel.ShowID]];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } else if ([request isKindOfClass:[ContactBookGetCompanyDeptUpDateTimeRequest class]]) {
        ContactBookGetCompanyDeptUpDateTimeResponse * resp = (ContactBookGetCompanyDeptUpDateTimeResponse *)response;
        BOOL isChange =   [[ContactBookMag share] deptIsChangeWithData:resp.dict parentId:resp.parentId];
        self.deptTimeLong = [[resp.dict objectForKey:@"lastUpadteTime"] longLongValue];
        if (isChange)
        {
            ContactBookGetDeptListRequest *request = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
            [request getCompanyDeptWithParentId:self.currentModel.ShowID];
            [self postLoading];
        }
        else
        {
            [self hideLoading];
        }
    } else if ([request isKindOfClass:[ContactBookGetCompanyUserUpDateTimeRequest class]]) {
        ContactBookGetCompanyUserUpDateTimeResponse * resp = (ContactBookGetCompanyUserUpDateTimeResponse *)response;
        BOOL isChange = [[ContactBookMag share] userIsChangeWithData:resp.dict deptId:resp.deptId];
        self.userTimeLong = [[resp.dict objectForKey:@"lastUpadteTime"] longLongValue];
        if (isChange) {
            //获取人员数据
            ContactBookGetUserListRequest *request = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
            [request getUserWithDepartID:self.currentModel.ShowID];
            [self postLoading];
        }
        else
        {
            [self hideLoading];
        }
    }
    else
    {
        [self hideLoading];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrayTable count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.arrayTable objectAtIndex:section];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return [ContactBookDeptTableViewCell height];
    }
    
    return [ContactBookNameTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    if (indexPath.section) {
        if (self.tabbar && !self.tabbar.singleSelectable) {
            [self.allSelectLabel setHidden:NO];
            [self.allSelectImage setHidden:NO];
        }
        // 联系人
        cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookNameTableViewCell identifier]];
        
        ContactPersonDetailInformationModel *model = [self.arrayTable[indexPath.section] objectAtIndex:indexPath.row];
        [cell setDataWithModel:model selectMode:self.tabbar != nil];
        
        if (self.tabbar) {
            [cell setIsMission:self.tabbar.isMission];
            BOOL selected = [self.tabbar.dictSelected objectForKey:model.show_id] != nil;
            BOOL unableSelected = [self.tabbar.dictUnableSelected objectForKey:model.show_id] != nil;
            [cell setSelect:selected unableSelect:unableSelected selfSelectable:self.tabbar.selfSelectable];
        }
    }
    
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookDeptTableViewCell identifier]];
        
        ContactDepartmentImformationModel *departmentModel = [self.arrayTable[indexPath.section] objectAtIndex:indexPath.row];
        
        if (self.tabbar) {
            // 判断该部门下是否都选中
            BOOL allSelect = YES;
            NSArray *arraySelect = [departmentModel.dictRelateContacts allKeys];
            if (![arraySelect count] && !departmentModel.isSelect) {
                allSelect = NO;
            }
            
            for (NSString *selectedShowId in arraySelect) {
                if (![self.tabbar.dictSelected valueForKey:selectedShowId]) {
                    allSelect = NO;
                    break;
                }
            }
            
            departmentModel.isSelect = allSelect;
        }
        
        [cell setDataWithDeptModel:departmentModel selectMode:NO];
        if (self.tabbar.singleSelectable) {
            [cell isSingleMode];
        }
        
        __weak typeof(self) weakSelf = self;
        [cell clickToSelect:^(id cell) {
            // 点击打勾
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSIndexPath *clickedIndexPath = [strongSelf.tableView indexPathForCell:cell];
            ContactDepartmentImformationModel *deptModel = [strongSelf.arrayTable[clickedIndexPath.section] objectAtIndex:clickedIndexPath.row];
            
            deptModel.isSelect ^= 1;
            if (strongSelf.reloadBlock) {
                strongSelf.reloadBlock();
            }
            
            //[self.tabbar addOrDeleteDepartment:deptModel];
            
            [strongSelf.tableView reloadRowsAtIndexPaths:@[clickedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.doubleclick) {
        
    
        
        if (indexPath.section == 0) {
            // 部门
            ContactDepartmentImformationModel *selectedModel = [self.arrayTable[indexPath.section] objectAtIndex:indexPath.row];
            ContactBookDeptmentViewController *VC = [[ContactBookDeptmentViewController alloc] initWithCurrentDeptment:selectedModel tabbar:self.tabbar];
			
			__weak typeof(self) weakSelf = self;
            [VC reloadData:^{
				__strong typeof(weakSelf) strongSelf = weakSelf;
                // 选择部门的，弄一层循环
                !strongSelf.reloadBlock ?: strongSelf.reloadBlock();
                
                [strongSelf.tableView reloadData];
            }];
            
            [self.navigationController pushViewController:VC animated:YES];
        }
        else {
            // 人员
            ContactPersonDetailInformationModel *selectedModel = [self.arrayTable[indexPath.section] objectAtIndex:indexPath.row];
            
            !self.reloadBlock? : self.reloadBlock();
            
            if (!self.tabbar) {
                ContactBookDetailViewController *VC = [[ContactBookDetailViewController alloc] initWithUserModel:selectedModel];
				
				__weak typeof(self) weakSelf = self;
                [VC setbackblock:^{
					__strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
                
                [self.navigationController pushViewController:VC animated:YES];
                return;
            }
            
            // 选择人员模式
            [self.tabbar addOrDeletePerson:selectedModel];
            [self.tableView reloadData];
        }
        //检查是否为全选状态
        self.currentModel.isSelect ^= 1;
        self.isSelectAll = [self checkState];
        if (!self.tabbar) {
            self.doubleclick = NO;
        }
    }
}

- (void)dealloc
{
    [_tabbar removeObserver:self forKeyPath:@"arraycount"];//移除监听
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }

        [_tableView registerClass:[ContactBookDeptTableViewCell class] forCellReuseIdentifier:[ContactBookDeptTableViewCell identifier]];
        [_tableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
    }
    return _tableView;
}

- (NSMutableArray *)deptArray
{
    if (!_deptArray) {
        _deptArray = [NSMutableArray array];
    }
    return _deptArray;
}

- (NSMutableArray *)contactArray
{
    if (!_contactArray) {
        _contactArray = [NSMutableArray array];
    }
    return _contactArray;
}

- (UIView *)emptyPageView
{
    if (!_emptyPageView) {
        _emptyPageView = [[UIView alloc] init];
        [self.view addSubview:_emptyPageView];
        [_emptyPageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tableView);
        }];

        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_contactbook"]];
        UILabel *titel = [[UILabel alloc]init];
        [titel setText:LOCAL(HOMETABBAR_CONTACT)];
        [titel setTextColor:[UIColor themeBlue]];
        [_emptyPageView addSubview:imageView];
        [_emptyPageView addSubview:titel];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.bottom.equalTo(_emptyPageView.mas_centerY).offset(15);
        }];
        [titel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.top.equalTo(_emptyPageView.mas_centerY).offset(35);
        }];
    }
    return _emptyPageView;
}

@end
