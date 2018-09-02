//
//  ChooseDocumentChooseIllViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ChooseDocumentChooseIllViewController.h"
#import "CreateDocumetnMessionInfo.h"
#import "DocumentDiseaseSelectViewController.h"



@implementation ChooseDocumentChooseIllControl

- (id) init
{
    self = [super init];
    if (self)
    {
        [self showBottomLine];
        
        UIImageView* ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c_grayArrow"]];
        [self addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        _diseaseLable = [[UILabel alloc]init];
        [self addSubview:_diseaseLable];
        [_diseaseLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.top.and.bottom.equalTo(self);
            make.right.equalTo(ivArrow.mas_left);
        }];
        
        [_diseaseLable setText:@"请选择疾病类型"];
        [_diseaseLable setTextColor:[UIColor commonGrayTextColor]];
        [_diseaseLable setFont:[UIFont systemFontOfSize:13]];
    }
    return self;
}

@end

/*
 ChooseDocumentChooseIllViewController
 建档－选择患者疾病界面
 */
@interface ChooseDocumentChooseIllViewController ()
{
    CreateDocumetnMessionInfo* createDocumentMession;
    
    UIView* diseaseView;
    ChooseDocumentChooseIllControl* chooseControl;
}
@end


@implementation ChooseDocumentChooseIllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* navigationTitle = @"选择疾病";
    if (self.paramObject && [self.paramObject isKindOfClass:[CreateDocumetnMessionInfo class]])
    {
        createDocumentMession = (CreateDocumetnMessionInfo*) self.paramObject;
        navigationTitle = [NSString stringWithFormat:@"%@ (%@|%ld)", createDocumentMession.userName, createDocumentMession.sex, createDocumentMession.age];
    }
    [self.navigationItem setTitle:navigationTitle];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self createDiseaseView];
    
    //温馨提示
    UILabel* reminderLable = [[UILabel alloc]init];
    [self.view addSubview:reminderLable];
    [reminderLable setFont:[UIFont systemFontOfSize:10]];
    [reminderLable setTextColor:[UIColor commonRedColor]];
    [reminderLable setNumberOfLines:0];
    [reminderLable setText:@"温馨提示：不同的用户类型，建档评估模板不同，请慎重选择，选择之后不要随意更换，否则将重新录入所有建档评估数据"];
    
    [reminderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(diseaseView.mas_bottom).with.offset(10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize
- (void) createDiseaseView
{
    diseaseView = [[UIView alloc]init];
    [self.view addSubview:diseaseView];
    [diseaseView setBackgroundColor:[UIColor whiteColor]];
    [diseaseView showBottomLine];
    [diseaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@72);
    }];
    
    UIView* docuNumberView = [[UIView alloc]init];
    [docuNumberView setBackgroundColor:[UIColor commonBackgroundColor]];
    [docuNumberView showBottomLine];
    [diseaseView addSubview:docuNumberView];
    [docuNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(diseaseView);
        make.top.equalTo(diseaseView);
        make.height.mas_equalTo(28);
        
    }];
    
    UILabel* docuIdTitleLable = [[UILabel alloc]init];
    [docuNumberView addSubview:docuIdTitleLable];
    [docuIdTitleLable setFont:[UIFont systemFontOfSize:13]];
    [docuIdTitleLable setTextColor:[UIColor commonGrayTextColor]];
    [docuIdTitleLable setText:@"档案编号："];
    [docuIdTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(docuNumberView);
        make.left.equalTo(docuNumberView).with.offset(12.5);
    }];
    
    UILabel* docuIdLable = [[UILabel alloc]init];
    [docuNumberView addSubview:docuIdLable];
    [docuIdLable setText:createDocumentMession.healtyRecordId];
    [docuIdLable setFont:[UIFont systemFontOfSize:13]];
    [docuIdLable setTextColor:[UIColor commonTextColor]];
    [docuIdLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(docuNumberView);
        make.left.equalTo(docuIdTitleLable.mas_right);
        make.right.lessThanOrEqualTo(docuNumberView).with.offset(-12.5);
    }];
    
    chooseControl = [[ChooseDocumentChooseIllControl alloc]init];
    [diseaseView addSubview:chooseControl];
    [chooseControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(docuNumberView.mas_bottom);
        make.left.and.right.equalTo(diseaseView);
        make.bottom.equalTo(diseaseView);
    }];
    
    [chooseControl addTarget:self action:@selector(chooseControlClicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (void) chooseControlClicked:(id) sender
{
    __weak typeof(self) weakSelf = self;
    [DocumentDiseaseSelectViewController showInParentController:self messionModel:createDocumentMession selectedBlock:^(BOOL selected, CreateDocumetnTemplateModel* templateModel) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (selected)
        {
            [strongSelf performSelector:@selector(gotoCreateDocumentAssessmentDetailView) withObject:nil afterDelay:0.01];
        }
    }];
}

- (void) gotoCreateDocumetnMessionList
{
     [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentStartViewController" ControllerObject:nil];
}

- (void) gotoCreateDocumentAssessmentDetailView
{
    [createDocumentMession setStatus:2];
    [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentAssessmentDetailViewController" FromControllerId:nil ControllerObject:createDocumentMession];
}

@end
