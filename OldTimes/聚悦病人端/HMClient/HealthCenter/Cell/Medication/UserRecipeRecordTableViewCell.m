//
//  UserRecipeRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserRecipeRecordTableViewCell.h"

@implementation UserRecipeRecord (RecordTableCellHeight)

- (CGFloat) recordCellHeight
{
    CGFloat cellHeight = 78;
    if (self.useDrugList)
    {
        NSInteger rows = self.useDrugList.count / 3;
        if (0  < self.useDrugList.count % 3) {
            rows += 1;
        }
        cellHeight += 35 * rows;
    }
    
    cellHeight += 5;
    return cellHeight;
}

@end



@interface UserRecipeUsageView : UIView
{
    UILabel* lbPeriod;
    
}
@property (nonatomic, readonly) UIButton* buttonUsage;
@end

@implementation UserRecipeUsageView
 
- (id) init
{
    self = [super init];
    if (self)
    {
        lbPeriod = [[UILabel alloc]init];
        [self addSubview:lbPeriod];
        [lbPeriod setFont:[UIFont font_26]];
        [lbPeriod setTextColor:[UIColor commonGrayTextColor]];
        [lbPeriod mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
        }];
        
        _buttonUsage = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_buttonUsage];
        [_buttonUsage setBackgroundImage:[UIImage rectImage:CGSizeMake(80, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_buttonUsage setBackgroundImage:[UIImage rectImage:CGSizeMake(80, 40) Color:[UIColor commonGrayTextColor]] forState:UIControlStateDisabled];
        
        [_buttonUsage setTitle:@"服用" forState:UIControlStateNormal];
        [_buttonUsage setTitle:@"已服用" forState:UIControlStateDisabled];
        [_buttonUsage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonUsage.titleLabel setFont:[UIFont font_24]];
        
        _buttonUsage.layer.cornerRadius = 2.5;
        _buttonUsage.layer.masksToBounds = YES;
        
        [_buttonUsage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbPeriod.mas_right).with.offset(5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 27));
        }];
        
        //[self showBottomLine];
    }
    return self;
}

- (void) setUserRecipeUsage:(UserRecipeDrugUsage*) usage
{

    if (![usage.frequencyType isEqualToString:@"week"])
    {
         [lbPeriod setText:usage.usePeriod];
    }
    else
    {
        [lbPeriod setText:[NSString stringWithFormat:@"本周已服用%ld次", usage.count]];
    }
    [_buttonUsage setEnabled:(1 == usage.status)];
}

@end

@interface UserRecipeRecordTableViewCell ()
{
    UIView* dragsView;
   
    UILabel* lbDragName;
     UILabel* lbCompany;
    UILabel* lbUsege;
    UILabel* lbFrequency;
    
    NSMutableArray* usageviews;
}

@end

@implementation UserRecipeRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        dragsView = [[UIView alloc]init];
        [dragsView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:dragsView];
        [dragsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(@78);
        }];
        [dragsView showBottomLine];
        
        lbDragName = [[UILabel alloc]init];
        [self.contentView addSubview:lbDragName];
        [lbDragName setTextColor:[UIColor commonTextColor]];
        [lbDragName setFont:[UIFont font_30]];
        [lbDragName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dragsView).with.offset(12.5);
            make.top.equalTo(dragsView).with.offset(11.5);
            make.right.lessThanOrEqualTo(dragsView).with.offset(-12.5);
        }];
        
        lbCompany = [[UILabel alloc]init];
        [self.contentView addSubview:lbCompany];
        [lbCompany setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbCompany setFont:[UIFont font_24]];
        [lbCompany mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dragsView).with.offset(12.5);
            make.top.equalTo(lbDragName.mas_bottom).with.offset(5);
            make.right.lessThanOrEqualTo(dragsView).with.offset(-12.5);
        }];
        
        lbUsege = [[UILabel alloc]init];
        [self.contentView addSubview:lbUsege];
        [lbUsege setTextColor:[UIColor commonLightGrayTextColor]];
        [lbUsege setFont:[UIFont font_22]];
        [lbUsege mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dragsView).with.offset(12.5);
            make.top.equalTo(lbCompany.mas_bottom).with.offset(5);
            make.right.lessThanOrEqualTo(dragsView).with.offset(-12.5);
        }];
        
        lbFrequency = [[UILabel alloc]init];
        [self.contentView addSubview:lbFrequency];
        [lbFrequency setTextColor:[UIColor commonLightGrayTextColor]];
        [lbFrequency setFont:[UIFont font_22]];
        [lbFrequency mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUsege.mas_right).with.offset(5);
            make.top.equalTo(lbUsege);
            make.right.lessThanOrEqualTo(dragsView).with.offset(-12.5);
        }];
        
        //[self.contentView showBottomLine];
        
        UIView* bottomview = [[UIView alloc]init];
        [self.contentView addSubview:bottomview];
        [bottomview setBackgroundColor:[UIColor commonBackgroundColor]];
        [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(@5);
            make.bottom.equalTo(self.contentView);
        }];
        
        usageviews = [NSMutableArray array];
    }
    return self;
}

- (void) setUserRecipeRecord:(UserRecipeRecord*) record
{
    [lbDragName setText:record.drugName];
    [lbCompany setText:record.drugCompany];
    
    NSString* usage = record.drugsUsageName;
    if (!usage || 0 == usage.length)
    {
        usage = @"";
    }
    if ([CommonFuncs isInteger:record.singleDosage]) {
        usage = [usage stringByAppendingFormat:@" 每次%ld%@", (NSInteger)record.singleDosage, record.drugOneSpecUnit];
    }
    else
    {
        usage = [usage stringByAppendingFormat:@" 每次%.2f%@", record.singleDosage, record.drugOneSpecUnit];
    }
//    usage = [usage stringByAppendingFormat:@" 每次%ld%@", record.singleDosage, record.drugUnit];
//    NSString* usage = [record drugSpecString];
    
    [lbUsege setText:usage];
    
    if (usageviews)
    {
        for (UIView* sub in usageviews)
        {
            [sub removeFromSuperview];
        }
        [usageviews removeAllObjects];
    }
    
    NSString* drugsFrequencyName = record.drugsFrequencyName;
    if (!drugsFrequencyName)
    {
        drugsFrequencyName = @"";
    }
    if (record.remarks && 0 < record.remarks.length)
    {
        if (0 < drugsFrequencyName.length ) {
            drugsFrequencyName = [drugsFrequencyName stringByAppendingString:@"/"];
        }
        drugsFrequencyName = [drugsFrequencyName stringByAppendingString:record.remarks];
    }
    
    [lbFrequency  setText:drugsFrequencyName];
    if (record.useDrugList && 0 < record.useDrugList.count)
    {
        
        MASViewAttribute* bottom = dragsView.mas_bottom;
        MASViewAttribute* left = self.contentView.mas_left;
        
        for (NSInteger index = 0; index < record.useDrugList.count; ++index)
        {
            UserRecipeDrugUsage* usage = record.useDrugList[index];
            UserRecipeUsageView* usageview = [[UserRecipeUsageView alloc]init];
            [self.contentView addSubview:usageview];
            
            
            UserRecipeUsageView* perView = [usageviews lastObject];
            [usageviews addObject:usageview];
            if (0 == index % 3)
            {
                left = self.contentView.mas_left;
            }
            else
            {
                left = perView.mas_right;
            }
            
            [usageview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(left);
                if (2 == index % 3 || usage == [record.useDrugList lastObject])
                {
                    make.right.equalTo(self.contentView);
                }
                make.width.mas_equalTo([NSNumber numberWithFloat:self.contentView.width/3]);
//                if (perView)
//                {
//                    make.width.equalTo(perView);
//                }
                make.top.equalTo(bottom);
                make.height.mas_equalTo(35);
            }];
            [usageview setUserRecipeUsage:usage];
            if (2 == index % 3)
            {
                bottom = usageview.mas_bottom;
            }
            
            [usageview.buttonUsage addTarget:self action:@selector(dragButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (void) dragButtonClicked:(id) sender
{
    UIButton* btn = (UIButton*) sender;

    UserRecipeUsageView* usageview = (UserRecipeUsageView*)btn.superview;
    if (![usageview isKindOfClass:[UserRecipeUsageView class]])
    {
        return;
    }
    
    NSInteger index = [usageviews indexOfObject:usageview];
    if (NSNotFound == index)
    {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(userRecipeRecordDrag:WithIndex:)])
    {
        [_delegate userRecipeRecordDrag:self WithIndex:index];
    }
}

@end
