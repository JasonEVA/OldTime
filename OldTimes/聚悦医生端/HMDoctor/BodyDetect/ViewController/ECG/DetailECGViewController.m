//
//  DetailECGViewController.m
//  HMClient
//
//  Created by lkl on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetailECGViewController.h"
#import "DetailECGResultView.h"
#import "LeadPlayer.h"

#define DetialECGLength 260.0/375.0*ScreenWidth

@interface DetailECGViewController ()
<TaskObserver>
{
    DetailECGResultView *resultView;
    UIScrollView *scrollView;
    LeadPlayer *leadView;
    UIButton *backBtn;
    
    NSArray *bitMapDatas;
}

@end

@implementation DetailECGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"详细心电图"];
}

- (void)initWithDetailView
{
    //竖屏显示
    CATransform3D transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1.0);
    self.view.layer.transform = transform;
    
    //详细心电图
    scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    NSString *datas = [bitMapDatas objectAtIndex:0];
    
    NSArray* datacomps = [datas componentsSeparatedByString:@","];
    int wideSize = datacomps.count*2* 160.0f / 500.0f;
    
    leadView = [[LeadPlayer alloc] initWithFrame:CGRectMake(0, 0,wideSize, DetialECGLength)];
    leadView.isStatic = YES;
    if (datacomps)
    {
        [leadView.pointsArray addObjectsFromArray:datacomps];
    }
    [leadView initStaticDatas];
    [leadView setNeedsDisplay];
    
    [scrollView addSubview:leadView];
    [scrollView setContentSize:CGSizeMake(wideSize, DetialECGLength)];
    [self.view addSubview:scrollView];
    
    
    backBtn = [[UIButton alloc] init];
    backBtn.layer.cornerRadius = 2.0f;
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back001002"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pageUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    resultView = [[DetailECGResultView alloc] init];
    [self.view addSubview:resultView];
    
    [self subViewsLayout];
}

- (void)subViewsLayout
{
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.width.mas_equalTo(self.view.height);
        make.height.mas_equalTo(DetialECGLength);
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(45, 30));
    }];
    
    
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(scrollView.mas_bottom).with.offset(20);
        make.width.mas_equalTo(self.view.height);
        make.height.mas_equalTo(100);
    }];
}

-(void)pageUp:(id)sender
{
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    CATransform3D transform = CATransform3DMakeRotation(-M_PI / 2, 0, 0, 1.0);
    self.view.layer.transform = transform;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) detectResultLoaded:(HeartRateDetectResult*) result
{
    if (!result)
    {
        return;
    }

    bitMapDatas = result.dataDets.bitMapDatas;

    [self initWithDetailView];
    
    [resultView setHR:[NSString stringWithFormat:@"%ld",result.dataDets.XL_OF_XD] RR:result.dataDets.RR QRS:result.dataDets.QRS Result:result.symptom];
    
    [resultView setTestTime:result.testTime];
    

}



@end
