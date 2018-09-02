//
//  NewbieGuideAddPressureVCFive.m
//  HMClient
//
//  Created by Andrew Shen on 2016/11/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewbieGuideAddPressureVCFive.h"
#import "BodyDetectUniversalPickerView.h"

@interface NewbieGuideAddPressureVCFive ()

@end

@implementation NewbieGuideAddPressureVCFive

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configBackgroundImageView:@"newbieGuide_addPressure6"];
    [self hideSkipButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
