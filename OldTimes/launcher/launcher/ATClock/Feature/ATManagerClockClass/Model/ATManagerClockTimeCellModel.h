//
//  ATManagerClockTimeCellModel.h
//  Clock
//
//  Created by SimonMiao on 16/7/22.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATManagerClockTimeCellModel : NSObject

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, assign) BOOL *isOpen;

@end
