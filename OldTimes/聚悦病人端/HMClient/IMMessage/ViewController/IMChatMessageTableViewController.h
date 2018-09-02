//
//  IMChatMessageTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMChatMessageTableViewController : UITableViewController
{
    
}

- (id) initWithTargetId:(NSString*) tid;
- (void) scrollToBottom;
@end
