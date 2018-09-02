//
//  MeSettingViewController.m
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeSettingViewController.h"
#import "Category.h"
#import "Masonry.h"
#import "MeLanguageViewController.h"
#import "MeNotificationViewController.h"
#import "MeDeviceManageViewController.h"
#import "MeSuggestViewController.h"
#import "AppDelegate.h"
#import "MeDeleteUserAccountRequest.h"
#import "UnifiedUserInfoManager.h"
#import <MintcodeIM/MintcodeIM.h>
#import "MixpanelMananger.h"
#import "WebViewController.h"
#import "AboutUsViewController.h"
#import "MeInputHabitViewController.h"
#import "MeAlertSetViewController.h"
#import "SystemSoundList.h"

static NSString *ID = @"Me_SettingCell";


typedef NS_ENUM(NSInteger, ALERTVIEWTAG)
{
    kDeleteCountTag = 1000,  // 删除账号
    kCleanCacheTag,          // 清空缓存
    kLoginOutTag             // 退出登录
};

typedef NS_ENUM(NSInteger, NUMOFSECTION)
{
    kFirstSection = 0,  //第一个section
    kSecondSection,     //第二个section
    kThirdSection       //第三个section
};

typedef NS_ENUM(NSInteger, CURRENTROW)
{
    klanguage = 0,      // 语言
    kInputHabit,        // 输入法习惯
    kNotification,      // 消息通知
    kDeviceManager,     // 设备管理
    kCleanCache,        // 清理缓存
    kGetRequest,        // 意见反馈
    kHelpCenter = 10,   // 帮助中心
    kAboutLaunchr,      // 关于
    kDeleteCount = 20,  // 删除账号
};

@interface MeSettingViewController ()<UITableViewDataSource, UITableViewDelegate,BaseRequestDelegate>

@property(nonatomic, strong)UITableView *tableView;
//红色退出按钮
@property(nonatomic, strong)UIButton *quitButton;
//容器view
@property(nonatomic, strong) UIView *contentView;
//当前语言
@property(nonatomic, copy) NSString *currentLanguage;
//选择打开的通知
@property(nonatomic, strong) NSMutableArray *selectedNotification;

@end

@implementation MeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_SET);
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //防止从语言页返回title颜色没变回来
    UIColor * color = [UIColor themeBlue];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Privite Methods
// 退出当前账号
- (void)signOut
{
    //按钮暴力点击防御
    [self.quitButton mtc_deterClickedRepeatedly];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:LOCAL(CERTAIN_SIGNOUT) delegate:self cancelButtonTitle:LOCAL(SETNO) otherButtonTitles:LOCAL(SETYES), nil];
    alertView.tag = kLoginOutTag;
    [alertView show];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kFirstSection:
            return 3;
//            return 5;
        case kSecondSection:
            return 2;
//        case kThirdSection:
//            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.textLabel.font = [UIFont mtc_font_30];
        cell.detailTextLabel.font = [UIFont mtc_font_30];
        cell.detailTextLabel.textColor = [UIColor minorFontColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSInteger currentIdnx = indexPath.section * 10 + indexPath.row;
    switch (currentIdnx) {
        case klanguage:
        {
            cell.textLabel.text = LOCAL(ME_LANGUAGE);
            NSString *textLabelString = LOCAL(LANGUAGE_SYSTEM);
            switch ([[UnifiedUserInfoManager share] getLanguageUserSetting]) {
                case language_chinese:
                    textLabelString = LOCAL(LANGUAGE_SPCHINESE);
                    break;
                case language_japanese:
                    textLabelString = LOCAL(LANGUAGE_JAPANESE);
                    break;
                case language_english:
                    textLabelString = LOCAL(LANGUAGE_ENGLISH);
                    break;
                default:
                    break;
            }
            cell.detailTextLabel.text = textLabelString;
        }
            break;
        case kInputHabit:
            cell.textLabel.text = LOCAL(CHAT_INPUTHABIT_SETTING);
            break;
        case kNotification:
            cell.textLabel.text = LOCAL(NEWMESSAGEATTENTION);
            
            PlaySystemKind  type = (PlaySystemKind)[[UnifiedUserInfoManager share] getPlaySystemKindType];
            switch (type) {
                case system_soundOnly:
                    cell.detailTextLabel.text = @"仅声音";
                    break;
                   
                case system_shakeOnly:
                    cell.detailTextLabel.text = @"仅震动";
                    break;

                case system_soundAndShake:
                    cell.detailTextLabel.text = LOCAL(OPENNOTIFY);
                    break;

                case system_silence:
                    cell.detailTextLabel.text = LOCAL(CLOSENOTIFY);
                    break;

                default:
                    break;
            }
            
            
            //cell.textLabel.text = LOCAL(ME_MESSAGE_NOTIFICATION);
            break;
        case kDeviceManager:
            cell.textLabel.text = LOCAL(ME_DEVISE_MANAGE);
            break;
        case kCleanCache:
            cell.textLabel.text = LOCAL(ME_CLEAN_ALL);
            break;
        case kGetRequest:
            cell.textLabel.text = LOCAL(ME_SUGGEST_BACK);
            break;
        case kHelpCenter:
            cell.textLabel.text = LOCAL(ME_HELP);
            break;
        case kAboutLaunchr:
            cell.textLabel.text = LOCAL(ME_ABOUT_P);
#if (!defined(JAPANMODE) && !defined(JAPANTESTMODE) )
            if ([LOCAL(ME_ABOUT_P) isEqualToString:@"关于WorkHub"]) {
                cell.textLabel.text = @"关于Launchr";
            }
#endif
            break;
        case kDeleteCount:
            cell.textLabel.text = LOCAL(ME_DELETE_ACCOUNT);
            break;
        default:
            break;
            
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger currentIndex = indexPath.section * 10 + indexPath.row;
    
    id disPlayViewController = nil;
    
    switch (currentIndex)
    {
        case klanguage:
        {
            disPlayViewController = [[MeLanguageViewController alloc] init];
            break;
        }
        case kNotification:
        {
//            disPlayViewController = [[MeNotificationViewController alloc] init];
//            [disPlayViewController getSelectedIndexWithBlock:^(NSMutableArray *selectNums) {
//                self.selectedNotification = selectNums;
//            }];
//            [disPlayViewController setIndexArr:self.selectedNotification];
            
            disPlayViewController = [[MeAlertSetViewController alloc] init];
            
            [disPlayViewController changeAlertType:^{
                [tableView reloadData];
            }];
            
            break;
        }
        case kDeviceManager:
        {
            disPlayViewController = [[MeDeviceManageViewController alloc] init];
            [disPlayViewController quiteActionsWithBlock:^{
                NSLog(@"退出来吧！！");
            }];
            break;
        }
        case kCleanCache:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCAL(ME_CONFIRM_CLEAN_ALL) message:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) otherButtonTitles:LOCAL(CERTAIN), nil];
            alert.tag = kCleanCacheTag;
            [alert show];
            break;
        }
        case kGetRequest:
        {
            disPlayViewController = [[MeSuggestViewController alloc] init];
            break;
        }
        case kDeleteCount:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCAL(ME_WARN_OPERATION) message:LOCAL(ME_CONFIRM_DELETE) delegate:self cancelButtonTitle:LOCAL(CANCEL) otherButtonTitles:LOCAL(CERTAIN), nil];
            alert.tag = kDeleteCountTag;
            [alert show];
            break;
        }
        case kHelpCenter: {
            disPlayViewController = [[WebViewController alloc] initWithURL:@"https://workhub.zendesk.com"];
        }
            break;
        case kAboutLaunchr: {
            disPlayViewController = [[AboutUsViewController alloc] init];
        }
            break;
        case kInputHabit:
            disPlayViewController = [MeInputHabitViewController new];
            break;
        default:
            break;
    }
    
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kThirdSection )
    {
        self.quitButton.frame = CGRectMake(20, 35, self.view.frame.size.width - 40, 40);
        [self.contentView addSubview:self.quitButton];

        return self.contentView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case kFirstSection:
        case kSecondSection:
            return 0.01;
            break;
        case kThirdSection:
            return 75.0f;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case kLoginOutTag:
            if (buttonIndex) {
                [self postLoading];
                //退出 IM
                [[MessageManager share] logout];
                AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
                [aDelegate.controllerManager releaseHomeView];
                // 增加AppIcon未读角标设置
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }
            break;
        case kCleanCacheTag:
            // TODO: 清空缓存
            break;
        case kDeleteCountTag:
            if (buttonIndex) {
                // TODO: 向服务器做删除账号请求
                MeDeleteUserAccountRequest *request = [[MeDeleteUserAccountRequest alloc] initWithDelegate:self];
                [request GetShowID:[[UnifiedUserInfoManager share] userShowID]];
            }
            break;
    }
}

#pragma mark - BaseDelegate Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[MeDeleteUserAccountResponse class]])
    {
//        [LoginOutRequest loginOutWithDelegate:self];
    }
    
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - setterAndGetter

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)quitButton
{
    if (!_quitButton)
    {
        _quitButton = [[UIButton alloc] init];
        [_quitButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeRed]] forState:UIControlStateNormal];
        [_quitButton setTitle:LOCAL(ME_LOGIN_OUT) forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchUpInside];
        _quitButton.frame = CGRectMake(13, 44, self.view.frame.size.width - 26, 45);
        _quitButton.titleLabel.font = [UIFont mtc_font_30];
        _quitButton.layer.cornerRadius = 4;
        _quitButton.clipsToBounds = YES;
    }
    return _quitButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

@end
