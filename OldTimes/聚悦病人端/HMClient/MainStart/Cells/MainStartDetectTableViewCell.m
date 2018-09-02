//
//  MainStartDetectTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartDetectTableViewCell.h"
#import "NewbieGuideInteractor.h"

@interface MainStartDetectTableViewCell ()
{
    UILabel* lbDetect;
    UIButton* detectbutton;
}
@end

@implementation MainStartDetectTableViewCell



- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbDetect = [[UILabel alloc]init];
        [self.contentView addSubview:lbDetect];
        [lbDetect setFont:[UIFont font_30]];
        [lbDetect setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbDetect setText:@"要坚持每天记录健康状况哦！"];
        
        detectbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detectbutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 44) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [self.contentView addSubview:detectbutton];
        [detectbutton setTitle:@"记录健康" forState:UIControlStateNormal];
        [detectbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [detectbutton.titleLabel setFont:[UIFont boldSystemFontOfSize:23]];
        
        //ic_home_add
        [detectbutton setImage:[UIImage imageNamed:@"ic_home_add"] forState:UIControlStateNormal];
        detectbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
        [detectbutton.layer setCornerRadius:30];
        detectbutton.layer.masksToBounds = YES;
        
        [detectbutton addTarget:self action:@selector(detectbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbDetect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(15);
    }];
    
    [detectbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(250, 60));
        make.bottom.equalTo(self.contentView);
    }];
}

- (void) detectbuttonClicked:(id) sender
{
    // 新手指引
    if (![NewbieGuideInteractor showedNewbieGuideWithType:NewbieGuidePageTypeAddBloodPressure]) {
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

        [NewbieGuideInteractor presentNewbieGuideWithGuideType:NewbieGuidePageTypeAddBloodPressure presentingViewController:rootViewController animated:NO];
    }

    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－记录健康"];
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyDetectStartViewController"ControllerObject:nil];
}
@end
