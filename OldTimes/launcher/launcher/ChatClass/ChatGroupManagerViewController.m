//
//  ChatGroupManagerViewController.m
//  launcher
//
//  Created by Andrew Shen on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatGroupManagerViewController.h"
#import <Masonry.h>
#import "ChatGroutAvatarsTableViewCell.h"
#import "BaseInputTableViewCell.h"
#import "UIImage+Manager.h"
#import "SelectContactBookViewController.h"
#import <MintcodeIM/MintcodeIM.h>
#import "UnifiedUserInfoManager.h"
#import "ContactBookDetailViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CalendarSwitchTableViewCell.h"
#import "ContactPersonDetailInformationModel.h"
#import "Category.h"

static CGFloat const headerHeight = 15; // 区头高度
@interface ChatGroupManagerViewController ()<UITableViewDataSource,UITableViewDelegate,InputCellDelegate,ChatGroutAvatarsTableViewCellDelegate,UIActionSheetDelegate,MessageManagerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;// <##>
@property (nonatomic, copy  ) NSArray                     *arrayTitles;// 标题集合
@property (nonatomic, strong) UITextField                 *txfdName;// 群聊名称
@property (nonatomic, strong) UserProfileModel            *groupProfile;// <##>
@property (nonatomic, strong) UserProfileModel            *deleteModel;// 删除的成员model
@property (nonatomic, strong) ContactDetailModel          *contactModel;
@property (nonatomic)  BOOL  isHost; // 是否是群管理员
@end

@implementation ChatGroupManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = LOCAL(CHAT_SET);

    [[MessageManager share] getUserInfoWithUid:self.groupID];
    [[MessageManager share] querySessionDataWithUid:self.groupID completion:^(ContactDetailModel *contactModel) {
        self.contactModel = contactModel;
        [self.tableView reloadData];
    }];
    // 从数据库取出群信息
    [self getGroupProfileData];
    
    [self initCompnents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[MessageManager share] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[MessageManager share] setDelegate:nil];
}

- (void)initCompnents {
    NSArray *firstSection = @[@""];
    NSArray *secondSection = @[LOCAL(GROUPDATA_NAME)];
    NSArray *thirdSection = @[LOCAL(CHAT_DONT_DISTURB)]; //,LOCAL(DELETE_MESSAGE)];
    self.arrayTitles = @[firstSection,secondSection,thirdSection];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

// 从数据库取出群信息
- (void)getGroupProfileData {
    self.groupProfile = [[MessageManager share] queryContactProfileWithUid:self.groupID];
    if (self.groupProfile.memberList.count > 0) {
        UserProfileModel *model = self.groupProfile.memberList[0];
        self.isHost = [model.userName isEqualToString:[[UnifiedUserInfoManager share] userShowID]];
    }
}
// 编辑按钮点击
- (void)addPeopleClick {
    NSLog(@"------------------->%@",NSStringFromSelector(_cmd));
    
    NSMutableArray *arrNickName = [NSMutableArray arrayWithCapacity:self.groupProfile.memberList.count];
    for (UserProfileModel *profileModel in self.groupProfile.memberList)
    {
        ContactPersonDetailInformationModel *person = [ContactPersonDetailInformationModel new];
        person.show_id = profileModel.userName;
        person.u_true_name = profileModel.nickName;
        [arrNickName addObject:person];
    }
    SelectContactBookViewController *createGroupVC = [[SelectContactBookViewController alloc] initWithSelectedPeople:nil unableSelectPeople:arrNickName];
    createGroupVC.selectType = selectContact_addPeople;
    createGroupVC.groupID = self.groupID;
    [self presentViewController:createGroupVC animated:YES completion:nil];
}

- (void)deletePeopleUid:(NSString *)uid {
    NSLog(@"------------------->%@",NSStringFromSelector(_cmd));

    [[MessageManager share] groupSessionUid:self.groupID deleteMemberId:uid completion:^(BOOL isSuccess) {
        [self hideLoading];
        
        if (!isSuccess) {
            return;
        }
        
        if ([uid isEqualToString:[[UnifiedUserInfoManager share] userShowID]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        
        [self.groupProfile.memberList removeObject:self.deleteModel];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self postLoading];
}

// 修改群名
- (void)updateGroupName:(NSString *)newName {
    NSLog(@"------------------->%@",NSStringFromSelector(_cmd));
    [[MessageManager share] groupSessionUid:self.groupID changeName:newName];
	[[MessageManager share] getUserInfoWithUid:self.groupID];	
}

// 清空消息记录
- (void)clearMessageHistory {
    NSLog(@"------------------->%@",NSStringFromSelector(_cmd));
    // 清空聊天记录
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(DELETE_MESSAGE), nil];
    [actionSheet showInView:self.view];
}

// 删除并退出
- (void)deleteAndQuit {
    NSLog(@"------------------->%@",NSStringFromSelector(_cmd));
    NSString *myUid = [[UnifiedUserInfoManager share] userShowID];
    [self deletePeopleUid:myUid];
}

- (UIView *)deleteBtn {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85)];
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(13, 25, view.frame.size.width - 26, view.frame.size.height - 40)];
    [delete setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeRed]] forState:UIControlStateNormal];
    [delete setTintColor:[UIColor whiteColor]];
    [delete setTitle:LOCAL(QUIT_DELETE) forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteAndQuit) forControlEvents:UIControlEventTouchUpInside];
    [delete.layer setCornerRadius:3.0];
    [delete.layer setMasksToBounds:YES];
    [view addSubview:delete];
    
    return view;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = self.arrayTitles[section];
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSInteger count = (IOS_SCREEN_WIDTH - 26 + interitemSpacing) / (collectionCellWidth + interitemSpacing);
        CGFloat height = ((self.groupProfile.memberList.count + (self.isHost ? 2 : 1) - 1) / count) * (collectionCellheight + lineSpacing) + collectionCellheight + 36;
        return height;
    }
    
//    if (indexPath.section == 2 && indexPath.row == 0) {
//        return 0;
//    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    static NSString *name       = @"name";
    static NSString *avatars    = @"avatars";
    if (indexPath.section == 0) {
        ChatGroutAvatarsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:avatars];
        if (!cell) {
            cell = [[ChatGroutAvatarsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:avatars];
            [cell setDelegate:self];
        }
        [cell setPersonData:self.groupProfile.memberList isHost:self.isHost];
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        BaseInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name];
        if (!cell) {
            cell = [[BaseInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
            [cell setDelegate:self];
            [cell.txtFd setTextAlignment:NSTextAlignmentRight];
            [cell.txtFd setTextColor:[UIColor darkGrayColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textLabel.font = [UIFont mtc_font_30];
        }
        
        cell.indexPath = indexPath;
        [cell.textLabel setText:self.arrayTitles[indexPath.section][indexPath.row]];
        
        //群聊名称
        [cell.txtFd setText:self.groupProfile.nickName];
        return cell;
        
    }
    
    else if (indexPath.section == 2 && indexPath.row == 0) {
        CalendarSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CalendarSwitchTableViewCell identifier]];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont mtc_font_30];
        cell.textLabel.text = self.arrayTitles[indexPath.section][indexPath.row];
        cell.switchColor = [UIColor themeRed];
        [cell isOn:self.contactModel._muteNotification != kUserProfileReceiveNormal];
        
        [cell calendarSwitchDidChange:^(CalendarSwitchType swithType, BOOL isOn) {
            [self postLoading];
            // 免打扰
            
            userProfileReceiveMode receiveMode = isOn ? kUserProfileReceiveAccept : kUserProfileReceiveNormal;
            
            [[MessageManager share] groupSessionUid:self.groupID receiveMode:receiveMode completion:^(BOOL success) {
                [self hideLoading];
                
                if (success) {
                    return;
                }
                
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
        
        return cell;
    }
    
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont mtc_font_30];
        }
        [cell.textLabel setText:self.arrayTitles[indexPath.section][indexPath.row]];
        
        if (indexPath.row == 0) {
            
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 2)
    {
        if (indexPath.row == 1)
        {
            [self clearMessageHistory];
        }
    }
    
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}

#pragma mark - InputCell Deletate
- (void)InputCellDelegateCallBack_endEditWithIndexPath:(NSIndexPath *)indexPath {
    // 输入完毕 修改群名
    BaseInputTableViewCell *cell = (BaseInputTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *newName  = cell.txtFd.text;
    // 判断是否更改
	BOOL didChangedName = ![newName isEqualToString:self.groupProfile.nickName];
    if (didChangedName)
    {
        [self updateGroupName:newName];
    }
	
	if ([self.delegate respondsToSelector:@selector(chatGroupManagerViewControllerDidChangedGroupName:NewGroupName:OldGroupName:)]) {
		[self.delegate chatGroupManagerViewControllerDidChangedGroupName:didChangedName NewGroupName:newName OldGroupName:self.groupProfile.nickName];		
	}
}

#pragma mark - avatarCell Delegate
- (void)ChatGroutAvatarsTableViewCellDelegateCallBack_addPeople
{
    [self addPeopleClick];
}

- (void)ChatGroutAvatarsTableViewCellDelegateCallBack_deletePeopleWithProfile:(UserProfileModel *)model
{
    self.deleteModel = model;
    [self deletePeopleUid:model.userName];
}

- (void)ChatGroutAvatarsTableViewCellDelegateCallBack_personDetailClicked:(UserProfileModel *)model
{
    // 查看个人信息
    ContactBookDetailViewController *detailVC = [[ContactBookDetailViewController alloc] initWithUserShowId:model.userName];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - ConctactProfileChange Delegate
- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile {
    // 从数据库取出群信息
    [self getGroupProfileData];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Init
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setTableFooterView:[self deleteBtn]];
        
        [_tableView registerClass:[CalendarSwitchTableViewCell class] forCellReuseIdentifier:[CalendarSwitchTableViewCell identifier]];
    }
    return _tableView;
}

- (UITextField *)txfdName {
    if (!_txfdName) {
        _txfdName = [[UITextField alloc] init];
    }
    return _txfdName;
}

@end
