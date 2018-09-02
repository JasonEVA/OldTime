//
//  MainConsoleFunctionButton.h
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainConsoleFunctionModel.h"


@interface MainConsoleFunctionButton : UIButton

- (void) setFunctionModel:(MainConsoleFunctionModel*) functionModel;

@end

@interface MainConsoleStartFunctionButton : MainConsoleFunctionButton

@end

@interface MainConsoleDisplayFunctionButton : MainConsoleFunctionButton


@end

@interface MainConsoleEditSelectedFunctionButton : MainConsoleDisplayFunctionButton

@property (nonatomic, readonly) UIButton* minusButton;
@end

@interface MainConsoleEditUnSelectedFunctionButton :MainConsoleDisplayFunctionButton

@property (nonatomic, readonly) UIButton* plusButton;
@end
