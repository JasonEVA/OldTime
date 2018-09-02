//
//  SiteDetailViewController.m
//  HMClient
//
//  Created by jasonwang on 16/6/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SiteDetailViewController.h"
#import "SiteMessageReadedRequest.h"

@interface SiteDetailViewController ()<TaskObserver>
@property (strong ,nonatomic) UILabel *titelLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UITextView *myContentTextView;
//@property (nonatomic, strong) UIView *line;
//@property (nonatomic, strong) UIButton *toSeeSeeBtn;
@end

@implementation SiteDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"信息详情"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.titelLb setText:self.model.msgTitle];
    [self.timeLb setText:self.model.createTime];
    
//    NSDictionary *dict = [NSDictionary JSONValue:self.model.doThing];
//    NSString *contentString = [dict valueForKey:@"msg"];
    [self.myContentTextView setText:self.model.msgContent ? : @""];
    [self meeageReaded];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configElements];
}

#pragma mark -private method
- (void)configElements {
    [self.view addSubview:self.timeLb];
    [self.view addSubview:self.titelLb];
    //[self.view addSubview:self.line];
    //[self.view addSubview:self.toSeeSeeBtn];
    [self.view addSubview:self.myContentTextView];
    
    
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(15);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLb.mas_bottom).offset(15);
        make.right.equalTo(self.view).offset(-22);
    }];
    
//    [self.toSeeSeeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-15);
//        make.right.equalTo(self.view).offset(-14);
//        make.left.equalTo(self.view).offset(14);
//        make.height.equalTo(@45);
//    }];
//    
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.toSeeSeeBtn.mas_top).offset(-15);
//        make.height.equalTo(@0.5);
//    }];
    [self.myContentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLb.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(17);
        make.right.equalTo(self.view).offset(-17);
        make.bottom.equalTo(self.view).offset(-15);
    }];
}

- (void)meeageReaded
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%@",self.model.msgId] forKey:@"msgId"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([SiteMessageReadedRequest class]) taskParam:dict TaskObserver:self];
}
#pragma mark - TaskDelegate
- (void)task:(NSString *)taskId Result:(id)taskResult
{
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    
}

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (taskError == StepError_None) {return;}
    
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setText:@"西南医院联手推出免费体检活动"];
        [_titelLb setTextColor:[UIColor blackColor]];
        [_titelLb setFont:[UIFont systemFontOfSize:17]];
    }
    return _titelLb;
}
- (UILabel *)timeLb
{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb setText:@"2016-02-05"];
        [_timeLb setTextColor:[UIColor blackColor]];
        [_timeLb setFont:[UIFont systemFontOfSize:13]];
    }
    return _timeLb;
}
- (UITextView *)myContentTextView
{
    if (!_myContentTextView) {
        _myContentTextView = [UITextView new];
        [_myContentTextView setTextColor:[UIColor blackColor]];
        [_myContentTextView setFont:[UIFont systemFontOfSize:15]];
        [_myContentTextView setEditable:NO];
    }
    return _myContentTextView;
}
//- (UIView *)line
//{
//    if (!_line) {
//        _line = [UIView new];
//        [_line setBackgroundColor:[UIColor blackColor]];
//    }
//    return _line;
//}

//- (UIButton *)toSeeSeeBtn
//{
//    if (!_toSeeSeeBtn) {
//        _toSeeSeeBtn = [UIButton new];
//        [_toSeeSeeBtn setBackgroundColor:[UIColor mainThemeColor]];
//        [_toSeeSeeBtn setTitle:@"去看看" forState:UIControlStateNormal];
//    }
//    return _toSeeSeeBtn;
//}
@end
