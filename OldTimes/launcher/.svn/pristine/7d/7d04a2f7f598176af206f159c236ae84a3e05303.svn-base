//
//  NewUserDetailViewController.m
//  launcher
//
//  Created by TabLiu on 16/3/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewUserDetailViewController.h"
#import "ContactBookViewController.h"
#import "ChatSingleViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MintcodeIM/MintcodeIM.h>
#import "IMNickNameManager.h"
#import <Masonry/Masonry.h>
#import "UIImage+Manager.h"
#import "UIColor+Hex.h"
#import "UIView+Util.h"
#import "AvatarUtil.h"
#import "MyDefine.h"

@interface NewUserDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UIAlertViewDelegate>
/**************** headerView  ******************/
@property (nonatomic, strong) UIView      *headerView;
@property (nonatomic, strong) UIView      *avatarBG;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property(nonatomic, strong) UIButton  *talkBtn;
/**************** headerView  ******************/

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MessageRelationInfoModel *relationModel;
@property (nonatomic, readonly) NSString *userShowId;

@end

@implementation NewUserDetailViewController

- (instancetype)initWithUserModel:(MessageRelationInfoModel *)model {
    self = [super init];
    if (self) {
        _userShowId    = model.relationName;
        _relationModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    avatarRemoveCache(self.userShowId);
    [[MessageManager share] searchRelationUserWithRelationValue:self.userShowId completion:^(NSArray *array, BOOL success) {
        if (success && array.count)
        {
            MessageRelationInfoModel *model = [array firstObject];
            self.relationModel = model;
            
            self.nameLabel.text = self.relationModel.relation ? self.relationModel.remark : self.relationModel.nickName;
            
            if (self.relationModel.relation)
            {
                UIButton *setButton = [UIButton new];
                [setButton setImage:[UIImage imageNamed:@"friend_more"] forState:UIControlStateNormal];
                [setButton addTarget:self action:@selector(setBtnclick) forControlEvents:UIControlEventTouchUpInside];
                [self.headerView addSubview:setButton];
                [setButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.headerView);
                    make.top.equalTo(self.headerView).offset(30);
                    make.width.equalTo(@43);
                    make.height.equalTo(@29);
                }];

                UIButton *button = [UIButton new];
                button.expandSize = CGSizeMake(30, 10);
                button.layer.borderColor =  [UIColor whiteColor].CGColor;
                button.layer.borderWidth = 0.5;
                button.layer.cornerRadius = 5;
                button.clipsToBounds = YES;
                
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                
                [button setImage:[UIImage imageNamed:@"contactBook_chat"] forState:UIControlStateNormal];
                [button setTitle:LOCAL(CONTACTBOOK_CHAT) forState:UIControlStateNormal];
                
                [button setImage:[UIImage imageNamed:@"contactBook_chat_select"] forState:UIControlStateHighlighted];
                [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
                
                [button addTarget:self action:@selector(clickToChat) forControlEvents:UIControlEventTouchUpInside];
                self.talkBtn = button;
                [self.headerView addSubview:button];
                
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.nameLabel);
                    make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
                }];
            }
            
            [self.avatarView sd_setImageWithURL:avatarIMURL(avatarType_150, self.relationModel.relationAvatar) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"]];
            [self.tableView reloadData];
        }
    }];
    
    [self initComponents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //    self.avatarBG.layer.cornerRadius = CGRectGetWidth(self.avatarBG.frame) / 2;
    //    self.avatarView.layer.cornerRadius = CGRectGetWidth(self.avatarView.frame) / 2;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initComponents {
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@230);
    }];
    
    UIButton *backButton = [UIButton new];
    [backButton setImage:[UIImage imageNamed:@"userInfo_backArrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView);
        make.top.equalTo(self.headerView).offset(30);
        make.width.equalTo(@43);
        make.height.equalTo(@29);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

#pragma mark - UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *text = [alertView textFieldAtIndex:0].text;
    
    if ([text length] == 0) {
        return;
    }
    
    [[MessageManager share] remarkRelationWithUid:self.userShowId remark:text completion:^(BOOL success) {
        if (!success) {
            return;
        }
        
        self.relationModel.remark = text;
        [[MessageManager share] insertRelationInfoWithArray:@[self.relationModel]];
        [IMNickNameManager setNickName:text forUserId:self.userShowId];
        self.nameLabel.text = text;
    }];}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //设置备注
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:LOCAL(MISSION_REMARK) message:nil delegate:self cancelButtonTitle:LOCAL(FINISH) otherButtonTitles: nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * textField = [alertView textFieldAtIndex:0];
        textField.placeholder = LOCAL(FRIEND_REMARK_PLEASE);
        textField.text = self.relationModel.remark;
        alertView.delegate = self;
        [alertView show];
    }else if (buttonIndex == 1){ // 删除好友

        [[MessageManager share] deleteRelationWithUid:self.relationModel.relationName completion:^(BOOL isSuccess){
            if (isSuccess)
            {
                [[MessageManager share] removeSessionUid:self.relationModel.relationName completion:^(BOOL isSuccess) {
                    if (!isSuccess)
                    {
                        [self postError:LOCAL(ERROROTHER)];
                    }else
                    {
                        //删除本地数据里的好友数据
                        [[MessageManager share] deleteRelationInfoWithRelationName:self.relationModel.relationName];
                        
                        [self.navigationController setNavigationBarHidden:NO animated:NO];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }
        }];
    }
}
#pragma mark - Button Click
- (void)setBtnclick
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:LOCAL(FRIEND_ADDREMARK) otherButtonTitles:LOCAL(FRIEND_REMOVE), nil];
    [actionSheet showInView:self.view];
}

- (void)clickToBack {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)clickToChat {
    
    UIViewController *naviRootVC = [self.navigationController viewControllers].firstObject;
    
    // 从联系人VC中push出来
    if ([naviRootVC isKindOfClass:[ContactBookViewController class]]) {
        [self sendNotify];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    else {
        for (UIViewController *viewController in [self.navigationController viewControllers]) {
            if (![viewController isKindOfClass:[ChatSingleViewController class]]) {
                continue;
            }
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            [self.navigationController popToViewController:viewController animated:NO];
            return;
        }
        
        // 从chatGroupVC中出来
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self sendNotify];
    }
}



#pragma mark - Private Method
- (NSArray *)titleArray {
#if defined(JAPANMODE) || defined(JAPANTESTMODE)
    NSString *launchrId = @"Launchr ID";
#else
    NSString *launchrId = @"WorkHub ID";
#endif
    
    return @[
             @[launchrId, LOCAL(ME_NAME), LOCAL(CONTACTBOOK_PHONENUM)]
             ];
}

- (void)sendNotify {
    NSDictionary *dictContact = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.relationModel.relationName, personDetail_show_id,
                                 self.relationModel.remark, personDetail_u_true_name,
                                 self.relationModel.relationAvatar, personDetail_headPic,
                                 nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTWillShowSingleChatNotification object:nil userInfo:dictContact];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self titleArray][section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell textLabel].font = [UIFont systemFontOfSize:15];
        [cell textLabel].textColor = [UIColor mtc_colorWithHex:0x000000];
        [cell detailTextLabel].font = [UIFont systemFontOfSize:15];
        [cell detailTextLabel].textColor = [UIColor mtc_colorWithHex:0x666666];
    }
    
    [cell textLabel].text = [[self titleArray][indexPath.section] objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    
    NSString *detailText = @"";
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) detailText = self.relationModel.imNumber;
        else if (indexPath.row == 1) detailText = self.relationModel.nickName;
        else if (indexPath.row == 1) detailText = self.relationModel.mobile;
    }
    
    [cell detailTextLabel].text = detailText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        if (row == 2) {
            if (![self.relationModel.mobile length]) {
                return;
            }
            // 打电话
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.relationModel.mobile]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

#pragma mark - Initializer
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor themeBlue];
        
        [_headerView addSubview:self.avatarBG];
        [self.avatarBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView);
            make.width.height.equalTo(@100);
            make.top.equalTo(_headerView).offset(30);
        }];
        
        [_headerView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView);
            make.top.equalTo(self.avatarBG.mas_bottom).offset(5);
        }];
        
        }
    return _headerView;
}

- (UIView *)avatarBG {
    if (!_avatarBG) {
        _avatarBG = [UIView new];
        _avatarBG.backgroundColor = [UIColor whiteColor];
        _avatarBG.layer.cornerRadius = 50;
        _avatarBG.clipsToBounds = YES;
        
        [_avatarBG addSubview:self.avatarView];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_avatarBG);
            make.width.height.equalTo(_avatarBG).offset(-5);
        }];
    }
    return _avatarBG;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.layer.cornerRadius = 47;
        _avatarView.clipsToBounds = YES;
        [_avatarView sd_setImageWithURL:avatarURL(avatarType_150, self.userShowId) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = self.relationModel.remark;
    }
    return _nameLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
