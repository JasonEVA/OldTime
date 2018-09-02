//
//  MainGuideStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainGuideStartViewController.h"

//#import "InitializationHelper.h"

@interface MainGuideStartViewController ()
<UIScrollViewDelegate>
{
    UIScrollView* guideScrollview;
    UIPageControl* pageControl;
}
@end

@interface MainGuidePageViewController : UIViewController
{
    UIImageView* ivBackground;
}
@end

@implementation MainGuidePageViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    ivBackground = [[UIImageView alloc]init];
    [self.view addSubview:ivBackground];
    
    [ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = kScreenWidth * 0.7;
        CGFloat height = width * 1.5;
        make.height.mas_equalTo([NSNumber numberWithFloat:height]);
        make.width.mas_equalTo([NSNumber numberWithFloat:width]);
        make.center.equalTo(self.view);
    }];
    
    [self setGuideImage];
    //[self.view setBackgroundColor:[UIColor blueColor]];
}

- (void) setGuideImage
{
    
}

@end

@interface MainGuideFirstPageViewController : MainGuidePageViewController

@end

@implementation MainGuideFirstPageViewController

- (void) setGuideImage
{
    [ivBackground setImage:[UIImage imageNamed:@"landing_01"]];
    
}

@end

@interface MainGuideSecondPageViewController : MainGuidePageViewController

@end

@implementation MainGuideSecondPageViewController

- (void) setGuideImage
{
    [ivBackground setImage:[UIImage imageNamed:@"landing_02"]];
    
}

@end

@interface MainGuideThirdPageViewController : MainGuidePageViewController

@end

@implementation MainGuideThirdPageViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIButton* entrymainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:entrymainButton];
    [entrymainButton setBackgroundImage:[UIImage rectImage:CGSizeMake(80, 38) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [entrymainButton setTitle:@"马上进入" forState:UIControlStateNormal];
    [entrymainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [entrymainButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    entrymainButton.layer.cornerRadius = 19;
    entrymainButton.layer.masksToBounds = YES;
    [entrymainButton addTarget:self action:@selector(entrymainButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [entrymainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(138, 38));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-62);
    }];
}

- (void) setGuideImage
{
    [ivBackground setImage:[UIImage imageNamed:@"landing_03"]];
    
}

- (void) entrymainButtonClicked:(id) sender
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setValue:app_Version forKey:@"guideVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Launch Screen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    [mainWindow setRootViewController:viewController];

    
}

@end

@implementation MainGuideStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    guideScrollview = [[UIScrollView alloc]init];
    [guideScrollview setDelegate:self];
    [self.view addSubview:guideScrollview];
    [guideScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    [guideScrollview setBackgroundColor:[UIColor whiteColor]];
    [self initGuidePages];
}

- (void) initGuidePages
{
   
    MainGuideFirstPageViewController* vcFirst = [[MainGuideFirstPageViewController alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:vcFirst];
    [guideScrollview addSubview:vcFirst.view];
    [vcFirst.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(guideScrollview);
        make.width.equalTo(guideScrollview);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    MainGuideSecondPageViewController* vcSecond = [[MainGuideSecondPageViewController alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:vcSecond];
    [guideScrollview addSubview:vcSecond.view];
    [vcSecond.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vcFirst.view.mas_right);
        make.width.equalTo(guideScrollview);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    MainGuideThirdPageViewController* vcThird = [[MainGuideThirdPageViewController alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:vcThird];
    [guideScrollview addSubview:vcThird.view];
    [vcThird.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vcSecond.view.mas_right);
        make.width.equalTo(guideScrollview);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    [guideScrollview setPagingEnabled:YES];
    [guideScrollview setContentSize:CGSizeMake(kScreenWidth * 3, kScreenHeight)];
    [guideScrollview setShowsHorizontalScrollIndicator:NO];
    
    pageControl = [[UIPageControl alloc]init];
    [self.view addSubview:pageControl];
    [pageControl setNumberOfPages:3];
    [pageControl setPageIndicatorTintColor:[UIColor commonBackgroundColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor mainThemeColor]];
    //[pageControl setBackgroundColor:[UIColor redColor]];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-15);
        make.centerX.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageIndex = offsetX / kScreenWidth;
    [pageControl setCurrentPage:pageIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
