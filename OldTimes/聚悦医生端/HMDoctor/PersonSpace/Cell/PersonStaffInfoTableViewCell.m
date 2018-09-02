//
//  PersonStaffInfoTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonStaffInfoTableViewCell.h"

@implementation PersonStaffInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface PersonStaffPortraitTableViewCell ()
{
    UIImageView* ivPortrait;
    UILabel* lbTitle;
    UIImageView* ivRightArrow;
}
@end

@implementation PersonStaffPortraitTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        ivPortrait = [[UIImageView alloc]init];
        [self.contentView addSubview:ivPortrait];
        [ivPortrait.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
        [ivPortrait.layer setBorderWidth:0.5];
        [ivPortrait.layer setCornerRadius:16.5];
        [ivPortrait.layer setMasksToBounds:YES];
        [ivPortrait setImage:[UIImage imageNamed:@"img_default_staff"]];
        [self updateStaffInfo];
        
        lbTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbTitle];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setFont:[UIFont systemFontOfSize:15]];
        [lbTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbTitle setText:@"编辑头像"];
        
        ivRightArrow = [[UIImageView alloc]init];
        [self.contentView addSubview:ivRightArrow];
        [ivRightArrow setImage:[UIImage imageNamed:@"ic_right_arrow"]];
        
        [self subviewsLayout];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) subviewsLayout
{
    [ivPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [ivRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 20));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
    }];
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ivRightArrow.mas_left).with.offset(-5);
        make.height.mas_equalTo(@21);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void) updateStaffInfo
{
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.center = CGPointMake(30.0f, 30.0f);
    [ivPortrait addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor orangeColor];
    [testActivityIndicator startAnimating];
    [testActivityIndicator setHidesWhenStopped:YES];
    
    StaffInfo* staff = [UserInfoHelper defaultHelper].currentStaffInfo;
    
    if (staff.staffIcon)
    {
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [ivPortrait sd_setImageWithURL:[NSURL URLWithString:staff.staffIcon] placeholderImage:[UIImage imageNamed:@"img_default_staff"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [testActivityIndicator stopAnimating];
        }];
    }
}

@end

@interface PersonStaffBaseInfoTableViewCell ()
{
    UILabel* lbName;
    UILabel* lbValue;
}


@end

@implementation PersonStaffBaseInfoTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];

        lbName = [[UILabel alloc]init];
        [self.contentView addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        [lbName setTextColor:[UIColor commonTextColor]];
        
        lbValue = [[UILabel alloc]init];
        [self.contentView addSubview:lbValue];
        [lbValue setBackgroundColor:[UIColor clearColor]];
        [lbValue setFont:[UIFont systemFontOfSize:15]];
        [lbValue setTextColor:[UIColor commonGrayTextColor]];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@19);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@19);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);

    }];
}

- (void) setName:(NSString*) name Value:(NSString*) value
{
    [lbName setText:name];
    [lbValue setText:value];
    
//    [lbValue mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(lbName.mas_right).with.offset(3);
//        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
//    }];
}
@end


@interface PersonStaffHospitalInfoTableViewCell ()
{
    UILabel* lbName;
    UILabel* lbValue;
    
}
@end

@implementation PersonStaffHospitalInfoTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc]init];
        [self.contentView addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        [lbName setTextColor:[UIColor commonTextColor]];
        
        lbValue = [[UILabel alloc]init];
        [self.contentView addSubview:lbValue];
        [lbValue setBackgroundColor:[UIColor clearColor]];
        [lbValue setFont:[UIFont systemFontOfSize:15]];
        [lbValue setTextColor:[UIColor commonGrayTextColor]];
        
        

        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@19);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@19);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.left.greaterThanOrEqualTo(lbName.mas_right).with.offset(10);
    }];
}

- (void) setName:(NSString*) name Value:(NSString*) value
{
    [lbName setText:name];
    [lbValue setText:value];
    
    //    [lbValue mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(lbName.mas_right).with.offset(3);
    //        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
    //    }];
}


@end

@interface PersonStaffDescriptionTableViewCell ()
{
    UILabel* lbName;
    UILabel* lbValue;
    UIImageView* ivRightArrow;
}
@end

@implementation PersonStaffDescriptionTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc]init];
        [self.contentView addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        [lbName setTextColor:[UIColor commonTextColor]];
        
        lbValue = [[UILabel alloc]init];
        [self.contentView addSubview:lbValue];
        [lbValue setBackgroundColor:[UIColor clearColor]];
        [lbValue setFont:[UIFont systemFontOfSize:15]];
        [lbValue setTextColor:[UIColor commonGrayTextColor]];
        
        ivRightArrow = [[UIImageView alloc]init];
        [self.contentView addSubview:ivRightArrow];
        [ivRightArrow setImage:[UIImage imageNamed:@"ic_right_arrow"]];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@19);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [ivRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 14));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@19);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(ivRightArrow.mas_left).with.offset(-3);
//        make.left.greaterThanOrEqualTo(lbName.mas_right).with.offset(10);
    }];
}

- (void) setName:(NSString*) name Value:(NSString*) value
{
    [lbName setText:name];
    [lbValue setText:value];
    
    [lbValue mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(lbName.mas_right).with.offset(10);
//            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        }];
}

@end
