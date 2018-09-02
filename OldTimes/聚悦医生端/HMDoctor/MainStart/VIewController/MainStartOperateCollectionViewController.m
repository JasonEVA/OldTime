//
//  MainStartOperateCollectionViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartOperateCollectionViewController.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ATModuleInteractor+PatientChat.h"

@interface MainStartOperateCollectionViewCell : UICollectionViewCell
{
    UIImageView* ivIcon;
    UILabel* lbName;
    
    UIImageView* ivNoOpen;
}

- (void) setOperateGird:(NSString*) girdname
                   Icon:(UIImage*) girdicon;

- (void) setNoOpenImage;
@end

@implementation MainStartOperateCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ivIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:ivIcon];
        
        lbName = [[UILabel alloc]init];
        [self.contentView addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setTextColor:[UIColor whiteColor]];
        [lbName setFont:[UIFont systemFontOfSize:13]];
        [lbName setTextAlignment:NSTextAlignmentCenter];
        
        ivNoOpen = [[UIImageView alloc] init];
        [self addSubview:ivNoOpen];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.equalTo(self.contentView).with.offset(8);
        make.centerX.equalTo(self.contentView);
    }];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(@17);
        make.top.equalTo(ivIcon.mas_bottom).with.offset(5);
    }];
    
    [ivNoOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
}

- (void) setOperateGird:(NSString*) girdname
                   Icon:(UIImage*) girdicon
{
    [ivIcon setImage:girdicon];
    [lbName setText:girdname];
}

- (void) setNoOpenImage
{
    [ivNoOpen setImage:[UIImage imageNamed:@"icon_no_open_1"]];
}

@end

typedef enum : NSUInteger {
//    MainStart_PatientIndex,
    MainStart_PatientFree,          // 随访患者
    MainStart_PatientCharge,        // 收费患者
    //MainStart_DiseaseGirdInex,      //疾病指南
    MainStart_PrescriptionIndex,    //开处方
    // MainStart_FormatInex,           //医疗公式
    MainStart_InterrogationIndex,   //问诊表
    //MainStart_MedicationIndex,      //用药助手
    MainStart_SurveyIndex,
    //MainStart_Examine,              //检验检查
    MainStart_CoordinateMessage,    //协同消息
    MainStart_NutrientPool,         //营养库
    MainStart_CoordinateTask,       //协同任务
    //MainStart_MedicalInformation,   //医疗资讯
   // MainStart_MedicalRecord,        //病历案例
    
    
    //MainStart_HospitalInformation,  //院内资讯
    MainStart_MoreIndex,
    MainStartGirdIndexCount,
} MainStartGirdIndex;

@interface MainStartOperateCollectionViewController ()

@end

@implementation MainStartOperateCollectionViewController

static NSString * const reuseIdentifier = @"MainStartOperateCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.collectionView setBackgroundColor:[UIColor magentaColor]];
    // Register cell classes
    [self.collectionView registerClass:[MainStartOperateCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setPagingEnabled:YES];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scroll" object:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    return MainStartGirdIndexCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainStartOperateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell

    switch (indexPath.row)
    {
        case MainStart_PatientFree:
        {
            [cell setOperateGird:@"随访用户" Icon:[UIImage imageNamed:@"icon_paitent_free"]];
            break;
        }
            
        case MainStart_PatientCharge:
        {
            [cell setOperateGird:@"收费用户" Icon:[UIImage imageNamed:@"icon_paitent_charge"]];
            break;
        }

        case MainStart_PrescriptionIndex:
        {
            [cell setOperateGird:@"用药建议" Icon:[UIImage imageNamed:@"img_main_prescription"]];
        }
            break;
        case MainStart_InterrogationIndex:
        {
            [cell setOperateGird:@"问诊表" Icon:[UIImage imageNamed:@"img_main_interrogation"]];
        }
            break;
        case MainStart_SurveyIndex:
        {
            [cell setOperateGird:@"随访表" Icon:[UIImage imageNamed:@"img_main_survey"]];
        }
            break;

//        case MainStart_DiseaseGirdInex:
//        {
//            [cell setOperateGird:@"疾病指南" Icon:[UIImage imageNamed:@"img_main_disease"]];
//        }
//            break;
//        case MainStart_FormatInex:
//        {
//            [cell setOperateGird:@"医疗公式" Icon:[UIImage imageNamed:@"img_main_format"]];
//        }
//            break;
//        case MainStart_MedicationIndex:
//        {
//            [cell setOperateGird:@"用药助手" Icon:[UIImage imageNamed:@"img_main_medication"]];
//        }
//            break;

            /*
             MainStart_Examine,              //检验检查
             MainStart_CoordinateMessage,    //协同消息
             MainStart_CoordinateTask,       //协同任务
             MainStart_MedicalRecord,        //病历案例
             MainStart_NutrientPool,         //营养库
             MainStart_MedicalInformation,   //医疗资讯
             MainStart_HospitalInformation,  //院内资讯
             */
//        case MainStart_Examine:
//        {
//            [cell setOperateGird:@"检验检查" Icon:[UIImage imageNamed:@"img_main_patient"]];
//        }
//            break;
        case MainStart_CoordinateMessage:
        {
            [cell setOperateGird:@"协同消息" Icon:[UIImage imageNamed:@"img_main_format"]];
        }
            break;
        case MainStart_CoordinateTask:
        {
            [cell setOperateGird:@"协同任务" Icon:[UIImage imageNamed:@"img_main_interrogation"]];
        }
            break;
//        case MainStart_MedicalRecord:
//        {
//            [cell setOperateGird:@"病历案例" Icon:[UIImage imageNamed:@"img_main_survey"]];
//        }
//            break;
        case MainStart_NutrientPool:
        {
            [cell setOperateGird:@"营养库" Icon:[UIImage imageNamed:@"img_main_disease"]];
        }
            break;
//        case MainStart_MedicalInformation:
//        {
//            [cell setOperateGird:@"医疗资讯" Icon:[UIImage imageNamed:@"img_main_format"]];
//        }
//            break;
//        case MainStart_HospitalInformation:
//        {
//            [cell setOperateGird:@"院内资讯" Icon:[UIImage imageNamed:@"img_main_medication"]];
//        }
//            break;
            
        case MainStart_MoreIndex:
        {
            [cell setOperateGird:@"更多" Icon:[UIImage imageNamed:@"img_main_more"]];
        }
            break;
        
        default:
            break;
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(80 * kScreenScale, 72 * kScreenScale);
    return size;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case MainStart_PatientFree:
        {
            // 随访患者
            [[ATModuleInteractor sharedInstance] goPatientListVCWithPatientFilterViewType:PatientFilterViewTypeFree];
            break;
        }
            
        case MainStart_PatientCharge:
        {
            // 收费患者
            [[ATModuleInteractor sharedInstance] goPatientListVCWithPatientFilterViewType:PatientFilterViewTypeCharge];
            break;
        }

        case MainStart_SurveyIndex:
        {
            //随访
            [HMViewControllerManager createViewControllerWithControllerName:@"SurveryStartViewController" ControllerObject:nil];
        }
            break;
        case MainStart_InterrogationIndex:
        {
            //问诊
            [HMViewControllerManager createViewControllerWithControllerName:@"InterrogationStartViewController" ControllerObject:nil];
        }
            break;
        case MainStart_CoordinateTask:
        {
            //协同任务
            [[ATModuleInteractor sharedInstance] goTaskList];
        }
            break;
        case MainStart_CoordinateMessage:
        {
            [[HMViewControllerManager defaultManager].tabRoot setSelectedIndex:2];
        }
            break;
            case MainStart_NutrientPool:
        {
            //营养库 
            [HMViewControllerManager createViewControllerWithControllerName:@"NutritionLibsStartViewController" ControllerObject:nil];
        }
            break;
        case MainStart_PrescriptionIndex:
        {
            //开处方
            [HMViewControllerManager createViewControllerWithControllerName:@"NewPrescribeSelectPatientViewController" ControllerObject:nil];
        }
            break;
            
//        case MainStart_DiseaseGirdInex:
//        {
//            //疾病指南
////           
//        }
//            break;
            
        
        default:
            break;
    }
}

@end
