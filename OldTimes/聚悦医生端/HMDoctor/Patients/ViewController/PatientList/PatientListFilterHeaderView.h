//
//  PatientListFilterHeaderView.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//  病人列表筛选顶部栏

#import <UIKit/UIKit.h>

typedef void(^PatientFilterItemClickedHandler)(UIButton *item);
@interface PatientListFilterHeaderView : UIView
@property (nonatomic, strong)  UIButton  *selectedButton; // <##>

- (instancetype)initWithTitles:(NSArray<NSString *> *)arrayTitles tags:(NSArray<NSNumber *> *)arrayTags;
- (void)addNotyficationForItemClicked:(PatientFilterItemClickedHandler)block;
- (void)refreshTitleStateWithTitle:(NSString *)title;

- (void)lockFilterButtonSelected:(BOOL)selected;
@end
