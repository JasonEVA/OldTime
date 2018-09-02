//
//  FoodVolumeSelectViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "FoodVolumeSelectViewController.h"
#import "NuritionFoodListView.h"

@interface FoodVolumeSelectViewController ()
<UIPickerViewDataSource,
UIPickerViewDelegate>
{
    UIPickerView* pickerview;
//    UIView* foodInfoView;
//    UIImageView* ivFood;
//    UILabel* lbFoodName;
    UIView* titleView;
    
    NSMutableArray* volumeStrings;
    
    FoodListItem* foodInfo;
}

@property (nonatomic, copy) FoodVolumeSelectBlock selectBlock;

- (id) initWithFoodItem:(FoodListItem*) food;
@end

@implementation FoodVolumeSelectViewController

+ (void) showInParentController:(UIViewController*) parentcontroller
                   FoodInfo:(FoodListItem*) foodInfo
          FoodVolumeSelectBlock:(FoodVolumeSelectBlock)block
{
    if (!parentcontroller || !foodInfo)
    {
        return;
    }
    
    FoodVolumeSelectViewController* vcFoodVolume = [[FoodVolumeSelectViewController alloc]initWithFoodItem:foodInfo];
    [parentcontroller addChildViewController:vcFoodVolume];
    [parentcontroller.view addSubview:vcFoodVolume.view];
    [vcFoodVolume.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentcontroller.view);
        make.top.and.bottom.equalTo(parentcontroller.view);
    }];
    
    [vcFoodVolume setSelectBlock:block];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self closeController];
}

- (id) initWithFoodItem:(FoodListItem*) food
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        foodInfo = food;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    volumeStrings = [NSMutableArray array];
    for (NSInteger index = 2; index < 50; ++index)
    {
        NSString* strVolume = [NSString stringWithFormat:@"%ld 克", index * 10];
        [volumeStrings addObject:strVolume];
    }
    [self createPickerView];
    [self createTitleView];
    [self createFoodItemInfoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createFoodItemInfoView{
    NuritionFoodListView *foodInfoView = [[NuritionFoodListView alloc] init];
    [foodInfoView setFood:foodInfo];
    [foodInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:foodInfoView];
    
    [foodInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(titleView.mas_top);
        make.height.mas_equalTo(@83);
    }];
}

- (void) createPickerView
{
    pickerview = [[UIPickerView alloc]init];
    [self.view addSubview:pickerview];
    [pickerview setBackgroundColor:[UIColor whiteColor]];
    
    [pickerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@230);
    }];
    
    [pickerview setDataSource:self];
    [pickerview setDelegate:self];
    
    [pickerview reloadAllComponents];
    [pickerview selectRow:8 inComponent:0 animated:NO];
}



- (void) createTitleView
{
    titleView = [[UIView alloc]init];
    [self.view addSubview:titleView];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(pickerview.mas_top);
        make.height.mas_equalTo(@40);
    }];
    
    UILabel* lbTitle = [[UILabel alloc]init];
    [titleView addSubview:lbTitle];
    [lbTitle setText:@"重量估算"];
    [lbTitle setTextColor:[UIColor commonTextColor]];
    [lbTitle setFont:[UIFont font_30]];
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleView);
    }];
    
    UIButton* cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleView addSubview:cancelbutton];
//    [cancelbutton setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    [cancelbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(titleView);
        make.left.equalTo(titleView).with.offset(10);
    }];
    [cancelbutton addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* confirmbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleView addSubview:confirmbutton];
//    [confirmbutton setImage:[UIImage imageNamed:@"icon_confirm"] forState:UIControlStateNormal];
    [confirmbutton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmbutton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    [confirmbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(titleView);
        make.right.equalTo(titleView).with.offset(-10);
    }];
    [confirmbutton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *estimateBtn = [[UIButton alloc] init];
    [estimateBtn setImage:[UIImage imageNamed:@"icon_question"] forState:UIControlStateNormal];
    [titleView addSubview:estimateBtn];
    [estimateBtn addTarget:self action:@selector(estimateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [estimateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.left.equalTo(lbTitle.mas_right).offset(2);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void) closeController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

//估算食物重量
- (void)estimateBtnClick{
    [self closeController];
    [HMViewControllerManager createViewControllerWithControllerName:@"NutritionDietEstimateViewController" ControllerObject:nil];
}

- (void) confirmButtonClicked:(id) sender
{
    NSInteger selIndex = [pickerview selectedRowInComponent:0];
    NSInteger volume = (selIndex + 2) * 10;
   
    if (_selectBlock)
    {
        _selectBlock(volume);
    }
    
    [self closeController];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (volumeStrings)
    {
        return volumeStrings.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return volumeStrings[row];
}
@end
