//
//  OrderedServiceTableViewCell.h
//  JYHMUser
//
//  Created by yinquan on 16/11/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderedServiceModel.h"

@interface OrderedServiceSummaryView : UIView

@end

@interface OrderedServiceDetsView : UIView

@end

@interface OrderedServiceModel (TableViewCellHeight)

- (CGFloat) tableCellHeight;

//是否显示升级vip按钮
- (BOOL) showUpdateButton;
@end

@interface OrderedServiceTableViewCell : UITableViewCell

@property (nonatomic, readonly) OrderedServiceSummaryView* serviecSummaryView;
@property (nonatomic, readonly) OrderedServiceDetsView* serviceDetsView;

- (void) setOrderedService:(OrderedServiceModel*) orderedService;
@end

//已订购的增值服务Cell
@interface OrderedAppreciationServiceTableViewCell : UITableViewCell

@property (nonatomic, readonly) UIImageView* serviceImageView;

- (void) setOrderedService:(OrderedServiceModel*) orderedService;
@end


@interface OrderedAppreciationGoodsTableViewCell : UITableViewCell

@property (nonatomic, readonly) UIImageView* serviceImageView;

- (void) setOrderedService:(OrderedServiceModel*) orderedService;
@end


@interface OrderedHistoryServiceTableViewCell : OrderedServiceTableViewCell

@end

@interface OrderedHistoryAppreciationServiceTableViewCell : OrderedAppreciationServiceTableViewCell

@end

@interface OrderedHistoryAppreciationGoodsTableViewCell : OrderedAppreciationGoodsTableViewCell


@end
