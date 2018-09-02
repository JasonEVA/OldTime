//
//  CoordinationSelectContactsBaseViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationSelectContactsBaseViewController.h"

@interface CoordinationSelectContactsBaseViewController ()
@property (nonatomic, strong)  UIView  *contentView; // <##>
@property (nonatomic, strong)  UIButton  *actionButton; // <##>

@property (nonatomic, strong)  MASConstraint  *selectViewHeight; // <##>
@end

@implementation CoordinationSelectContactsBaseViewController

- (void)dealloc {
    [self.selectView removeObserver:self forKeyPath:@"arraySelect"];
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

// ritghtItem事件
- (void)rightItemEvent {
    [self quickButtonClickdefense];
}

- (void)configRightItemTitle:(NSString *)title {
    if (self.selectView.arraySelect.count < 2 && self.atLeastTwoPeople) {
        self.actionButton.enabled = NO;
    }
    else {
        self.actionButton.enabled = YES;
    }
    [self.actionButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.navigationItem setRightBarButtonItem:self.rightItem];

    [self.view addSubview:self.contentView];
    [self.view addSubview:self.selectView];
    [self addChildViewController:self.navi];
    [self.contentView addSubview:self.navi.view];
    [self.navi didMoveToParentViewController:self];

    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        self.selectViewHeight = make.height.mas_equalTo(0.5);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.selectView.mas_bottom);
    }];
    [self.navi.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView.mas_height);
    }];
}

// 设置数据
- (void)configData {
    [self.selectView addObserver:self forKeyPath:@"arraySelect" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
}


// 快速点击防御
- (void)quickButtonClickdefense {
    if (self.actionButton.enabled) {
        self.actionButton.enabled = NO;
        [self performSelector:@selector(quickButtonClickRemove) withObject:nil afterDelay:0.5];
    }
}

// 快速点击防御解除
- (void)quickButtonClickRemove {
    self.actionButton.enabled = YES;
}
#pragma mark - Event Response

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"arraySelect"]) {
        [self configRightItemTitle:self.selectView.arraySelect.count == 0 ? self.rightItemTitle : [NSString stringWithFormat:@"%@(%ld)",self.rightItemTitle,self.selectView.arraySelect.count]];
        if (self.selectView.arraySelect.count == 0) {
            self.selectViewHeight.offset = 0.5;
        }
        else {
            self.selectViewHeight.offset = 55;
        }
        [UIView animateWithDuration:0.24 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - Delegate

#pragma mark - Override



#pragma mark - Init

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.actionButton];
    }
    return _rightItem;
}

- (SelectContactTabbarView *)selectView {
    if (!_selectView) {
        _selectView = [SelectContactTabbarView new];
    }
    return _selectView;
}

- (HMBaseNavigationViewController *)navi {
    if (!_navi) {
        _navi = [[HMBaseNavigationViewController alloc] initWithRootViewController:self.containerVC];
    }
    return _navi;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.frame = CGRectMake(0, 0, 60, 44);
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setTitleColor:[UIColor colorWithHexString:@"83c2ff"] forState:UIControlStateDisabled];
        [_actionButton titleLabel].font = [UIFont systemFontOfSize:15];
        [_actionButton addTarget:self action:@selector(rightItemEvent) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _actionButton;
}

@end
