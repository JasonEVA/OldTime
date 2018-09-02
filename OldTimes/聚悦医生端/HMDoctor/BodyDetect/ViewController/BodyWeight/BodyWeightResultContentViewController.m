//
//  BodyWeightResultContentViewController.m
//  HMClient
//
//  Created by lkl on 16/4/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightResultContentViewController.h"
#import "BodyWeightResultDetectTimeView.h"
#import "BodyWeightResultView.h"
#import "BodyWeightSuggestView.h"

@interface BodyWeightResultContentViewController ()
{
    BodyWeightResultDetectTimeView* timeview;
    BodyWeightResultView* resultview;
    BodyWeightSuggestView* suggestionview;
}
@end

@implementation BodyWeightResultContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
    
    timeview = [[BodyWeightResultDetectTimeView alloc]init];
    [self.view addSubview:timeview];

    resultview = [[BodyWeightResultView alloc]init];
    [self.view addSubview:resultview];
    
    suggestionview = [[BodyWeightSuggestView alloc]init];
    [self.view addSubview:suggestionview];
    
    [self subviewLayout];
    /*
    if (self.paramObject && [self.paramObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicRecord = (NSDictionary*) self.paramObject;
        
        //测试数据
        BodyWeightDetectResult* result = [BodyWeightDetectResult mj_objectWithKeyValues:dicRecord];
        [result setUserHealthySuggest:@"您属于标准体重，请继续保持健康的生活方式。"];
        [self detectResultLoaded:result];
    }
     */
}

- (NSString*) resultTaskName
{
    return @"BodyWeightDetectResultTask";
}


- (void) subviewLayout
{
    [timeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [resultview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@175);
        make.top.equalTo(timeview.mas_bottom).with.offset(5);
    }];
    
    [suggestionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(resultview.mas_bottom).with.offset(5);
        
    }];
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    if (!detectResult || 0 == detectResult.userId) {
        return;
    }
    [targetUser setUserId:detectResult.userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightRecordsStartViewController" ControllerObject:targetUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) detectResultLoaded:(DetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    BodyWeightDetectResult* weightResult = (BodyWeightDetectResult*)result;
    [timeview setDetectResult:weightResult];
    [resultview setDetectResult:weightResult];
    [suggestionview setDetectResult:weightResult];
}

@end
