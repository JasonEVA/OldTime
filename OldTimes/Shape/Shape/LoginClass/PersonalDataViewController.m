//
//  PersonalDataViewController.m
//  Shape
//
//  Created by jasonwang on 15/10/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "MyToolBar.h"
#import "BaseRequest.h"
#import "MeChangeUserInfoRequest.h"
#import "UILabel+EX.h"
#import "BaseToolBarTextField.h"
#import "UIButton+EX.h"
#import "MeGetUserInfoModel.h"
#import "unifiedUserInfoManager.h"
#import "DBUnifiedManager.h"

typedef NS_ENUM(NSInteger, EditingType) {
    sexTag,
    hightTag,
    weightTag,
    birthdayTag
};




@interface PersonalDataViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,MyToolBarDelegate,BaseRequestDelegate>
@property (nonatomic, strong) UILabel *sexLb;
@property (nonatomic, strong) UILabel *hightLb;
@property (nonatomic, strong) UILabel *weightLb;
@property (nonatomic, strong) UILabel *birthdayLb;
@property (nonatomic, strong) BaseToolBarTextField *sexTxfd;
@property (nonatomic, strong) BaseToolBarTextField *hightTxfd;
@property (nonatomic, strong) BaseToolBarTextField *weightTxfd;
@property (nonatomic, strong) BaseToolBarTextField *birthdayTxfd;
@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, strong) UIPickerView *pickerViewSex;
@property (nonatomic, strong) UIPickerView *pickerViewHight;
@property (nonatomic, strong) UIPickerView *pickerViewWeight;
@property (nonatomic, strong) UIPickerView *birthdayPickView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic) NSInteger hightMin;
@property (nonatomic) NSInteger hightMax;
@property (nonatomic) NSInteger weightMin;
@property (nonatomic) NSInteger weightMax;
@property (nonatomic) NSInteger yearMax;         //可选年龄最大值
@property (nonatomic) NSInteger yearMin;         //可选年龄最小值



@property (nonatomic, copy) NSString *sexString;
@property (nonatomic, copy) NSString *hightString;
@property (nonatomic, copy) NSString *weightString;
@property (nonatomic, copy) NSString *birthdayString;
@property (nonatomic) EditingType editType;

@property (nonatomic, strong) MeGetUserInfoModel *model;
@end

@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"个人资料填写"];
    
    [self initComponent];
    [self.view needsUpdateConstraints];
    [self setPickerdata];
    [self.pickerViewSex selectRow:0 inComponent:0 animated:YES];
    [self.pickerViewHight selectRow:35 inComponent:0 animated:YES];
    [self.pickerViewWeight selectRow:88 inComponent:0 animated:YES];
    self.sexString = @"男";
    self.hightString = @"175";
    self.weightString = @"74.0";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.sexTxfd resignFirstResponder];
    [self.hightTxfd resignFirstResponder];
    [self.weightTxfd resignFirstResponder];
}
#pragma mark - private method

- (void)setPickerdata
{
    self.dataList = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
    self.hightMax = 200;
    self.hightMin = 140;
    self.weightMax = 150;
    self.weightMin = 30;
    self.yearMin = 1960;
    self.yearMax = 2000;
    self.model.birthYear = 1960;
    self.model.birthMonth = 1;
}

- (void)finishRecordData {
    MeChangeUserInfoRequest *request = [[MeChangeUserInfoRequest alloc]init];
    [request prepareRequest];
    self.model.weight = [self.weightTxfd.text doubleValue];
    self.model.height = [self.hightTxfd.text integerValue];
    if([self.sexTxfd.text isEqualToString:@"男"])
    {
        self.model.gender = 1;
    }
    else if ([self.sexTxfd.text isEqualToString:@"女"])
    {
        self.model.gender = 0;
    }
    request.model = self.model;
    [request requestWithDelegate:self];
    [self postLoading];
    
}
#pragma mark - event Response


- (void)MyToolBarDelegateCallBack_SaveClickWithTag:(NSInteger)tag
{
    switch (tag) {
        case sexTag:
            [self.sexTxfd setText:self.sexString];
            break;
            
        case hightTag:
            [self.hightTxfd setText:self.hightString];
            break;
            
        case weightTag:
            [self.weightTxfd setText:self.weightString];
            break;
        case birthdayTag:
            self.birthdayString = [NSString stringWithFormat:@"%ld年%ld月",(long)self.model.birthYear,self.model.birthMonth];
            [self.birthdayTxfd setText:self.birthdayString];
            break;
            
        default:
            break;
    }
    [self.sexTxfd resignFirstResponder];
    [self.hightTxfd resignFirstResponder];
    [self.weightTxfd resignFirstResponder];
    [self.birthdayTxfd resignFirstResponder];
}

- (void)MyToolBarDelegateCallBack_CancelClick
{
    [self.sexTxfd resignFirstResponder];
    [self.hightTxfd resignFirstResponder];
    [self.weightTxfd resignFirstResponder];
    [self.birthdayTxfd resignFirstResponder];
}


#pragma mark - UIpickerView Delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == birthdayTag) {
        if (component == 0) {
            return (self.yearMax - self.yearMin) + 1;
        }
        else
        {
            return 12;
        }
    }
    else
    {
        NSInteger rowNum = 0;
        switch (pickerView.tag) {
            case sexTag:
                rowNum = self.dataList.count;
                break;
                
            case hightTag:
                rowNum = self.hightMax - self.hightMin + 1;
                break;
                
            case weightTag:
                rowNum = (self.weightMax - self.weightMin) * 2 + 1;
                break;
                
            default:
                break;
        }
        return rowNum;

    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == birthdayTag) {
        return 2;
    }
    else
    {
        return 1;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = nil;
    switch (pickerView.tag) {
        case sexTag:
            str = self.dataList[row];
            break;
            
        case hightTag:
            str = [NSString stringWithFormat:@"%ld",self.hightMin + row];
            break;
            
        case weightTag:
            str = [NSString stringWithFormat:@"%.1f",self.weightMin + row * 0.5];
            break;
        case birthdayTag:
        {
            if (component == 0) {
                str = [NSString stringWithFormat:@"%ld",(long)(self.yearMin +row)];
            }
            else
            {
                str = [NSString stringWithFormat:@"%ld",(long)(row + 1)];
            }
        }
            
            break;
        default:
            break;
    }

    
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (pickerView.tag) {
        case sexTag:
            self.sexString = self.dataList[row];
            break;
            
        case hightTag:
            self.hightString = [NSString stringWithFormat:@"%ld",self.hightMin + row];
            break;
            
        case weightTag:
            self.weightString = [NSString stringWithFormat:@"%.1f",self.weightMin + row * 0.5];
            break;
        case birthdayTag:
        {
            if (component == 0) {
                self.model.birthYear = self.yearMin + row;
            }
            else
            {
                
                self.model.birthMonth = row + 1;;
            }
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - updateViewConstraints

- (void)updateViewConstraints
{
    [self.sexLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(40);
    }];
    
    [self.sexTxfd mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexLb.mas_bottom).offset(9);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(49);
    }];
    
    [self.birthdayLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexTxfd.mas_bottom).offset(27);
        make.left.equalTo(self.sexTxfd);
    }];
    
    [self.birthdayTxfd mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.sexTxfd);
        make.top.equalTo(self.birthdayLb.mas_bottom).offset(9);
    }];

    
    [self.hightLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdayTxfd.mas_bottom).offset(27);
        make.left.equalTo(self.sexTxfd);
    }];
    
    [self.hightTxfd mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.sexTxfd);
        make.top.equalTo(self.hightLb.mas_bottom).offset(9);
    }];
    
    [self.weightLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hightTxfd.mas_bottom).offset(27);
        make.left.equalTo(self.sexTxfd);
    }];
    
    [self.weightTxfd mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.sexTxfd);
        make.top.equalTo(self.weightLb.mas_bottom).offset(9);
    }];
    
    [self.finishBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.sexTxfd);
        make.top.equalTo(self.weightTxfd.mas_bottom).offset(27);
    }];
    
    [super updateViewConstraints];
}


#pragma mark - initComponent

- (void)initComponent
{
    [self.view addSubview:self.sexTxfd];
    [self.view addSubview:self.sexLb];
    [self.view addSubview:self.hightTxfd];
    [self.view addSubview:self.hightLb];
    [self.view addSubview:self.weightTxfd];
    [self.view addSubview:self.weightLb];
    [self.view addSubview:self.finishBtn];
    [self.view addSubview:self.birthdayTxfd];
    [self.view addSubview:self.birthdayLb];
}


#pragma mark - init UI

- (UILabel *)sexLb
{
    if (!_sexLb) {
        _sexLb = [UILabel setLabel:_sexLb text:@"性别" font:nil textColor:[UIColor whiteColor]];
    }
    return _sexLb;
}

- (UILabel *)hightLb
{
    if (!_hightLb) {
        _hightLb = [UILabel setLabel:_hightLb text:@"身高(CM)" font:nil textColor:[UIColor whiteColor]];
    }
    return _hightLb;
}

- (UILabel *)weightLb
{
    if (!_weightLb) {
        _weightLb = [UILabel setLabel:_weightLb text:@"体重(KG)" font:nil textColor:[UIColor whiteColor]];
    }
    return _weightLb;
}

- (UILabel *)birthdayLb
{
    if (!_birthdayLb) {
        _birthdayLb = [UILabel setLabel:_birthdayLb text:@"出生年月" font:nil textColor:[UIColor whiteColor]];
    }
    return _birthdayLb;
}

- (BaseToolBarTextField *)sexTxfd
{
    if (!_sexTxfd) {
        _sexTxfd = [[BaseToolBarTextField alloc]initWithToolBar:YES backgroundColor:[UIColor themeBackground_373737] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter tag:sexTag text:@"男" inputView:self.pickerViewSex];
        [_sexTxfd setToolBarDeletate:self];
        [_sexTxfd setToolBarTitle:@"选择性别"];
    }
    return _sexTxfd;
}

- (BaseToolBarTextField *)hightTxfd
{
    if (!_hightTxfd) {
        _hightTxfd = [[BaseToolBarTextField alloc]initWithToolBar:YES backgroundColor:[UIColor themeBackground_373737] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter tag:hightTag text:@"175" inputView:self.pickerViewHight];
        [_hightTxfd setToolBarDeletate:self];
        [_hightTxfd setToolBarTitle:@"选择身高"];
    }
    return _hightTxfd;
}

- (BaseToolBarTextField *)weightTxfd
{
    if (!_weightTxfd) {
        _weightTxfd = [[BaseToolBarTextField alloc]initWithToolBar:YES backgroundColor:[UIColor themeBackground_373737] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter tag:weightTag text:@"74.0" inputView:self.pickerViewWeight];
        [_weightTxfd setToolBarDeletate:self];
        [_weightTxfd setToolBarTitle:@"选择体重"];
        
    }
    return _weightTxfd;
}

- (BaseToolBarTextField *)birthdayTxfd
{
    if (!_birthdayTxfd) {
        _birthdayTxfd = [[BaseToolBarTextField alloc]initWithToolBar:YES backgroundColor:[UIColor themeBackground_373737] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter tag:birthdayTag text:@"1960年1月" inputView:self.birthdayPickView];
        [_birthdayTxfd setToolBarDeletate:self];
        [_birthdayTxfd setToolBarTitle:@"选择出生日期"];
    }
    return _birthdayTxfd;
}


- (UIButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [UIButton setBntData:_finishBtn backColor:nil backImage:[UIColor switchToImageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] title:@"完成" titleColorNormal:nil titleColorSelect:nil font:nil tag:1 isSelect:NO];
        [_finishBtn addTarget:self action:@selector(finishRecordData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UIPickerView *)pickerViewSex
{
    if (!_pickerViewSex) {
        _pickerViewSex = [[UIPickerView alloc] init];
        [_pickerViewSex setDelegate:self];
        [_pickerViewSex setDataSource:self];
        [_pickerViewSex setTag:sexTag];
        [_pickerViewSex setBackgroundColor:[UIColor whiteColor]];
    }
    return _pickerViewSex;
}

- (UIPickerView *)pickerViewHight
{
    if (!_pickerViewHight) {
        _pickerViewHight = [[UIPickerView alloc] init];
        [_pickerViewHight setDelegate:self];
        [_pickerViewHight setDataSource:self];
        [_pickerViewHight setTag:hightTag];
        [_pickerViewHight setBackgroundColor:[UIColor whiteColor]];
    }
    return _pickerViewHight;
}

- (UIPickerView *)pickerViewWeight
{
    if (!_pickerViewWeight) {
        _pickerViewWeight = [[UIPickerView alloc] init];
        [_pickerViewWeight setDelegate:self];
        [_pickerViewWeight setDataSource:self];
        [_pickerViewWeight setTag:weightTag];
        [_pickerViewWeight setBackgroundColor:[UIColor whiteColor]];
    }
    return _pickerViewWeight;
}
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}


- (UIPickerView *)birthdayPickView
{
    if (!_birthdayPickView) {
        _birthdayPickView = [[UIPickerView alloc] init];
        [_birthdayPickView setDelegate:self];
        [_birthdayPickView setDataSource:self];
        [_birthdayPickView setBackgroundColor:[UIColor whiteColor]];
        //[_birthdayPickView selectRow:30 inComponent:0 animated:YES];
        [_birthdayPickView setTag:birthdayTag];
    }
    return _birthdayPickView;
}

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求成功");
    [[unifiedUserInfoManager share] saveUserInfoData:self.model];
    
    // 保存体脂率
    [[DBUnifiedManager share] saveFatRange:[[unifiedUserInfoManager share] calculateFatRange]];
    
    [self postSuccess:response.message];
    [self hideLoading];
    [[NSNotificationCenter defaultCenter] postNotificationName:n_showHome object:nil];
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求失败");
   

    [self postError:response.message];
    [self hideLoading];
}

@end
