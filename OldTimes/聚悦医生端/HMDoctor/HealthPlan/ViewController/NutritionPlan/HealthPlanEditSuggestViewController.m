//
//  HealthPlanEditSuggestViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanEditSuggestViewController.h"

@interface HealthPlanEditSuggestViewController ()

@property (nonatomic, strong) HealthPlanDetCriteriaModel* criteriaModel;
@property (nonatomic, strong) HeathPlanSuggestEditedHandle editHandle;

@property (nonatomic, strong) UITextView* suggestTextView;


@end

@implementation HealthPlanEditSuggestViewController

- (id) initWithHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) criteriaModel editHandle:(HeathPlanSuggestEditedHandle) handle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _criteriaModel = criteriaModel;
        _editHandle = handle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"建议"];
    [self layoutElements];
    
    [self.suggestTextView setText:self.criteriaModel.suggest];
    
    UIBarButtonItem* saveBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(commitButtonClicked:)];
    [self.navigationItem  setRightBarButtonItem:saveBarItem];
    [self.suggestTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.suggestTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12.5);
        make.right.equalTo(self.view).offset(-12.5);
        make.top.equalTo(self.view).offset(15);
        make.height.mas_equalTo(@206);
    }];
    
   
}

- (void) commitButtonClicked:(id)sender
{
    NSString* suggest = self.suggestTextView.text;
    if (!suggest || suggest.length == 0) {
        [self showAlertMessage:@"请输入您的建议。"];
        return;
    }
    
    self.criteriaModel.suggest = suggest;
    if (self.editHandle) {
        self.editHandle(self.criteriaModel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark settingAndGetting

- (UITextView*) suggestTextView
{
    if (!_suggestTextView) {
        _suggestTextView = [[UITextView alloc] init];
        [self.view addSubview:_suggestTextView];
        [_suggestTextView setBackgroundColor:[UIColor whiteColor]];
        [_suggestTextView setFont:[UIFont systemFontOfSize:15]];
        [_suggestTextView setTextColor:[UIColor commonTextColor]];
        
        _suggestTextView.layer.cornerRadius = 5;
        _suggestTextView.layer.borderWidth = 0.5;
        _suggestTextView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _suggestTextView.layer.masksToBounds = YES;
//        [_suggestTextView becomeFirstResponder];
    }
    return _suggestTextView;
}


@end
