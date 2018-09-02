//
//  ATStaticViewCell.h
//  Clock
//
//  Created by Dariel on 16/7/20.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATTableViewCell.h"

@class ATStaticViewCell, ATStaticOutSideDetailView;
@protocol ATStaticViewCellDelegate <NSObject>

@optional
- (void)sendDateForRequest:(double)date staticViewCell:(ATStaticViewCell *) cell;

@end


@interface ATStaticViewCell : ATTableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ATStaticOutSideDetailView *staticOutSideView;


@property (nonatomic, weak) id<ATStaticViewCellDelegate> delegate;

@end
