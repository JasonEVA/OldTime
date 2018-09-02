//
//  NewMissionDetailTitelTableViewCell.h
//  launcher
//
//  Created by jasonwang on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionDetailModel.h"

@protocol NewMissionDetailTitelTableViewCellDelegate <NSObject>


@end

@interface NewMissionDetailTitelTableViewCell : UITableViewCell

@property (nonatomic, weak) id <NewMissionDetailTitelTableViewCellDelegate> delegate;

+ (NSString *)identifier;

- (void)setDataWithModel:(MissionDetailModel *)model;

@end
