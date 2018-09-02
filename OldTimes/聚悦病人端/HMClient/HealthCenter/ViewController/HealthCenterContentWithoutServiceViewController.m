//
//  HealthCenterContentWithoutServiceViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterContentWithoutServiceViewController.h"

@interface HealthCenterContentWithoutServiceHeaderView : UIView
{
    UILabel* lbDesc;
    UIButton* purchasebutton;
}
@end

@implementation HealthCenterContentWithoutServiceHeaderView

- (id) init
{
    self = [super init];
    if (self)
    {
        lbDesc = [[UILabel alloc]init];
        [self addSubview:lbDesc];
        [lbDesc setText:@"您还没有购买服务套餐"];
        [lbDesc setFont:[UIFont font_30]];
        [lbDesc setTextColor:[UIColor commonGrayTextColor]];
        [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(12.5);
        }];
        
        purchasebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:purchasebutton];
        purchasebutton.layer.borderWidth = 0.5;
        purchasebutton.layer.borderColor = [UIColor mainThemeColor].CGColor;
        purchasebutton.layer.cornerRadius = 2.5;
        purchasebutton.layer.masksToBounds = YES;
        
        [purchasebutton setTitle:@"购买套餐" forState:UIControlStateNormal];
        [purchasebutton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [purchasebutton.titleLabel setFont:[UIFont font_28]];
        [purchasebutton addTarget:self action:@selector(purchasebuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [purchasebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
        
        [self showBottomLine];
    }
    return self;
}

- (void) purchasebuttonClicked:(id) sender
{
    //跳转到购买服务界面
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
}

@end

@interface HealthCenterContentWithoutServiceDescCell : UIView
{
    UIImageView* ivIcon;
    UILabel* lbDesc;
}
- (id) initWithImage:(UIImage*) icon
                Desc:(NSString*) desc;
@end

@implementation HealthCenterContentWithoutServiceDescCell

- (id) initWithImage:(UIImage*) icon
                Desc:(NSString*) desc
{
    self = [super init];
    if (self)
    {
        ivIcon = [[UIImageView alloc]init];
        [self addSubview:ivIcon];
        [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];
        [ivIcon setImage:icon];
        
        lbDesc = [[UILabel alloc]init];
        [self addSubview:lbDesc];
        [lbDesc setText:desc];
        [lbDesc setFont:[UIFont font_30]];
        [lbDesc setTextColor:[UIColor blackColor]];
        [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(ivIcon.mas_right).with.offset(10);
            make.right.lessThanOrEqualTo(self).with.offset(-12.5);
        }];

        [self showBottomLine];
    }
    return self;
}

@end

@interface HealthCenterContentWithoutServiceViewController ()
{
    HealthCenterContentWithoutServiceHeaderView* headerview;
}
@end

@implementation HealthCenterContentWithoutServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) createSubviews
{
    headerview = [[HealthCenterContentWithoutServiceHeaderView alloc]init];
    [self.view addSubview:headerview];
    [headerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    NSArray* icons = @[[UIImage imageNamed:@"icon_health_center_no_buy1"], [UIImage imageNamed:@"icon_health_center_no_buy2"], [UIImage imageNamed:@"icon_health_center_no_buy3"], [UIImage imageNamed:@"icon_health_center_no_buy4"]];
    NSArray* descs = @[@"三甲医院为依托，知名专家带队", @"医生主动问候，时时关注您的健康", @"用药，营养，运动，心理，生活全面指导", @"就诊绿色通道，省时，省心"];
    
    NSMutableArray* cells = [NSMutableArray array];
    
    
    for (NSInteger index = 0; index < icons.count; ++index)
    {
        UIImage* icon = icons[index];
        NSString* desc = descs[index];
        
        HealthCenterContentWithoutServiceDescCell* cell = [[HealthCenterContentWithoutServiceDescCell alloc]initWithImage:icon Desc:desc];
        [self.view addSubview:cell];
        [cells addObject:cell];
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.height.mas_equalTo(@45);
            //make.bottom.equalTo(cellbottom);
            if (cell == [cells firstObject])
            {
                make.top.equalTo(headerview.mas_bottom);
            }
            else
            {
                HealthCenterContentWithoutServiceDescCell* perCell = cells[index-1];
                make.top.equalTo(perCell.mas_bottom);
            }
        }];
        
        //cellbottom = cell.mas_bottom;
    }
}
@end
