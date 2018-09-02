//
//  PersonSpaceStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonSpaceStartViewController.h"
//#import "PersonNavigationView.h"
#import "PersonSpaceCollectionViewController.h"
#import "PersonStartNavigaionView.h"
#import "PersonStartCollectionServiceHeaderView.h"

@interface PersonSpaceStartViewController ()
{
    //PersonSpaceTableViewController* tvcPersonSpace;
    PersonSpaceCollectionViewController* cvcPersonSpace;
    UIImageView *navBarHairlineImageView;
    PersonStartNavigaionView* navTitleView;
    
    PersonStartCollectionServiceHeaderView* serviceHeaderView;
}

@end

@implementation PersonSpaceStartViewController

- (void)viewDidLoad {
    //[self.view setBackgroundColor:[UIColor mainThemeColor]];
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    //navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [[UINavigationBar appearance] setBarTintColor:[UIColor mainThemeColor]];
    
    navTitleView = [[PersonStartNavigaionView alloc]initWithFrame:CGRectMake(10, 0, 320 * kScreenScale, 56 * kScreenScale)];
    [navTitleView setBackgroundColor:[UIColor mainThemeColor]];
    
    serviceHeaderView = [[PersonStartCollectionServiceHeaderView alloc]init];
    [self.view addSubview:serviceHeaderView];
    [serviceHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(22);
        make.height.mas_equalTo([NSNumber numberWithFloat:37 * kScreenScale]);
    }];

    UICollectionViewFlowLayout* fl = [[UICollectionViewFlowLayout alloc]init];
    cvcPersonSpace = [[PersonSpaceCollectionViewController alloc]initWithCollectionViewLayout:fl];
    [self addChildViewController:cvcPersonSpace];
    //[cvcPersonSpace.collectionView setFrame:rtCollection];
    [self.view addSubview:cvcPersonSpace.collectionView];
    
    [cvcPersonSpace.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(serviceHeaderView.mas_bottom);
    }];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //navBarHairlineImageView.hidden = YES;
//    UINavigationBar *bar = [self.navigationController navigationBar];
    
//    CGFloat navBarHeight = 69.0f ;
//    CGRect frame = CGRectMake(0.0f, 20.0f, 320.0f * kScreenScale, navBarHeight);
//    [bar setFrame:frame];
    
    
    
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

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO];
    UINavigationBar *bar = [self.navigationController navigationBar];
    CGFloat navBarHeight = 44.0f ;
    CGRect frame = CGRectMake(0.0f, 20.0f, 320.0f * kScreenScale, navBarHeight);
    [bar setFrame:frame];
    [navTitleView removeFromSuperview];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    CGFloat navBarHeight = 56 * kScreenScale ;
    CGRect frame = CGRectMake(0.0f, 20.0f, 320.0f * kScreenScale, navBarHeight);
    [bar setFrame:frame];
    
    [bar addSubview:navTitleView];
    
    if (cvcPersonSpace)
    {
        [cvcPersonSpace loadUserService];
    }
    
    [navTitleView setUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) initContentView
//{
//    tvcPersonSpace = [[PersonSpaceTableViewController alloc]initWithStyle:UITableViewStylePlain];
//    [self addChildViewController:tvcPersonSpace];
//    [tvcPersonSpace.tableView setFrame:self.view.bounds];
//    [self.view addSubview:tvcPersonSpace.tableView];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) userLoginButtonClicked:(id) sender
{
  
    [[HMViewControllerManager defaultManager] userLogout];
}

@end
