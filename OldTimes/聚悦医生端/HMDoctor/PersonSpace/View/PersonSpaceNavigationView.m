//
//  PersonSpaceNavigationView.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceNavigationView.h"

@interface PersonSpaceNavigationView ()
{
    UILabel* lbStaffName;
    UILabel* lbDept;
    
    UIView* funline;
    UIView* funmidline;
    UIView* funview;
    UIView* commentview;
    
    UIImageView* ivFuns;
    UILabel* lbFuns;
    UILabel* lbFunCount;
    
    UIImageView* ivComments;
    UILabel* lbComment;
    UILabel* lbCommentCount;
    
    UIView* authview;
    UILabel* lbAuth;
}
@end

@implementation PersonSpaceNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _ivPartrait = [[UIImageView alloc] init];
        [self addSubview:_ivPartrait];
        
        [_ivPartrait.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
        [_ivPartrait.layer setBorderWidth:0.5];
        [_ivPartrait.layer setCornerRadius:30];
        [_ivPartrait.layer setMasksToBounds:YES];
        
        [_ivPartrait setImage:[UIImage imageNamed:@"img_default_staff"]];
        
        
        lbStaffName = [[UILabel alloc]init];
        [lbStaffName setBackgroundColor:[UIColor clearColor]];
        [lbStaffName setTextColor:[UIColor whiteColor]];
        [lbStaffName setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:lbStaffName];
        
        authview = [[UIView alloc]init];
        [self addSubview:authview];
        [authview setBackgroundColor:[UIColor colorWithHexString:@"F9BD37"]];
        authview.layer.cornerRadius = 4;
        authview.layer.masksToBounds = YES;
        //[authview setHidden:YES];
        
        lbAuth = [[UILabel alloc]init];
        [authview addSubview:lbAuth];
        [lbAuth setFont:[UIFont systemFontOfSize:10]];
        [lbAuth setText:@"未认证"];
        [lbAuth setTextColor:[UIColor whiteColor]];
        [lbAuth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(authview);
        }];
        
        lbDept = [[UILabel alloc]init];
        [lbDept setBackgroundColor:[UIColor clearColor]];
        [lbDept setTextColor:[UIColor whiteColor]];
        [lbDept setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:lbDept];
    
        funview = [[UIView alloc]init];
        [self addSubview:funview];
        [funview setBackgroundColor:[UIColor mainThemeColor]];
        
        commentview = [[UIView alloc]init];
        [self addSubview:commentview];
        [commentview setBackgroundColor:[UIColor mainThemeColor]];
        
        funline = [[UIView alloc]init];
        [funline setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:funline];
       
        funmidline = [[UIView alloc]init];
        [funmidline setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:funmidline];
        
        ivFuns = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_funs_count"]];
        [funview addSubview:ivFuns];
        
        lbFuns = [[UILabel alloc]init];
        [funview addSubview:lbFuns];
        [lbFuns setBackgroundColor:[UIColor clearColor]];
        [lbFuns setFont:[UIFont systemFontOfSize:14]];
        [lbFuns setTextColor:[UIColor whiteColor]];
        [lbFuns setText:@"粉丝:"];
        
        lbFunCount = [[UILabel alloc]init];
        [commentview addSubview:lbFunCount];
        [lbFunCount setBackgroundColor:[UIColor clearColor]];
        [lbFunCount setFont:[UIFont systemFontOfSize:14]];
        [lbFunCount setTextColor:[UIColor whiteColor]];
        [lbFunCount setText:@"0"];
        
        ivComments = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_comment_count"]];
        [commentview addSubview:ivComments];
        
        
        
        lbComment = [[UILabel alloc]init];
        [commentview addSubview:lbComment];
        [lbComment setBackgroundColor:[UIColor clearColor]];
        [lbComment setFont:[UIFont systemFontOfSize:14]];
        [lbComment setTextColor:[UIColor whiteColor]];
        [lbComment setText:@"评价:"];
        
        lbCommentCount = [[UILabel alloc]init];
        [commentview addSubview:lbCommentCount];
        [lbCommentCount setBackgroundColor:[UIColor clearColor]];
        [lbCommentCount setFont:[UIFont systemFontOfSize:14]];
        [lbCommentCount setTextColor:[UIColor whiteColor]];
        [lbCommentCount setText:@"0"];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [_ivPartrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60 , 60 ));
        make.left.equalTo(self).with.offset(16 * kScreenScale);
        make.top.equalTo(self).with.offset(10 * kScreenScale);
    }];
    
    [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ivPartrait).with.offset(6);
        make.left.equalTo(_ivPartrait.mas_right).with.offset(17);
        make.height.mas_equalTo(@18);
    }];
    
    [authview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbStaffName.mas_right).with.offset(10);
        make.centerY.equalTo(lbStaffName);
        //make.size.mas_equalTo(CGSizeMake(37, 16));
        make.height.equalTo(lbAuth).with.offset(4);
        make.width.equalTo(lbAuth).with.offset(6);
    }];
    

    
    [lbDept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbStaffName.mas_bottom).with.offset(7);
        make.left.equalTo(_ivPartrait.mas_right).with.offset(17);
        make.height.mas_equalTo(@16);
        make.right.lessThanOrEqualTo(self).offset(-10);
    }];
    
    [funline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-34*kScreenScale);
        make.left.equalTo(self);
        make.height.mas_equalTo(@0.5);
        make.width.equalTo(self);
    }];
    
    [funview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160 * kScreenScale, 33.5 * kScreenScale));
        make.left.equalTo(self);
        make.top.equalTo(funline.mas_bottom);
        //make.bottom.equalTo(self);
    }];
    
    [funmidline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(funview.mas_right);
        make.width.mas_offset(@0.5);
        make.centerY.equalTo(funview);
        make.height.equalTo(funview);
    }];
    
    [commentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160 * kScreenScale, 33.5 * kScreenScale));
        make.left.equalTo(funview.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [ivFuns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 11));
        make.centerY.equalTo(funview.mas_centerY);
        make.left.equalTo(funview).with.offset(52 * kScreenScale);
    }];
    
    [lbFuns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.centerY.equalTo(funview.mas_centerY);
        make.left.equalTo(ivFuns.mas_right).with.offset(5);
    }];
    
    [lbFunCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.centerY.equalTo(funview.mas_centerY);
        make.left.equalTo(lbFuns.mas_right).with.offset(2);
    }];
    
    [ivComments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 11));
        make.centerY.equalTo(commentview.mas_centerY);
        make.left.equalTo(commentview).with.offset(52 * kScreenScale);
    }];
    
    [lbComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.centerY.equalTo(commentview.mas_centerY);
        make.left.equalTo(ivComments.mas_right).with.offset(5);
    }];
    
    [lbCommentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.centerY.equalTo(commentview.mas_centerY);
        make.left.equalTo(lbComment.mas_right).with.offset(2);
    }];
}

- (void) setStaffAuthentication:(NSString*) authent
{
    //[authview setHidden:!authent];
    if (authent && 0 < authent.length)
    {
        [lbAuth setHidden:NO];
        [lbAuth setText:authent];
    }
    else
    {
        [lbAuth setHidden:YES];
    }
}

- (void) setStaffInfo
{
    StaffInfo* staff = [UserInfoHelper defaultHelper].currentStaffInfo;
    
    if (staff.staffIcon)
    {
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [_ivPartrait sd_setImageWithURL:[NSURL URLWithString:staff.staffIcon] placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    
    [lbStaffName setText:staff.staffName];
    [lbFunCount setText:staff.fans];
    //[lbCommentCount setText:staff.folk];
    
    NSString* stafforgname = staff.orgName;
    NSString* staffdeptname = staff.depName;
    
    NSString* orgdeptStr = stafforgname;
    if (orgdeptStr && 0 < orgdeptStr.length)
    {
        if (staffdeptname && 0 < staffdeptname.length) {
            orgdeptStr = [orgdeptStr stringByAppendingFormat:@"/%@", staffdeptname];
        }
    }
    else
    {
        orgdeptStr = staffdeptname;
    }
    
    
    [lbDept setText:orgdeptStr];
}
@end
