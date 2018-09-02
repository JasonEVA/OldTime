//
//  ATStatisticsViewAdapter.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATTableViewAdapter.h"

@class ATStaticViewCell;
@protocol ATStatisticsViewAdapterDelegate <NSObject>

@optional
- (void)sendDateForRequest:(double)date staticViewCell:(ATStaticViewCell *) cell;


@end

@interface ATStatisticsViewAdapter : ATTableViewAdapter

@property (nonatomic, weak) id<ATStatisticsViewAdapterDelegate> delegate;

@end
