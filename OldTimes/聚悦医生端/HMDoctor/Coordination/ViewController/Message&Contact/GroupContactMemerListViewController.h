//
//  GroupContactMemerListViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBaseViewController.h"

@class SelectContactTabbarView;

@interface GroupContactMemerListViewController : HMBaseViewController

- (instancetype)initWithGroupID:(NSString *)groupID selectView:(SelectContactTabbarView *)selectView nonSelectableContacts:(NSArray *)array singleSelect:(BOOL)singleSelect;
@end
