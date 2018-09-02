//
//  HMCoordinationMainViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/12/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMCoordinationMainViewController.h"
#import "CoordinationStartViewController.h"
#import "ContactsViewController.h"
#import "CoordinationFilterView.h"
#import "ATModuleInteractor+CoordinationInteractor.h"

@interface HMCoordinationMainViewController ()<CoordinationFilterViewDelegate>
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) CoordinationStartViewController *chatListVC;
@property (nonatomic, strong) ContactsViewController *contactsListVC;
@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>

@end

@implementation HMCoordinationMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segment setFrame:CGRectMake(0, 0, 100, 30)];
    [self.navigationItem setTitleView:self.segment];
    
     UIBarButtonItem *taskItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(taskAction)];
    [self.navigationItem setRightBarButtonItem:taskItem];
    
    
    [self addChildViewController:self.chatListVC];
    [self.view addSubview:self.chatListVC.view];
    [self.chatListVC didMoveToParentViewController:self];

    [self.chatListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-48);
    }];
    
    [self addChildViewController:self.contactsListVC];
    [self.view addSubview:self.contactsListVC.view];
    [self.contactsListVC didMoveToParentViewController:self];

    [self.contactsListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-48);
    }];
    [self.contactsListVC.view setHidden:YES];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response

- (void)taskAction {
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
- (void)segmentClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == self.selectedIndex) {
        return;
    }
    
    self.selectedIndex = sender.selectedSegmentIndex;
    [self.contactsListVC.view setHidden:!self.selectedIndex];
    [self.chatListVC.view setHidden:self.selectedIndex];
}

#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    TitelType type = (TitelType)tag;
    switch (type) {
        case AddNewFriendType: {
            //
            [[ATModuleInteractor sharedInstance] goAddFriends];
            
            break;
        }
        case CreateWorkCircle: {
            [[ATModuleInteractor sharedInstance] goCreateWorkCircleIsCreate:YES nonSelectableContacts:nil workCircleID:nil];
            
            break;
        }
        case AddNewMissionType: {
            [[ATModuleInteractor sharedInstance] goToAddNewMission];
            break;
        }
    }
    
}
- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"消息",@"联系人"]];
        [_segment setTintColor:[UIColor whiteColor]];
        [_segment setBackgroundColor:[UIColor mainThemeColor]];
        [_segment.layer setCornerRadius:3];
        [_segment.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_segment.layer setBorderWidth:0.5];
        [_segment setClipsToBounds:YES];
        self.selectedIndex = 0;
        [_segment setSelectedSegmentIndex:self.selectedIndex];
        [_segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName,nil];
        [_segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    }
    return _segment;
}

- (CoordinationStartViewController *)chatListVC {
    if (!_chatListVC) {
        _chatListVC = [CoordinationStartViewController new];
    }
    return _chatListVC;
}

- (ContactsViewController *)contactsListVC {
    if (!_contactsListVC) {
        _contactsListVC = [ContactsViewController new];
    }
    return _contactsListVC;
}

- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"c_addFriend",@"c_addWorkCircle",@"c_newTask"] titles:@[@"加好友",@"创建工作圈",@"新建任务"] tags:@[@(AddNewFriendType),@(CreateWorkCircle),@(AddNewMissionType)]];
        _filterView.delegate = self;
    }
    return _filterView;
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
