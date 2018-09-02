//
//  MissionMainListHeadView.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MissionMainListHeadViewBlock)(BOOL selected, NSInteger tag);
@interface MissionMainListHeadView : UIView
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *titelLb;
- (void)selectClickBlock:(MissionMainListHeadViewBlock)block;
@end
