//
//  AppointmentDetailImageTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentDetailImageTableViewCell.h"

@interface AppointmentDetailImageTableViewCell ()
{
    UIView* vBackgound;
    UIImageView* ivImage;
}
@end

@implementation AppointmentDetailImageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        vBackgound = [[UIView alloc]init];
        [self.contentView addSubview:vBackgound];
        [vBackgound setBackgroundColor:[UIColor commonBackgroundColor]];
        
        ivImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c"]];
        [vBackgound addSubview:ivImage];
    
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [vBackgound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    
    [ivImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(vBackgound);
        make.size.mas_equalTo(CGSizeMake(60, 50));
    }];
}

- (void) setImageUrl:(NSString*) imageUrl
{
    if (!imageUrl || 0 == imageUrl.length)
    {
        [ivImage setImage:[UIImage imageNamed:@"img_default"]];
        [ivImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(60, 50));
        }];
        return;
    }
    
    [vBackgound setBackgroundColor:[UIColor commonBackgroundColor]];
    [ivImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"img_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error)
        {
            [ivImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(60, 50));
            }];
            return ;
        }
        else
        {
            //[ivImage setImage:image];
            CGSize imgSize = image.size;
            float imgHeight = imgSize.height;
            float imgWidth = imgSize.width ;
            
            if (image.size.height < 150)
            {
                if (image.size.width < kScreenWidth - 25)
                {
                    
                    return;
                }
                
            }
            else
            {
                imgWidth = kScreenWidth - 25;
                imgHeight = imgHeight * imgWidth/imgSize.width;
            }

            [ivImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(imgWidth, imgHeight));
            }];
            [vBackgound setBackgroundColor:[UIColor whiteColor]];
            if (_delegate && [_delegate respondsToSelector:@selector(appointmentDetailImageCell:ImageHeihgt:)])
            {
                [_delegate appointmentDetailImageCell:self ImageHeihgt:imgHeight];
            }
        }
    }];
}

@end


