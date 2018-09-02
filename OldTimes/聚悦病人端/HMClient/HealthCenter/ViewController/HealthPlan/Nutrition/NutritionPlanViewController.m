//
//  NutritionViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NutritionPlanViewController.h"
#import "NutritionPlanTableViewController.h"
#import "NuritionDetail.h"

@interface NutritionPlanViewController ()
{
    UIView* appendButtonsView;
    NSMutableArray* buttons;
    
    NutritionPlanTableViewController* tvcNutritionPlan;
}
@end

@implementation NutritionPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    appendButtonsView = [[UIView alloc]init];
    [self.view addSubview:appendButtonsView];
    [appendButtonsView setBackgroundColor:[UIColor whiteColor]];
    [appendButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_offset(@45);
    }];
    
    [self createAppendButtons];
    
    [self createNutriationTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createAppendButtons
{
    buttons = [NSMutableArray array];
    NSArray* titles = @[@"＋早餐", @"＋午餐", @"＋晚餐", @"＋加餐"];
    MASViewAttribute* leftAttr = appendButtonsView.mas_left;
    
    for (NSString* title in titles)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [appendButtonsView addSubview:button];
        [button setBackgroundImage:[UIImage rectImage:CGSizeMake(80, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont font_30]];
        [button addTarget:self action:@selector(appendDietBttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftAttr);
            make.top.and.bottom.equalTo(appendButtonsView);
            if (0 < buttons.count)
            {
                UIButton* perButton = [buttons lastObject];
                make.width.equalTo(perButton);
            }
            if (title == [titles lastObject])
            {
                make.right.equalTo(appendButtonsView.mas_right);
            }
            [buttons addObject:button];

        }];
        //leftAttr = button.mas_right;
        if (0 < buttons.count)
        {
            if (title != titles.lastObject)
            {
                //UIButton* perButton = [buttons lastObject];
                UIView* lineview = [[UIView alloc]init];
                [appendButtonsView addSubview:lineview];
                [lineview setBackgroundColor:[UIColor whiteColor]];
                
                [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.and.bottom.equalTo(appendButtonsView);
                    make.left.equalTo(button.mas_right);
                    make.width.mas_equalTo(@0.5);
                }];
                leftAttr = lineview.mas_right;
                 
               
            }
        }
    }
}

- (void) createNutriationTable
{
    tvcNutritionPlan = [[NutritionPlanTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcNutritionPlan];
    [self.view addSubview:tvcNutritionPlan.tableView];
    [tvcNutritionPlan.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(5);
        make.bottom.equalTo(appendButtonsView.mas_top);
    }];
}

- (void) appendDietBttonClicked:(id) sender
{
    NSInteger selIndex = [buttons indexOfObject:sender];
    if (NSNotFound == selIndex)
    {
        return;
    }
    
    NuritionDietAppendParam* appendParam = [[NuritionDietAppendParam alloc]init];
    [appendParam setDietType:selIndex + 1];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"NuritionAppendDietStartViewController" ControllerObject:appendParam];
}
@end
