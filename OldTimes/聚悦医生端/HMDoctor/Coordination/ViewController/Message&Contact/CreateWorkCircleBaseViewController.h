//
//  CreateWorkCircleBaseViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationSelectContactsBaseViewController.h"

@interface CreateWorkCircleBaseViewController : CoordinationSelectContactsBaseViewController
@property (nonatomic)  BOOL  create; // 创建工作圈还是添加成员
@property (nonatomic, copy)  NSString  *workCircleID; // 工作圈ID
@property (nonatomic, copy)  NSArray  *arrayNonSelectableContacts; // <##>

@end
