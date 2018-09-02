//
//  TaskMainButtonView.h
//  launcher
//
//  Created by TabLiu on 16/2/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskMainButtonViewDelegate <NSObject>

- (void)TaskMainButtonViewDelegateCallBack_SelectButtonIndex:(NSInteger)index;

@end


@interface TaskMainButtonView : UIView

@property (nonatomic,weak) id<TaskMainButtonViewDelegate> delegate;

- (void)setLiftButtonTitle:(NSString *)title imageName:(NSString *)string;
- (void)setRightButtonTitle:(NSString *)title imageName:(NSString *)string;



@end
