//
//  TrainAddMarksModel.h
//  Shape
//
//  Created by jasonwang on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainAddMarksModel : NSObject
@property (nonatomic, copy) NSString *bodyPropertyId;	//部位ID	String	;
@property (nonatomic, copy) NSString *bodyPropertyName;	//部位名称	String	;
@property (nonatomic) NSInteger score;	//加分	Int	;
@property (nonatomic) NSInteger consumption;	//消耗	Int
@end
