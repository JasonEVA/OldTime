//
//  MainStartWithoutServiceOperationCollectionViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartWithoutServiceOperationCollectionViewController.h"
#import "MainStartAdvertiseListViewController.h"
#import "MainStartEvaluateSectionCollectionViewCell.h"

@implementation MainStartOperationInfo
{
    
}


@end

@interface MainStartWithoutServiceOperationCollectionViewCell : UICollectionViewCell
{
    UIImageView* ivIcon;
    UILabel* lbTitle;
    UILabel* lbAlert;
    UIView* bottomLine;
}

- (void) setMainStartOperationInfo:(MainStartOperationInfo*) operation;
@end

@implementation MainStartWithoutServiceOperationCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //NSLog(@"%f", self.contentView.width);
        
        ivIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:ivIcon];
        [ivIcon setImage:[UIImage imageNamed:@"img_default_maingird"]];
        
        lbTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbTitle];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle setFont:[UIFont font_26]];
        
        lbAlert = [[UILabel alloc]init];
        [self.contentView addSubview:lbAlert];
        [lbAlert setTextAlignment:NSTextAlignmentCenter];
        [lbAlert setTextColor:[UIColor colorWithHexString:@"FC1C04"]];
        [lbAlert setFont:[UIFont font_22]];
        
        bottomLine = [[UIView alloc]init];
        [self.contentView addSubview:bottomLine];
        [bottomLine setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [self.contentView showLeftLine];
        [self.contentView showRightLine];
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(6);
    }];
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(17);
        make.top.equalTo(ivIcon.mas_bottom).with.offset(4);
    }];
    
    [lbAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(15);
        make.top.equalTo(lbTitle.mas_bottom).with.offset(4);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(@0.5);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void) setMainStartOperationInfo:(MainStartOperationInfo*) operation
{
    if (!operation)
    {
        return;
    }
    
    [lbAlert setText:operation.operationAlert];
    [lbTitle setText:operation.operationName];
    
}
@end

typedef enum : NSUInteger {
    MainOperation_AdvertiseSection,
    MainOperation_EvaluateSecton,
    MainOperation_ItemsSection,
    MainOperationSectionCount,
} MainOperationSection;

@interface MainStartWithoutServiceOperationCollectionViewController ()
{
    MainStartAdvertiseListViewController* vcAdvertiseList;
    BOOL advertiseLoaded;
    NSArray* operationItems;
}
@end

@implementation MainStartWithoutServiceOperationCollectionViewController

static NSString * const operationreuseIdentifier = @"MainStartWithoutServiceOperationCollectionViewCell";
static NSString * const reuseIdentifier = @"UICollectionViewCell";
static NSString * const evaluatereuseIdentifier =  @"MainStartEvaluateSectionCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setBackgroundColor:[UIColor commonBackgroundColor]];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    vcAdvertiseList = [[MainStartAdvertiseListViewController alloc]init];
    [vcAdvertiseList setViewHeight:112 * kScreenScale];
    
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[MainStartWithoutServiceOperationCollectionViewCell class] forCellWithReuseIdentifier:operationreuseIdentifier];
    [self.collectionView registerClass:[MainStartEvaluateSectionCollectionViewCell class] forCellWithReuseIdentifier:evaluatereuseIdentifier];
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray* opearteNames = @[@"测血压", @"测心电", @"测体重", @"吃药", @"做运动", @"懂营养", @"知心理", @"控烟酒", @"做自评", @"看档案", @"问医生", @"约专家", @"学知识", @"填随访", @"看报告"];
    NSArray* opearteAlerts = @[@"12:00测量", @"8:00测量", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"1份待填写", @""];
    
    NSMutableArray* operItems = [NSMutableArray array];
    for (NSInteger index = 0; index < opearteNames.count; ++index)
    {
        MainStartOperationInfo* operation = [[MainStartOperationInfo alloc]init];
        [operation setOperationName:[opearteNames objectAtIndex:index]];
        [operation setOperationAlert:[opearteAlerts objectAtIndex:index]];
        [operItems addObject:operation];
    }
    
    [self operationItemsLoaded:operItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) operationItemsLoaded:(NSArray*) items
{
    CGRect rtFrame = self.collectionView.frame;
    rtFrame.size.width = 320 * kScreenScale;
    [self.collectionView setFrame:rtFrame];
    
    operationItems = [NSArray arrayWithArray:items];
    [self.collectionView reloadData];
    
    NSInteger rows = operationItems.count/3;
    if (0 < operationItems.count % 3) {
        ++rows;
    }
    
    [self setViewHeight:rows * 80 * kScreenScale];
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
    return MainOperationSectionCount;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    switch (section)
    {
        case MainOperation_AdvertiseSection:
        case MainOperation_EvaluateSecton:
        {
            return 1;
        }
            break;
        case MainOperation_ItemsSection:
        {
            if (operationItems)
            {
                return operationItems.count;
            }
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    switch (indexPath.section)
    {
        case MainOperation_AdvertiseSection:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//            NSArray* subviews = [self.collectionView subviews];
//            for (UIView* sub in subviews)
//            {
//                [sub removeFromSuperview];
//            }
            [cell.contentView addSubview:vcAdvertiseList.view];
            
        }
            break;
        case MainOperation_EvaluateSecton:
        {
            MainStartEvaluateSectionCollectionViewCell *evaluateCell = [collectionView dequeueReusableCellWithReuseIdentifier:evaluatereuseIdentifier forIndexPath:indexPath];
            cell = evaluateCell;
        }
            break;
        case MainOperation_ItemsSection:
        {
            MainStartWithoutServiceOperationCollectionViewCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:operationreuseIdentifier forIndexPath:indexPath];
            MainStartOperationInfo* operation = [operationItems objectAtIndex:indexPath.row];
            [itemCell setMainStartOperationInfo:operation];
            cell = itemCell;
        }
            break;
            
        default:
            break;
    }
    // Configure the cell
    if (!cell)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
    return cell;
}



#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case MainOperation_AdvertiseSection:
        {
            return CGSizeMake(self.collectionView.width, 112 * kScreenScale);
        }
            break;
        case MainOperation_EvaluateSecton:
        {
            return CGSizeMake(self.collectionView.width, 96);
        }
        case MainOperation_ItemsSection:
            return CGSizeMake(self.collectionView.width/3, 80 * kScreenScale);
            break;
            
        default:
            break;
    }
    return CGSizeZero;
    
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
        case MainOperation_ItemsSection:
        {
            switch (indexPath.row)
            {
                case 0:
                case 1:
                case 2:
                {
                    [HMViewControllerManager createViewControllerWithControllerName:@"BodyDetectStartViewController"ControllerObject:nil];
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
