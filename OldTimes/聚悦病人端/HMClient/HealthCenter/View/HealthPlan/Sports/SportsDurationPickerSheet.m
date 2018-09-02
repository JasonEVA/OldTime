//
//  SportsDurationPickerSheet.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SportsDurationPickerSheet.h"

@interface SportsDurationPickerSheet ()
<UIPickerViewDataSource,
UIPickerViewDelegate>
{
    NSMutableArray* durationList;
}
@end

@implementation SportsDurationPickerSheet
- (instancetype)init {
    if (self = [super init]) {
        [self createPicker];
    }
    return self;
}

- (void) createPicker
{
    durationList = [NSMutableArray array];
    for (NSInteger index = 1; index < 180; index++)
    {
        NSString* dura = [NSString stringWithFormat:@"%ld分钟", index];
        [durationList addObject:dura];
    }
    
    durationPicker = [[UIPickerView alloc]init];
    [durationPicker setDataSource:self];
    [durationPicker setDelegate:self];
    [durationPicker selectRow:29 inComponent:0 animated:NO];
    [pickerview addSubview:durationPicker];
    [durationPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(pickerview);
    }];
}

- (void) makeResult
{
    _selectedIndex = [durationPicker selectedRowInComponent:0];
    sResult = durationList[_selectedIndex];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (durationList)
    {
        return durationList.count;
    }
    return 0;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [durationList objectAtIndex:row];
}

@end
