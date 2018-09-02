//
//  NewSiteMeaageRoundsDetailViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/1/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMeaageRoundsDetailViewController.h"
@interface NewSiteMeaageRoundsDetailViewController ()
@property (nonatomic, strong) NewSiteMessageRoundsModel *model;

@end

@implementation NewSiteMeaageRoundsDetailViewController

- (instancetype)initWithModel:(NewSiteMessageRoundsModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"回复详情"];
    UIView *backView = [UIView new];
    [backView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewSite_face"]];
    [backView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(backView).offset(40);
    }];
    
    UILabel *askResult = [UILabel new];
    [askResult setTextColor:[UIColor mainThemeColor]];
    [askResult setFont:[UIFont systemFontOfSize:24]];
    [askResult setText:@"没有症状"];
    [backView addSubview:askResult];
    
    [askResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
    }];

    UILabel *titelLb = [UILabel new];
    [titelLb setText:@"感谢您的配合,祝您新的一天生活愉快!"];
    [titelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    [titelLb setFont:[UIFont systemFontOfSize:14]];
    [titelLb setTextAlignment:NSTextAlignmentCenter];
    [backView addSubview:titelLb];
    
    [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(askResult.mas_bottom).offset(15);
        make.centerX.equalTo(backView);
        make.bottom.equalTo(backView).offset(-40);
    }];
    
        // Do any additional setup after loading the view.
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
