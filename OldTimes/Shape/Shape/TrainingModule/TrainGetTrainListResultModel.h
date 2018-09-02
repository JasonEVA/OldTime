//
//  TrainGetTrainListResultModel.h
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainGetTrainListResultModel : NSObject
@property (nonatomic, copy) NSString *pageIndex;	//当前页数	String
@property (nonatomic, copy) NSString *totalPages;	//总页数	String
@property (nonatomic) NSInteger totalRecords;	//总条数	int
@property (nonatomic, copy) NSArray *pageItems;	//数据集合	Array
@end
