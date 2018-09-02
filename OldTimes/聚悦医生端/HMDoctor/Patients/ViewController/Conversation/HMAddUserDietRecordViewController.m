//
//  HMAddUserDietRecordViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/8/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMAddUserDietRecordViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ChatIMConfigure.h"

static NSInteger JWMaxTextCount = 150;

@interface HMAddUserDietRecordViewController ()<UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,TaskObserver>
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholdLb;
@property (nonatomic, strong) MASConstraint *bottomHieght;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *timePicker;
@property (nonatomic, copy) NSArray *timeArr;
@property (nonatomic, strong) MessageBaseModel *model;
@property (nonatomic, copy) NSString *strUid;
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, copy) AddUserDietRecordVCDisMiss block;
@end

@implementation HMAddUserDietRecordViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (instancetype)initWithModel:(MessageBaseModel *)model strUid:(NSString *)strUid disMisssBlock:(AddUserDietRecordVCDisMiss)disMisssBlock
{
    self = [super init];
    if (self) {
        self.model = model;
        self.strUid = strUid;
//        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        self.definesPresentationContext = YES;
//        self.providesPresentationContextTransitionStyle = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.block = disMisssBlock;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self hideTimePicker];
    [self hideDatePicker];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeArr = @[@"早餐",@"午餐",@"晚餐",@"加餐"];
    self.selectDate = [NSDate date];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];

    [self configElements];
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}


#pragma mark -private method
- (void)configElements {
    UIView *backView = [UIView new];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [backView.layer setCornerRadius:4];
    [backView setClipsToBounds:YES];
    
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        self.bottomHieght = make.bottom.equalTo(self.view).offset(-200);
    }];
    
    UILabel *titelLb = [UILabel new];
    [titelLb setText:@"收藏到饮食记录"];
    [titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    [titelLb setFont:[UIFont systemFontOfSize:15]];
    
    [backView addSubview:titelLb];
    [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(backView).offset(15);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"SEMainStartic_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.bottom.equalTo(backView.mas_top).offset(-15);
    }];
    
    UIView *lineOne = [UIView new];
    [lineOne.layer setBorderColor:[[UIColor colorWithHexString:@"dfdfdf"] CGColor]];
    [lineOne.layer setBorderWidth:0.5];
    [lineOne setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lineOneTap)];
    [lineOne addGestureRecognizer:tapOne];
    
    [backView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titelLb.mas_bottom).offset(15);
        make.left.equalTo(backView).offset(10);
        make.right.equalTo(backView).offset(-10);
        make.height.equalTo(@40);
    }];
    
    self.dateLb  = [UILabel new];
    [self.dateLb setTextColor:[UIColor colorWithHexString:@"666666"]];
    [self.dateLb setFont:[UIFont systemFontOfSize:14]];
    NSDate *pickerDate = [NSDate date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    [self.dateLb setText:dateString];
    
    [lineOne addSubview:self.dateLb];
    [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineOne);
        make.left.equalTo(lineOne).offset(10);
    }];
    
    UIImageView *arrow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
    [lineOne addSubview:arrow1];
    [arrow1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineOne);
        make.right.equalTo(lineOne).offset(-10);
    }];
    
    UIView *lineTwo = [UIView new];
    [lineTwo.layer setBorderColor:[[UIColor colorWithHexString:@"dfdfdf"] CGColor]];
    [lineTwo.layer setBorderWidth:0.5];
    [lineTwo setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lineTwoTap)];
    [lineTwo addGestureRecognizer:tapTwo];

    [backView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(5);
        make.left.equalTo(backView).offset(10);
        make.right.equalTo(backView).offset(-10);
        make.height.equalTo(@40);
    }];
    
    self.timeLb  = [UILabel new];
    [self.timeLb setTextColor:[UIColor colorWithHexString:@"666666"]];
    [self.timeLb setFont:[UIFont systemFontOfSize:14]];
    [self.timeLb setText:self.timeArr.firstObject];
    
    [lineTwo addSubview:self.timeLb];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineTwo);
        make.left.equalTo(lineTwo).offset(10);
    }];
    
    UIImageView *arrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
    [lineTwo addSubview:arrow2];
    [arrow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineTwo);
        make.right.equalTo(lineTwo).offset(-10);
    }];
    
    
    UIView *lineThree = [UIView new];
    [lineThree.layer setBorderColor:[[UIColor colorWithHexString:@"dfdfdf"] CGColor]];
    [lineThree.layer setBorderWidth:0.5];
    [lineThree setBackgroundColor:[UIColor whiteColor]];
    
    [backView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwo.mas_bottom).offset(5);
        make.left.equalTo(backView).offset(10);
        make.right.equalTo(backView).offset(-10);
        make.height.equalTo(@80);
    }];
    
    
    self.textView = [[UITextView alloc] init];
    [self.textView setFont:[UIFont systemFontOfSize:14]];
    [self.textView setDelegate:self];
    
    [lineThree addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThree).offset(5);
        make.left.equalTo(lineThree).offset(10);
        make.right.equalTo(lineThree).offset(-10);
        make.bottom.equalTo(lineThree).offset(-5);
    }];
    
    self.placeholdLb = [UILabel new];
    [self.placeholdLb setText:@"添加饮食备注信息"];
    [self.placeholdLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    [self.placeholdLb setFont:[UIFont systemFontOfSize:14]];
    
    [lineThree addSubview:self.placeholdLb];
    [self.placeholdLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThree).offset(13);
        make.left.equalTo(lineThree).offset(17);
    }];
    
    
    UIButton *saveBtn = [UIButton new];
    [saveBtn.layer setCornerRadius:4];
    [saveBtn setClipsToBounds:YES];
    [saveBtn setBackgroundImage:[UIImage imageColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:saveBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lineThree);
        make.top.equalTo(lineThree.mas_bottom).offset(15);
        make.height.equalTo(@40);
        make.bottom.equalTo(backView).offset(-15);
    }];
    
    
    [self.view addSubview:self.datePicker];
    [self.view addSubview:self.timePicker];
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    [self hideDatePicker];
    [self hideTimePicker];
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    self.bottomHieght.offset(-height);
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    self.bottomHieght.offset(-200);
    
}

- (void)startAddUserDietRecordRequest {
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dicPost setValue:[NSString stringWithFormat:@"%@%@",im_IP_http,self.model.attachModel.fileUrl] forKey:@"imageUrl"];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [pickerFormatter stringFromDate:self.selectDate];
    [dicPost setValue:dateString forKey:@"date"];
    [dicPost setValue:self.textView.text forKey:@"dietDesc"];

    [dicPost setValue:@([self.timeArr indexOfObject:self.timeLb.text] + 1) forKey:@"dietType"];
    [dicPost setValue:self.strUid forKey:@"sessionName"];
    [dicPost setValue:@(self.model._msgId) forKey:@"msgId"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMAddImageToUserDietRecordRequest" taskParam:dicPost TaskObserver:self];
}

#pragma mark - event Response
- (void)btnClick {
    if (self.block) {
        self.block(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)saveClick {
    [self startAddUserDietRecordRequest];
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    //添加你自己响应代码
    NSLog(@"dateChanged响应事件：%@",date);
    
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    self.selectDate = pickerDate;
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    [self.dateLb setText:dateString];
    
}

- (void)hideDatePicker {
    [UIView animateWithDuration:0.2 animations:^{
        [self.datePicker setFrame:CGRectMake(0, ScreenHeight, self.view.frame.size.width, 190)];
    }];
}

- (void)hideTimePicker {
    [UIView animateWithDuration:0.2 animations:^{
        [self.timePicker setFrame:CGRectMake(0, ScreenHeight, self.view.frame.size.width, 190)];
    }];

}
- (void)lineOneTap {
    if (self.datePicker.frame.origin.y < ScreenHeight) {
        [self hideDatePicker];
            }
    else {
        [self hideTimePicker];
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.2 animations:^{
            [self.datePicker setFrame:CGRectMake(0, ScreenHeight - 190, self.view.frame.size.width, 190)];

        }];

    }
}

- (void)lineTwoTap {
    if (self.timePicker.frame.origin.y < ScreenHeight) {
        [self hideTimePicker];
           }
    else {
        [self hideDatePicker];
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.2 animations:^{
            [self.timePicker setFrame:CGRectMake(0, ScreenHeight - 190, self.view.frame.size.width, 190)];
            
        }];
        
    }
}
#pragma mark - Delegate
- (void)textViewDidChange:(UITextView *)textView {
    [self.placeholdLb setHidden:self.textView.text.length];
    
    if ([textView.text length] > JWMaxTextCount) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, JWMaxTextCount)];
        [textView.undoManager removeAllActions];
        [textView becomeFirstResponder];
        [self at_postError:[NSString stringWithFormat:@"最多输入%ld字",(long)JWMaxTextCount]];
        return;
    }
}

#pragma mark - PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.timeArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.frame.size.width;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.timeArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.timeLb setText:self.timeArr[row]];
}
#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self.view closeWaitView];

        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HMAddImageToUserDietRecordRequest"])
    {
        if (self.block) {
            self.block(YES);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Interface

#pragma mark - init UI

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, ScreenHeight, self.view.frame.size.width, 190)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];//重点：UIControlEventValueChanged
        
        //设置显示格式
        //默认根据手机本地设置显示为中文还是其他语言
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
        _datePicker.locale = locale;
        [_datePicker setMaximumDate:[NSDate date]];
    }
    return _datePicker;
}

- (UIPickerView *)timePicker {
    if (!_timePicker) {
        _timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight, self.view.frame.size.width, 190)];
        [_timePicker setDelegate:self];
        [_timePicker setDataSource:self];
        _timePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];

    }
    return _timePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
