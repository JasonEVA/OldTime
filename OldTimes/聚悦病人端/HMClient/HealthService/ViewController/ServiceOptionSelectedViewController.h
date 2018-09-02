//
//  ServiceOptionSelectedViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectOptionSelectOptionsBlock)(NSArray* selectedItems);

@interface ServiceOptionSelectedViewController : UIViewController
{
    
}



+ (void) showSelectOptionView:(NSArray*) selectedOptions
               ServiceOptions:(NSArray*) options
SelectOptionSelectOptionsBlock:(SelectOptionSelectOptionsBlock) block;
@end

@interface ServiceOptionSelectedTableViewController : UITableViewController

- (id) initWithSelectedOption:(NSArray*) selectedOptions
               ServiceOptions:(NSArray*) options;
- (NSArray*) selectedOptionItems;
@end
