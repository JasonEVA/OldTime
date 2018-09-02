//
//  ZJKPickerSheet.h
//  ZJKPatient
//
//  Created by yinqaun on 15/5/6.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJKPickerSheetDelegate <NSObject>

- (void) pickersheet:(id)sheet selectedResult:(NSString*) result;

@end

@interface ZJKPickerSheet : UIView
{
    UIView* pickerview;
@protected
    
    NSString* sResult;
}

@property (nonatomic, weak) id<ZJKPickerSheetDelegate> delegate;

- (void) show;
@end
