//
//  SearchServiceListTableViewController.h
//  HMClient
//
//  Created by yinquan on 16/12/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceSearchModel.h"

@interface SearchServiceListTableViewController : UITableViewController

@property (nonatomic, retain) NSString* keyword;

- (id) initWithSearchModel:(ServiceSearchModel*) serviceModel keyword:(NSString*) keyword;
@end
