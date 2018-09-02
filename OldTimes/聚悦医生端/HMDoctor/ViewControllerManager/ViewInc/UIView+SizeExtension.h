//
//  UIView+SizeExtension.h
//  HakimHospitalRegister
//
//  Created by YinQ on 15/1/12.
//  Copyright (c) 2015年 YinQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SizeExtension)
{
    
}

@property (nonatomic, readonly) CGSize size;

@property (nonatomic, assign) float left;
@property (nonatomic, assign) float right;
@property (nonatomic, assign) float top;
@property (nonatomic, assign) float bottom;

@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;

+ (UIView*)appTopView;

- (void) showAlertMessage:(NSString*) msg;
@end
