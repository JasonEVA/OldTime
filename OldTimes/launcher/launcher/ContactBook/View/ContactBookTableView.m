//
//  ContactBookTableView.m
//  launcher
//
//  Created by williamzhang on 15/10/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactBookTableView.h"
#import "ContactPersonDetailInformationModel.h"
#import "ContactDepartmentImformationModel+UserForSelect.h"
#import "ContactBookGetDeptListRequest.h"
#import "ContactBookGetSortListRequest.h"
#import "ContactBookGetUserListRequest.h"
#import "ContactBookNameTableViewCell.h"
#import "ContactBookDeptTableViewCell.h"
#import "UnifiedUserInfoManager.h"
#import "BaseViewController.h"

#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "AppDelegate.h"

static NSString * const sortNameKey = @"sortNameKey";

typedef NS_ENUM(NSInteger, OrderTypes) {
    kInNameOrder = 0,   //按姓名
    kInDeptOrder        //按部门
};

@interface ContactBookTableView () <UITableViewDataSource, UITableViewDelegate, BaseRequestDelegate>

@property (nonatomic, weak, readonly) BaseViewController *superVC;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, readonly) SelectContactTabbarView *tabbar;
//已将数据归类好的数据,二维数组
@property(nonatomic, strong) NSMutableArray  *userListModelArr;
//序列数组
@property(nonatomic, strong) NSMutableArray  *sortArr;
//部门数组
@property(nonatomic, strong) NSMutableArray  *deptModelArr;

/** 显示用的数组 */
@property(nonatomic, strong) NSMutableArray  *modelArr;
/** 姓氏首字母显示器 */
@property (nonatomic, strong) UILabel *indicateLabel;


//排列类型
@property(nonatomic, assign) OrderTypes  orderType;

@property (nonatomic, copy) ContactBookTableViewSelectContactBlock contactBlock;
@property (nonatomic, copy) ContactBookTableViewSelectDeptmentBlock deptmentBlock;
@property (nonatomic, copy) ContactBoolTableViewSelectDeptmentSelectBlock departmentSelectBlock;

@property (nonatomic, strong) UIView *emptyPageView; //空白页

@end

@implementation ContactBookTableView

- (instancetype)initWithSuperViewController:(BaseViewController *)superViewController {
    return [self initWithSuperViewController:superViewController tabbar:nil];
}

- (instancetype)initWithSuperViewController:(BaseViewController *)superViewController tabbar:(SelectContactTabbarView *)tabbar {
    self = [super init];
    if (self) {
        
        _tabbar = tabbar;
        [_tabbar addObserver:self forKeyPath:@"arraycount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
        _superVC = superViewController;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    
//        ContactBookGetSortListRequest *sortRequest = [[ContactBookGetSortListRequest alloc] initWithDelegate:self];
//        [sortRequest requestData];
        // 数据库中获取数据
      //  self.sortArr = [[NSUserDefaults standardUserDefaults] objectForKey:sortNameKey];
//        NSArray *userArray = [[UnifiedSqlManager share] findAllContactPeople];
//        self.userListModelArr = [self getSortedUserListArrWithDataArray:userArray];
        //self.modelArr = self.userListModelArr;
       // [self.tableView reloadData];
        if (![self.sortArr count]) {
            [self.superVC postLoading];
        }
    }
    
    return self;
}

#pragma mark - Interface Method
- (void)reloadData {
    [self.tableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self reloadData];
}

#pragma mark - Private Method

// 是否显示空白页
- (void)isShowEmptyPage
{
    if (self.mixModelArr.count == 0) {
        [self.emptyPageView setHidden:NO];
    } else {
        [self.emptyPageView setHidden:YES];
    }
}

- (void)startGetCompanyDeptRequest
{
    ContactBookGetDeptListRequest *deptListRequest = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
    [deptListRequest getCompanyDeptWithParentId:[UnifiedUserInfoManager share].companyShowID];
}

/** 同时加载人员与部门时部门先获取过来需要进行重新配置人员 */
- (void)shouldSetPeopleToDepartment {
    if ([self.mixModelArr count] != 2) {
        // 人员已经获取完毕，部门还没有
        return;
    }
    
    NSArray *array = [self.mixModelArr lastObject];
    if ([array count]) {
        // 人员获取完毕，部门获取完毕
        return;
    }
    
    [self.mixModelArr removeLastObject];
    [self.mixModelArr addObject:[self companyPeople]];
}

/** 搜索出隶属公司门下人员 */
- (NSArray *)companyPeople {
    NSMutableArray *userArrayTmp = [NSMutableArray array];

    for (NSArray *userSortArray in self.userListModelArr) {
        
        for (ContactPersonDetailInformationModel *userModel in userSortArray) {
            
            if (![userModel.u_dept_id containsObject:[UnifiedUserInfoManager share].companyShowID]) {
                continue;
            }
            
            [userArrayTmp addObject:userModel];
        }
    }
    
    return userArrayTmp;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.modelArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.modelArr objectAtIndex:section];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.orderType == kInDeptOrder) {
        return 0.000001;
    }
    
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderType == kInDeptOrder && indexPath.section == 0) {
        return [ContactBookDeptTableViewCell height];
    }
    return [ContactBookNameTableViewCell height];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.orderType == kInDeptOrder) {
        return nil;
    }
    
    ContactPersonDetailInformationModel *model = [self.modelArr[section] firstObject];
    return model.u_true_name_c;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.orderType == kInDeptOrder) {
        return nil;
    }
    
    UIView *headerView = [UIView new];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 8, 50, 10)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor mtc_colorWithHex:0x666666];
    [headerView addSubview:titleLabel];
    
    ContactPersonDetailInformationModel *model = [self.modelArr[section] firstObject];
    if ([model.u_hira length]) {
        titleLabel.text = model.u_hira;
    } else if ([model.u_true_name_c length]) {
        titleLabel.text = model.u_true_name_c;
    } else {
        titleLabel.text = @"#";
    }
    
    return headerView;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.orderType == kInDeptOrder) {
        return nil;
    }
    
    NSMutableArray *arraySort = [NSMutableArray array];
    for (NSInteger i = 0; i < [self.modelArr count]; i ++) {
        ContactPersonDetailInformationModel *model = [self.modelArr[i] firstObject];
        if ([model.u_hira length]) {
            [arraySort addObject:model.u_hira];
        
        } else if ([model.u_true_name_c length]) {
            [arraySort addObject:model.u_true_name_c];
        } else {
            [arraySort addObject:@"#"];
        }
    }
    
    return arraySort;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (self.indicateLabel) {
        [self.indicateLabel removeFromSuperview];
        self.indicateLabel = nil;
    }
    
    self.indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.indicateLabel.backgroundColor = [UIColor themeBlue];
    self.indicateLabel.alpha = 0.5;
    self.indicateLabel.font = [UIFont systemFontOfSize:24];
    self.indicateLabel.textColor = [UIColor whiteColor];
    self.indicateLabel.textAlignment = NSTextAlignmentCenter;
    self.indicateLabel.layer.cornerRadius = 4;
    self.indicateLabel.layer.masksToBounds = YES;
    self.indicateLabel.text = title;
    
    CGPoint center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2, CGRectGetHeight([UIScreen mainScreen].bounds) / 2);
    self.indicateLabel.center = center;
    
    AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
    [aDelegate.window addSubview:self.indicateLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.indicateLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self.indicateLabel removeFromSuperview];
        self.indicateLabel = nil;
    }];
    
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    id cell = nil;
    if (self.orderType == kInDeptOrder && section == 0) {
        // 部门
        cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookDeptTableViewCell identifier]];
        ContactDepartmentImformationModel *departmentModel = [self.modelArr[section] objectAtIndex:row];
        
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
        
        [cell setDataWithDeptModel:departmentModel selectMode:(NO)];
        
        if (self.tabbar.singleSelectable) {
            [cell isSingleMode];
        }
        __weak typeof(self) weakSelf = self;
        [cell clickToSelect:^(id selectedCell) {
            // 点击了部门勾选
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSIndexPath *clickedIndexPath = [strongSelf.tableView indexPathForCell:selectedCell];
            ContactDepartmentImformationModel *deptModel = [strongSelf.modelArr[clickedIndexPath.section] objectAtIndex:clickedIndexPath.row];
            
            deptModel.isSelect ^= 1;
            
            if (strongSelf.departmentSelectBlock) {
                strongSelf.departmentSelectBlock(deptModel);
            }
            
            //[strongSelf.tabbar addOrDeleteDepartment:departmentModel];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[clickedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    else {
        // 姓名排序
        cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookNameTableViewCell identifier]];
        ContactPersonDetailInformationModel *userModel = [self.modelArr[section] objectAtIndex:row];

        [cell setDataWithModel:userModel selectMode:(self.tabbar != nil)];
        if (self.tabbar) {
            [cell setIsMission:self.tabbar.isMission];
            BOOL selected = [self.tabbar.dictSelected objectForKey:userModel.show_id] != nil;
            BOOL unableSelected = [self.tabbar.dictUnableSelected objectForKey:userModel.show_id] != nil;
            [cell setSelect:selected unableSelect:unableSelected selfSelectable:self.tabbar.selfSelectable];
        }
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.orderType == kInDeptOrder && indexPath.section == 0) {
        // 点击部门
        if (self.deptmentBlock) {
            ContactDepartmentImformationModel *selectedModel = [self.mixModelArr[indexPath.section] objectAtIndex:indexPath.row];
            self.deptmentBlock(selectedModel, self.deptModelArr);
        }
    }
    else {
        ContactPersonDetailInformationModel *selectedModel = [self.modelArr[indexPath.section] objectAtIndex:indexPath.row];
        if (self.contactBlock) {
            self.contactBlock(selectedModel);
        }
        
        if (!self.tabbar) {
            return;
        }
        
        [self.tabbar addOrDeletePerson:selectedModel];
        
        [self.tableView reloadData];
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    self.orderType = kInDeptOrder;
    if ([request isKindOfClass:[ContactBookGetSortListRequest class]]) {
        // 首字母排序
        self.sortArr = [NSMutableArray arrayWithArray:[(id)response sortArr]] ;
        [self.sortArr addObject:@"#"];
        [[NSUserDefaults standardUserDefaults] setObject:self.sortArr forKey:sortNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self endEditing:YES];
    }
    
    else if ([request isKindOfClass:[ContactBookGetUserListRequest class]]) {
        // 用户列表
        NSArray *arrayTmp = [(id)response modelArr];
        [self.mixModelArr addObject:arrayTmp];
        [self isShowEmptyPage];
        if (self.orderType == kInDeptOrder) {
            self.modelArr = self.mixModelArr;
            [self.tableView reloadData];
        }
        [self.superVC hideLoading];

    }
    
    else if ([request isKindOfClass:[ContactBookGetDeptListRequest class]]) {
        // 部门列表
        self.deptModelArr = [(id)response arrResult];
        //部门列表获取成功后，发出获取隶属公司人员列表请求
        ContactBookGetUserListRequest *request = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
        [request getUserWithDepartID:[UnifiedUserInfoManager share].companyShowID];
        self.mixModelArr = [NSMutableArray array];
        
        [self.mixModelArr addObject:self.deptModelArr];
        
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self.superVC postError:errorMessage];
}

#pragma mark - Private Method
- (NSMutableArray *)getSortedUserListArrWithDataArray:(NSArray *)tempArray
{
    NSMutableArray *sortedArray = [NSMutableArray array];

    for (NSInteger i = 0; i < [self.sortArr count]; i ++) {
        [sortedArray addObject:[NSMutableArray array]];
    }
    
    for (ContactPersonDetailInformationModel *model in tempArray) {
       
        for (NSInteger i = 0; i < [self.sortArr count]; i ++) {
        
            NSString *character = [self.sortArr objectAtIndex:i];
            if (![model.u_hira length] && ![model.u_true_name_c length]) {
                [[sortedArray lastObject] addObject:model];
                break;
            }
            
            if (![model.u_hira isEqualToString:character] && ![model.u_true_name_c isEqualToString:character]) {
                continue;
            }
            
            [[sortedArray objectAtIndex:i] addObject:model];
            break;
        }
    }
    
    NSMutableArray *finalArray = [NSMutableArray array];
    for (NSArray *arrayTmp in sortedArray) {
        if ([arrayTmp count]) {
            [finalArray addObject:arrayTmp];
        }
    }
    
    return finalArray;
}

- (void)setCountWithModel:(ContactDepartmentImformationModel *)deptModel
{
    NSInteger count = 0;
    for (ContactDepartmentImformationModel *model in self.deptModelArr)
    {
        if ([model.D_PARENTID_SHOW_ID isEqualToString:deptModel.ShowID])
        {
            count = count + model.subObjCount;
        }
    }
    
    NSMutableDictionary *dictRelateContacts = [NSMutableDictionary dictionary];
    for (NSMutableArray *temArr in self.userListModelArr)
    {
        for (ContactPersonDetailInformationModel *model in temArr) {
            if ([model.u_dept_id containsObject:deptModel.ShowID]) {
                count ++;
            }
            
            if ([model.d_path_name containsObject:deptModel.D_NAME]) {
                [dictRelateContacts setObject:@1 forKey:model.show_id];
            }
        }
    }
    
    deptModel.dictRelateContacts = [NSDictionary dictionaryWithDictionary:dictRelateContacts];
    deptModel.subObjCount = count;
}

#pragma mark - Setter
- (void)selectContact:(ContactBookTableViewSelectContactBlock)contactBlock {
    _contactBlock = contactBlock;
}

- (void)selectDeptment:(ContactBookTableViewSelectDeptmentBlock)deptmentBlock {
    _deptmentBlock = deptmentBlock;
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
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_tableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
        [_tableView registerClass:[ContactBookDeptTableViewCell class] forCellReuseIdentifier:[ContactBookDeptTableViewCell identifier]];
    }
    return _tableView;
}

- (UIView *)emptyPageView
{
    if (!_emptyPageView) {
        _emptyPageView = [[UIView alloc] init];
        [self addSubview:_emptyPageView];
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
            make.bottom.equalTo(_emptyPageView.mas_centerY);
        }];
        [titel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.top.equalTo(_emptyPageView.mas_centerY).offset(20);
        }];
        [_emptyPageView setHidden:YES];
    }
    return _emptyPageView;
}

@end
