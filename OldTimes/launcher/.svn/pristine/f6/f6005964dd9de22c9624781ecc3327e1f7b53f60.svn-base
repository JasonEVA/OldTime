//
//  ContactBookNormalTableView.m
//  launcher
//
//  Created by williamzhang on 16/2/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ContactBookNormalTableView.h"
#import "ContactBookGetDeptListRequest.h"
#import "ContactBookGetUserListRequest.h"
#import "ContactBookNameTableViewCell.h"
#import "ContactBookDeptTableViewCell.h"
#import "UIViewController+Loading.h"
#import "UnifiedUserInfoManager.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "ContactBookGetCompanyDeptUpDateTimeRequest.h"
#import "ContactBookGetCompanyUserUpDateTimeRequest.h"
#import "ContactBookMag.h"
#import "SelectContactTabbarView.h"
#import "ContactPersonDetailInformationModel.h"

typedef NS_ENUM(NSUInteger, Contact_sectionType) {
    contact_sectionGroup = 0,
    contact_sectionDeparment,
    contact_sectionPeople,
};

@interface ContactGroupTableViewCell : UITableViewCell
+ (NSString *)identifier;
- (void)setCellDataWithIsFriend:(BOOL)isFriend;
@end

@interface ContactBookNormalTableView () <UITableViewDataSource, UITableViewDelegate, BaseRequestDelegate>

@property (nonatomic, weak, readonly) UIViewController *superViewController;
@property (nonatomic, weak, readonly) SelectContactTabbarView *tabbar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *departmentArray;
/// 直属公司的人员
@property (nonatomic, strong) NSArray *peopleArray;

@property (nonatomic, assign) long long deptTimeLong;
@property (nonatomic, assign) long long userTimeLong;

@end

@implementation ContactBookNormalTableView

@synthesize tabbar = _tabbar;

- (instancetype)initWithViewController:(UIViewController *)superViewController tabbar:(SelectContactTabbarView *)tabbar {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _superViewController = superViewController;
        _tabbar = tabbar;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Interface Method
- (void)downloadDataIfNeed {
   // [self downloadDepartmentsDataIfNeed];
    [self getDeptData];
    [self getUserData];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case contact_sectionGroup:
            return 2;
        case contact_sectionDeparment:
            return [self.departmentArray count];
        case contact_sectionPeople:
            return [self.peopleArray count];
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 25; }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case contact_sectionDeparment:
            return [ContactBookDeptTableViewCell height];
        default:
            return [ContactBookNameTableViewCell height];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != contact_sectionDeparment) {
        return nil;
    }
    
    UIView *headerView = [UIView new];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 8, 50, 10)];
    titleLabel.font = [UIFont mtc_font_24];
    titleLabel.textColor = [UIColor mtc_colorWithHex:0x666666];
    titleLabel.text = LOCAL(CONTACT_ORGANIZATION);
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    id cell = nil;
    switch (section) {
        case contact_sectionGroup: {
            cell = [tableView dequeueReusableCellWithIdentifier:[ContactGroupTableViewCell identifier]];
            if (row == 0) {
                [cell setCellDataWithIsFriend:NO];
            }else {
                [cell setCellDataWithIsFriend:YES];
            }
        }
            break;
        case contact_sectionDeparment: {
            
            cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookDeptTableViewCell identifier]];
            ContactDepartmentImformationModel *department = [self.departmentArray objectAtIndex:row];
            [cell setDataWithDeptModel:department];
        }
            break;
        case contact_sectionPeople: {
            
            cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookNameTableViewCell identifier]];
            ContactPersonDetailInformationModel *person = [self.peopleArray objectAtIndex:row];
            [cell setDataWithModel:person selectMode:(self.tabbar != nil)];
            BOOL selected = [self.tabbar.dictSelected objectForKey:person.show_id] != nil;
            [cell setSelect:selected unableSelect:NO selfSelectable:YES];
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case contact_sectionGroup:
            if (indexPath.row == 0) {
                if ([self.delegate respondsToSelector:@selector(contactBookNormalTableViewDidSelectGroup:)]) {
                    [self.delegate contactBookNormalTableViewDidSelectGroup:self];
                }
            }else {
                if ([self.delegate respondsToSelector:@selector(contactBookNormalTableViewDidSelectFriend:)]) {
                    [self.delegate contactBookNormalTableViewDidSelectFriend:self];
                }
            }
            
            break;
        case contact_sectionDeparment: {
            if ([self.delegate respondsToSelector:@selector(contactBookNormalTableView:didSelectDepartment:)]) {
                
                ContactDepartmentImformationModel *department = [self.departmentArray objectAtIndex:indexPath.row];
                [self.delegate contactBookNormalTableView:self didSelectDepartment:department];
            }
        }
            break;
        case contact_sectionPeople: {
            if ([self.delegate respondsToSelector:@selector(contactBookNormalTableView:didSelectPerson:)]) {
                
                ContactPersonDetailInformationModel *person = [self.peopleArray objectAtIndex:indexPath.row];
                [self.delegate contactBookNormalTableView:self didSelectPerson:person];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tabbar) {
        return NO;
    }
    
    if (indexPath.section == contact_sectionPeople) {
        return YES;
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[ContactBookGetDeptListRequest class]]) {
        self.departmentArray = [(id)response arrResult];
        [self.tableView reloadData];
        [[NSUserDefaults standardUserDefaults] setValue:@(self.deptTimeLong) forKey:[[ContactBookMag share] getDeptTimeWithDict:[UnifiedUserInfoManager share].companyShowID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([request isKindOfClass:[ContactBookGetUserListRequest class]]) {
        self.peopleArray = [(id)response modelArr];
        [self.tableView reloadData];
        [[NSUserDefaults standardUserDefaults] setValue:@(self.userTimeLong) forKey:[[ContactBookMag share] getUserTimeWithDict:[UnifiedUserInfoManager share].companyShowID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if ([request isKindOfClass:[ContactBookGetCompanyDeptUpDateTimeRequest class]]) {
        ContactBookGetCompanyDeptUpDateTimeResponse * resp = (ContactBookGetCompanyDeptUpDateTimeResponse *)response;
        self.deptTimeLong = [[resp.dict objectForKey:@"lastUpadteTime"] longLongValue];
        BOOL isChange =   [[ContactBookMag share] deptIsChangeWithData:resp.dict parentId:resp.parentId];
        if (isChange) {
            ContactBookGetDeptListRequest *request = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
            [request getCompanyDeptWithParentId:[UnifiedUserInfoManager share].companyShowID];
        }
    } else if ([request isKindOfClass:[ContactBookGetCompanyUserUpDateTimeRequest class]]) {
        ContactBookGetCompanyUserUpDateTimeResponse * resp = (ContactBookGetCompanyUserUpDateTimeResponse *)response;
        self.userTimeLong = [[resp.dict objectForKey:@"lastUpadteTime"] longLongValue];
        BOOL isChange = [[ContactBookMag share] userIsChangeWithData:resp.dict deptId:resp.deptId];
        if (isChange) {
            //获取人员数据
            ContactBookGetUserListRequest *request = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
            [request getUserWithDepartID:[UnifiedUserInfoManager share].companyShowID];
        }
    }
    [self.superViewController hideLoading];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    if ([request isKindOfClass:[ContactBookGetCompanyDeptUpDateTimeRequest class]]) {
        
    } else if ([request isKindOfClass:[ContactBookGetCompanyUserUpDateTimeRequest class]]) {
        
    }else {
        [self.superViewController postError:errorMessage];
    }
}

#pragma mark - Private Method
- (void)downloadDepartmentsDataIfNeed {
    if (!self.departmentArray) {
        ContactBookGetDeptListRequest *deptListRequest = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
        [deptListRequest getCompanyDeptWithParentId:[UnifiedUserInfoManager share].companyShowID];
        [self.superViewController postLoading];
        return;
    }
    
    [self downloadPeopleDataIfNeed];
}

- (BOOL)downloadPeopleDataIfNeed {
    if (!self.peopleArray) {
        ContactBookGetUserListRequest *userListRequest = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
        [userListRequest getUserWithDepartID:[UnifiedUserInfoManager share].companyShowID];
        [self.superViewController postLoading];
    }
    
    return self.peopleArray == nil;
}

// 获取 当下部门 的更新时间戳
- (void)getCompanyDeptUpDateTimeRequest
{
    ContactBookGetCompanyDeptUpDateTimeRequest * request = [[ContactBookGetCompanyDeptUpDateTimeRequest alloc] initWithDelegate:self];
    request.parentId = [UnifiedUserInfoManager share].companyShowID;
    [request requestData];
}
// 获取 当下部门成员 的更新时间戳
- (void)getCompanyUserUpDateTimeRequest
{
    ContactBookGetCompanyUserUpDateTimeRequest * request= [[ContactBookGetCompanyUserUpDateTimeRequest alloc] initWithDelegate:self];
    request.deptId = [UnifiedUserInfoManager share].companyShowID;
    [request requestData];
}

- (void)getDeptData
{
    NSArray * array = [[ContactBookMag share] getBranchDataWithParentId:[UnifiedUserInfoManager share].companyShowID];
    if (array.count) {
        self.departmentArray = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
        [self getCompanyDeptUpDateTimeRequest];
    }else {
        //[self getCompanyDeptUpDateTimeRequest];
        ContactBookGetDeptListRequest *request = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
        [request getCompanyDeptWithParentId:[UnifiedUserInfoManager share].companyShowID];
        [self.superViewController postLoading];
    }
}
- (void)getUserData
{
    NSArray * array = [[ContactBookMag share] getMemberWithDeptId:[UnifiedUserInfoManager share].companyShowID];
    if (array && array.count) {
        self.peopleArray = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
        [self getCompanyUserUpDateTimeRequest];
    }else {
        //[self getCompanyUserUpDateTimeRequest];
        //获取人员数据
        ContactBookGetUserListRequest *request = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
        [request getUserWithDepartID:[UnifiedUserInfoManager share].companyShowID];
        [self.superViewController postLoading];
    }
}




#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 12, 0, 0);
        [_tableView setSeparatorInset:insets];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:insets];
        }
        
        [_tableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
        [_tableView registerClass:[ContactBookDeptTableViewCell class] forCellReuseIdentifier:[ContactBookDeptTableViewCell identifier]];
        [_tableView registerClass:[ContactGroupTableViewCell class] forCellReuseIdentifier:[ContactGroupTableViewCell identifier]];
    }
    return _tableView;
}

@end

@interface ContactGroupTableViewCell ()

@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UILabel * titleLabel;

@end

@implementation ContactGroupTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self); }
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titleLabel];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.width.height.equalTo(@40);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.imgView.mas_right).offset(8);
        }];
    }
    return self;
}
- (void)setCellDataWithIsFriend:(BOOL)isFriend
{
    if (isFriend) {
        self.imgView.image = [UIImage imageNamed:@"friend_icon"];
        self.titleLabel.text = LOCAL(CONTACT_MYFRIEND);
    }else {
        self.imgView.image = [UIImage imageNamed:@"group_blue_avatar"];
        self.titleLabel.text = LOCAL(CONTACT_MYGROUP);
    }
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_blue_avatar"]];
        _imgView.layer.cornerRadius = 3;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.text = LOCAL(CONTACT_MYGROUP);
    }
    return _titleLabel;
}
@end
