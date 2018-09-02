//
//  SESessionListSelectTypeView.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//  筛选集团view

#import <UIKit/UIKit.h>

typedef void(^configClickBlock)(NSArray *selectedArr);
typedef void(^cellClickBlock)(NSInteger row);
@interface SESessionListSelectTypeView : UIView
@property (nonatomic, copy) NSArray *unReadArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectedArr;

- (void)selectedEndBlock:(configClickBlock)block;

- (void)clickCellBlock:(cellClickBlock)block;

@end
