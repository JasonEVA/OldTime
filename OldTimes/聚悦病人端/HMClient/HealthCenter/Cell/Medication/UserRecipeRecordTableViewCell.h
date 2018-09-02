//
//  UserRecipeRecordTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRecipeRecord.h"



@interface UserRecipeRecord (RecordTableCellHeight)
{
    
}
- (CGFloat) recordCellHeight;
@end

@protocol UserRecipeRecordTableViewCellDelegate <NSObject>

- (void) userRecipeRecordDrag:(UITableViewCell*) cell
                    WithIndex:(NSInteger) index;

@end

@interface UserRecipeRecordTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, weak) id<UserRecipeRecordTableViewCellDelegate> delegate;

- (void) setUserRecipeRecord:(UserRecipeRecord*) record;
@end
