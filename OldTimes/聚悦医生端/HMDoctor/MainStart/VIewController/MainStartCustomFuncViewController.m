//
//  MainStartCustomFuncViewController.m
//  HMDoctor
//
//  Created by lkl on 16/8/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartCustomFuncViewController.h"
#import "StartFuncInfo.h"

#define kStartFuncKey        @"StartFunList"

@interface CustomGroupView : UIView
@property (nonatomic, retain) UILabel *lbMsg;
@end

@implementation CustomGroupView
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        
        _lbMsg = [[UILabel alloc] init];
        [self addSubview:_lbMsg];
        [_lbMsg setFont:[UIFont systemFontOfSize:14]];
        [_lbMsg setTextColor:[UIColor blackColor]];
        
        [_lbMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self);
            make.height.mas_equalTo(@20);
        }];
    }
    return self;
}


@end

@interface MainStartCustomFuncViewController ()
{
    UIScrollView *scrollView;
    UILabel *lbPromptMsg;
    StartFuncInfoHelper* funcHelper;
    NSArray *funcItemArray;
    
    UIView *showFunsView;
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    
    UIView *customAddView;
    CustomGroupView *patientMangerView;
    CustomGroupView *workGroupView;
    CustomGroupView *toolLibraryView;
    
    CGPoint nextPoint;
}

//行数
@property (nonatomic, assign) NSInteger showLineNum;

@property (nonatomic, retain) NSMutableArray *showFuncInfoArray;
@property (nonatomic, retain) NSMutableArray *otherFuncInfoArray;

@property (nonatomic, strong) NSMutableArray *selectedBtns;
@property (nonatomic, strong) NSMutableArray *otherBtns;
@end

@implementation MainStartCustomFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"自定义"];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton setFrame:CGRectMake(0, 0, 40, 40)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *saveBtnItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [self.navigationItem setRightBarButtonItem:saveBtnItem];
    [saveButton addTarget:self action:@selector(saveFunsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    funcHelper = [StartFuncInfoHelper defaultHelper];
    funcItemArray = [funcHelper startFuncItems];
    self.showFuncInfoArray = [[NSMutableArray alloc] initWithArray:funcItemArray];
    
    [self initWithSubViews];
    [self getAllCategories];
    [self createButtons];
}

-(void)getAllCategories
{
    if (!self.otherFuncInfoArray)
    {
        _otherFuncInfoArray = [[NSMutableArray alloc] init];
    }
    
    NSArray *funcNameArray = @[@"随访用户", @"收费用户", @"用药建议",@"问诊表",@"随访表",@"医生关怀",@"检验检查",
                      @"工作组",
                      @"医疗公式",@"用药助手",@"疾病指南",@"病例案例",@"营养库",@"医疗资讯",@"院内资讯"
                      ];
    NSArray *funcIconNameArray = @[
                          @"icon_paitent_free",
                          @"icon_paitent_charge",
                          @"img_main_prescription",
                          @"img_main_interrogation",
                          @"img_main_survey",
                          @"img_main_guanhuai",
                          @"img_main_survey",
                          
                          @"img_main_survey",
                          
                          @"img_main_format",
                          @"img_main_survey",
                          @"img_main_disease",
                          @"img_main_survey",
                          @"img_main_survey",
                          @"img_main_survey",
                          @"img_main_survey",
                          ];
    
    //是否开通
    NSArray *isValidArray = @[@"1",@"1",@"1",@"1",@"1",@"1",@"0",
                              @"1",
                              @"0",@"0",@"0",@"0",@"1",@"0",@"0"
                              ];
    //是否必须
    NSArray *isisMustArray = @[@"1",@"1",@"1",@"0",@"1",@"1",@"1",
                               @"0",
                               @"0",@"0",@"0",@"0",@"0",@"0",@"0"
                               ];
    
    for (int index = 0; index < funcNameArray.count; index++)
    {
        StartFuncInfo *funcInfo = [[StartFuncInfo alloc] init];
        funcInfo.funcName = [funcNameArray objectAtIndex:index];
        funcInfo.funcIconName = [funcIconNameArray objectAtIndex:index];
        [funcInfo setIsValid:[[isValidArray objectAtIndex:index] integerValue]];
        [funcInfo setIsMust:[[isisMustArray objectAtIndex:index] integerValue]];
        [funcInfo setFuncIndex:index];
        [self.otherFuncInfoArray addObject:funcInfo];
    }
    
}

#pragma mark -计算按钮行数
-(void)calculationOfLineNum
{
    if (self.showFuncInfoArray.count%4 != 0)
    {
        _showLineNum = self.showFuncInfoArray.count/4+1;
    }else
    {
        _showLineNum = self.showFuncInfoArray.count/4;
    }
}

#pragma mark -定制Button
-(void)customButton:(UIButton*)btn andTitle:(NSString*)name
{
    [btn setBackgroundColor:[UIColor mainThemeColor]];
    [btn.layer setCornerRadius:5.0f];
    [btn.layer setMasksToBounds:YES];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)createButtons
{
    buttonWidth = (ScreenWidth-55)/4;
    buttonHeight = 30;
    [self calculationOfLineNum];

    NSLog(@"%@",NSHomeDirectory());
    //自定义
    self.selectedBtns=[[NSMutableArray alloc]init];
    
    for (int i=0; i< funcItemArray.count; i++)
    {
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(12.5+i%4*(buttonWidth+10), 15+i/4*(buttonHeight+15), buttonWidth, buttonHeight)];
        [showFunsView addSubview:btn];
        
        [self customButton:btn andTitle:[[funcItemArray objectAtIndex:i] funcName]];
        
        [btn addTarget:self action:@selector(deleteCustomFunsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i <= 3)
        {
            btn.enabled=NO;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [self.selectedBtns addObject:btn];
    }
    
    //患者管理、工作组、工具库
    self.otherBtns = [[NSMutableArray alloc] init];
    for (int i=0; i < self.otherFuncInfoArray.count; i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        
        [self customButton:btn andTitle:[[self.otherFuncInfoArray objectAtIndex:i] funcName]];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (i < 5)
        {
            [btn setFrame:CGRectMake(12.5+i%4*(buttonWidth+10), 25+15+i/4*(buttonHeight+15), buttonWidth, buttonHeight)];
            [patientMangerView addSubview:btn];
            
        }else if (i == 5)
        {
            [btn setFrame:CGRectMake(12.5+(i-5)%4*(buttonWidth+10), 25+15+(i-5)/4*(buttonHeight+15), buttonWidth, buttonHeight)];
            [workGroupView addSubview:btn];
        }else
        {
            [btn setFrame:CGRectMake(12.5+(i-6)%4*(buttonWidth+10), 25+15+(i-6)/4*(buttonHeight+15), buttonWidth, buttonHeight)];
            [toolLibraryView addSubview:btn];
        }
        [self.otherBtns addObject:btn];
        [btn addTarget:self action:@selector(addCustomFunsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //如果数组里面有这个item,设置不可点
        for (int j = 0; j < self.showFuncInfoArray.count; j++)
        {
            if ([[[self.showFuncInfoArray objectAtIndex:j] funcName] isEqualToString:[[self.otherFuncInfoArray objectAtIndex:i] funcName]])
            {
                [btn setEnabled:NO];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)addCustomFunsBtnClick:(UIButton *)btn
{
    [btn setEnabled:NO];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    UIButton *button=self.selectedBtns.lastObject;
    
    for (StartFuncInfo *funcInfo in self.otherFuncInfoArray)
    {
        if ([funcInfo.funcName isEqualToString:btn.titleLabel.text])
        {
            [self.showFuncInfoArray addObject:funcInfo];

            UIButton *addButton = [[UIButton alloc]init];
            [addButton setFrame:btn.frame];
            [self customButton:addButton andTitle:btn.titleLabel.text];
            [self.selectedBtns addObject:addButton];
            
            CGRect buttonRect = button.frame;

            if (customAddView.bottom+45 > ScreenHeight - 94)
            {
                [scrollView setContentSize:CGSizeMake(ScreenWidth, customAddView.bottom+90)];
            }
            
            if (buttonRect.origin.x+buttonRect.size.width+addButton.frame.size.width>ScreenWidth)
            {
                addButton.frame = CGRectMake(12.5, button.frame.size.height+buttonRect.origin.y+15, buttonRect.size.width, buttonRect.size.height);
                [UIView animateWithDuration:0.3 animations:^{
                    
                    [showFunsView mas_updateConstraints:^(MASConstraintMaker *make) {
            
                        make.height.mas_equalTo(showFunsView.frame.size.height+buttonHeight+15);
                    }];

                } completion:^(BOOL finished) {
                    
                }];
            }else
            {
                addButton.frame = CGRectMake(buttonRect.size.width+buttonRect.origin.x+10, buttonRect.origin.y, buttonRect.size.width, buttonRect.size.height);
            }
            [showFunsView addSubview:addButton];
            [addButton addTarget:self action:@selector(deleteCustomFunsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (void)deleteCustomFunsBtnClick:(UIButton *)btn
{
    [btn removeFromSuperview];
    
    //如果数组里面有这个item,设置不可点
    for (int j = 0; j < self.otherFuncInfoArray.count; j++)
    {
        if ([btn.titleLabel.text isEqualToString:[[self.otherFuncInfoArray objectAtIndex:j] funcName]])
        {
            [[self.otherBtns objectAtIndex:j] setEnabled:YES];
            [[self.otherBtns objectAtIndex:j] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    for (StartFuncInfo *funcInfo in self.showFuncInfoArray)
    {
        if ([funcInfo.funcName isEqualToString:btn.titleLabel.text])
        {
            
            CGPoint btnPoint = btn.center;
            __block CGPoint wbtPoint = btnPoint;
            
            [self.showFuncInfoArray removeObject:funcInfo];
            [self calculationOfLineNum];
            
            NSInteger showFunsViewHeight =15+ _showLineNum*(buttonHeight+15);
            [UIView animateWithDuration:0.3 animations:^{
                
                [showFunsView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(showFunsViewHeight);
                }];
                
                if (customAddView.bottom-45 > ScreenHeight - 94)
                {
                    [scrollView setContentSize:CGSizeMake(ScreenWidth, customAddView.bottom-90)];
                }
                
                for (NSInteger i = [self.selectedBtns indexOfObject:btn]+1; i<self.selectedBtns.count; i++)
                {
                    UIButton * nextBt = self.selectedBtns[i];
                    nextPoint = nextBt.center;
                    nextBt.center = wbtPoint;
                    wbtPoint = nextPoint;
                }
            } completion:^(BOOL finished) {
                [self.selectedBtns removeObject:btn];
            }];
            
            break;
        }
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithSubViews
{
    lbPromptMsg = [[UILabel alloc] init];
    [self.view addSubview:lbPromptMsg];
    [lbPromptMsg setBackgroundColor:[UIColor colorWithRed:255.0/255 green:254.0/255 blue:200.0/255 alpha:1.0]];
    [lbPromptMsg setText:@"    点击可以进行增减"];
    [lbPromptMsg setFont:[UIFont systemFontOfSize:12]];
    [lbPromptMsg setTextColor:[UIColor blackColor]];
    
    scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    
    showFunsView = [[UIView alloc]init];
    [scrollView addSubview:showFunsView];
    //[showFunsView setBackgroundColor:[UIColor magentaColor]];
    
    customAddView = [[UIView alloc] init];
    [scrollView addSubview:customAddView];
    
    patientMangerView = [[CustomGroupView alloc] init];
    [customAddView addSubview:patientMangerView];
    [patientMangerView.lbMsg setText:@"    用户管理"];
    
    workGroupView = [[CustomGroupView alloc] init];
    [customAddView addSubview:workGroupView];
    [workGroupView.lbMsg setText:@"    工作组"];
    
    toolLibraryView = [[CustomGroupView alloc] init];
    [customAddView addSubview:toolLibraryView];
    [toolLibraryView.lbMsg setText:@"    工具库"];
    
    [self subViewsLayout];
}

- (void)subViewsLayout
{
    [lbPromptMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(@30);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbPromptMsg.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(ScreenHeight-30);
    }];
    
    [self calculationOfLineNum];
    float showFunsViewH = _showLineNum*45+15;
    [showFunsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.width.equalTo(scrollView);
        make.height.mas_equalTo(showFunsViewH);
    }];

    [customAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(showFunsView.mas_bottom);
        make.height.mas_equalTo(@330);
    }];

    if (showFunsViewH+330 > ScreenHeight - 94)
    {
        [scrollView setContentSize:CGSizeMake(ScreenWidth, showFunsViewH+330+45)];
    }
    
    [patientMangerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(customAddView);
        make.height.mas_equalTo(@125);
        
    }];
    
    [workGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(patientMangerView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@80);
        
    }];
    
    [toolLibraryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workGroupView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@125);
        
    }];
}

//保存
- (void)saveFunsButtonClick:(UIButton *)sender
{
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];

    NSDictionary *dicFuncInfo = @{[NSString stringWithFormat:@"%ld",curStaff.staffId]:self.showFuncInfoArray};

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicFuncInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kStartFuncKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
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
