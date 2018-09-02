//
//  SelectContactsFromAllContactsViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBaseViewController.h"
@class MessageBaseModel;

typedef void (^selectFromAllContactsCompletion)(NSArray *selectedPeople); //  选人回调

@interface SelectContactsFromAllContactsViewController : HMBaseViewController
@property (nonatomic, strong)  MessageBaseModel  *messageModel; // <##>

- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople completion:(selectFromAllContactsCompletion)completion;
@end
