//
//  MeChangeInfoCell.m
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeChangeInfoCell.h"


@implementation MeChangeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        [self setMyData];
        [self.txtFd setText:@"未填写"];
        [self.txtFd setEnabled:YES];
        [self.txtFd setInputAccessoryView:self.toolBar];        
    }
    return self;
}

- (void)updatePickerView:(MeGetUserInfoModel *)model
{
    self.model = model;
    if (self.indexPath.section == 1) {
        if (self.indexPath.row == 1) {
            if (model.gender == 1) {
                [self.sexPickView selectRow:0 inComponent:0 animated:YES];
            }
            else if (model.gender == 0)
            {
                [self.sexPickView selectRow:1 inComponent:0 animated:YES];
            }

        }
    }
    else if (self.indexPath.section == 2)
    {
        if (self.indexPath.row == 0) {
            if(!(model.birthYear == 0 || model.birthMonth == 0))
            {
                self.year = model.birthYear;
                self.month = model.birthMonth;
                [self.birthdayPickView selectRow:(model.birthYear - self.yearMin) inComponent:0 animated:YES];
                [self.birthdayPickView selectRow:(model.birthMonth - 1) inComponent:1 animated:YES];
            }

        }
    }
    
}

- (void)setTextFieldText:(NSString *)text editing:(BOOL)isEditing
{
    [super setTextFieldText:text editing:isEditing];
    if ([text isEqualToString:@""]) {
        [self.txtFd setText:@"未填写"];
    }
    
}
- (void)MyToolBarDelegateCallBack_CancelClick
{
    [self.txtFd resignFirstResponder];
    
}

- (void)MyToolBarDelegateCallBack_SaveClick
{
    self.txtFd.text = self.string;
    self.model.birthYear = self.year;
    self.model.birthMonth = self.month;
    
    [self.txtFd resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    self.string = self.txtFd.text;
    if (self.indexPath.section == 1) {
        switch (self.indexPath.row) {
            case 0:
                [self.toolBar setMyTitel:@"更改用户名"];
                break;
            case 1:
                self.keyboardType = sexType;
                [self.txtFd setInputView:self.sexPickView];
                [self.toolBar setMyTitel:@"更改性别"];
                break;
            case 2:
            {
                self.keyboardType = localionType;
                NSInteger selectedProvinceIndex = [self.locationPickView selectedRowInComponent:0];
                NSString *seletedProvince = [self.provinceArray objectAtIndex:selectedProvinceIndex];
                self.cityArray = [self.locationDict objectForKey:seletedProvince];
                [self.txtFd setInputView:self.locationPickView];
                [self.toolBar setMyTitel:@"更改所在地"];
            }
                
                break;
                
            default:
                break;
        }
    }
    else if (self.indexPath.section == 2)
    {
        if (self.indexPath.row == 0) {
            self.keyboardType = birthdarType;
            [self.txtFd setInputView:self.birthdayPickView];
            [self.toolBar setMyTitel:@"更改生日"];
        }
    }
    return YES;
}
//设置PickerView数据源
- (void)setMyData
{
    /**
     *  性别
     */
    self.sexArr = [NSArray arrayWithObjects:@"男",@"女", nil];
    //城市
    NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
    self.locationDict = [[NSMutableDictionary alloc]initWithContentsOfFile:addressPath];
    self.provinceArray = [self.locationDict allKeys];
    //生日
    self.yearMax = 2000;
    self.yearMin = 1960;
    self.year = self.yearMin + 30;
    self.month = 1;
    
}

#pragma mark - UIpickerView Delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 0;
    switch (self.keyboardType) {
        case sexType:
            num = self.sexArr.count;
            break;
            
        case localionType:
            if (component == 0) {
                num = self.provinceArray.count;
            }
            else
            {
                num = self.cityArray.count;
            }
            break;
            
        case birthdarType:
        {
            if (component == 0) {
                num = self.yearMax - self.yearMin + 1;
            }
            else
            {
                num = 12;
            }
        }
            break;
            
        default:
            break;
    }
    
    return num;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger num = 0;
    switch (self.keyboardType) {
        case sexType:
            num = 1;
            break;
            
        case localionType:
            num = 2;
            break;
            
        case birthdarType:
            num = 2;
            break;
            
        default:
            break;
    }
    
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = nil;
    switch (self.keyboardType) {
        case sexType:
            string = self.sexArr[row];
            break;
            
        case localionType:
            if (component == 0) {
                string = [self.provinceArray objectAtIndex:row];
            }
            else
            {
                string = [self.cityArray objectAtIndex:row];
            }
            break;
            
        case birthdarType:
        {
            if (component == 0) {
                string = [NSString stringWithFormat:@"%ld",(long)(self.yearMin +row)];
            }
            else
            {
                string = [NSString stringWithFormat:@"%ld",(long)(row + 1)];
            }
        }
            
            break;
            
        default:
            break;
    }
    
    return string;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (self.keyboardType) {
        case sexType:
            self.string = self.sexArr[row];
            break;
            
        case localionType:
        {
            NSString *seletedProvince = nil;
            NSString *seletedCity = nil;
            if (component == 0) {
                seletedProvince = [self.provinceArray objectAtIndex:row];
                self.cityArray = [self.locationDict objectForKey:seletedProvince];
                
                //重点！更新第二个轮子的数据
                [self.locationPickView reloadComponent:1];
                
                NSInteger selectedCityIndex = [self.locationPickView selectedRowInComponent:1];
                seletedCity = [self.cityArray objectAtIndex:selectedCityIndex];
            }
            else
            {
                NSInteger selectedProvinceIndex = [self.locationPickView selectedRowInComponent:0];
                seletedProvince = [self.provinceArray objectAtIndex:selectedProvinceIndex];
                seletedCity = [self.cityArray objectAtIndex:row];
                
            }
            NSString *msg = [NSString stringWithFormat:@"%@ %@", seletedProvince,seletedCity];
            self.string = msg;
        }
            break;
            
        case birthdarType:
        {
            if (component == 0) {
                self.year = self.yearMin + row;
            }
            else
            {
                
                self.month = row + 1;;
            }
            NSString *string = [NSString stringWithFormat:@"%ld年%ld月",self.year,self.month];
            self.string = string;
        }
            break;
            
        default:
            break;
    }
    
    
    
}

- (UIPickerView *)sexPickView
{
    if (!_sexPickView) {
        _sexPickView = [[UIPickerView alloc] init];
        [_sexPickView setDelegate:self];
        [_sexPickView setDataSource:self];
        [_sexPickView setBackgroundColor:[UIColor whiteColor]];
    }
    return _sexPickView;
}

- (UIPickerView *)locationPickView
{
    if (!_locationPickView) {
        _locationPickView = [[UIPickerView alloc] init];
        [_locationPickView setDelegate:self];
        [_locationPickView setDataSource:self];
        [_locationPickView setBackgroundColor:[UIColor whiteColor]];
    }
    return _locationPickView;
}

- (UIPickerView *)birthdayPickView
{
    if (!_birthdayPickView) {
        _birthdayPickView = [[UIPickerView alloc] init];
        [_birthdayPickView setDelegate:self];
        [_birthdayPickView setDataSource:self];
        [_birthdayPickView setBackgroundColor:[UIColor whiteColor]];
        [_birthdayPickView selectRow:30 inComponent:0 animated:YES];
    }
    return _birthdayPickView;
}

- (MyToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[MyToolBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        [_toolBar setMyDelegate:self];
    }
    return _toolBar;}

@end
