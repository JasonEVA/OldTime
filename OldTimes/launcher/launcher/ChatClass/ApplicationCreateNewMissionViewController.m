//
//  ApplicationCreateNewMissionViewController.m
//  launcher
//
//  Created by 马晓波 on 16/2/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ApplicationCreateNewMissionViewController.h"
#import "UnifiedUserInfoManager.h"
#import "NewChatNewTaskView.h"
#import <Masonry/Masonry.h>
#import "NSString+HandleEmoji.h"
@interface ApplicationCreateNewMissionViewController ()
@property (nonatomic, strong) UINavigationController *navigationVC;

@property (nonatomic, strong) NewChatNewTaskView *taskView;

@property (nonatomic, copy) NSString *placeTitle;

@property (nonatomic, copy) createTaskCallback taskSuccessBlock;
@end

@implementation ApplicationCreateNewMissionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *dissmissView = [UIView new];
    dissmissView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [dissmissView addGestureRecognizer:tap];
    [self.view addSubview:dissmissView];
    [dissmissView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.taskView];
    [self.taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(56, 5.5, 50, 5.5));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)handleDataWithNavigationController:(UINavigationController *)navigationController title:(NSString *)title completion:(createTaskCallback)completion {
    //去除emoji表情
	self.placeTitle = [title stringByRemovingEmoji];
    self.navigationVC = navigationController;
    self.taskSuccessBlock = completion;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Initializer
- (NewChatNewTaskView *)taskView {
    if (!_taskView) {
        __weak typeof(self) weakSelf = self;
        _taskView = [[NewChatNewTaskView alloc] initCreateNewTaskWithTitle:self.placeTitle block:^(MessageAppModel *appModel, ContactPersonDetailInformationModel *personModel) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            !strongSelf.taskSuccessBlock ?: strongSelf.taskSuccessBlock(appModel, personModel);
        }];
        
        _taskView.currentUserModel = self.currentUserModel;
        if (self.currentUserModel == nil) {
            _taskView.isGroupChat = YES;
            ContactPersonDetailInformationModel *myselfModel = [ContactPersonDetailInformationModel new];
            myselfModel.show_id = [[UnifiedUserInfoManager share] userShowID];
            myselfModel.u_true_name = [[UnifiedUserInfoManager share] userName];
            _taskView.currentUserModel = myselfModel;
        }
        _taskView.parentController = self;
        [_taskView moreOptions:^UINavigationController *{
            return weakSelf.navigationVC;
        }];
    }
    return _taskView;
}
@end

@implementation ApplicationCreateNewMissionNavigationController
@synthesize rootVC = _rootVC;
- (instancetype)init {
    ApplicationCreateNewMissionViewController *rootViewController = [[ApplicationCreateNewMissionViewController alloc] init];
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        _rootVC = rootViewController;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
}

@end
