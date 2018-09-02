//
//  JapanRegisterModule.h
//  launcher
//
//  Created by williamzhang on 16/4/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  日本注册Module

#import <UIKit/UIKit.h>

@interface JapanRegisterModule : NSObject

@property (nonatomic, readonly) NSInteger step;

@property (nonatomic, readonly) NSString *navigationTitle;

@property (nonatomic, readonly) NSString *accountString;
@property (nonatomic, readonly) NSString *password;

@property (nonatomic, readonly) NSString *teamName;
@property (nonatomic, readonly) NSString *teamDomain;
@property (nonatomic, readonly) NSString *name;
/// default:YES
@property (nonatomic, assign) BOOL essentialReason;

@property (nonatomic, assign) NSInteger tableViewRows;

- (void)preStep;
- (void)nextStep;
- (void)setStep:(NSInteger)step;

- (void)setAccountString:(NSString *)accountString;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)checkEmailAccount;

@end
