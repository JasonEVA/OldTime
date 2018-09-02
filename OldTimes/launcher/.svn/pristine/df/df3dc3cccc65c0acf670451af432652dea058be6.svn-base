//
//  ContactBookDetailViewController.m
//  launcher
//
//  Created by williamzhang on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactBookDetailViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ContactBookViewController.h"
#import "ChatSingleViewController.h"
#import "ContactGetUserInformationRequest.h"
#import "RelationCheckCollectionReuqest.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IMNickNameManager.h"
#import <Masonry/Masonry.h>
#import "UIImage+Manager.h"
#import "UIColor+Hex.h"
#import "UIView+Util.h"
#import "AvatarUtil.h"
#import "MyDefine.h"

@interface ContactBookDetailViewController () <UITableViewDataSource, UITableViewDelegate, BaseRequestDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
/**************** headerView  ******************/
@property (nonatomic, strong) UIView      *headerView;
@property (nonatomic, strong) UIView      *avatarBG;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel     *nameLabel;
/**************** headerView  ******************/

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ContactPersonDetailInformationModel *userModel;
@property (nonatomic, readonly) NSString *userShowId;

@property (nonatomic, copy) void (^notifyStartChatBlock)();
@property (nonatomic, copy) backBlock myblock;
//右上角的更多
@property(nonatomic, strong) UIButton  *moreBtn;

@property (nonatomic, strong) MessageRelationInfoModel *relationModel;

@end

@implementation ContactBookDetailViewController

- (instancetype)initWithUserShowId:(NSString *)showId {
    self = [super init];
    if (self) {
        _userShowId = showId;
    }
    return self;
}

- (instancetype)initWithUserModel:(ContactPersonDetailInformationModel *)model {
    self = [super init];
    if (self) {
        _userModel = model;
        _userShowId = model.show_id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.relationModel = [[MessageManager share] queryRelationInfoWithUserID:self.userShowId];
    
    if (!self.relationModel) {
        RelationCheckCollectionReuqest *request = [[RelationCheckCollectionReuqest alloc] initWithDelegate:self];
        [request checkCollectionWithRelationName:self.userShowId];
    }
    
    avatarRemoveCache(self.userShowId);
    
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
    
    if (self.relationModel) {
        self.nameLabel.text = self.relationModel.remark;
    }
}

- (void)setbackblock:(backBlock)block
{
    if (block)
    {
        self.myblock = block;
    }
}

#pragma mark - uiactionSheetdelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //设置备注
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:LOCAL(MISSION_REMARK) message:nil delegate:self cancelButtonTitle:LOCAL(FINISH) otherButtonTitles:nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * textField = [alertView textFieldAtIndex:0];
        textField.placeholder = LOCAL(FRIEND_REMARK_PLEASE);
        textField.text = self.nameLabel.text;
        alertView.delegate = self;
        [alertView show];
    }else if (buttonIndex == 1){ // 删除好友
        
        [[MessageManager share] deleteRelationWithUid:self.relationModel.relationName
                                           completion:^(BOOL isSuccess)
        {
            if (!isSuccess) {
                [self postError:LOCAL(ERROROTHER)];
                return;
            }

            [[MessageManager share] removeSessionUid:self.userModel.show_id completion:^(BOOL isSuccess) {
                //删除本地数据里的好友数据
                [[MessageManager share] deleteRelationInfoWithRelationName:self.userModel.show_id];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
        NSString *text = [alertView textFieldAtIndex:0].text;
        if ([text length] == 0) {
            return;
        }
        
        [[MessageManager share] remarkRelationWithUid:self.userShowId remark:text completion:^(BOOL success){
            if (!success) {
                return;
            }
            
            self.relationModel.remark = text;
            [[MessageManager share] insertRelationInfoWithArray:@[self.relationModel]];
            [IMNickNameManager setNickName:text forUserId:self.userShowId];
            self.nameLabel.text = text;
        }];

}

#pragma mark - Interface Method
- (void)notifyStartChat:(void (^)())startChatBlock {
    _notifyStartChatBlock = startChatBlock;
}

#pragma mark - Button Click
- (void)clickToBack {
    if (self.myblock)
    {
        self.myblock();
    }
    if (_getStrName) {
        _getStrName(self.nameLabel.text);
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)clickToChat {
    if (self.notifyStartChatBlock) {
        self.notifyStartChatBlock();
    }
    
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

- (void)moreAction
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:LOCAL(FRIEND_ADDREMARK) otherButtonTitles:LOCAL(FRIEND_REMOVE), nil];
    [actionSheet showInView:self.view];
}


- (void)showDetailAction
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:80 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.backgroundColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.toValue =  (__bridge id _Nullable)([UIBezierPath bezierPathWithArcCenter:self.view.center radius:300 startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath);
    pathAnimation.duration = 0.25;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    [shape addAnimation:pathAnimation forKey:@"path"];
    
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:self.avatarView.image];
    [contentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    
    imageview.layer.mask = shape;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction:)];
    contentView.userInteractionEnabled = YES;
    [contentView addGestureRecognizer:tap];

}

- (void)dismissAction:(UIGestureRecognizer *)gesture
{
    UIView *currentImageView = gesture.view;
    [currentImageView removeFromSuperview];
}
#pragma mark - Private Method
- (NSArray *)titleArray {
#if defined(JAPANMODE) || defined(JAPANTESTMODE)
    NSString *launchrId = @"WorkHub ID";
#else
    NSString *launchrId = @"Launchr ID";
#endif
    if (self.relationModel) {
        return @[@[launchrId, LOCAL(ME_NAME), LOCAL(CONTACTBOOK_PHONENUM)]];
    }
    
    return @[
             @[launchrId, LOCAL(CONTACTBOOK_PHONENUM), LOCAL(CONTACTBOOK_EMAIL), LOCAL(CONTACTBOOK_BUSINESSPHONENUM), LOCAL(CONTACTBOOK_DEPART), LOCAL(CONTACTBOOK_JOB)],
             @[LOCAL(CONTACTBOOK_QRCODE), LOCAL(CONTACTBOOK_SHARE)]
             ];
    
}

- (void)sendNotify {
    NSDictionary *dictContact;
    if (!self.relationModel) {
        dictContact = [NSDictionary dictionaryWithObjectsAndKeys:
                       self.userShowId, personDetail_show_id,
                       self.userModel.u_true_name, personDetail_u_true_name,
                       self.userModel.headPic, personDetail_headPic,
                       nil];
    }
    else {
        dictContact = @{
                        personDetail_show_id:self.relationModel.relationName,
                        personDetail_u_true_name:self.relationModel.remark,
                        personDetail_headPic:self.relationModel.relationAvatar
                        };
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTWillShowSingleChatNotification object:nil userInfo:dictContact];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    
    if ([request isKindOfClass:[RelationCheckCollectionReuqest class]]) {
        if ([(id)response isColleague]) {
            ContactGetUserInformationRequest *getInfoRequest = [[ContactGetUserInformationRequest alloc] initWithDelegate:self];
            [getInfoRequest userShowID:self.userShowId];
        }
        else
        {
            [[MessageManager share] searchRelationUserWithRelationValue:self.userShowId completion:^(NSArray *array, BOOL success) {
                if (success && array.count)
                {
                    MessageRelationInfoModel *model = [array firstObject];
                    self.relationModel = model;
//                    [self.avatarView sd_setImageWithURL:avatarIMURL(avatarType_150, self.relationModel.relationAvatar) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"]];
                    [self.avatarView sd_setImageWithURL:avatarURL(avatarType_150, self.userShowId)];
                    if (self.relationModel.relation) {
                        [self.moreBtn class];
                    }
                    self.nameLabel.text = self.relationModel.relation ? self.relationModel.remark : self.relationModel.nickName;
                    
                    [self.tableView reloadData];
                }
            }];
        }
    }
    
    else if ([request isKindOfClass:[ContactGetUserInformationRequest class]]) {
        self.userModel = [(id)response personModel];
        self.nameLabel.text = self.userModel.u_true_name;
        [self.avatarView sd_setImageWithURL:avatarURL(avatarType_150, self.userShowId)];
        
        [self.tableView reloadData];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
    if ([request isKindOfClass:[RelationCheckCollectionReuqest class]]) {
        ContactGetUserInformationRequest *getInfoRequest = [[ContactGetUserInformationRequest alloc] initWithDelegate:self];
        [getInfoRequest userShowID:self.userShowId];
    }
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0)      detailText = [NSString stringWithFormat:@"%ld", self.userModel.launchrId];
        else if (indexPath.row == 1) detailText = self.userModel.u_mobile;
        else if (indexPath.row == 2) detailText = self.userModel.u_mail;
        else if (indexPath.row == 3) detailText = self.userModel.u_telephone;
        else if (indexPath.row == 4) detailText = self.userModel.d_name_forShow;
        else if (indexPath.row == 5) detailText = self.userModel.u_job;
        
        
        if (self.relationModel) {
            if (indexPath.row == 0)      detailText = self.relationModel.imNumber;
            else if (indexPath.row == 1) detailText = self.relationModel.nickName;
            else if (indexPath.row == 2) detailText = self.userModel.u_mobile;
        }
    }

    [cell detailTextLabel].text = detailText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        if (row == 1) {

            if (self.relationModel) {
                return;
            }
            
            if (![self.userModel.u_mobile length]) {
                return;
            }
            // 打电话
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.userModel.u_mobile]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
        else if (row == 2) {
            if (!self.relationModel) {
                return;
            }
            
            if (![self.relationModel.mobile length]) {
                return;
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.relationModel.mobile]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
        else if (row == 3) {
            if (![self.userModel.u_telephone length]) {
                return;
            }
            // 部门电话
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.userModel.u_telephone]];
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
            make.top.equalTo(self.avatarBG.mas_bottom).offset(15);
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
        
        [_headerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.nameLabel);
            make.bottom.equalTo(_headerView).offset(-20);
        }];
        
        if (self.relationModel)
        {
            self.moreBtn;
        }
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

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton new];
        [_moreBtn setImage:[UIImage imageNamed:@"friend_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:_moreBtn];
        
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView);
            make.top.equalTo(_headerView).offset(30);
            make.width.equalTo(@43);
            make.height.equalTo(@29);
        }];
    }
    return _moreBtn;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.layer.cornerRadius = 47;
        _avatarView.clipsToBounds = YES;
		avatarRemoveCache(self.userShowId);
        [_avatarView sd_setImageWithURL:avatarURL(avatarType_150, self.userShowId) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:0];
        _avatarView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailAction)];
        [_avatarView addGestureRecognizer:tap];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = self.userModel.u_true_name;
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
