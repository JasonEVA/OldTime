//
//  HMSelectContactsViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/7/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//  选择联系人（工作组 ，专家组，好友等）通用VC

#import "HMBaseViewController.h"
typedef void (^selectFromAllContactsCompletion)(NSArray *selectedPeople); //  选人回调

@interface HMSelectContactsViewController : HMBaseViewController
@property (nonatomic, strong)  NSMutableArray  *selectedPeople; // <##>

- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople completion:(selectFromAllContactsCompletion)completion;
@end
