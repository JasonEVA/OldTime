//
//  DoctorGreetingViewController.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DoctorGreetingViewController.h"
#import "DoctorGreetingCollectionViewCell.h"
#import "ATAudioSessionPlayUtility.h"

#define ITEMWIDTH (self.view.frame.size.width * 0.872)
#define ITEMHEIGHT (self.view.frame.size.height * 0.66)
#define LINESPACING (self.view.frame.size.width - ITEMWIDTH)

@interface DoctorGreetingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)  UIView  *bgView; // <##>
@property (nonatomic, strong)  UILabel  *greetingTitle; // 未读标题
@property (nonatomic, strong)  UICollectionView  *collectionView; // 卡片
@property (nonatomic, strong)  UIPageControl  *pageControl; // <##>
@property (nonatomic, strong)  UIButton  *btnClose; // 关闭按钮
@end

@implementation DoctorGreetingViewController

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

    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    self.view.backgroundColor = [UIColor clearColor];
    UIView *baseView = [[UIView alloc] initWithFrame:self.view.frame];
    baseView.backgroundColor = [UIColor blackColor];
    baseView.alpha = 0.8;
    
    [self.view addSubview:baseView];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.greetingTitle];
    [self.bgView addSubview:self.collectionView];
    [self.bgView addSubview:self.pageControl];
    [self.bgView addSubview:self.btnClose];
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.greetingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.greetingTitle.mas_bottom).offset(25);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(ITEMHEIGHT + 1);
        make.centerY.equalTo(self.bgView);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        make.top.equalTo(self.pageControl.mas_bottom).offset(10);
    }];
}

// 设置数据
- (void)configData {
    
}

#pragma mark - Event Response

// 关闭
- (void)closeDoctorGreeting {
    [[ATAudioSessionPlayUtility sharedInstance] stopAllVoiceGreeting];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DoctorGreetingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DoctorGreetingCollectionViewCell at_identifier] forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x - self.view.frame.size.width * 0.5) / self.view.frame.size.width + 1;
    self.pageControl.currentPage = currentIndex;
}


#pragma mark - Override

#pragma mark - Init

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor clearColor]];
    }
    return _bgView;
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = LINESPACING;
        layout.itemSize = CGSizeMake(ITEMWIDTH, ITEMHEIGHT);
        layout.sectionInset = UIEdgeInsetsMake(0, LINESPACING * 0.5, 0, LINESPACING * 0.5);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[DoctorGreetingCollectionViewCell class] forCellWithReuseIdentifier:[DoctorGreetingCollectionViewCell at_identifier]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (UILabel *)greetingTitle {
    if (!_greetingTitle) {
        _greetingTitle = [UILabel new];
        _greetingTitle.textColor = [UIColor whiteColor];
        _greetingTitle.font = [UIFont font_30];
        _greetingTitle.text = @"你有2条医生问候未查看";
        [_greetingTitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _greetingTitle;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor mainThemeColor];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.defersCurrentPageDisplay = YES;
        _pageControl.numberOfPages = 2;
    }
    return _pageControl;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnClose setImage:[UIImage imageNamed:@"icon_doctorGreeting_close"] forState:UIControlStateNormal];
        [_btnClose setTitle:@"关闭" forState:UIControlStateNormal];
        _btnClose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_btnClose setTitleColor:[UIColor colorWithHexString:@"EBEBEB"] forState:UIControlStateNormal];
        [_btnClose.titleLabel setFont:[UIFont font_30]];
        _btnClose.imageEdgeInsets = UIEdgeInsetsMake(-30, 20, 0, 0);
        _btnClose.titleEdgeInsets = UIEdgeInsetsMake(30, -30, 0, 0);
        [_btnClose addTarget:self action:@selector(closeDoctorGreeting) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClose;
}

@end
