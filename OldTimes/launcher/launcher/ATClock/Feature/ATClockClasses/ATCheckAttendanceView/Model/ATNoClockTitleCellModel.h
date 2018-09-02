//
//  ATNoClockTitleCellModel.h
//  Clock
//
//  Created by SimonMiao on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATNoClockTitleCellModel : NSObject

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *dateStr;

@property (nonatomic, assign) BOOL isHideTopLine;

@end
