//
//  HMHistoryCollectImageTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/4.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMHistoryCollectImageTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ChatIMConfigure.h"

@interface HMHistoryCollectImageTableViewCell ()
@property (nonatomic, strong) UIImageView *collectImageView;       //收藏的图片
@property (nonatomic, strong) MessageBaseModel *cellModel;
@end
@implementation HMHistoryCollectImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectImageView];
        [self configElements];
    }
    return self;
}/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark -private method
- (void)configElements {
    if (self.cellModel.bookMarkName && self.cellModel.bookMarkName.length) {
        
        [self.collectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(15);
            make.left.equalTo(self.iconView);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
            make.height.equalTo(@135);
            make.width.equalTo(@230);
        }];
        
        NSArray *array = [self.cellModel.bookMarkName componentsSeparatedByString:@","];
        
        __block UILabel *lastLb = nil;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *temp = (NSString *)obj;
            UILabel *tempLb = [UILabel new];
            [tempLb setText:[NSString stringWithFormat:@"   %@   ",temp]];
            [tempLb setTextColor:[UIColor colorWithHexString:@"999999"]];
            [tempLb setFont:[UIFont systemFontOfSize:12]];
            [tempLb setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
            [tempLb.layer setCornerRadius:2];
            [tempLb setClipsToBounds:YES];
            
            [self.contentView addSubview:tempLb];
            if (!idx) {
                [tempLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.iconView);
                    make.top.equalTo(self.collectImageView.mas_bottom).offset(15);
                    make.height.equalTo(@22);
                    make.bottom.equalTo(self.contentView).offset(-15);
                }];
            }
            else {
                [tempLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastLb.mas_right).offset(10);
                    make.top.equalTo(self.collectImageView.mas_bottom).offset(15);
                    make.height.equalTo(@22);
                    make.bottom.equalTo(self.contentView).offset(-15);
                }];
            }
            
            lastLb = tempLb;
        }];
    }
    else {
        [self.collectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(15);
            make.left.equalTo(self.iconView);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
            make.height.equalTo(@135);
            make.width.equalTo(@230);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
    }
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)setDataWithModel:(MessageBaseModel *)model {
    [self setBaseDataWithModel:model];
    self.cellModel = model;
    if (model._nativeThumbnailUrl.length != 0) {
        NSString * str = model._nativeThumbnailUrl;
        NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:str];
        UIImage * image = [UIImage imageWithContentsOfFile:fullPath];
        self.collectImageView.image = image;
    }else {
        NSString * str= @"";
        if ([model.attachModel.thumbnail isEqualToString:@""] || model.attachModel.thumbnail == nil) {
            str = model.attachModel.fileUrl;
        }else {
            str = model.attachModel.thumbnail;
        }
        SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
        NSString * string = [NSString stringWithFormat:@"AppName=%@;UserName=%@",im_appName,[MessageManager getUserID]];
        [manager setValue:string forHTTPHeaderField:@"Cookie"];
        
        NSString *fullPath = [NSString stringWithFormat:@"%@%@",im_IP_http,str];
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [self.collectImageView sd_setImageWithURL:[NSURL URLWithString:fullPath]];
        
    }

    [self configElements];
    
}
#pragma mark - init UI
- (UIImageView *)collectImageView {
    if(!_collectImageView) {
        _collectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default"]];
        _collectImageView.contentMode = UIViewContentModeScaleAspectFill;
        _collectImageView.clipsToBounds = YES;
    }
    return _collectImageView;
}
@end
