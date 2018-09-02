//
//  CreateWorkCircleFromExistGroupViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//  从群工作圈选择

#import "HMBaseViewController.h"
@class SelectContactTabbarView;

@interface CreateWorkCircleFromExistGroupViewController : HMBaseViewController

- (instancetype)initWithSelectView:(SelectContactTabbarView *)selectView nonSelectableContacts:(NSArray *)array;
@end
