//
//  RecipeRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RecipeRecordTableViewCell.h"
#import "RecipeRecordView.h"
@interface RecipeRecord (RecipeDate)

@end

@implementation RecipeRecord (RecipeDate)

- (NSString*) dateStr
{
    if (!self.createTime)
    {
        return nil;
    }
    
    //NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSDate* visitDate = [NSDate dateWithString:self.createTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [visitDate formattedDateWithFormat:@"MM-dd"];
    
    return dateStr;

}

@end

@interface RecipeRecordTableViewCell ()
{
    UIView* topLine;
    UIView* bottomline;
    UIView* circleView;
    UILabel* lbDate;
    UILabel* lbTime;
    
    RecipeRecordView* recordview;
}
@end

@implementation RecipeRecordTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        topLine = [[UIView alloc]init];
        [topLine setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:topLine];
        
        bottomline = [[UIView alloc]init];
        [bottomline setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:bottomline];
        
        circleView = [[UIView alloc]init];
        [circleView setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:circleView];
        circleView.layer.cornerRadius = 6;
        circleView.layer.masksToBounds = YES;
        
        lbDate = [[UILabel alloc]init];
        [self.contentView addSubview:lbDate];
        [lbDate setBackgroundColor:[UIColor clearColor]];
        [lbDate setTextColor:[UIColor commonTextColor]];
        [lbDate setFont:[UIFont font_22]];
        
        lbTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbTime];
        [lbTime setBackgroundColor:[UIColor clearColor]];
        [lbTime setTextColor:[UIColor commonTextColor]];
        [lbTime setFont:[UIFont font_22]];
        
        recordview = [[RecipeRecordView alloc]init];
        [self.contentView addSubview:recordview];
        
        [self subviewLayout];
        
    }
    return self;
}

- (void) subviewLayout
{
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@8.5);
        make.width.mas_equalTo(@1);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self).with.offset(51);
    }];
    
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@12);
        make.top.equalTo(topLine.mas_bottom).with.offset(1.5);
        make.centerX.equalTo(topLine);
    }];
    
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.equalTo(circleView.mas_bottom).with.offset(1.5);
        make.left.equalTo(self.contentView).with.offset(51);
        make.bottom.equalTo(self.contentView);
    }];
    
    [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@13);
        make.centerY.equalTo(circleView);
        make.right.equalTo(circleView.mas_left).with.offset(-4);
    }];
    
    [recordview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleView.mas_right).with.offset(2);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];

    
}

- (void) setRecipeRecord:(RecipeRecord*) record
{
    [lbDate setText:[record dateStr]];
    
    [recordview setRecipeRecord:record];

}

@end
