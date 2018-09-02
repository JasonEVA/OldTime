//
//  JapanCompanySelectViewController.h
//  launcher
//
//  Created by williamzhang on 16/4/12.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  日本选择公司

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface JapanNaviCompanySelectViewController : BaseNavigationController

- (instancetype)initWithChangeCompany:(BOOL)isChangeCompany NS_DESIGNATED_INITIALIZER;

@end

@interface JapanCompanySelectViewController : BaseViewController

- (instancetype)initWithChangeCompany:(BOOL)isChangeCompany;

@end