//
//  MissionTitelTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务标题cell

#import <UIKit/UIKit.h>

@interface MissionTitelTableViewCell : UITableViewCell

typedef void(^MissionTitelTableViewCellBlock)();
+ (NSString *)identifier;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *selectButton;

- (void)btnSelect:(MissionTitelTableViewCellBlock)selectBlock;
@end
