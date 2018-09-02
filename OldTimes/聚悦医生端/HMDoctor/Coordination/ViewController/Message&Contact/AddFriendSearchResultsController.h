//
//  AddFriendSearchResultsController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//  加好友结果界面

#import "HMBaseViewController.h"

typedef void(^SearchResultClicked)(id resultData);
@interface AddFriendSearchResultsController : HMBaseViewController

- (void)updateResultsWithKeywords:(NSString *)keywords resultClicked:(SearchResultClicked)clicked;
@end
