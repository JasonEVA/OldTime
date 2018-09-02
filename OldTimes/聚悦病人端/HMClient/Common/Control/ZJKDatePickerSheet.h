//
//  ZJKDatePickerSheet.h
//  ZJKPatient
//
//  Created by yinqaun on 15/5/7.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import "ZJKPickerSheet.h"

@interface ZJKDatePickerSheet : ZJKPickerSheet
{
    UIDatePicker* datePicker;
}

- (void) setDate:(NSString*) sDate;
@end

@interface ZJkDateTimePickerSheet : ZJKDatePickerSheet

@end
