//
//  PersonSpaceSettingAboutUsViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceSettingAboutUsViewController.h"

@interface PersonSpaceSettingAboutUsViewController ()

@end

@implementation PersonSpaceSettingAboutUsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"关于我们"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initContentView];
    //[self.navigationController.navigationBar setHidden:NO];
}

- (void)initContentView
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UILabel *lbProjectName = [[UILabel alloc] init];
    [lbProjectName setText:app_Name];
    [lbProjectName setText:@"聚悦健康"];
    [lbProjectName setFont:[UIFont systemFontOfSize:14]];
    [lbProjectName setTextColor:[UIColor commonTextColor]];
    [self.view addSubview:lbProjectName];
    
    UILabel *lbVersion = [[UILabel alloc] init];
    [lbVersion setText:[NSString stringWithFormat:@"版本号：V%@",app_Version]];
    [lbVersion setFont:[UIFont systemFontOfSize:14]];
    [lbVersion setTextColor:[UIColor commonTextColor]];
    [self.view addSubview:lbVersion];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor commonTextColor]];
    [self.view addSubview:lineView];
    
    UILabel *lbContent = [[UILabel alloc] init];
    [lbContent setNumberOfLines:0];
    [lbContent setText:@"健康管理平台是基于区域临床资源整合的O2O平台，以医疗健康服务为核心，基于健康大数据，为用户提供健康档案、随访、健康计划、健康评估等服务，整合导诊、咨询、挂号服务，打造院内院外闭环的医疗健康服务体系。我们有专业医生团队支撑，全情景感知的服务体验和保障，给用户提供个性化、持续化的健康管理服务。"];
    [lbContent setFont:[UIFont systemFontOfSize:12]];
    [lbContent setTextColor:[UIColor lightGrayColor]];
    [self.view addSubview:lbContent];
    
    //设置字体间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    
    //NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:lbContent.text attributes:@{NSKernAttributeName : @(1.5f)}];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lbContent.text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lbContent.text length])];
    [lbContent sizeToFit];
    lbContent.attributedText = attributedString;
    
    [lbProjectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [lbVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbProjectName.mas_bottom).with.offset(5);
        make.size.and.left.equalTo(lbProjectName);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbVersion.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(self.view.width, 1));
    }];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(lineView.mas_bottom).with.offset(5);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@140);
        
    }];
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

@end
