//
//  HealthDiscoveryCollectionViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthDiscoveryCollectionViewController.h"
#import "HealthDiscoveryCollectionViewCell.h"

typedef enum : NSUInteger {
    HealthDiscoveryServiceSection,
    HealthDiscoveryKnowledgeSection,
    HealthDiscoverySectionCount,
} HealthDiscoverySection;

@interface HealthDiscoveryCollectionHeaderView : UICollectionReusableView
{
    UILabel* lbTitle;
//    UIView* topLine;
//    UIView* bottomLine;
}
- (void) setTitle:(NSString*) title;

@end

@implementation HealthDiscoveryCollectionHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 290, 20)];
        [self addSubview:lbTitle];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setFont:[UIFont font_24]];
        [lbTitle setTextColor:[UIColor colorWithHexString:@"999999"]];
        
        [lbTitle setText:@"Section"];
        
        [self subviewLayout];
    }
    
    return self;
}

- (void) setTitle:(NSString*) title{
    [lbTitle setText:title];
}

- (void) subviewLayout
{
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(14);
        make.height.equalTo(@15);
    }];
}

@end

static NSString *const HeaderIdentifier = @"HeaderIdentifier";
static NSString *const FooterIdentifier = @"FooterIdentifier";

@interface HealthDiscoveryCollectionViewController ()
{
    NSArray* serviceDiscoveryItems;
    NSArray* knowledgeDiscoveryItems;
}
@end

@implementation HealthDiscoveryCollectionViewController

static NSString * const reuseIdentifier = @"HealthDiscoveryCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[HealthDiscoveryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
     [self.collectionView registerClass:[HealthDiscoveryCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    
    NSMutableArray* serviceGirds = [NSMutableArray array];
    NSArray* servicenames = @[@"服务项目", @"名医团队"];
    NSArray* serivceImageNames = @[@"discovery_service", @"discovery_team"];
    
    for (NSInteger index = 0; index < servicenames.count; ++index)
    {
        NSString* name = servicenames[index];
        NSString* imagename = serivceImageNames[index];
   
        HealthDiscoveryGirdInfo* gird = [[HealthDiscoveryGirdInfo alloc]init];
        [gird setGirdName:name];
        [gird setIconName:imagename];
        [serviceGirds addObject:gird];
    }
    [self serviceGirdItemsLoaded:serviceGirds];
    
    NSMutableArray* knowledgeGirds = [NSMutableArray array];
    NSArray* knowledgenames = @[@"健康课堂", @"用药助手", @"营养库"];
    NSArray* knowledgeImageNames = @[@"discovery_education", @"discovery_medicine", @"discovery_nutrition"];
    for (NSInteger index = 0; index < knowledgenames.count; ++index)
    {
        NSString* name = knowledgenames[index];
        NSString* imagename = knowledgeImageNames[index];

        HealthDiscoveryGirdInfo* gird = [[HealthDiscoveryGirdInfo alloc]init];
        [gird setGirdName:name];
        [gird setIconName:imagename];
        [knowledgeGirds addObject:gird];
    }
    [self knowledgeGirdItemsLoaded:knowledgeGirds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) serviceGirdItemsLoaded:(NSArray*) items
{
    serviceDiscoveryItems = [NSArray arrayWithArray:items];
    [self.collectionView reloadData];
}

- (void) knowledgeGirdItemsLoaded:(NSArray*) items
{
    knowledgeDiscoveryItems = [NSArray arrayWithArray:items];
    [self.collectionView reloadData];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    switch (section)
    {
        case HealthDiscoveryServiceSection:
        {
            if (serviceDiscoveryItems) {
                return serviceDiscoveryItems.count;
            }
        }
            break;
        case HealthDiscoveryKnowledgeSection:
        {
            if (knowledgeDiscoveryItems) {
                return knowledgeDiscoveryItems.count;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HealthDiscoveryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    switch (indexPath.section)
    {
        case HealthDiscoveryServiceSection:
        {
            HealthDiscoveryGirdInfo* gird = serviceDiscoveryItems[indexPath.row];
            [cell setDiscoveryInfo:gird];
        }
            break;
        case HealthDiscoveryKnowledgeSection:
        {
            HealthDiscoveryGirdInfo* gird = knowledgeDiscoveryItems[indexPath.row];
            [cell setDiscoveryInfo:gird];
            
            if (indexPath.row == 1)
            {
                [cell setNoOpenImage];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGFloat height = 30 * kScreenWidthScale;
    
    return CGSizeMake(320, height);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    CGFloat height = 0.5;
    
    return CGSizeMake(320, height);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableView;
    
    //此处是headerView
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        HealthDiscoveryCollectionHeaderView* headReusableView = (HealthDiscoveryCollectionHeaderView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
//        [headReusableView setBackgroundColor:[UIColor redColor]];
        reusableView = headReusableView;
//       
        switch (indexPath.section)
        {
            case HealthDiscoveryServiceSection:
            {
                [headReusableView setTitle:@"服务与专家团队"];
            }
                break;
            case HealthDiscoveryKnowledgeSection:
            {
                [headReusableView setTitle:@"健康知识"];
            }
                break;
            default:
                break;
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        reusableView = (UICollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        [reusableView setBackgroundColor:[UIColor commonControlBorderColor]];
    }
    
    return reusableView;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.width/4, 80 * kScreenWidthScale);
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
    switch (indexPath.section)
    {
        case HealthDiscoveryServiceSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    //服务项目
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康中心－服务项目"];
//                    [HMViewControllerManager createViewControllerWithControllerName:@"ServiceCategoryStartViewController" ControllerObject:nil];
                    
                    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
                }
                    break;
                case 1:
                {
                    //名医团队
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康中心－名医团队"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"DoctorTeamListStartViewController" ControllerObject:nil];
                }
                default:
                    break;
            }
        }
            break;
            case HealthDiscoveryKnowledgeSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    //健康课堂
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－健康课堂"];
                     [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationStartViewController" ControllerObject:nil];
                }
                    break;
                    
                    case 2:
                {
                    //营养库
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－营养库"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"NutritionLibsStartViewController" ControllerObject:nil];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

@end
