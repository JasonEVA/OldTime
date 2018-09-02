//
//  ShapeMainViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/10/14.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "ShapeMainViewController.h"
#import "LoginViewController.h"
#import "RowButtonGroup.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import <Masonry/Masonry.h>
#import "AerobicExerciseView.h"
#import "AnaerobicExerciseView.h"
#import "DataAnalysisView.h"
#import "AddAerobicDataModalViewController.h"
#import "BaseNavigationViewController.h"
#import "DBUnifiedManager.h"
#import "Weight.h"
#import "FatRange.h"

typedef enum : NSUInteger {
    tag_anaerobic, // 无氧运动
    tag_aerobic, // 有氧运动
    tag_analysis // 数据分析
} ExericiseTypeTag;
@interface ShapeMainViewController ()<RowButtonGroupDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)  RowButtonGroup  *rowBtnGroup;    // 导航栏选择栏

@property (nonatomic, strong)  AerobicExerciseView  *aerobicExerciseView; // 有氧运动界面
@property (nonatomic, strong)  AnaerobicExerciseView  *anaerobicExerciseView; // 无氧运动界面
@property (nonatomic, strong)  DataAnalysisView  *dataAnalysisView; // 数据分析界面

@property (nonatomic, strong)  UIView  *shownView; // 当前显示的view

@property (nonatomic, strong)  UIScrollView  *backgroundScrollView; // 滑动背景
@end

@implementation ShapeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitleView:self.rowBtnGroup];
    
    [self configElements];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAerobicData) name:n_addAerobicData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anaerobicExerciseWithMuscle:) name:n_trainingPart object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:n_updateAerobicData object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    // 背景
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // 无氧
    [self.anaerobicExerciseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.width.height.equalTo(self.backgroundScrollView);
    }];

    // 有氧
    [self.aerobicExerciseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.anaerobicExerciseView.mas_right);
        make.top.bottom.width.height.equalTo(self.anaerobicExerciseView);
    }];
    
    // 数据分析
    [self.dataAnalysisView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aerobicExerciseView.mas_right);
        make.top.bottom.width.height.equalTo(self.anaerobicExerciseView);
    }];
    
    [self.backgroundScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dataAnalysisView);
    }];
    

    [super updateViewConstraints];
}
#pragma mark - Private Method

- (void)configElements {
    
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.anaerobicExerciseView];
    [self.backgroundScrollView addSubview:self.aerobicExerciseView];
    [self.backgroundScrollView addSubview:self.dataAnalysisView];
    
    // 默认显示无氧
    self.shownView = self.anaerobicExerciseView;

    [self updateViewConstraints];

}

- (void)showExericiseViewWithTag:(ExericiseTypeTag)tag {
    if (self.shownView.tag != tag) {
        switch (tag) {
            case tag_anaerobic:
                // 无氧
                self.shownView = self.anaerobicExerciseView;
                break;
                
            case tag_aerobic:
            {
                // 有氧
                self.shownView = self.aerobicExerciseView;
                [self.aerobicExerciseView setAerobicComprehensiveData];
                break;
            }
                
            case tag_analysis:
                // 分析
                self.shownView = self.dataAnalysisView;
                break;
                
            default:
                break;
        }
        [self.backgroundScrollView scrollRectToVisible:self.shownView.frame animated:YES];
        NSLog(@"----------%@",NSStringFromCGRect(self.shownView.frame));
    }

}


// 锻炼某个部位
- (void)anaerobicExerciseWithMuscle:(NSNotification *)notification {
    NSLog(@"------------------->%@",notification.object);
    [[NSNotificationCenter defaultCenter] postNotificationName:n_switchModule object:@0];
    [self performSelector:@selector(pushToAddTraining:) withObject:notification.object afterDelay:0.05];

}
- (void)pushToAddTraining:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:n_pushToAddTraining object:sender];

}
// 增加有氧运动数据
- (void)addAerobicData {
    AddAerobicDataModalViewController *addDataVC = [[AddAerobicDataModalViewController alloc] init];
    Weight *weightTemp = [[DBUnifiedManager share] fetchWeightWithCount:1].lastObject;
    FatRange *fatRangeTemp = [[DBUnifiedManager share] fetchFatRange];

    [addDataVC setWeight:weightTemp ? weightTemp.weight.floatValue : 0.0 fatRange:fatRangeTemp ? fatRangeTemp.fatRange : @""];
    addDataVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    addDataVC.edgesForExtendedLayout = UIRectEdgeAll;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8) {
        addDataVC.providesPresentationContextTransitionStyle = YES;
        [addDataVC setDefinesPresentationContext:YES];
        addDataVC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:addDataVC animated:YES completion:nil];
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:addDataVC animated:YES completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}

#pragma mark - RowBtnDelegate
- (void)RowButtonGroupDelegateCallBack_btnClickedWithTag:(NSInteger)tag {
    ExericiseTypeTag newTag = (ExericiseTypeTag)tag;
    [self showExericiseViewWithTag:newTag];
    NSLog(@"-------------->btnClickecd:%ld",tag);

}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x - self.view.frame.size.width * 0.5) / self.view.frame.size.width + 1;
    ExericiseTypeTag tag = (ExericiseTypeTag)currentIndex;
    [self.rowBtnGroup setBtnSelectedWithTag:tag];
}

#pragma mark - Init
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] init];
        [_backgroundScrollView setPagingEnabled:YES];
        [_backgroundScrollView setScrollsToTop:NO];
        _backgroundScrollView.showsHorizontalScrollIndicator = NO;
        _backgroundScrollView.showsVerticalScrollIndicator = NO;
        [_backgroundScrollView setDelegate:self];
    }
    return _backgroundScrollView;
}

- (RowButtonGroup *)rowBtnGroup {
    if (!_rowBtnGroup) {
        _rowBtnGroup = [[RowButtonGroup alloc] initWithTitles:@[@"无氧运动",@"有氧运动",@"数据分析"] tags:@[@(tag_anaerobic),@(tag_aerobic),@(tag_analysis)] normalTitleColor:[UIColor colorLightGray_898888] selectedTitleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:fontSize_15]];
        [_rowBtnGroup setFrame:CGRectMake(0, 0, self.view.frame.size.width, height_44)];
        [_rowBtnGroup setDelegate:self];
        
    }
    return _rowBtnGroup;
}

// 有氧
- (AerobicExerciseView *)aerobicExerciseView {
    if (!_aerobicExerciseView) {
        _aerobicExerciseView = [[AerobicExerciseView alloc] init];
        [_aerobicExerciseView setTag:tag_aerobic];
    }
    return _aerobicExerciseView;
}

// 无氧
- (AnaerobicExerciseView *)anaerobicExerciseView {
    if (!_anaerobicExerciseView) {
        _anaerobicExerciseView = [[AnaerobicExerciseView alloc] init];
        [_anaerobicExerciseView setTag:tag_anaerobic];
    }
    return _anaerobicExerciseView;

}

// 数据分析
- (DataAnalysisView *)dataAnalysisView {
    if (!_dataAnalysisView ) {
        _dataAnalysisView = [[DataAnalysisView alloc] init];
        [_dataAnalysisView setTag:tag_analysis];
    }
    return _dataAnalysisView;
}
@end
