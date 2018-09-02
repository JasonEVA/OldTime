//
//  AppointmentStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentStartViewController.h"
#import "AppointmentSelectStaffViewController.h"
#import "AppointmentSymptomInputViewController.h"
#import "AppointStaffModel.h"

@interface AppointmentStartViewController ()
<TaskObserver>
{
    
}

@property (nonatomic, strong) AppointmentSelectStaffViewController* staffSelectViewController;
@property (nonatomic, strong) AppointmentSymptomInputViewController* symptomInputViewController;
@property (nonatomic, strong) UIButton* appointbutton;
@property (nonatomic, strong) UILabel* noticeLabel;
@end

@implementation AppointmentStartViewController

- (void) dealloc
{
    if (self.staffSelectViewController) {
        [self.staffSelectViewController removeObserver:self forKeyPath:@"selectedStaff"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"约诊"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.symptomInputViewController.view setHidden:YES];
    [self.appointbutton setHidden:YES];
    [self.noticeLabel setHidden:YES];
    
    [self layoutElements];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements{
    [self.staffSelectViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(220);
    }];
    
    [self.symptomInputViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.staffSelectViewController.view.mas_bottom);
        make.height.mas_equalTo(220);
    }];
    
    [self.appointbutton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.symptomInputViewController.view.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@44);
    }];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.appointbutton.mas_bottom).with.offset(5);
    }];
}

- (void) appointmentButtonClicked:(id) sender
{
    AppointStaffModel *selectedStaff = self.staffSelectViewController.selectedStaff;
    if (!selectedStaff)
    {
        [self showAlertMessage:@"您还没有选择预约的医生，请选择预约的医生。"];
        return;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", selectedStaff.staffId] forKey:@"staffId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", selectedStaff.serviceDetId] forKey:@"serviceDetId"];
    
    if (self.symptomInputViewController.symptomText &&
        0 < self.symptomInputViewController.symptomText.length)
    {
        [dicPost setValue:self.symptomInputViewController.symptomText forKey:@"desc"];
    }

    if (self.symptomInputViewController.imageUrls)
    {
        [dicPost setValue:self.symptomInputViewController.imageUrls forKey:@"imgUrls"];
    }
    
    //测试
    //跳转到约诊成功界面
//    {
//        AppointStaffModel *selectedStaff = self.staffSelectViewController.selectedStaff;
//        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentSuccessViewController" ControllerObject:selectedStaff];
//        return;
//    }
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AppointmentApplyTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark settingAndGetting

- (AppointmentSelectStaffViewController*) staffSelectViewController{
    if(!_staffSelectViewController){
        _staffSelectViewController = [[AppointmentSelectStaffViewController alloc]init];
        [self addChildViewController:_staffSelectViewController];
        [self.view addSubview:_staffSelectViewController.view];
        
        [_staffSelectViewController addObserver:self forKeyPath:@"selectedStaff" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _staffSelectViewController;
}

- (AppointmentSymptomInputViewController*) symptomInputViewController{
    if(!_symptomInputViewController){
        _symptomInputViewController = [[AppointmentSymptomInputViewController alloc]init];
        [self addChildViewController:_symptomInputViewController];
        [self.view addSubview:_symptomInputViewController.view];
        
    }
    return _symptomInputViewController;
}

- (UIButton*) appointbutton{
    if(!_appointbutton)
    {
        _appointbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_appointbutton];
        [_appointbutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 44) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_appointbutton setTitle:@"立即预约" forState:UIControlStateNormal];
        [_appointbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_appointbutton.titleLabel setFont:[UIFont font_30]];
        
        _appointbutton.layer.cornerRadius = 2.5;
        _appointbutton.layer.masksToBounds = YES;
        [_appointbutton addTarget:self action:@selector(appointmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _appointbutton;
}

- (UILabel*) noticeLabel{
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc]init];
        [_noticeLabel setText:@"*温馨提示\n约诊成功后，会通知您具体的预约时间和地点"];
        [_noticeLabel setNumberOfLines:2];
        [_noticeLabel setTextColor:[UIColor commonLightGrayTextColor]];
        [_noticeLabel setFont:[UIFont font_20]];
        
        [self.view addSubview:_noticeLabel];
        
    }
    return _noticeLabel;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self.staffSelectViewController) {
        if ([keyPath isEqualToString:@"selectedStaff"]) {
            if (self.staffSelectViewController.selectedStaff) {
                [self.symptomInputViewController.view setHidden:NO];
                [self.appointbutton setHidden:NO];
                [self.noticeLabel setHidden:NO];
            }
        }
    }
}
  

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"AppointmentApplyTask"])
    {
        //跳转到我的约诊列表
//        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentListViewController" ControllerObject:nil];
        
        //跳转到约诊成功界面  AppointmentSuccessViewController
        AppointStaffModel *selectedStaff = self.staffSelectViewController.selectedStaff;
        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentSuccessViewController" ControllerObject:selectedStaff];
    }
}

@end
