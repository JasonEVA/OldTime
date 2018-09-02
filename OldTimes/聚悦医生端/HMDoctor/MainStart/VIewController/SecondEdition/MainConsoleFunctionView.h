//
//  MainConsoleFunctionView.h
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainConsoleFunctionView : UIView

@property (nonatomic, readonly) NSMutableArray* functionButtons;

- (void) setFunctionModels:(NSArray*) models;

//- (void) setContentSize:(CGSize) contentSize;

@end

@interface MainConsoleStartFunctionView : MainConsoleFunctionView

@end

@interface MainConsoleDisplayFunctionView : MainConsoleFunctionView


@end

@interface MainConsoleEditSelectedFunctionView : MainConsoleFunctionView

- (void) replaceSortAnimation:(NSInteger) startIndex endIndex:(NSInteger) endIndex;

@end

@interface MainConsoleEditUnSelectedFunctionView : MainConsoleFunctionView



@end
