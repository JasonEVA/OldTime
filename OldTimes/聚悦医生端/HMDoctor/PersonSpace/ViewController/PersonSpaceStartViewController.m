//
//  PersonSpaceStartViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceStartViewController.h"
#import "PersonSpaceNavigationView.h"
#import "PersonSpaceStartTableViewController.h"

@interface PersonSpaceStartViewController ()
<TaskObserver>
{
    PersonSpaceNavigationView* navTitleView;
    UIImageView* navBarHairlineImageView;
    
    PersonSpaceStartTableViewController* tvcPersonSpace;
}
@end

@implementation PersonSpaceStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    
    navTitleView = [[PersonSpaceNavigationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 108 * kScreenScale)];
    [navTitleView setBackgroundColor:[UIColor mainThemeColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterStaffInfo)];
    [navTitleView.ivPartrait setUserInteractionEnabled:YES];
    [navTitleView.ivPartrait addGestureRecognizer:tap];
}

- (void)enterStaffInfo
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－个人信息设置"];
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonStaffInfoViewController" ControllerObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    CGFloat navBarHeight = 107 * kScreenScale;
    CGRect frame = CGRectMake(0.0f, 20.0f * kScreenScale, kScreenWidth, navBarHeight);
    [bar setFrame:frame];
    
    [self.navigationController.navigationBar addSubview:navTitleView];
    
    [navTitleView setStaffInfo];
    
    if (!tvcPersonSpace) {
        CGRect rtTable = self.view.bounds;
        rtTable.origin.y += 73.0 * kScreenScale;
        rtTable.size.height -= 73.0 * kScreenScale;
        tvcPersonSpace = [[PersonSpaceStartTableViewController alloc]initWithStyle:UITableViewStylePlain];
        [tvcPersonSpace.tableView setFrame:rtTable];
        [self addChildViewController:tvcPersonSpace];
        [self.view addSubview:tvcPersonSpace.tableView];
    }
    
    //UserAuthenticationInfoTask
    if (navTitleView)
    {
        [navTitleView setStaffAuthentication:nil];
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAuthenticationInfoTask" taskParam:dicPost TaskObserver:self];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    CGFloat navBarHeight = 73.0f;
    CGRect frame = CGRectMake(0.0f, 20.0f, kScreenWidth, navBarHeight);
    [bar setFrame:frame];
    
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO];
    UINavigationBar *bar = [self.navigationController navigationBar];
    CGFloat navBarHeight = 44.0f;
    CGRect frame = CGRectMake(0.0f, 20.0f, kScreenWidth, navBarHeight);
    [bar setFrame:frame];
    
    if (navTitleView)
    {
        [navTitleView removeFromSuperview];
    }
}

#pragma mark - TaskObserver

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"UserAuthenticationInfoTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSNumber class]])
        {
            NSNumber* numAuthen = (NSNumber*) taskResult;
            NSString* authen = nil;
            switch (numAuthen.integerValue)
            {
                case 1:
                    authen = @"未认证";
                    break;
                case 2:
                    authen = @"身份证认证";
                    break;
                case 3:
                    authen = @"医保卡认证";
                    break;
                case 4:
                    authen = @"医生资格证认证";
                    break;
                default:
                    break;
            }
            if (navTitleView)
            {
                [navTitleView setStaffAuthentication:authen];
            }
        }
        else
        {
            //未认证
            if (navTitleView)
            {
                [navTitleView setStaffAuthentication:@"未认证"];
            }
        }
    }
}
@end
