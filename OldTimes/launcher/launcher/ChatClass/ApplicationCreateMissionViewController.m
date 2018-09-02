//
//  ApplicationCreateMissionViewController.m
//  launcher
//
//  Created by williamzhang on 15/12/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCreateMissionViewController.h"
#import <Masonry/Masonry.h>
#import "ChatNewTaskView.h"

@interface ApplicationCreateMissionViewController ()

@property (nonatomic, strong) UINavigationController *navigationVC;

@property (nonatomic, strong) ChatNewTaskView *taskView;

@property (nonatomic, copy) NSString *placeTitle;

@property (nonatomic, copy) createTaskCallback taskSuccessBlock;

@end

@implementation ApplicationCreateMissionViewController

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
    self.placeTitle = title;
    self.navigationVC = navigationController;
    self.taskSuccessBlock = completion;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Initializer
- (ChatNewTaskView *)taskView {
    if (!_taskView) {
        __weak typeof(self) weakSelf = self;
        _taskView = [[ChatNewTaskView alloc] initCreateNewTaskWithTitle:self.placeTitle block:^(MessageAppModel *appModel, ContactPersonDetailInformationModel *personModel) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            !strongSelf.taskSuccessBlock ?: strongSelf.taskSuccessBlock(appModel, personModel);
        }];
        
        _taskView.currentUserShowId = self.currentUserShowId;
        if (self.currentUserShowId == nil) {
            _taskView.isGroupChat = YES;
        }
        _taskView.parentController = self;
        [_taskView moreOptions:^UINavigationController *{
            return weakSelf.navigationVC;
        }];
    }
    return _taskView;
}

@end

@implementation ApplicationCreateMissionNavigationController
@synthesize rootVC = _rootVC;
- (instancetype)init {
    ApplicationCreateMissionViewController *rootViewController = [[ApplicationCreateMissionViewController alloc] init];
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