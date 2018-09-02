//
//  NuritionFoodListTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NuritionFoodListTableViewCell.h"
@protocol NuritionFoodListDelegate <NSObject>

- (void)popupFoodVolumeSelectVC;

- (void) foodAndNumSelected:(FoodListItem*) food
                        Num:(NSInteger) num;

@end

@interface NuritionFoodListTableViewController : UITableViewController
{
    
}

@property (nonatomic, retain) NSString* searchName;
@property (nonatomic, weak) id<NuritionFoodListDelegate> selectDelegate;
@end
