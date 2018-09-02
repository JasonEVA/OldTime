//
//  ContactBookNormalTableView.h
//  launcher
//
//  Created by williamzhang on 16/2/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  通讯录联系人tableView

#import <UIKit/UIKit.h>

@class SelectContactTabbarView;
@class ContactBookNormalTableView;
@class ContactDepartmentImformationModel, ContactPersonDetailInformationModel;

@protocol ContactBookNormalTableViewDelegate <NSObject>

- (void)contactBookNormalTableView:(ContactBookNormalTableView *)tableView didSelectPerson:(ContactPersonDetailInformationModel *)person;
- (void)contactBookNormalTableView:(ContactBookNormalTableView *)tableView didSelectDepartment:(ContactDepartmentImformationModel *)department;
- (void)contactBookNormalTableViewDidSelectGroup:(ContactBookNormalTableView *)tableView;
- (void)contactBookNormalTableViewDidSelectFriend:(ContactBookNormalTableView *)tableView;

@end

@interface ContactBookNormalTableView : UIView

- (instancetype)initWithViewController:(UIViewController *)superViewController tabbar:(SelectContactTabbarView *)tabbar;

@property (nonatomic, weak) id<ContactBookNormalTableViewDelegate> delegate;

- (void)downloadDataIfNeed;

@end
