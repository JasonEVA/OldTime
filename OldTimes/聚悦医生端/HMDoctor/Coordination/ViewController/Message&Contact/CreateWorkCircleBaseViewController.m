//
//  CreateWorkCircleBaseViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateWorkCircleBaseViewController.h"
#import "CreateWorkCircleViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ContactInfoModel.h"

@interface CreateWorkCircleBaseViewController ()
@property (nonatomic, strong)  CreateWorkCircleViewController  *createVC; // <##>
@end

@implementation CreateWorkCircleBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backEvent)];
    [self.navigationItem setLeftBarButtonItem:left];
    [self.navigationItem setTitle:self.create ? @"创建工作圈" : @"添加成员"];
    self.atLeastTwoPeople = self.create;
    self.rightItemTitle = self.create ? @"创建" : @"添加";
    
    [self configRightItemTitle:self.rightItemTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interface Method

#pragma mark - Private Method

#pragma mark - Event Response

- (void)backEvent {
    if (self.navi.viewControllers.count > 1) {
        [self.navi popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createWorkCircle {
    NSMutableArray *uidArr = [NSMutableArray array];
    for (int i = 0 ; i < self.selectView.arraySelect.count; i++) {
        ContactInfoModel *model = self.selectView.arraySelect[i];
        [uidArr addObject:model.relationInfoModel.relationName];
    }
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] createGroupWithUserIds:uidArr tag:@"标签" completion:^(UserProfileModel *profileModel, BOOL isSuccess) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (isSuccess) {
            [strongSelf at_hideLoading];
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [strongSelf at_postError:@"创建失败"];
        }
    }];
    
}

- (void)addWorkCircleMember {
    NSMutableArray *uidArr = [NSMutableArray array];
    [self.selectView.arraySelect enumerateObjectsUsingBlock:^(ContactInfoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [uidArr addObject:model.relationInfoModel.relationName];
    }];
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] groupSessionUid:self.workCircleID addUserIds:uidArr completion:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            [strongSelf at_postError:@"添加失败"];
        }
        else {
            [strongSelf at_hideLoading];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Delegate

#pragma mark - Override

- (void)rightItemEvent {
    [super rightItemEvent];
    [self at_postLoading];
    if (self.create) {
        [self createWorkCircle];
    }
    else {
        [self addWorkCircleMember];
    }
}

#pragma mark - Init

- (HMBaseViewController *)containerVC {
    return self.createVC;
}

- (CreateWorkCircleViewController *)createVC {
    if (!_createVC) {
        _createVC = [[CreateWorkCircleViewController alloc] initWithSelectView:self.selectView nonSelectableContacts:self.arrayNonSelectableContacts];
    }
    return _createVC;
}

@end
