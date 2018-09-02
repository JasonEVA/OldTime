//
//  ATStaticOutSideDetailView.h
//  Clock
//
//  Created by Dariel on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATStaticOutsideModel.h"

@interface ATStaticOutSideDetailView : UIView

@property (nonatomic, strong) NSArray<ATStaticOutsideModel *> *staticOutSideModels;
@property (nonatomic, strong) UITableView *detailTableView;

@end
