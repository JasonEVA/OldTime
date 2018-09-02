//
//  SportsDurationPickerSheet.h
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ZJKPickerSheet.h"

@interface SportsDurationPickerSheet : ZJKPickerSheet
{
    UIPickerView* durationPicker;
}

@property (nonatomic, assign) NSInteger selectedIndex;
@end
