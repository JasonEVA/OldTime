//
//  HMAdverstiseListViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMAdverstiseListViewController.h"


@interface HMAdverstiseListViewController ()
{
    UIScrollView* scrollview;
    NSMutableArray* advertiseCells;
    NSArray* advertiseItems;
    
    UIPageControl* pageControl;
}
@end

@implementation HMAdverstiseListViewController

- (void) loadView
{
    scrollview = [[UIScrollView alloc]init];
    [scrollview setPagingEnabled:YES];
    [scrollview setShowsHorizontalScrollIndicator:NO];
    [self setView:scrollview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [scrollview setWidth:320 * kScreenScale];
    // Do any additional setup after loading the view.
    if (0 < _viewHeight)
    {
        [scrollview setHeight:_viewHeight];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setViewHeight:(CGFloat)viewHeight
{
    _viewHeight = viewHeight;
    if (scrollview)
    {
        [scrollview setHeight:viewHeight];
    }
}

- (void) advertiseListLoaded:(NSArray*) advertises
{
    if (advertiseCells)
    {
        for (HMAdvertiseCell* cell in advertiseCells)
        {
            [cell removeFromSuperview];
        }
    }
    
    advertiseCells = [NSMutableArray array];
    
    advertiseItems = [NSArray arrayWithArray:advertises];
    for (NSInteger index = 0; index < advertiseItems.count; ++index)
    {
        HMAdvertiseCell* cell = [[HMAdvertiseCell alloc]initWithFrame:CGRectMake(scrollview.width * index, 0, scrollview.width, scrollview.height)];
        [scrollview addSubview:cell];
        [cell setAdvertiseInfo:[advertiseItems objectAtIndex:index]];
        [cell addTarget:self action:@selector(advertiseCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        [advertiseCells addObject:cell];
       
        if (advertiseItems.count > 1)
        {
            pageControl = [[UIPageControl alloc] init];
            [cell addSubview:pageControl];
            [pageControl setEnabled:NO];
            [pageControl setNumberOfPages:advertiseItems.count];
            [pageControl setCurrentPage:index];
            [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
            [pageControl setCurrentPageIndicatorTintColor:[UIColor mainThemeColor]];
            [pageControl addTarget:self action:@selector(pageControlChange:) forControlEvents:UIControlEventTouchUpInside];
            
            [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell);
                make.top.equalTo(cell.mas_bottom).with.offset(-20);
                make.size.mas_equalTo(CGSizeMake(15*advertiseItems.count, 20));
            }];
        }

    }
    
    [scrollview setContentSize:CGSizeMake(scrollview.width * advertiseItems.count, scrollview.height)];
}

- (void)pageControlChange:(UIPageControl *)sender
{
    [scrollview setContentOffset:CGPointMake(sender.currentPage*scrollview.width, 0) animated:YES];
}

- (void) advertiseCellClicked:(id) sender
{
    if (![sender isKindOfClass:[HMAdvertiseCell class]])
    {
        return;
    }
    NSInteger advertiseIndex = [advertiseCells indexOfObject:sender];
    if (NSNotFound == advertiseIndex)
    {
        return;
    }
    AdvertiseInfo* advertise = advertiseItems[advertiseIndex];
    [self advertiseInfoSelected:advertise];
}

- (void) advertiseInfoSelected:(AdvertiseInfo*) advertise
{
    
}
@end
