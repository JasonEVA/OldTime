//
//  HealthCenterDoctorGreetingViewController.m
//  HMClient
//
//  Created by lkl on 16/6/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterDoctorGreetingViewController.h"
#import "HealthCenterDoctorGreetingCollectionViewCell.h"

#define ITEMWIDTH (self.view.frame.size.width * 0.872)
#define ITEMHEIGHT (self.view.frame.size.height * 0.66)
#define LINESPACING (self.view.frame.size.width - ITEMWIDTH)

@interface HealthCenterDoctorGreetingViewController ()<TaskObserver, UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView* bottomView;
    UIView* bgView;
    UILabel* greetingTitle;
    UIPageControl* pageControl;
    UIButton* closeButton;

}
@property (nonatomic, strong)  UICollectionView  *collectionView;
@end

@implementation HealthCenterDoctorGreetingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.definesPresentationContext = YES;
        self.providesPresentationContextTransitionStyle = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];

    bottomView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:bottomView];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    [bottomView setAlpha:0.8];

    [self initWithSubViews];
}

- (void)initWithSubViews
{
    bgView = [[UIView alloc] init];
    [self.view addSubview:bgView];
    [bgView setBackgroundColor:[UIColor clearColor]];

    greetingTitle = [[UILabel alloc] init];
    [bgView addSubview:greetingTitle];
    greetingTitle.textColor = [UIColor whiteColor];
    greetingTitle.font = [UIFont font_30];
    greetingTitle.text = @"问候加载中，请稍等……";
    [greetingTitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = LINESPACING;
    layout.itemSize = CGSizeMake(ITEMWIDTH, ITEMHEIGHT);
    layout.sectionInset = UIEdgeInsetsMake(0, LINESPACING * 0.5, 0, LINESPACING * 0.5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [bgView addSubview:_collectionView];
    [_collectionView registerClass:[HealthCenterDoctorGreetingCollectionViewCell class] forCellWithReuseIdentifier:[HealthCenterDoctorGreetingCollectionViewCell at_identifier]];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    pageControl = [[UIPageControl alloc] init];
    [bgView addSubview:pageControl];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor mainThemeColor];
    pageControl.hidesForSinglePage = YES;
    pageControl.defersCurrentPageDisplay = YES;
    pageControl.numberOfPages = 0;
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"icon_doctorGreeting_close"] forState:UIControlStateNormal];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [closeButton setTitleColor:[UIColor colorWithHexString:@"EBEBEB"] forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont font_30]];
    closeButton.imageEdgeInsets = UIEdgeInsetsMake(-30, 20, 0, 0);
    closeButton.titleEdgeInsets = UIEdgeInsetsMake(30, -30, 0, 0);
    [closeButton addTarget:self action:@selector(closeDoctorGreeting) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.greetingsList.count > 0) {
        [greetingTitle setText:[NSString stringWithFormat:@"你有%ld条医生问候未查看",_greetingsList.count]];
        [pageControl setNumberOfPages:_greetingsList.count];
        [self.collectionView reloadData];
        
        //标记第一条已读
        [self markCareRead:0];
    }
    [self subViewsLayout];
}

- (void)closeDoctorGreeting
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)subViewsLayout
{
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [greetingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(27);
        make.centerX.equalTo(bgView);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(greetingTitle.mas_bottom).offset(25);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(ITEMHEIGHT + 1);
        make.centerY.equalTo(bgView);
    }];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bgView);
        make.top.equalTo(bgView.mas_bottom).offset(-80);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _greetingsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoctorGreetingInfo* greetingInfo = [_greetingsList objectAtIndex:indexPath.row];
    
    HealthCenterDoctorGreetingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HealthCenterDoctorGreetingCollectionViewCell at_identifier] forIndexPath:indexPath];
    
    [cell setDoctorGreetingData:greetingInfo];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = (scrollView.contentOffset.x - self.view.frame.size.width * 0.5) / self.view.frame.size.width + 1;
    pageControl.currentPage = currentIndex;
    
    [self markCareRead:currentIndex];
}

- (void)markCareRead:(NSInteger)index
{
    DoctorGreetingInfo* greetingInfo = [_greetingsList objectAtIndex:index];
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:greetingInfo.careId forKey:@"careId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"markCareReadedTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{

    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"markCareReadedTask"])
    {
        //NSLog(@"%@",taskResult);
    }
}


@end
