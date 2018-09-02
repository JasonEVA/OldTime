//
//  ApplyTabBarController.m
//  launcher
//
//  Created by Kyle He on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyTabBarController.h"
#import "ApplySenderViewController.h"
#import "ApplyAcceptViewController.h"
#import "ApplyAddViewController.h"
#import "ApplyTableBar.h"
#import "Masonry.h"
#import "MyDefine.h"
#import "BaseNavigationController.h"
#import "ApplyAddForExpenseViewController.h"
#import "ApplyGetSenderListRequest.h"
#import "UIColor+Hex.h"
#import "ApplyStyleModel.h"
#import "ApplyAddNewUserDefinedViewController.h"
#import "MixpanelMananger.h"
#import "UIViewController+Loading.h"

typedef enum
{
    AcceptApplyVC = 0,
    
    SenderApplyVC =1,
    
    AddApplyVC = 2
    
}TheNumOfVC;


@interface ApplyTabBarController ()<ApplyTabBarDelegate,UIActionSheetDelegate, UITabBarControllerDelegate>


@property (nonatomic ,strong) ApplyTableBar          *applyTabBar;
@property (nonatomic ,strong) UIActionSheet          *actionSheet;
@property (nonatomic ,strong) ApplyAddViewController *addApplyVC;
@property(nonatomic, assign) BOOL  removed;

@property(nonatomic, strong) UILabel  *acceptRoundTag;
@property(nonatomic, strong) UILabel  *senderRoundTag;
@property (nonatomic, strong) NSMutableArray *arrStyle;
@property (nonatomic, strong) NSMutableArray *arrStyleModels;

@end

@implementation ApplyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ApplyStyleRequest *stylerequest = [[ApplyStyleRequest alloc] initWithDelegate:self];
    [stylerequest getInfo];
    
    [self postLoading];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBarController.delegate = self;
    [self initChildController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnBackToSecond:) name:@"turntosender" object:nil];
}

- (void)dimissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//添加三个控制器
- (void) initChildController
{
    ApplyAcceptViewController *acceptApplyVC = [[ApplyAcceptViewController alloc] init];
    [self initChildController:acceptApplyVC title:LOCAL(APPLY_ACCEPT_RECEIVER_TITLE) image:@"login" selectedImg:@"login_select"];
    acceptApplyVC.acceptCounLbl = self.acceptRoundTag;
    acceptApplyVC.senderCuntLbl = self.senderRoundTag;
    
    ApplySenderViewController *sendApplyVC = [[ApplySenderViewController alloc] init];
    [self initChildController:sendApplyVC   title:LOCAL(APPLY_ACCEPT_SENDER_TITLE) image:@"logout" selectedImg:@"logout_select"];
    sendApplyVC.countLbl = self.senderRoundTag;
    
    _addApplyVC  = [[ApplyAddViewController alloc] init];
    [self initChildController:_addApplyVC title:LOCAL(APPLY_ADD) image:@"plus_gray" selectedImg:@"plus_blue"];
    
    acceptApplyVC.tabBarItem.badgeValue = @"22";
}

- (void)searchAction
{
    
}

- (void)turnBackToSecond:(NSNotification *)notification
{
    NSInteger index = [notification.object integerValue];
    
    self.selectedIndex = index;
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[ApplyStyleResponse class]])
    {
        if (((ApplyStyleResponse *)response).arrrTitles.count >0)
        {
            for (NSInteger i = 0; i<((ApplyStyleResponse *)response).arrrTitles.count; i++)
            {
                ApplyStyleModel *model = [((ApplyStyleResponse *)response).arrrTitles objectAtIndex:i];
                if (model.def == 0)
                {
                    [self.arrStyleModels addObject:model];
                    [self.arrStyle addObject:model.name];
                }
            }
        }
    }
    [self postSuccess];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - applyTabBarDelegate
-(void)ApplytabBar:(ApplyTableBar *)tabBar CurrentSelectedIndex:(NSInteger)index
{
    if (index == 2) {
        [self clickedAdd];
        return;
    }
    self.selectedIndex = index;
    switch (index) {
        case AcceptApplyVC:
        {
            self.navigationItem.title = LOCAL(APPLY_ACCEPT_RECEIVER_TITLE);
            break;
        }
        case SenderApplyVC:
        {
            self.navigationItem.title = LOCAL(APPLY_ACCEPT_SENDER_TITLE);
            ApplySenderViewController *vc = (ApplySenderViewController *)self.selectedViewController.childViewControllers[0];
            [vc refreshData];
            break;
        }
        default:
            break;
    }
}

- (void)clickedAdd
{
    [self.actionSheet showInView:self.view];
}
//设置actionsheet
- (UIActionSheet *)actionSheet
{
    if (!_actionSheet)
        //    {
        //        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil
        //                                                  delegate:self
        //                                         cancelButtonTitle:LOCAL(CANCEL)
        //                                    destructiveButtonTitle:nil
        //                                         otherButtonTitles:LOCAL(APPLY_ACCEPT_VOCATION_TITLE),LOCAL(APPLY_ACCEPT_EXPENSED_TITLE),nil];
        //    }
    {
        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:LOCAL(CANCEL)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        [_actionSheet addButtonWithTitle:LOCAL(APPLY_ACCEPT_VOCATION_TITLE)];
        [_actionSheet addButtonWithTitle:LOCAL(APPLY_ACCEPT_EXPENSED_TITLE)];
        
        for (NSInteger i = 0; i<self.arrStyle.count; i++)
        {
            [_actionSheet addButtonWithTitle:[self.arrStyle objectAtIndex:i]];
        }
    }
    return _actionSheet;
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0 :
        {
            return;
        }
        case 1 :
        {
            ApplyAddViewController *addVc = [[ApplyAddViewController alloc]initWithFrom:kNewApply];
            BaseNavigationController *addNav = [[BaseNavigationController alloc]initWithRootViewController:addVc];
            addVc.navigationItem.title = LOCAL(APPLY_ADD_NEW_VOCATION);
            UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
            addVc.navigationItem.leftBarButtonItem = item;
            [self presentViewController:addNav animated:YES completion:nil];
            break;
        }
        case 2 :
        {
            ApplyAddForExpenseViewController *addExpendVc = [[ApplyAddForExpenseViewController alloc] init];
            BaseNavigationController *addNav = [[BaseNavigationController alloc] initWithRootViewController:addExpendVc];
            addExpendVc.navigationItem.title = LOCAL(APPLY_ADD_NEW_MONEY);
            UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
            addExpendVc.navigationItem.leftBarButtonItem = item;
            [self presentViewController:addNav animated:YES completion:nil];
            break;
        }
        default:
        {
            ApplyStyleModel *model = [self.arrStyleModels objectAtIndex:buttonIndex - 3];
            ApplyAddNewUserDefinedViewController *vc = [[ApplyAddNewUserDefinedViewController alloc] initWithShowID:model.showid type:NewApply];
            BaseNavigationController *addNav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            vc.navigationItem.title = model.name;

            [self presentViewController:addNav animated:YES completion:nil];
            break;
        }
    }
    
    [MixpanelMananger track:@"approve/new"];
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    int i = 0;
    for (UIButton *view in self.tabBar.subviews)
    {
        if ([view isKindOfClass:[UIControl class]])
        {
            if (i <= 1)
            {   //添加分隔线
                UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width, 0, 1, view.frame.size.height)];
                seperateView.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
                [view addSubview:seperateView];
                if (i==0)  [view addSubview:self.acceptRoundTag];
                if (i==1)  [view addSubview:self.senderRoundTag];
            }
            if (i == 2)
            {
                if (!self.removed)
                {
                    [view removeFromSuperview];
                    self.removed = YES;
                }
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*2, 0, self.view.frame.size.width/3, 48)];
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
                
                [btn setTitle:LOCAL(APPLY_ADD) forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
                [btn setTitleColor:[UIColor mtc_colorWithHex:0x959595] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"plus_gray"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"Cross_Add_Blue"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(clickedAdd) forControlEvents:UIControlEventTouchUpInside];
                [self.tabBar addSubview:btn];
            }
            i++;
        }
        
    }
}


//初始化三个控制器
- (void)initChildController:(UIViewController *)childVC title:(NSString*)title image:(NSString*)imageName selectedImg:(NSString*)selectedImgName
{
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childVC];
    nav.title = title;
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(10, -10);
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AppleGothic" size:18.0]} forState:UIControlStateNormal];
    nav.tabBarItem.image = [UIImage imageNamed:imageName];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImgName];
    nav.tabBarItem.imageInsets  = UIEdgeInsetsMake(8, -40, -8, 40);
    
    [self addChildViewController:nav];
    
    //添加tabbar内部按钮
    [self.applyTabBar addTabeBarButtonWitItem:childVC.tabBarItem];
}

#pragma mark - Initializer
- (UILabel *)acceptRoundTag
{
    if (!_acceptRoundTag)
    {
        _acceptRoundTag = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3-self.view.frame.size.width/3/3+5, 10, 10, 10)];
        _acceptRoundTag.backgroundColor = [UIColor themeRed];
        _acceptRoundTag.layer.cornerRadius = 5;
        _acceptRoundTag.layer.masksToBounds = YES;
        _acceptRoundTag.hidden = YES;
    }
    return _acceptRoundTag;
}

- (UILabel *)senderRoundTag
{
    if (!_senderRoundTag)
    {
        _senderRoundTag = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3-self.view.frame.size.width/3/3+5, 10, 10, 10)];
        _senderRoundTag.backgroundColor = [UIColor themeRed];
        _senderRoundTag.layer.cornerRadius = 5;
        _senderRoundTag.layer.masksToBounds = YES;
        _senderRoundTag.hidden = YES;
    }
    return _senderRoundTag;
}

- (NSMutableArray *)arrStyle
{
    if (!_arrStyle)
    {
        _arrStyle = [[NSMutableArray alloc] init];
    }
    return _arrStyle;
}

- (NSMutableArray *)arrStyleModels
{
    if (!_arrStyleModels)
    {
        _arrStyleModels = [[NSMutableArray alloc] init];
    }
    return _arrStyleModels;
}

@end
