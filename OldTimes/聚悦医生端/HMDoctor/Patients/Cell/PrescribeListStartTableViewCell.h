//
//  PrescribeListStartTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/6/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrescribeInfo.h"

@interface PrescribeListStartTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *buttonCopy;

- (void)setPrescribeInfo:(PrescribeInfo *)info;

@end
