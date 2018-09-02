//
//  MeetingSelectedMeetingRoomView.m
//  launcher
//
//  Created by Conan Ma on 15/8/13.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingSelectedMeetingRoomView.h"

@interface MeetingSelectedMeetingRoomView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) NSArray *arrRoomList;
@property (nonatomic, strong) UIPickerView *pickView;
@end

@implementation MeetingSelectedMeetingRoomView
- (instancetype)initWithFrame:(CGRect)frame MeetingRoomList:(NSArray *)RoomArr
{
    if (self = [super initWithFrame:frame])
    {
        self.arrRoomList = RoomArr;
        
        [self addSubview:self.pickView];
        [self addSubview:self.btnDone];
        [self addSubview:self.btnBigDone];
    }
    return self;
}

#pragma mark - Interface Method
- (void)setRoomList:(NSArray *)roomList {
    self.arrRoomList = roomList;
    
    if (![self.arrRoomList count]) {
        return;
    }
    
    NSInteger originalSelectedRow = [self.arrRoomList count] / 2;
    
    [self.pickView selectRow:originalSelectedRow inComponent:0 animated:YES];
    self.meetingRoomModel = self.arrRoomList[originalSelectedRow];
    
    [self.pickView reloadAllComponents];
}

#pragma mark - pickviewdelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrRoomList.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.arrRoomList.count > 0)
    {
        MeetingRoomListModel *model = self.arrRoomList[row];
        self.meetingRoomModel = model;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    
    if (row < [self.arrRoomList count]) {
        MeetingRoomListModel *model = self.arrRoomList[row];
        pickerLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    
    return pickerLabel;
}

#pragma mark - init
- (NSArray *)arrRoomList
{
    if (!_arrRoomList)
    {
        _arrRoomList = [[NSArray alloc] init];
    }
    return _arrRoomList;
}

- (UIPickerView *)pickView
{
    if (!_pickView)
    {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 30, self.frame.size.width - 40, self.frame.size.height - 40)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        [self pickerView:_pickView didSelectRow:0 inComponent:0];
    }
    return _pickView;
}

- (UIButton *)btnDone {
    if (!_btnDone) {
        _btnDone = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 35, 10, 25, 25)];
        _btnDone.expandSize = CGSizeMake(10, 10);
        [_btnDone setImage:[UIImage imageNamed:@"Calendar_check"] forState:UIControlStateNormal];
    }
    return _btnDone;
}

- (MeetingRoomListModel *)meetingRoomModel {
    if (!_meetingRoomModel) {
        _meetingRoomModel = [[MeetingRoomListModel alloc] init];
    }
    return _meetingRoomModel;
}

- (UIButton *)btnBigDone
{
    if (!_btnBigDone)
    {
        _btnBigDone = [[UIButton alloc] init];
        _btnBigDone.backgroundColor = [UIColor clearColor];
        _btnBigDone.frame = CGRectMake(self.frame.size.width - 50, 10, 50, 40);
    }
    return _btnBigDone;
}
@end
