//
//  SearchEmptyAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/9.
//  Copyright © 2017年 yinquan. All rights reserved.
//  搜索空白页adapter

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"

@interface SearchEmptyAdapter : NSObject<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, copy)  NSString  *title; // <##>
@property (nonatomic, assign)  BOOL  displayEmptyView; // 是否显示空视图，默认为NO
@end
