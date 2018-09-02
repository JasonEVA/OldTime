//
//  BodyDetectManageViewController.m
//  HMClient
//
//  Created by lkl on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyDetectManageViewController.h"
#import "RecordHealthInfo.h"
#import "InitializationHelper.h"

//@implementation CustomButton
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _imgView = [[UIImageView alloc] init];
//        [_imgView setImage:[UIImage imageNamed:@"monitor_del"]];
//        //[self setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
//        [self addSubview:_imgView];
//        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            //make.centerY.equalTo(self);
//            make.top.and.right.equalTo(self);
//            //make.right.equalTo(self.mas_right).offset(-10);
//            make.size.mas_equalTo(CGSizeMake(15, 15));
//        }];
//
//    }
//    return self;
//}
//
//@end

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont font_26]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
        
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
    }
    return self;
}

@end

@interface BodyDetectManageViewController ()
<TaskObserver>
{
    NSMutableArray *tempShowArray;
    NSMutableArray *tempOtherArray;
    
    NSInteger showDetectLineNum;
    NSInteger otherDetectLineNum;
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    
    UIView *showDetectView;
    UIView *otherDetectView;
    UILabel *lbaddItem;
    UILabel *lbaddedItem;

    CGPoint nextPoint;
    
    NSArray* showServiceArray;
}

@property (nonatomic, strong) NSMutableArray *selectedBtns;
@property (nonatomic, strong) NSMutableArray *otherBtns;

@end

@implementation BodyDetectManageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"监测项管理"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthCenterDetectEnumTask" taskParam:nil TaskObserver:self];
    
    //[self refreshUI];
}

- (void)refreshUI
{
    [self.view showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserTestRecoderHealthyTask" taskParam:nil TaskObserver:self];
}

- (BOOL) userHasService
{
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService) {
        return YES;
    }
    return NO;
}

#pragma mark -计算按钮行数
-(void)calculationOfLineNum
{
    if (self.showDetectArray.count%4 != 0)
    {
        showDetectLineNum = self.showDetectArray.count/4+1;
    }else
    {
        showDetectLineNum = self.showDetectArray.count/4;
    }
    
    if (self.otherDetectArray.count%4 != 0)
    {
        otherDetectLineNum = self.otherDetectArray.count/4+1;
    }else
    {
        otherDetectLineNum = self.otherDetectArray.count/4;
    }
}

#pragma mark -定制Button
-(void)customButton:(CustomButton*)btn andTitle:(NSString*)name
{
//    [btn.imgView setImage:[UIImage imageNamed:@"monitor_del"]];
//    [btn setTitle:name forState:UIControlStateNormal];
//    [btn.titleLabel setFont:[UIFont font_26]];
//    [btn setBackgroundColor:[UIColor mainThemeColor]];
//    [btn.layer setCornerRadius:4.0f];
//    [btn.layer setMasksToBounds:YES];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn.imgView setImage:[UIImage imageNamed:@"icon_close2"]];
    [btn.titleLabel setText:name];
    [btn.titleLabel setBackgroundColor:[UIColor mainThemeColor]];
    [btn.titleLabel setTextColor:[UIColor whiteColor]];
    [btn.titleLabel.layer setCornerRadius:4.0f];
    [btn.titleLabel.layer setMasksToBounds:YES];
}

- (void)canAddButton:(CustomButton*)btn andTitle:(NSString*)name{
//    [btn setTitle:name forState:UIControlStateNormal];
//    [btn.imgView setImage:[UIImage imageNamed:@"monitor_add"]];
//    [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor whiteColor]];
//    [btn.layer setBorderWidth:0.5];
//    [btn.layer setBorderColor:[UIColor mainThemeColor].CGColor];
//    [btn.layer setCornerRadius:4.0f];
//    [btn.layer setMasksToBounds:YES];
//    [btn.titleLabel setFont:[UIFont font_26]];
    
    [btn.imgView setImage:[UIImage imageNamed:@"monitor_add"]];
    [btn.titleLabel setText:name];
    [btn.titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [btn.titleLabel setBackgroundColor:[UIColor whiteColor]];
    [btn.titleLabel.layer setBorderWidth:0.5];
    [btn.titleLabel.layer setBorderColor:[UIColor mainThemeColor].CGColor];
    [btn.titleLabel.layer setCornerRadius:4.0f];
    [btn.titleLabel.layer setMasksToBounds:YES];

}

-(void)createUI
{
    self.showDetectArray = [[NSMutableArray alloc] initWithArray:tempShowArray];
    self.otherDetectArray = [[NSMutableArray alloc] initWithArray:tempOtherArray];
    
    buttonWidth = (ScreenWidth- 25 - 3*9)/4;
    buttonHeight = 40;
    
    [self calculationOfLineNum];
    
    lbaddedItem = [[UILabel alloc] init];
    [self.view addSubview:lbaddedItem];
    [lbaddedItem setText:@"已添加监测项"];
    [lbaddedItem setFont:[UIFont font_30]];
    [lbaddedItem setTextColor:[UIColor colorWithHexString:@"666666"]];
    
    [lbaddedItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.equalTo(self.view).with.offset(10);
    }];

    showDetectView = [[UIView alloc] init];
    [self.view addSubview:showDetectView];
    [showDetectView setBackgroundColor:[UIColor whiteColor]];
    [showDetectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(lbaddedItem.mas_bottom).offset(10);
        make.height.mas_equalTo(showDetectLineNum*(buttonHeight+10)+10);
    }];
    
    self.selectedBtns=[[NSMutableArray alloc]init];
    for (int i=0; i<self.showDetectArray.count; i++)
    {
        CustomButton* btn=[[CustomButton alloc]initWithFrame:CGRectMake(12.5+i%4*(buttonWidth+9), 10+i/4*(buttonHeight+10), buttonWidth, buttonHeight)];
        
        [btn addTarget:self action:@selector(deleteCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
        DeviceDetectRecord *testRecord = [self.showDetectArray objectAtIndex:i];
        [self customButton:btn andTitle:testRecord.kpiName];
        
        for (int i=0; i<showServiceArray.count; i++)
        {
            DeviceDetectRecord* showSeviceRecord = [showServiceArray objectAtIndex:i];
            
            if ([showSeviceRecord.kpiName isEqualToString:testRecord.kpiName]) {
                
                btn.enabled = NO;
                //[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                [btn.imgView setHidden:YES];
                //[btn setTitleEdgeInsets:UIEdgeInsetsZero];
                [btn.titleLabel setTextColor:[UIColor whiteColor]];
            }
        }
        
        //[btn setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
        
        /*if (i==0) {
         btn.enabled=NO;
         [btn setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
         }
         
         
         if (![self userHasService])
         {
         if ([testRecord.kpiCode isEqualToString:@"XY"] || [testRecord.kpiCode isEqualToString:@"XL"] || [testRecord.kpiCode isEqualToString:@"TZ"]) {
         btn.enabled = NO;
         [btn setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
         }
         }else
         {
         for (int i=0; i<showServiceArray.count; i++)
         {
         DeviceDetectRecord* showSeviceRecord = [showServiceArray objectAtIndex:i];
         
         if ([showSeviceRecord.kpiName isEqualToString:testRecord.kpiName]) {
         
         btn.enabled = NO;
         [btn setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
         }
         }
         }*/
        
        [showDetectView addSubview:btn];
        [self.selectedBtns addObject:btn];
    }
    
    lbaddItem = [[UILabel alloc] init];
    [self.view addSubview:lbaddItem];
    [lbaddItem setText:@"可添加监测项"];
    [lbaddItem setFont:[UIFont font_30]];
    [lbaddItem setTextColor:[UIColor colorWithHexString:@"666666"]];
    
    [lbaddItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.equalTo(showDetectView.mas_bottom).with.offset(10);
    }];

    otherDetectView = [[UIView alloc] init];
    [self.view addSubview:otherDetectView];
    [otherDetectView setBackgroundColor:[UIColor whiteColor]];
    [otherDetectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(lbaddItem.mas_bottom).offset(10);
        make.height.mas_equalTo(otherDetectLineNum*(buttonHeight+10)+10);
    }];
    
    
    
    [self.view insertSubview:otherDetectView atIndex:0];
    
    self.otherBtns=[[NSMutableArray alloc]init];
    for (int i = 0; i < self.otherDetectArray.count; i++)
    {
        CustomButton* btn=[[CustomButton alloc]initWithFrame:CGRectMake(12.5+i%4*(buttonWidth+9), 10+i/4*(buttonHeight+10), buttonWidth, buttonHeight)];
        DeviceDetectRecord *testRecord = [self.otherDetectArray objectAtIndex:i];
        [self canAddButton:btn andTitle:testRecord.kpiName];
        [btn addTarget:self action:@selector(addCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
        [otherDetectView addSubview:btn];
        [self.otherBtns addObject:btn];
    }
}

//做动画
-(void)addCategoryBtn:(CustomButton*)btn
{
    self.view.userInteractionEnabled=NO;
    
    CustomButton* button=self.selectedBtns.lastObject;
    
    for (DeviceDetectRecord *testRecord in self.otherDetectArray)
    {
        if ([testRecord.kpiName isEqualToString:btn.titleLabel.text])
        {
            [btn removeTarget:self action:@selector(addCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(deleteCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self customButton:btn andTitle:btn.titleLabel.text];
            [self.showDetectArray addObject:testRecord];
            [self.otherDetectArray removeObject:testRecord];
            
            CGPoint btnPoint = btn.center;
            __block CGPoint wbtPoint = btnPoint;
            [UIView animateWithDuration:0.3 animations:^{
                
                for (NSInteger i = [self.otherBtns indexOfObject:btn]+1; i<self.otherBtns.count; i++) {
                    CustomButton * nextBt = self.otherBtns[i];
                    nextPoint = nextBt.center;
                    nextBt.center = wbtPoint;
                    wbtPoint = nextPoint;
                }
                
                [self.otherBtns removeObject:btn];
                [self.selectedBtns addObject:btn];
                
                [self calculationOfLineNum];
                
            } completion:^(BOOL finished) {
                self.view.userInteractionEnabled=YES;
            }];
            
            if (self.showDetectArray.count == 1)
            {
                button = [[CustomButton alloc]initWithFrame:CGRectMake(-buttonWidth+9*kScreenScale, 0, buttonWidth, buttonHeight)];
                
                [showDetectView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(10 + showDetectLineNum*(buttonHeight+10));
                }];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [showDetectView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(10 + showDetectLineNum*(buttonHeight+10));
                }];
                
                [otherDetectView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(10 + otherDetectLineNum*(buttonHeight+10));
                }];
                
            } completion:^(BOOL finished) {
                
            }];
            
            if (button.frame.size.width+button.frame.origin.x+btn.frame.size.width>ScreenWidth) {
                btn.frame=CGRectMake(12.5, button.frame.size.height+button.frame.origin.y+10, 0, button.frame.size.height);
            }else
            {
                btn.frame=CGRectMake(button.frame.size.width+button.frame.origin.x+9, button.frame.origin.y, 0, button.frame.size.height);
            }
            //[btn setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
            [showDetectView addSubview:btn];
            
            [UIView animateWithDuration:0.3 animations:^{
                btn.frame=CGRectMake(btn.frame.origin.x, btn.frame.origin.y, button.frame.size.width, button.frame.size.height);
            } completion:^(BOOL finished) {
                self.view.userInteractionEnabled=YES;
            }];
            
            //上传
            NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *dicPostValue = [[NSMutableDictionary alloc] init];
            NSMutableArray *postArr = [[NSMutableArray alloc] init];
            
            [dicPostValue setValue:testRecord.userId forKey:@"userId"];
            [dicPostValue setValue:testRecord.relationId forKey:@"relationId"];
            [dicPostValue setValue:testRecord.kpiCode forKey:@"kpiCode"];
            [dicPostValue setValue:@"Y" forKey:@"isShow"];
            [dicPostValue setValue:testRecord.sort forKey:@"sort"];
            
            [postArr addObject:dicPostValue];
            [dicPost setValue:postArr forKey:@"userTestRelations"];
            
            [[TaskManager shareInstance] createTaskWithTaskName:@"UpdateUserTestRelationTask" taskParam:dicPost TaskObserver:self];
            
            break;
        }
    }
}


-(void)deleteCategoryBtn:(CustomButton*)btn
{
    self.view.userInteractionEnabled=NO;
    //[btn.titleLabel setTextColor:[UIColor mainThemeColor]];
    /*for (UIGestureRecognizer* gr in btn.gestureRecognizers)
     {
     if ([gr isKindOfClass:[UILongPressGestureRecognizer class]])
     {
     [btn removeGestureRecognizer:gr];
     }
     }*/
    
    for (DeviceDetectRecord *testRecord in self.showDetectArray)
    {
        if ([testRecord.kpiName isEqualToString:btn.titleLabel.text])
        {
            CGPoint btnPoint = btn.center;
            
            [btn removeTarget:self action:@selector(deleteCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(addCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self canAddButton:btn andTitle:btn.titleLabel.text];
            __block CGPoint wbtPoint = btnPoint;
            
            [self.showDetectArray removeObject:testRecord];
            [self.otherDetectArray insertObject:testRecord atIndex:0];
            [self calculationOfLineNum];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [showDetectView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(10 + showDetectLineNum*(buttonHeight+10));
                }];
                [otherDetectView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(10 + otherDetectLineNum*(buttonHeight+10));
                }];
                
                btn.frame = CGRectMake(0, otherDetectView.frame.origin.y, buttonWidth, buttonHeight);
                for (NSInteger i = [self.selectedBtns indexOfObject:btn]+1; i<self.selectedBtns.count; i++)
                {
                    CustomButton * nextBt = self.selectedBtns[i];
                    nextPoint = nextBt.center;
                    nextBt.center = wbtPoint;
                    wbtPoint = nextPoint;
                }
            } completion:^(BOOL finished) {
                btn.frame=CGRectMake(12.5, 10, buttonWidth, buttonHeight);
                [otherDetectView addSubview:btn];
                [self.selectedBtns removeObject:btn];
                [self.otherBtns insertObject:btn atIndex:0];
            }];
            
            [UIView animateWithDuration:0.3 animations:^{
                for (int i=0; i<self.otherBtns.count; i++)
                {
                    CustomButton* button=self.otherBtns[i];
                    button.frame=CGRectMake(12.5+(i+1)%4*(buttonWidth+9), 10+((i+1)/4)*(buttonHeight+10), buttonWidth, buttonHeight);
                    //[button.titleLabel setTextColor:[UIColor mainThemeColor]];
                }
            } completion:^(BOOL finished) {
                self.view.userInteractionEnabled=YES;
            }];
            
            //上传
            NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *dicPostValue = [[NSMutableDictionary alloc] init];
            NSMutableArray *postArr = [[NSMutableArray alloc] init];
            
            [dicPostValue setValue:testRecord.userId forKey:@"userId"];
            [dicPostValue setValue:testRecord.relationId forKey:@"relationId"];
            [dicPostValue setValue:testRecord.kpiCode forKey:@"kpiCode"];
            [dicPostValue setValue:@"N" forKey:@"isShow"];
            [dicPostValue setValue:testRecord.sort forKey:@"sort"];
            
            [postArr addObject:dicPostValue];
            [dicPost setValue:postArr forKey:@"userTestRelations"];
            
            [[TaskManager shareInstance] createTaskWithTaskName:@"UpdateUserTestRelationTask" taskParam:dicPost TaskObserver:self];
            
            break;
        }
    }
    
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UserTestRecoderHealthyTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            tempShowArray = [(NSMutableDictionary*) taskResult valueForKey:@"testRecord"];
            tempOtherArray = [(NSMutableDictionary*) taskResult valueForKey:@"otherTestRecord"];
            
            [self createUI];
        }
    }
    
    if ([taskname isEqualToString:@"HealthCenterDetectEnumTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            showServiceArray = (NSArray*) taskResult;
            
            [self refreshUI];
            //NSLog(@"%@",showArray);
            //[self createDetectCells:tempShowArray];
            
        }
    }
}

@end
