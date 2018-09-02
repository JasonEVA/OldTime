//
//  updateWhiteboardSortRequest.h
//  launcher
//
//  Created by williamzhang on 15/11/6.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  更新白板排序Request

#import "BaseRequest.h"

@interface updateWhiteboardSortRequest : BaseRequest

@property (nonatomic, readonly) NSInteger fromIndex;
@property (nonatomic, readonly) NSInteger toIndex;

- (void)beforeUpdateIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
/** 在调用此接口钱请使用｀beforeUpdateIndex:toIndex:记录下位置 */
- (void)updateWhiteboardSort:(NSString *)showId previousBoardShowId:(NSString *)prevShowId;

@end
