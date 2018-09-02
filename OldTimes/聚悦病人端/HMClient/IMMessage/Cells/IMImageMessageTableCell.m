//
//  IMImageMessageTableCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMImageMessageTableCell.h"

@interface IMImageMessageTableCell ()
{
    UIImageView* ivThumb;
    UIImageView* ivBackground;
}
@end


@implementation IMImageMessageTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivThumb = [[UIImageView alloc]init];
        [msgview addSubview:ivThumb];
        
        [ivThumb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(msgview);
            make.bottom.equalTo(msgview);
            make.left.and.right.equalTo(msgview);
            make.height.mas_equalTo(@112);
            
        }];
        
        ivBackground = [[UIImageView alloc]init];
        [msgview addSubview:ivBackground];
        [ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(msgview);
            make.top.and.bottom.equalTo(msgview);
            
        }];

    }
    return self;
}

- (void) setMessage:(MessageBaseModel*) message
{
    [super setMessage:message];
    NSString* thumballPath;
    if (message._nativeThumbnailUrl.length > 0) {
        // 本地路径
        thumballPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:message._nativeThumbnailUrl];
        UIImage* thumbImage = [UIImage imageWithContentsOfFile:thumballPath];
        if (thumbImage)
        {
            
            [ivThumb setImage:thumbImage];
        }
        else
        {
            [ivThumb setImage:[UIImage imageNamed:@"img_default"]];
        }

    }
    else {
        // 网络图片
        thumballPath = [NSString stringWithFormat:@"%@%@",im_IP_http,message.attachModel.thumbnail];
        SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
        NSString * string = [NSString stringWithFormat:@"AppName=%@;UserName=%@",im_appName,[MessageManager getUserID]];
        [manager setValue:string forHTTPHeaderField:@"Cookie"];
        [ivThumb sd_setImageWithURL:[NSURL URLWithString:thumballPath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    }
    if (![message isFileDownloaded])
    {
        NSLog(@"image is not download....");
    }
    if (message._markFromReceive) {
        [ivBackground setImage:[UIImage imageNamed:@"bg_lucency_pop_left"]];
    }
    else
    {
        [ivBackground setImage:[UIImage imageNamed:@"bg_lucency_pop_right"]];
    }
}
@end
