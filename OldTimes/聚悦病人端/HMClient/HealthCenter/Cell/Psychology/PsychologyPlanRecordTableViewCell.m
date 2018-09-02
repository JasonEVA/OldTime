//
//  PsychologyPlanRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PsychologyPlanRecordTableViewCell.h"

@interface PsychologyPlanRecordContorl : UIControl
{
    UIImageView* ivIcon;
    UILabel* lbName;
    
    UIImage* normalImage;
    UIImage* selectedImage;
}
@end

@implementation PsychologyPlanRecordContorl

- (id) initWithName:(NSString*) name
        NormalImage:(UIImage*) imgNormal
      SelectedImage:(UIImage*) imgSelected
{
    self = [super init];
    if (self)
    {
        ivIcon = [[UIImageView alloc]initWithImage:imgNormal];
        [self addSubview:ivIcon];
        [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self).with.offset(20);
        }];
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setFont:[UIFont font_28]];
        [lbName setTextColor:[UIColor commonLightGrayTextColor]];
        [lbName setText:name];
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).with.offset(-16);
        }];
        
        normalImage = imgNormal;
        selectedImage = imgSelected;
    }
    return self;
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        [ivIcon setImage:selectedImage];
        [lbName setTextColor:[UIColor commonRedColor]];
    }
    else
    {
        [ivIcon setImage:normalImage];
        [lbName setTextColor:[UIColor commonLightGrayTextColor]];
    }
}

@end

@interface PsychologyPlanRecordTableViewCell ()
{
    NSMutableArray* psyControls;
}
@end

@implementation PsychologyPlanRecordTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createControls];
    }
    return self;
}

- (void) createControls
{
    NSArray* names = @[@"开心", @"平静", @"沮丧", @"烦躁"];
    NSArray* norImages = @[[UIImage imageNamed:@"icon_health_plan_mood1"],
                           [UIImage imageNamed:@"icon_health_plan_mood2"],
                           [UIImage imageNamed:@"icon_health_plan_mood3"],
                           [UIImage imageNamed:@"icon_health_plan_mood4"]];
    NSArray* selImages = @[[UIImage imageNamed:@"icon_health_plan_mood1_s"],
                           [UIImage imageNamed:@"icon_health_plan_mood2_s"],
                           [UIImage imageNamed:@"icon_health_plan_mood3_s"],
                           [UIImage imageNamed:@"icon_health_plan_mood4_s"]];
    
    psyControls = [NSMutableArray array];
    for (NSInteger index = 0; index < names.count; ++index)
    {
        PsychologyPlanRecordContorl* control = [[PsychologyPlanRecordContorl alloc]initWithName:names[index]
                                                                                    NormalImage:norImages[index]
                                                                                  SelectedImage:selImages[index]];
        
        [control addTarget:self action:@selector(psychoControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:control];
        [psyControls addObject:control];
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.contentView);
            if (0 == index)
            {
                make.left.equalTo(self.contentView).with.offset(40);
            }
            else
            {
                PsychologyPlanRecordContorl* perControl = [psyControls objectAtIndex:index - 1];
                make.left.equalTo(perControl.mas_right);
                make.width.equalTo(perControl);
            }
            
            if (index == names.count - 1)
            {
                make.right.equalTo(self.contentView).with.offset(-40);
            }
        }];
    }
}

- (void) psychoControlClicked:(id) sender
{
    NSInteger clickedIndex = [psyControls indexOfObject:sender];
    if (NSNotFound == clickedIndex)
    {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedPsychology:)])
    {
        [_delegate selectedPsychology:clickedIndex + 1];
    }
}

- (void) setPsychologInfo:(UserPsychologyInfo*) info
{
    for (NSInteger index = 0; index < psyControls.count; ++index)
    {
        PsychologyPlanRecordContorl* control = psyControls[index];
        [control setSelected:(index + 1) == info.moodType];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface PsychologyPlanReaderTableViewCell ()
{
    UILabel* lbTitle;
    UILabel* lbContent;
}
@end

@implementation PsychologyPlanReaderTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbTitle];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle setFont:[UIFont font_30]];
        
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(11);
        }];
        
        lbContent = [[UILabel alloc]init];
        [self.contentView addSubview:lbContent];
        [lbContent setTextColor:[UIColor commonGrayTextColor]];
        [lbContent setFont:[UIFont font_24]];
        
        [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(lbTitle.mas_bottom).with.offset(4);
        }];
    }
    return self;
}

- (void) setTitle:(NSString *)title
          Content:(NSString*) content
{
    [lbTitle setText:title];
    [lbContent setText:content];
}
@end
