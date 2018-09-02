//
//  HMSEMainStartWithCollectionTableViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版首页带有collection通用cell

#import <UIKit/UIKit.h>
#import "HMSEMainStartEnum.h"

@protocol HMSEMainStartWithCollectionTableViewCellDelegate <NSObject>

- (void)HMSEMainStartWithCollectionTableViewCellDelegateCallBack_didSelectCollectionCellWithIndexPath:(NSIndexPath *)indexPath tableViewCellType:(SEMainStartType)type;

@end

@interface HMSEMainStartWithCollectionTableViewCell : UITableViewCell

//@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *moreLb;
@property (nonatomic, weak) id<HMSEMainStartWithCollectionTableViewCellDelegate> JWdelegate;

// 今日任务
- (void)fillDataWithTodayMissionTypeDataList:(NSArray *)dataList;

// 健康课堂
- (void)fillDataWithHealthClassTypeDataList:(NSArray *)dataList;

// 工具箱
- (void)fillDataWithToolBoxType;

@end
