//
//  CoordinationChatViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationChatViewController.h"
#import "CoordinationFilterView.h"
#import "ATModuleInteractor+CoordinationInteractor.h"

typedef NS_ENUM(NSUInteger, ChatMenuType) {
    ChatMenuHistoryList,
    ChatMenuGroupInfo,
};


@interface CoordinationChatViewController ()<CoordinationFilterViewDelegate>
@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>

@end

@implementation CoordinationChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"c_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    [self.navigationItem setRightBarButtonItem:menuItem];
    
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
 
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {

}

// 设置数据
- (void)configData {
    
}
#pragma mark - Event Response

- (void)showMenu {
    if (![self.view.subviews containsObject:self.filterView]) {
        [self.view addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [self.filterView removeFromSuperview];
        _filterView = nil;
    }

}

#pragma mark - Delegate

#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    ChatMenuType type = (ChatMenuType)tag;
    switch (type) {
        case ChatMenuHistoryList: {
           // [self.interactor goHistoryList];
            break;
        }
        case ChatMenuGroupInfo: {
            //[self.interactor goGroupInfo];
            break;
        }
    }
    
}

#pragma mark - Override

#pragma mark - Init

- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"c_historyList",@"c_groupID"] titles:@[@"历史消息",@"群名片"] tags:@[@(ChatMenuHistoryList),@(ChatMenuGroupInfo)]];
        _filterView.delegate = self;
    }
    return _filterView;
}



@end
