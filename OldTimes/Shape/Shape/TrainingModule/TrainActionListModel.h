//
//  TrainActionListModel.h
//  Shape
//
//  Created by jasonwang on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainActionListModel : NSObject
@property (nonatomic, copy) NSString *actionId;	//动作ID	String
@property (nonatomic, copy) NSString *name;	//动作名称	String
@property (nonatomic, copy) NSString *thumbnail;	//缩略图	String
@property (nonatomic, copy) NSString *thumbnailUrl;	//缩略图Url	String
@property (nonatomic, copy) NSString *video;	//动作视频	String
@property (nonatomic, copy) NSString *videoUrl;	//动作视频Url	String
@property (nonatomic, copy) NSArray *scoreList;	//加分属性	Array
@end
