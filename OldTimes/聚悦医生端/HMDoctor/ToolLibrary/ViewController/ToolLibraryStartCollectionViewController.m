//
//  ToolLibraryStartCollectionViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ToolLibraryStartCollectionViewController.h"
#import "ToolLibraryStartHeaderView.h"
#import "ToolLibraryStartCollectionViewCell.h"
#import "HMFastInGroupViewController.h"

#define FASTINGROUP   @"HMFastInGroupPermission"

typedef enum : NSUInteger {
    ToolLibraryStartLiteratureToolsSection,       //文献工具
    ToolLibraryStartInformationSection,   //资讯
    ToolLibraryStartFastTrackSection,   // 快速通道
    ToolLibraryStartCount,
} ToolLibraryStartGirdSection;

typedef enum : NSUInteger{

    ToolLibraryCasesIndex,               //病例案例
    ToolLibraryMedicalFormulaIndex,      //医学公式
    ToolLibraryPharmacyWarehousesIndex,  //药品库
    ToolLibraryNutritionLibraryIndex,    //营养库
    ToolLibraryDiseaseGuidelinesIndex,   //疾病指南
    ToolLibraryHealthEducationIndex,     //健康课堂
    ToolLibraryLiteratureToolMaxCount,
}ToolLibraryLiteratureToolIndex;

typedef enum : NSUInteger{

    ToolLibraryMedicalInformationIndex, //医学资讯
    ToolLibraryInTheInformationIndex,   //院内资讯
    ToolLibraryInformationMaxCount,
}ToolLibraryInformationIndex;

typedef enum : NSUInteger{
    
    ToolLibraryFastIntoGroupIndex, //快速入组
    ToolLibraryStartFastTrackMaxCount,
}ToolLibraryStartFastTrackIndex;

@interface ToolLibraryStartCollectionViewController ()
{
    NSArray* toolsItems;
    NSArray* informationsItems;
}
@end

@implementation ToolLibraryStartCollectionViewController

static NSString * const reuseIdentifier = @"ToolLibraryStartCollectionViewCell";
static NSString *const HeaderIdentifier = @"HeaderIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"工具库"];

    [self.collectionView registerClass:[ToolLibraryStartCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
     [self.collectionView registerClass:[ToolLibraryStartHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton* addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* addBtnItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    //暂时隐藏右上角添加按钮
    //    [self.navigationItem setRightBarButtonItem:addBtnItem];
    
    /*NSMutableArray* toolsGirds = [NSMutableArray array];
    NSArray* toolsnames = @[@"病例案例", @"医学公式", @"药品库", @"营养库",@"疾病指南"];
    for (NSString* name in toolsnames)
    {
        ToolLibraryStartGirdInfo* gird = [[ToolLibraryStartGirdInfo alloc]init];
        [gird setGirdName:name];
        [toolsGirds addObject:gird];
    }
    [self toolsGirdListLoaded:toolsGirds];
    
    NSMutableArray* knowledgeGirds = [NSMutableArray array];
    NSArray* knowledgenames = @[@"医学资讯", @"院内资讯"];
    for (NSString* name in knowledgenames)
    {
        ToolLibraryStartGirdInfo* gird = [[ToolLibraryStartGirdInfo alloc]init];
        [gird setGirdName:name];
        [knowledgeGirds addObject:gird];
    }
    [self knowledgeGirdListLoaded:knowledgeGirds];*/
}

- (void)addBtnClick
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void) toolsGirdListLoaded:(NSArray*) items
{
    toolsItems = [NSArray arrayWithArray:items];
    [self.collectionView reloadData];
}

- (void) knowledgeGirdListLoaded:(NSArray*) items
{
    informationsItems = [NSArray arrayWithArray:items];
    [self.collectionView reloadData];
}

- (BOOL)isHaveFastInGroupPermission {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef valueForKey:FASTINGROUP] && [[userDef valueForKey:FASTINGROUP] isEqualToString:@"Y"]) {
        return YES;
    }
    else {
        return NO;
    }
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (![self isHaveFastInGroupPermission]) {
        return ToolLibraryStartCount - !(ToolLibraryStartFastTrackMaxCount - 1);
    }
    else {
        return ToolLibraryStartCount;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    switch (section)
    {
        case ToolLibraryStartLiteratureToolsSection:
            return ToolLibraryLiteratureToolMaxCount;
            break;
            
        case ToolLibraryStartInformationSection:
            return ToolLibraryInformationMaxCount;
            break;
        case ToolLibraryStartFastTrackSection:
            return ToolLibraryStartFastTrackMaxCount;
            break;
        default:
            break;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolLibraryStartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    switch (indexPath.section)
    {
        case ToolLibraryStartLiteratureToolsSection:
        {
            switch (indexPath.row)
            {
                case ToolLibraryCasesIndex:
                {
                    [cell setGirdImage:@"binglianli" GirdName:@"病例案例"];
                    [cell setNoOpenImage];
                }
                    break;
                    
                case ToolLibraryMedicalFormulaIndex:
                {
                    [cell setGirdImage:@"yixuegongshi" GirdName:@"医学公式"];
                    [cell setNoOpenImage];
                }
                    break;
                    
                case ToolLibraryPharmacyWarehousesIndex:
                {
                    [cell setGirdImage:@"yaopin" GirdName:@"药品库"];
                    [cell setNoOpenImage];
                }
                    break;
                
                case ToolLibraryNutritionLibraryIndex:
                {
                    [cell setGirdImage:@"yingyang" GirdName:@"营养库"];
                }
                    break;
                    
                case ToolLibraryDiseaseGuidelinesIndex:
                {
                    [cell setGirdImage:@"jibingzhinan" GirdName:@"疾病指南"];
                    [cell setNoOpenImage];
                }
                    break;
                case ToolLibraryHealthEducationIndex:
                {
                    [cell setGirdImage:@"ic_xj" GirdName:@"健康课堂"];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case ToolLibraryStartInformationSection:
        {
            switch (indexPath.row) {
                case ToolLibraryMedicalInformationIndex:
                {
                    [cell setGirdImage:@"yixunzixun" GirdName:@"医学资讯"];
                    [cell setNoOpenImage];
                }
                    break;
                    
                case ToolLibraryInTheInformationIndex:
                {
                    [cell setGirdImage:@"yuanneizixun" GirdName:@"院内资讯"];
                    [cell setNoOpenImage];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
            case ToolLibraryStartFastTrackSection:
        {
            switch (indexPath.row) {
                case ToolLibraryFastIntoGroupIndex:
                {
                    // 快速入组
                    [cell setGirdImage:@"tool_fastInGroup" GirdName:@"快速入组"];
                    break;
                }
                default:
                    break;
            }
            break;
        }

        default:
            break;
    }
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case ToolLibraryStartLiteratureToolsSection:
        {
            switch (indexPath.row)
            {
                case ToolLibraryNutritionLibraryIndex:
                {
                    //营养库 NutritionLibsStartViewController
                    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工具库－营养库"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"NutritionLibsStartViewController" ControllerObject:nil];
                }
                    break;
                case ToolLibraryHealthEducationIndex:
                {
                    
                    //健康课堂
                    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"健康计划－健康课堂"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationStartViewController" ControllerObject:nil];
                    
                    break;
                }
                    
                default:
                    break;
            }
        }
            break;
            
            case ToolLibraryStartFastTrackSection:
        {
            switch (indexPath.row) {
                case ToolLibraryFastIntoGroupIndex:
                {
                    // 快速入组
                HMFastInGroupViewController *VC = [[HMFastInGroupViewController alloc] init];
                    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:VC];
                    [self presentViewController:navVC animated:YES completion:nil];

                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
}


#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGFloat height = 35 * kScreenScale;

    return CGSizeMake(320 * kScreenScale, height );
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    ToolLibraryStartHeaderView *headReusableView;
    //此处是headerView
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        headReusableView = (ToolLibraryStartHeaderView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];

        switch (indexPath.section)
        {
            case ToolLibraryStartLiteratureToolsSection:
            {
                [headReusableView setTitle:@"文献工具"];
            }
                break;
            case ToolLibraryStartInformationSection:
            {
                [headReusableView setTitle:@"资讯"];
            }
                break;
            case ToolLibraryStartFastTrackSection:
            {
                [headReusableView setTitle:@"快速通道"];
            }
                break;

            default:
                break;
        }
    }
    
    return headReusableView;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.width/4, 70);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
@end
