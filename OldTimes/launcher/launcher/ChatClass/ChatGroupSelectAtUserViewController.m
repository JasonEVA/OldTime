//
//  ChatGroupSelectAtUserViewController.m
//  launcher
//
//  Created by williamzhang on 15/12/3.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatGroupSelectAtUserViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ContactBookNameTableViewCell.h"
#import "UnifiedUserInfoManager.h"
#import <MintcodeIM/MintcodeIM.h>
#import "BaseViewController.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "Category.h"


@interface ChatGroupSelectAtUserViewController : BaseViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchVC;

@property (nonatomic, strong) UITableView *tableView;

/** 群里所有人员 */
@property (nonatomic, strong  ) NSArray  *groupPeople;
@property (nonatomic, readonly) NSString *groupID;
@property (nonatomic, assign) BOOL fromCommentVC;
@property (nonatomic, strong) NSArray *searchedPeople;

@property (nonatomic, copy) void (^selectedBlock)(ContactPersonDetailInformationModel *);

- (instancetype)initWithGroupID:(NSString *)groupID;
- (instancetype)initWithCanSelectedMembers:(NSArray *)members;
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

- (void)selectedPeople:(void (^)(ContactPersonDetailInformationModel *))selectedBlock {
    self.selectVC.selectedBlock = selectedBlock;
}

- (instancetype)initWithCanSelectedMembers:(NSArray *)members {
	ChatGroupSelectAtUserViewController *rootVC = [[ChatGroupSelectAtUserViewController alloc] initWithCanSelectedMembers:members];
	self = [super initWithRootViewController:rootVC];
	if (self) {
		_selectVC = rootVC;
	}
	return self;
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

- (instancetype)initWithCanSelectedMembers:(NSArray *)members {
	if (self = [super init]) {
		_fromCommentVC = YES;
		_groupPeople = [members copy];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStyleBordered target:self action:@selector(clickToBack)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
	
    [self getGroupPeople];
    
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [self.view addSubview:self.tableView];
    self.searchVC.delegate = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)dismissVCWithPerson:(ContactPersonDetailInformationModel *)person {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    !self.selectedBlock ?: self.selectedBlock(person);
}

#pragma mark - Button Click
- (void)clickToBack {
    [self dismissVCWithPerson:nil];
}

- (void)clickToSelectAll {
    //按钮暴力点击防御
    [self.createHeaderView mtc_deterClickedRepeatedly];
    
    ContactPersonDetailInformationModel *allPeople = [ContactPersonDetailInformationModel new];
    allPeople.show_id = @"ALL";
    allPeople.u_true_name = LOCAL(CHAT_ATALL);
    [self dismissVCWithPerson:allPeople];
}

#pragma mark - Private Method
/** 获取人员 */
- (void)getGroupPeople
{
	if (self.fromCommentVC) {
		self.title = LOCAL(CONTACT_SELECT);
		[self getCommentGroupPeople];
	} else {
		self.title = LOCAL(CHAT_SELECTPERSON);
		[self getChatGroupPeople];
	}
}

- (void)getCommentGroupPeople {
	NSMutableArray *peopleTmp = [NSMutableArray array];
	
	NSLog(@"%@", self.groupPeople);
	[self.groupPeople enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull profileDic, NSUInteger idx, BOOL * _Nonnull stop) {
		[profileDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull userName, NSString * _Nonnull nickName, BOOL * _Nonnull stop) {
			if (![[[UnifiedUserInfoManager share] userShowID] isEqualToString: userName]) {
				
				UserProfileModel *model = [UserProfileModel new];
				model.userName = userName;
				model.nickName = nickName;
				[peopleTmp addObject:model];
			}
		}];
	}];
	
	UserProfileModel *model = [UserProfileModel new];
	model.userName = [[UnifiedUserInfoManager share] userShowID];
	model.nickName = [[UnifiedUserInfoManager share] userName];
	[peopleTmp addObject:model];
	
	self.groupPeople = [peopleTmp copy];
}

- (void)getChatGroupPeople {
	UserProfileModel *groupProfile = [[MessageManager share] queryContactProfileWithUid:self.groupID];
	NSMutableArray *peopleTmp = [NSMutableArray array];
	
	NSString *myselfShowId = [[UnifiedUserInfoManager share] userShowID];
	
	for (UserProfileModel *person in groupProfile.memberList) {
		if ([person.userName isEqualToString:myselfShowId]) {
			continue;
		}
		
		[peopleTmp addObject:person];
	}
	self.groupPeople = peopleTmp;
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableView == tableView) {
        return [self.groupPeople count];
    }
    
    return [self.searchedPeople count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ContactBookNameTableViewCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return self.fromCommentVC ? 0 : 45.0;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 0.01;}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section { return self.fromCommentVC ? nil : [self createHeaderView];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactBookNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookNameTableViewCell identifier]];
    
    UserProfileModel *person;
    
    if (tableView == self.tableView) {
        person = [self.groupPeople objectAtIndex:indexPath.row];
    } else {
        person = [self.searchedPeople objectAtIndex:indexPath.row];
    }
    
    ContactPersonDetailInformationModel *showModel = [ContactPersonDetailInformationModel new];
    showModel.show_id     = person.userName;
    showModel.u_true_name = person.nickName;
    
    [cell setDataWithModel:showModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserProfileModel *person;
    if (tableView == self.tableView) {
        person = [self.groupPeople objectAtIndex:indexPath.row];
    } else {
        person = [self.searchedPeople objectAtIndex:indexPath.row];
    }
    
    ContactPersonDetailInformationModel *model = [ContactPersonDetailInformationModel new];
    model.show_id     = person.userName;
    model.u_true_name = person.nickName;
    [self dismissVCWithPerson:model];
}

#pragma mark - UISearchDisplayController Delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
}

#pragma mark - UISearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *array = [NSMutableArray array];
    
    for (UserProfileModel *person in self.groupPeople) {
        NSRange range = [[person.nickName uppercaseString] rangeOfString:[searchText uppercaseString]];
        if (range.location == NSNotFound) {
            continue;
        }
        
        // 匹配
        [array addObject:person];
    }
    
    self.searchedPeople = array;
    [self.searchVC.searchResultsTableView reloadData];
}

- (UIButton *)createHeaderView {
    UIButton *headerView = [UIButton new];
    
    [headerView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headerView setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    [headerView setTitle:LOCAL(CHAT_ATALL) forState:UIControlStateNormal];
    [headerView setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [headerView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerView.titleLabel setFont:[UIFont mtc_font_30]];
    
    [headerView setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
    [headerView setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
    
    [headerView addTarget:self action:@selector(clickToSelectAll) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

#pragma mark - Initializer
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
        _searchBar.delegate = self;
        _searchBar.tintColor = [UIColor themeBlue];
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableHeaderView:self.searchBar];
        
        [_tableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
    }
    return _tableView;
}

- (UISearchDisplayController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchVC.searchResultsDataSource = self;
        _searchVC.searchResultsDelegate = self;
        
        [_searchVC.searchResultsTableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
    }
    return _searchVC;
}

@end
