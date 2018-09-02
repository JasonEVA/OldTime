//
//  RecipeListTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeListTableViewController : UITableViewController
{
    
}
- (id) initWithUserId:(NSString*) aUserId;

- (void)refreshDataWithUserID:(NSString *)userID;
@end
