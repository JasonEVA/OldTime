//
//  SelectContactTabbarView.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactInfoModel;

typedef void (^ContactTabbarDeleteContactHandler)(id deleteModel);

@interface SelectContactTabbarView : UIView
@property (nonatomic, strong) NSMutableArray *arraySelect;

- (void)deletePeople:(NSArray *)people;
- (void)addPeople:(NSArray *)people;

- (void)addTabbarViewDeleteContactNoti:(ContactTabbarDeleteContactHandler)deleteHandler;

- (void)configData:(NSArray *)dataSource;

@end
