//
//  AppointmentDealViewController.m
//  HMDoctor
//
//  Created by lkl on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AppointmentDealViewController.h"
#import "AppointmentInfo.h"

@interface ApplayInfoView ()
{
    UILabel *lbProposer;
    UILabel *lbapplyTime;
    UILabel *lbapplyDoctor;
    UILabel *lbProposerValue;
    UILabel *lbapplyTimeValue;
    UILabel *lbapplyDoctorValue;
}
@end

@implementation ApplayInfoView
- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbProposer = [[UILabel alloc] init];
        [self addSubview:lbProposer];
        [lbProposer setText:@"申请人:"];
        [lbProposer setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbProposer setFont:[UIFont systemFontOfSize:15]];

        lbProposerValue = [[UILabel alloc] init];
        [self addSubview:lbProposerValue];
        [lbProposerValue setTextColor:[UIColor commonTextColor]];
        [lbProposerValue setFont:[UIFont systemFontOfSize:15]];

        lbapplyTime = [[UILabel alloc] init];
        [self addSubview:lbapplyTime];
        [lbapplyTime setText:@"申请时间:"];
        [lbapplyTime setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbapplyTime setFont:[UIFont systemFontOfSize:15]];

        lbapplyTimeValue = [[UILabel alloc] init];
        [self addSubview:lbapplyTimeValue];
        [lbapplyTimeValue setTextColor:[UIColor commonTextColor]];
        [lbapplyTimeValue setFont:[UIFont systemFontOfSize:15]];

        lbapplyDoctor = [[UILabel alloc] init];
        [self addSubview:lbapplyDoctor];
        [lbapplyDoctor setText:@"申请医生:"];
        [lbapplyDoctor setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbapplyDoctor setFont:[UIFont systemFontOfSize:15]];

        
        lbapplyDoctorValue = [[UILabel alloc] init];
        [self addSubview:lbapplyDoctorValue];
        [lbapplyDoctorValue setTextColor:[UIColor commonTextColor]];
        [lbapplyDoctorValue setFont:[UIFont systemFontOfSize:15]];
        
        [self subViewsLayout];

    }
    return self;
}

- (void)subViewsLayout
{
    [lbProposer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(self).with.offset(10);
    }];
    
    [lbProposerValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbProposer.mas_right).with.offset(2);
        make.top.equalTo(lbProposer);
    }];
    
    [lbapplyTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(lbProposer.mas_bottom).with.offset(5);
    }];
    
    [lbapplyTimeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbapplyTime.mas_right).with.offset(2);
        make.top.equalTo(lbapplyTime);
        //make.size.mas_equalTo(CGSizeMake(150, 20));
        make.right.lessThanOrEqualTo(self).with.offset(-12.5);
    }];
    
    [lbapplyDoctor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(lbapplyTime.mas_bottom).with.offset(5);
    }];
    [lbapplyDoctorValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbapplyDoctor.mas_right).with.offset(2);
        make.top.equalTo(lbapplyDoctor);
    }];
}

- (void)setApplayInfo:(AppointmentInfo *)appointInfo
{
    [lbProposerValue setText:appointInfo.userName];
    [lbapplyTimeValue setText:appointInfo.createTime];
    [lbapplyDoctorValue setText:appointInfo.staffName];
}


@end



@interface AppointmentDealViewController ()

@end

@implementation AppointmentDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"约诊处理"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[AppointmentInfo class]])
    {
        appointInfo = (AppointmentInfo*) self.paramObject;
    }
    
    [self applyInfoSubViews];
}

- (void)applyInfoSubViews
{
    applyInfoView = [[ApplayInfoView alloc] init];
    [self.view addSubview:applyInfoView];
    [applyInfoView setBackgroundColor:[UIColor whiteColor]];
    [applyInfoView setApplayInfo:appointInfo];
    
    [applyInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.mas_equalTo(@15);
        make.height.mas_equalTo(@85);
    }];
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:confirmBtn];
    [confirmBtn setBackgroundColor:[UIColor mainThemeColor]];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.height.mas_equalTo(@45);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
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
