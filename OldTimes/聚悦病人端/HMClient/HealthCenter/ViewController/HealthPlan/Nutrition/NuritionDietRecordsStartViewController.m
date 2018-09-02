//
//  NuritionDietRecordsStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionDietRecordsStartViewController.h"
#import "HealthPlanDateSelectView.h"
#import "NuritionDietRecordsTableViewController.h"
#import "NuritionDetail.h"

@interface NuritionDietRecordsStartViewController ()
{
    HealthPlanDateSelectView* dateSelectView;
    UIView* appendButtonsView;
    NSMutableArray* buttons;
    
    NuritionDietRecordsTableViewController* tvcRecords;
}
@end

@implementation NuritionDietRecordsStartViewController

- (void) dealloc
{
    if (dateSelectView)
    {
        [dateSelectView removeObserver:self forKeyPath:@"date"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"饮食记录"];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    
    
    appendButtonsView = [[UIView alloc]init];
    [self.view addSubview:appendButtonsView];
    [appendButtonsView setBackgroundColor:[UIColor whiteColor]];
    [appendButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_offset(@45);
    }];
    
    [self createDateSelectView];
    [self createAppendButtons];
    
    [self createDietRecordsTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createDateSelectView
{
    dateSelectView = [[HealthPlanDateSelectView alloc]init];
    [self.view addSubview:dateSelectView];
    [dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(5);
        make.height.mas_equalTo(@40);
    }];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        NSString* dateStr = self.paramObject;
        NSDate* date = [NSDate dateWithString:dateStr formatString:@"yyyy-MM-dd"];
        [dateSelectView setDate:date];
    }
    [dateSelectView addObserver:self forKeyPath:@"date" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
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

- (void) createDietRecordsTable
{
    tvcRecords = [[NuritionDietRecordsTableViewController alloc]initWithDate:dateSelectView.date];
    [self addChildViewController:tvcRecords];
    [self.view addSubview:tvcRecords.tableView];
    [tvcRecords.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(appendButtonsView.mas_top);
        make.top.equalTo(dateSelectView.mas_bottom).with.offset(5);
    }];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"date"])
    {
        NSDate* date = dateSelectView.date;
        if (tvcRecords)
        {
            [tvcRecords setDate:date];
        }
    }
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
    NSDate* date = dateSelectView.date;
    NSString* dateStr = [date formattedDateWithFormat:@"yyyy-MM-dd"];
    [appendParam setDate:dateStr];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"NuritionAppendDietStartViewController" ControllerObject:appendParam];
}
@end
