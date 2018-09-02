//
//  ChatGroupSelectAtUserViewController.m
//  launcher
//
//  Created by williamzhang on 15/12/3.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatGroupSelectAtUserViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ContactInfoModel.h"
#import "CoordinationContactTableViewCell.h"
#import "ContactCellAdapter.h"
#import "ChatIMConfigure.h"
#import "HMBaseViewController.h"
#import "UIImage+EX.h"
@interface ChatGroupSelectAtUserViewController : HMBaseViewController <UISearchDisplayDelegate, ATTableViewAdapterDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)  ContactCellAdapter  *adapter; // <##>

/** 群里所有人员 */
@property (nonatomic, strong) NSMutableArray  *groupPeople;
@property (nonatomic, readonly) NSString *groupID;

@property (nonatomic, copy) void (^selectedBlock)(ContactInfoModel *);

- (instancetype)initWithGroupID:(NSString *)groupID;

@end

@interface ChatGroupSelectAtUserNavigationViewController ()

@property (nonatomic, strong) ChatGroupSelectAtUserViewController *selectVC;

@end

@implementation  ChatGroupSelectAtUserNavigationViewController

- (instancetype)initWithGroupID:(NSString *)groupID {
    ChatGroupSelectAtUserViewController *rootVC = [[ChatGroupSelectAtUserViewController alloc] initWithGroupID:groupID];
    self = [super initWithRootViewController:rootVC];
    if (self) {
        _selectVC = rootVC;
    }
    return self;
}

- (void)selectedPeople:(void (^)(ContactInfoModel *))selectedBlock {
    self.selectVC.selectedBlock = selectedBlock;
}

@end

@implementation ChatGroupSelectAtUserViewController

- (instancetype)initWithGroupID:(NSString *)groupID {
    self = [super init];
    if (self) {
        _groupID = groupID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择提醒的人";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToBack)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)dismissVCWithPerson:(ContactInfoModel *)person {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    !self.selectedBlock ?: self.selectedBlock(person);
}

#pragma mark - Button Click
- (void)clickToBack {
    [self dismissVCWithPerson:nil];
}

//按钮暴力点击防御
- (void)defenseClick {
    [self.createHeaderView setEnabled:YES];
}

- (void)clickToSelectAll {
    //按钮暴力点击防御
    [self.createHeaderView setEnabled:NO];
    [self performSelector:@selector(defenseClick) withObject:nil afterDelay:0.5];
    ContactInfoModel *allPeople = [ContactInfoModel new];
    allPeople.relationInfoModel.relationName = @"ALL";
    allPeople.relationInfoModel.nickName = @"全体成员";
    [self dismissVCWithPerson:allPeople];
}

#pragma mark - Private Method

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section { return [self createHeaderView];}

#pragma mark - Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    [self dismissVCWithPerson:(ContactInfoModel *)cellData];
}



- (UIButton *)createHeaderView {
    UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];
    
    [headerView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headerView setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    [headerView setTitle:@"全体成员" forState:UIControlStateNormal];
    [headerView setBackgroundImage:[UIImage at_imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [headerView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerView.titleLabel setFont:[UIFont font_30]];
    
    [headerView setTitleColor:[UIColor mainThemeColor] forState:UIControlStateHighlighted];
    
    [headerView addTarget:self action:@selector(clickToSelectAll) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

#pragma mark - Initializer
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
        _searchBar.delegate = self;
        _searchBar.tintColor = [UIColor mainThemeColor];
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 60;
        [_tableView setTableHeaderView:[self createHeaderView]];
        [_tableView registerClass:[CoordinationContactTableViewCell class] forCellReuseIdentifier:[CoordinationContactTableViewCell at_identifier]];
    }
    return _tableView;
}

- (ContactCellAdapter *)adapter {
    if (!_adapter) {
        _adapter = [ContactCellAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.selectable = NO;
        _adapter.adapterArray = self.groupPeople;
    }
    return _adapter;
}

/** 获取人员 */
- (NSMutableArray *)groupPeople
{
    if (!_groupPeople) {
        UserProfileModel *groupProfile = [[MessageManager share] queryContactProfileWithUid:self.groupID];
        _groupPeople = [NSMutableArray arrayWithCapacity:groupProfile.memberList.count];
//        ContactInfoModel *allPeople = [ContactInfoModel new];
//        allPeople.relationInfoModel.relationName = @"ALL";
//        allPeople.relationInfoModel.nickName = @"全体成员";
//        [_groupPeople addObject:allPeople];
        
        NSString *myselfShowId = [MessageManager getUserID];
        
        for (UserProfileModel *person in groupProfile.memberList) {
            if ([person.userName isEqualToString:myselfShowId]) {
                continue;
            }
            ContactInfoModel *model = [[ContactInfoModel alloc] initWithUserProfileModel:person];
            [_groupPeople addObject:model];
        }
    }
    return _groupPeople;
}

@end
