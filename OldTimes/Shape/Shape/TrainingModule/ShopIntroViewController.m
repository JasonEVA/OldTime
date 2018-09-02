//
//  ShopIntroViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "ShopIntroViewController.h"
#import "ShopBaseInfoView.h"
#import <Masonry/Masonry.h>
#import "RowButtonGroup.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "TeamClassCollectionViewCell.h"
#import "PraviteTeachCollectionViewCell.h"

typedef enum : NSUInteger {
    tag_class,
    tag_praviteTeach,
    tag_video,
    tag_activity,
    tag_goods,
} ShopIntroColumnTag;

static NSString *const kTeamClass = @"teamClassCell";
static NSString *const kPraviteTeach = @"praviteTeach";

static NSInteger const kColumn = 5;

@interface ShopIntroViewController ()<RowButtonGroupDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)  ShopBaseInfoView  *baseInfoView; // <##>
@property (nonatomic, strong)  RowButtonGroup  *rowBtnGroup; // 课程按钮控件
@property (nonatomic, strong)  UIView  *lineOrange; // 按钮上的线
@property (nonatomic, strong)  UICollectionView  *collectionView; // 滑动背景
@end

@implementation ShopIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Shape官方"];
    [self configElements];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    
    [self.baseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    [self.rowBtnGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(height_40));
        make.top.equalTo(self.baseInfoView.mas_bottom);
    }];
    
    [self.lineOrange mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(0.2);
        make.height.equalTo(@2);
        make.bottom.equalTo(self.rowBtnGroup);
        make.centerX.equalTo(self.rowBtnGroup.selectedBtn);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.rowBtnGroup.mas_bottom);
    }];
    [super updateViewConstraints];
}
#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    
    [self.view addSubview:self.baseInfoView];
    [self.view addSubview:self.rowBtnGroup];
    [self.rowBtnGroup addSubview:self.lineOrange];
    [self.view addSubview:self.collectionView];
    [self.view needsUpdateConstraints];
}

- (void)updateCustomContraints {
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - rowBtnGroupDelegate
// 正反面点击委托
- (void)RowButtonGroupDelegateCallBack_btnClickedWithTag:(NSInteger)tag {
//    if (tag == tag_positive) {
//        self.shownView = self.positiveView;
//    } else {
//        self.shownView = self.negativeView;
//    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self updateCustomContraints];
    
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kColumn;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        PraviteTeachCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPraviteTeach forIndexPath:indexPath];
        
        return cell;

    } else {
        TeamClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTeamClass forIndexPath:indexPath];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x - self.view.frame.size.width * 0.5) / self.view.frame.size.width + 1;
    ShopIntroColumnTag tag = (ShopIntroColumnTag)currentIndex;
    [self.rowBtnGroup setBtnSelectedWithTag:tag];
    
}
#pragma mark - Init

- (ShopBaseInfoView *)baseInfoView {
    if (!_baseInfoView) {
        _baseInfoView = [[ShopBaseInfoView alloc] init];
    }
    return _baseInfoView;
}

- (RowButtonGroup *)rowBtnGroup {
    if (!_rowBtnGroup) {
        _rowBtnGroup = [[RowButtonGroup alloc] initWithTitles:@[@"团课",@"私教",@"视频",@"活动",@"店铺"] tags:@[@(tag_class),@(tag_praviteTeach),@(tag_video),@(tag_activity),@(tag_goods)] normalTitleColor:[UIColor whiteColor] selectedTitleColor:[UIColor themeOrange_ff5d2b] font:[UIFont systemFontOfSize:fontSize_15]];
        [_rowBtnGroup setDelegate:self];
        [_rowBtnGroup setBackgroundColor:[UIColor themeBackground_373737]];
    }
    return _rowBtnGroup;
}

- (UIView *)lineOrange {
    if (!_lineOrange) {
        _lineOrange = [[UIView alloc] init];
        [_lineOrange setBackgroundColor:[UIColor themeOrange_ff5d2b]];
    }
    return _lineOrange;
}

#pragma mark - Init
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height - 204);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [layout setSectionInset:UIEdgeInsetsZero];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[TeamClassCollectionViewCell class] forCellWithReuseIdentifier:kTeamClass];
        [_collectionView registerClass:[PraviteTeachCollectionViewCell class] forCellWithReuseIdentifier:kPraviteTeach];

        [_collectionView setPagingEnabled:YES];
        [_collectionView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];

    }
    return _collectionView;
}
@end
