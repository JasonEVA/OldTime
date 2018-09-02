//
//  DashboardCollectionViewCell.h
//  HMClient
//
//  Created by Andrew Shen on 2016/11/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainStartHealthTargetModel;

@interface DashboardCollectionViewCell : UICollectionViewCell

- (void)configTargetData:(MainStartHealthTargetModel *)targetData;

@end
