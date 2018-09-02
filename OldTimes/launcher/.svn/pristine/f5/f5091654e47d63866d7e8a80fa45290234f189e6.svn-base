//
//  NewSubMissionTableViewCell.h
//  launcher
//
//  Created by jasonwang on 16/2/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMissionDetailBaseModel.h"
#import "SWTableViewCell.h"
@protocol NewSubMissionTableViewCellDelegate <NSObject>

- (void)NewSubMissionTableViewCellDelegateCallBack_statusChange:(NSIndexPath *)indexPath;

@end
@interface NewSubMissionTableViewCell : SWTableViewCell
+ (NSString *)identifier;
- (void)setSubDataWithModel:(NewMissionDetailBaseModel *)model indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id <NewSubMissionTableViewCellDelegate> subdelegate;
@property (nonatomic, strong) NSIndexPath *myIndexpath;
@end
