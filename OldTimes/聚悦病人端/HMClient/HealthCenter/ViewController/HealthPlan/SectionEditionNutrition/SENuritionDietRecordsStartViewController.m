//
//  SENuritionDietRecordsStartViewController.m
//  HMClient
//
//  Created by lkl on 2017/8/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SENuritionDietRecordsStartViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "SENutritionDietPhotoView.h"
#import "HMPhotoPickerManager.h"
#import "NuritionFoodListTableViewController.h"
#import "HMWebViewController.h"
#import "ClientHelper.h"
#import "HealthPlanDateSelectView.h"
#import "NutritionDietRecord.h"
#import "DeviceTestTimeSelectView.h"

@interface SENuritionDietRecordsStartViewController () <TaskObserver,NuritionFoodListDelegate,SENutritionDietPhotoViewDelegate>
{
    NuritionFoodListTableViewController *tvcFood;
}
@property (nonatomic, strong) HealthPlanSENavTitleView *helthPlanNavView;
@property(nonatomic, strong) UIView  *comPickerview;

@property (nonatomic, strong) HealthPlanSEAddDietView *addDietView;
@property (nonatomic, strong) SENutritionDietPhotoView *dietPhotoView;
@property (nonatomic, strong) NSMutableArray *picUrls;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, copy) NSString *userDietId;
@end

@implementation SENuritionDietRecordsStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setFd_prefersNavigationBarHidden:YES];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self configElements];
    
    NSString *dateStr = _helthPlanNavView.dateLb.text;
    NSString *dietType = _addDietView.dietType;
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:dateStr forKey:@"date"];
    [dicPost setValue:dietType forKey:@"dietTime"];
    
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NutritionGetDietBeanTask" taskParam:dicPost TaskObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (!vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

#pragma mark - Interface Method

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    [self.view addSubview:self.helthPlanNavView];
    [self.view addSubview:self.addDietView];
    [self.view addSubview:self.dietPhotoView];
    
    [self.helthPlanNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(@64);
    }];
    
    [self.addDietView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.helthPlanNavView.mas_bottom);
        make.height.mas_equalTo(@160);
    }];
    
    [self.dietPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.addDietView.mas_bottom);
        make.height.mas_equalTo(@80);
    }];

    tvcFood = [[NuritionFoodListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcFood];
    [self.view addSubview:tvcFood.tableView];
    [tvcFood setSelectDelegate:self];
    [tvcFood.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.dietPhotoView.mas_bottom).with.offset(5);
    }];
    
    [self.view addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
}

#pragma mark - Event Response
//=====================导航栏事件=====================
- (void)backBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkForOnce {
    if (self.comPickerview) {
        [self.comPickerview removeFromSuperview];
        self.comPickerview = nil;
    }
}

- (void)timeControlClick:(UIControl *)sender{
    [sender removeFromSuperview];
    sender = nil;
}

//日期选择
- (void)helthPlanNavViewDateLbClick{
    
    [self.view endEditing:YES];
    [self checkForOnce];
    
    UIControl *timeControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:timeControl];
    [timeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    [timeControl addTarget:self action:@selector(timeControlClick:) forControlEvents:UIControlEventTouchUpInside];
    
    DeviceTestTimeSelectView *timePickerView = [[DeviceTestTimeSelectView alloc] init];
    self.comPickerview = timePickerView;
    [timePickerView setBackgroundColor:[UIColor whiteColor]];
    [timePickerView setDateModel:UIDatePickerModeDate];
    [timePickerView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        [_helthPlanNavView setDate:selectedTime];
    }];
    [timeControl addSubview:timePickerView];
    
    [timePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@160);
    }];
    [timePickerView setDate:_helthPlanNavView.date ? :[NSDate date]];
}


//饮食记录
- (void)dietRecordBtnClick{
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSString *urlStr = [NSString stringWithFormat:@"%@/liferecord.htm?vType=YH&userId=%ld&type=1",kZJKHealthDataBaseUrl,curUser.userId];
    
    HMWebViewController *webVC = [[HMWebViewController alloc] initWithUrlString:urlStr titelString:@"饮食记录"];
    [self.navigationController pushViewController:webVC animated:YES];
}

//数据上传
- (void)saveNutritionDietBtnClick
{
    NSString *date = _helthPlanNavView.dateLb.text;
    NSString *dietType = _addDietView.dietType;
    NSString *dietDesc = _addDietView.tvFood.text;
    
    if (dietDesc.length >= 150) {
        [self at_postError:@"最多150个字"];
        return;
    }
    
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:date forKey:@"date"];
    [dicPost setValue:dietType forKey:@"dietType"];
    
    if (!kStringIsEmpty(dietDesc)) {
        [dicPost setValue:dietDesc forKey:@"dietDesc"];
    }
    
    if (!kArrayIsEmpty(self.picUrls)) {
        [dicPost setValue:self.picUrls forKey:@"foodPicUrls"];
    }
    
    if (!kStringIsEmpty(self.userDietId)) {
        [dicPost setValue:self.userDietId forKey:@"userDietId"];
    }
    
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NutritionAddDietTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - SENutritionDietPhotoViewDelegate

- (void)hm_addImage
{
    [_addDietView.tvFood resignFirstResponder];
    
    [[HMPhotoPickerManager shareInstance] addTarget:self showImageViewSelcteWithResultBlock:^(UIImage *img) {
        
        //上传图片
        NSData *imageData = UIImageJPEGRepresentation(img, 1);
        [self at_postLoading:@"正在上传"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"NutritionImageUploadTask" taskParam:nil extParam:imageData TaskObserver:self];
    }];
}

- (void)hm_deleteImage:(NSInteger)flag
{
    if (kArrayIsEmpty(self.picUrls)) {
        return;
    }
    [self.picUrls removeObjectAtIndex:flag];
}

#pragma mark - NuritionFoodListDelegate
- (void)popupFoodVolumeSelectVC{
    [_addDietView.tvFood resignFirstResponder];
}

- (void) foodAndNumSelected:(FoodListItem *) food
                        Num:(NSInteger) num
{
    NSString *foodDesc;
    if (kStringIsEmpty(_addDietView.tvFood.text)) {
        foodDesc = [_addDietView.tvFood.text stringByAppendingString:[NSString stringWithFormat:@"%ld克%@",num,food.name]];
    }
    else{
        foodDesc = [_addDietView.tvFood.text stringByAppendingString:[NSString stringWithFormat:@", %ld克%@",num,food.name]];
    }
    [_addDietView setFoodTextView:foodDesc placeholder:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Override

#pragma mark - Action
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"date"] || [keyPath isEqualToString:@"dietType"])
    {
        NSString *dateStr = _helthPlanNavView.dateLb.text;
        NSString *dietType = _addDietView.dietType;
        
        NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:dateStr forKey:@"date"];
        [dicPost setValue:dietType forKey:@"dietTime"];
        
        [self at_postLoading];
        [[TaskManager shareInstance] createTaskWithTaskName:@"NutritionGetDietBeanTask" taskParam:dicPost TaskObserver:self];
    }
}

#pragma mark - Init

- (HealthPlanSENavTitleView *)helthPlanNavView{
    if (!_helthPlanNavView) {
        _helthPlanNavView = [[HealthPlanSENavTitleView alloc] init];
        [_helthPlanNavView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_helthPlanNavView.dietRecordBtn addTarget:self action:@selector(dietRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        __weak typeof(self) weakSelf = self;
        _helthPlanNavView.clickBlock = ^{
            [weakSelf at_postError:@"已经是当前日期"];
        };
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helthPlanNavViewDateLbClick)];
        [_helthPlanNavView.dateLb addGestureRecognizer:labelTapGestureRecognizer];
        _helthPlanNavView.dateLb.userInteractionEnabled = YES;
        
        [_helthPlanNavView addObserver:self forKeyPath:@"date" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

    }
    return _helthPlanNavView;
}

- (HealthPlanSEAddDietView *)addDietView{
    if (!_addDietView) {
        _addDietView = [[HealthPlanSEAddDietView alloc] init];
        _addDietView.ownViewController = self;
        [_addDietView addObserver:self forKeyPath:@"dietType" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _addDietView;
}

- (SENutritionDietPhotoView *)dietPhotoView{
    if (!_dietPhotoView) {
        _dietPhotoView = [[SENutritionDietPhotoView alloc] init];
        _dietPhotoView.delegate = self;
    }
    return _dietPhotoView;
}

- (NSMutableArray *)picUrls{
    if (!_picUrls) {
        _picUrls = [NSMutableArray array];
    }
    return _picUrls;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton new];
        [_saveBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn.titleLabel setFont:[UIFont font_28]];
        [_saveBtn addTarget:self action:@selector(saveNutritionDietBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self at_hideLoading];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length) {
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"NutritionImageUploadTask"])
    {
        NSString *imageUrl = [taskResult valueForKey:@"picUrl"];
        if (imageUrl) {
            [self.picUrls addObject:imageUrl];
            [_dietPhotoView.phonelist addObject:imageUrl];
            [_dietPhotoView resetLayout];
        }
    }
    
    if ([taskname isEqualToString:@"NutritionGetDietBeanTask"]) {
        
        //初始化，清除图片和饮食
        [_dietPhotoView delAllPhotos];
        [self.picUrls removeAllObjects];
        [_addDietView setFoodTextView:@"" placeholder:YES];
        
        self.userDietId = @"";
        
        if (taskResult && [taskResult isKindOfClass:[NutritionDietBeanModel class]]) {
            
            NutritionDietBeanModel *beanModel = taskResult;
            self.userDietId = beanModel.userDietId;
            
            if (!kArrayIsEmpty(beanModel.foodPicUrls)) {
                [_dietPhotoView reloadPhotos:beanModel.foodPicUrls];
                [self.picUrls addObjectsFromArray:beanModel.foodPicUrls];
            }
            
            if (!kStringIsEmpty(beanModel.dietDesc)) {
                [_addDietView setFoodTextView:beanModel.dietDesc placeholder:NO];
            }
        }
    }
    
    //上传数据
    if ([taskname isEqualToString:@"NutritionAddDietTask"]) {
        
        [self at_postSuccess:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
