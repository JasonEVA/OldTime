//
//  HMSetNewTargetWeightViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/8/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSetNewTargetWeightViewController.h"
#import "DYScrollRulerView.h"
#import "UIImage+EX.h"
#import "HMIdealWeightViewController.h"
#import "HMGroupPKMainViewController.h"

#define RULERVIEWHEIGHT        85
#define RULERVIEWWIDTH         ScreenWidth

@interface HMSetNewTargetWeightViewController ()<DYScrollRulerDelegate,TaskObserver>
@property (nonatomic, strong)DYScrollRulerView *rulerView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic) HMGroupPKSetTatgetWeightStep stepType;

@property (nonatomic, copy) NSString *titel;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *btnString;
@property (nonatomic) CGFloat rulerMax;
@property (nonatomic) CGFloat step;
@property (nonatomic) CGFloat rulerDefaultValue;
@property (nonatomic) BOOL rulerIsFixedCount;   // 是否保留小数

@property (nonatomic, copy) NSString *stepImageName;
@end

@implementation HMSetNewTargetWeightViewController

- (instancetype)initWithType:(HMGroupPKSetTatgetWeightStep)type nowWeight:(CGFloat)nowWeight
{
    self = [super init];
    if (self) {
        self.stepType = type;
        self.selectedNowWeight = nowWeight;
        [self configVCWithType:self.stepType];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置理想体重"];
    [self.view addSubview:self.rulerView];

    UILabel *setTargetWightLb = [UILabel new];
    [setTargetWightLb setFont:[UIFont systemFontOfSize:18]];
    [setTargetWightLb setText:self.titel];
    [setTargetWightLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    
    [self.view addSubview:setTargetWightLb];
    
    [setTargetWightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.rulerView.mas_top);
    }];
    
    
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(15);
        make.height.equalTo(@45);
    }];
    
    UIImageView *stepImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.stepImageName]];
    [self.view addSubview:stepImageView];
    
    [stepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_top).offset(90);
    }];
    

    // Do any additional setup after loading the view.
}


- (void)startUploadRequest {
    
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dicPost setValue:[NSString stringWithFormat:@"%.2f",self.selectedNowHeight / 100] forKey:@"height"];
    [dicPost setValue:[NSString stringWithFormat:@"%.1f",self.selectedNowWeight] forKey:@"initValue"];
    [dicPost setValue:[NSString stringWithFormat:@"%.1f",self.selectedTarget] forKey:@"aimValue"];
    [self at_postLoading];
    [[TaskManager shareInstance]createTaskWithTaskName:@"HMUploadTargetWeightRequest" taskParam:dicPost TaskObserver:self];

}

- (void)configVCWithType:(HMGroupPKSetTatgetWeightStep)type {
    switch (type) {
        case HMGroupPKSetTatgetWeightStep_oneHeight:
        {// 第一步
            self.titel = @"当前身高";
            self.unit = @"cm";
            self.rulerMax = 250;
            self.step = 1;
            self.btnString = @"下一步";
            self.rulerDefaultValue = 170;
            self.selectedNowHeight = 170;
            self.stepImageName = @"ic_one";
            self.rulerIsFixedCount = NO;
            break;
        }
        case HMGroupPKSetTatgetWeightStep_twoNowWeight:
        {// 第二步
            self.titel = @"当前体重";
            self.unit = @"kg";
            self.rulerMax = 200;
            self.step = 0.1;
            self.btnString = @"下一步";
            self.rulerDefaultValue = 50;
            self.selectedNowWeight = 50;
            self.stepImageName = @"ic_two";

            self.rulerIsFixedCount = YES;
            break;
        }
        case HMGroupPKSetTatgetWeightStep_threeTargetWeight:
        {// 第三步
            self.titel = @"设置理想体重";
            self.unit = @"kg";
            self.rulerMax = 200;
            self.step = 0.1;
            self.btnString = @"完成";
            self.rulerDefaultValue = self.selectedNowWeight;
            self.selectedTarget = self.selectedNowWeight;
            self.stepImageName = @"ic_three";

            self.rulerIsFixedCount = YES;
            break;
        }
        default:
            break;
    }
}

- (void)btnClick {
    if (self.rulerView.collectionView.isDecelerating) {
        return;
    }
    switch (self.stepType) {
        case HMGroupPKSetTatgetWeightStep_oneHeight:
        {// 第一步
            HMSetNewTargetWeightViewController *VC = [[HMSetNewTargetWeightViewController alloc] initWithType:HMGroupPKSetTatgetWeightStep_twoNowWeight nowWeight:0];
            VC.selectedNowHeight = self.selectedNowHeight;
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case HMGroupPKSetTatgetWeightStep_twoNowWeight:
        {// 第二步
            HMSetNewTargetWeightViewController *VC = [[HMSetNewTargetWeightViewController alloc] initWithType:HMGroupPKSetTatgetWeightStep_threeTargetWeight nowWeight:self.selectedNowWeight];
            VC.selectedNowHeight = self.selectedNowHeight;
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case HMGroupPKSetTatgetWeightStep_threeTargetWeight:
        {// 第三步
            [self startUploadRequest];
            NSLog(@"上传身高%f 当前体重 %f 理想体重 %f",self.selectedNowHeight,self.selectedNowWeight,self.selectedTarget);
            break;
        }
        default:
            break;
    }

   
}

#pragma mark - YKScrollRulerDelegate
-(void)dyScrollRulerView:(DYScrollRulerView *)rulerView valueChange:(float)value{
    switch (self.stepType) {
        case HMGroupPKSetTatgetWeightStep_oneHeight:
        {// 第一步
            self.selectedNowHeight = value;
            break;
        }
        case HMGroupPKSetTatgetWeightStep_twoNowWeight:
        {// 第二步
            self.selectedNowWeight = value;
            
            break;
        }
        case HMGroupPKSetTatgetWeightStep_threeTargetWeight:
        {// 第三步
            self.selectedTarget = value;
            if (value > self.selectedNowWeight) {
                [self.rulerView setRealValue:self.selectedNowWeight * 10 animated:NO];
                [self showAlertMessage:@"您已经到达理想体重，无需瘦身了！"];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMUploadTargetWeightRequest"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:upLoadWeightSuccessNotification object:nil];
        
        for (UIViewController *temp in [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects])
        {
            if ([temp isKindOfClass:[HMIdealWeightViewController class]])
            {
                [self.navigationController popToViewController:temp animated:NO];
            }
            else if ([temp isKindOfClass:[HMGroupPKMainViewController class]]) {
                [self.navigationController popToViewController:temp animated:NO];
            }
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(DYScrollRulerView *)rulerView{
    if (!_rulerView) {
        NSString *unitStr = self.unit;
        CGFloat rullerHeight = [DYScrollRulerView rulerViewHeight];
        _rulerView = [[DYScrollRulerView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - rullerHeight)/2 - 50, ScreenWidth, rullerHeight) theMinValue:0 theMaxValue:self.rulerMax theStep:self.step theUnit:unitStr theNum:10];
        _rulerView.isFixedCount = self.rulerIsFixedCount;
        [_rulerView setDefaultValue:self.rulerDefaultValue animated:YES];
        _rulerView.bgColor = [UIColor colorWithHexString:@"ffdb0c"];
        _rulerView.triangleColor   = [UIColor whiteColor];
        _rulerView.delegate        = self;
        _rulerView.scrollByHand    = YES;
    }
    return _rulerView;
}


- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        [_button.layer setCornerRadius:2];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_button setTitle:self.btnString forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
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
