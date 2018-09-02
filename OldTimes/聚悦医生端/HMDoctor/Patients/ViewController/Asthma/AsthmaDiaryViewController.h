//
//  AsthmaDiaryViewController.h
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsthmaDiaryViewController : UIViewController

- (id) initWithUserId:(NSString*) aUserId;
- (void)refreshDataWithUserID:(NSString *)userID;

@end
