//
//  ApplicationAttachmentTableViewCell.m
//  launcher
//
//  Created by williamzhang on 15/10/27.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationAttachmentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "UIFont+Util.h"

static CGFloat const maxTitleWidth = 50;

@interface ApplicationAttachmentTableViewCell ()

@property (nonatomic, strong) UILabel *innerTitleLabel;
@property (nonatomic, strong) UIView  *imageContentView;

@property (nonatomic, copy) void (^clickBlock)(NSUInteger);

@end

@implementation ApplicationAttachmentTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

+ (CGFloat)heightForCellWithImageCount:(NSUInteger)count {
    return [self heightForCellWithImageCount:count accessoryMode:NO];
}

+ (CGFloat)heightForCellWithImageCount:(NSUInteger)count accessoryMode:(BOOL)accessoryMode {
    if (!count) {
        return 44;
    }
    
    BOOL hasNextLine = count % 3;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    NSInteger line = count / 3 + (hasNextLine ? 1 : 0);
    return 20 + (screenWidth - 80 - (accessoryMode ? 30 : 0)) * line / 3 + 20;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initComponents];
    }
    return self;
}


#pragma mark - Interface Method
- (void)clickToSeeImage:(void (^)(NSUInteger))clickBlock {
    self.clickBlock = clickBlock;
}

- (void)configOriImages:(NSArray<UIImage *> *)images {
    [self configImages:images path:NO];
}

- (void)configImagePath:(NSArray<NSString *> *)arrayPaths {
    [self configImages:arrayPaths path:YES];
}

#pragma mark - Private Method 

/**
 *  设置图片或图片路径
 *
 *  @param images 图片或图片路径数组
 *  @param path   是否是路径
 */
- (void)configImages:(NSArray *)images path:(BOOL)path {
    NSArray *reversedSubViews = [[[self.imageContentView subviews] reverseObjectEnumerator] allObjects];
    [reversedSubViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    static NSInteger colouns = 3;
    
    UIImageView *lastView = nil;
    for (NSInteger index = 0 ;index < images.count; index++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        id imageOrPath = [images objectAtIndex:index];
        
        if (!path) {
            imageView.image = imageOrPath;
        }
        else {
             // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
            // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageOrPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]] placeholderImage:[UIImage imageNamed:@"image_placeholder_loading"]];
        }
        
        [self.imageContentView addSubview:imageView];
        
        NSInteger row = index / colouns;
        NSInteger col = index % colouns;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(imageView.mas_height);
            if (!row && !col) {
                // 第一块
                make.top.left.equalTo(self.imageContentView);
            }
            else if (row &&!col) {
                make.top.equalTo(lastView.mas_bottom).offset(10);
                make.left.equalTo(self.imageContentView);
            } else {
                make.left.equalTo(lastView.mas_right).offset(10);
                make.top.equalTo(lastView);
                if (col == 2) {
                    // 最后一块
                    make.right.equalTo(self.imageContentView);
                }
            }
            
            make.width.lessThanOrEqualTo(self.imageContentView).dividedBy(3);
            if (lastView) {
                make.width.equalTo(lastView);
            }
        }];
        
        imageView.tag = index;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSeeImageGesture:)];
        [imageView addGestureRecognizer:tapGesture];
        imageView.userInteractionEnabled = YES;
        
        lastView = imageView;
    }
    
    if (lastView) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imageContentView);
        }];
    }
}

- (void)initComponents {
    [self.contentView addSubview:self.innerTitleLabel];
    [self.contentView addSubview:self.imageContentView];
    
    [self.innerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
    }];
    
    [self.imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(75);
        make.top.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

#pragma mark - Button Click
- (void)clickToSeeImageGesture:(UITapGestureRecognizer *)gesture {
    UIView *clickedView = gesture.view;
    if (self.clickBlock) {
        self.clickBlock(clickedView.tag);
    }
}

- (UILabel *)titleLabel {
    return self.innerTitleLabel;
}

#pragma mark - Initiializer 
- (UILabel *)innerTitleLabel {
    if (!_innerTitleLabel) {
        _innerTitleLabel = [UILabel new];
        _innerTitleLabel.font = [UIFont font_30];
        _innerTitleLabel.textColor = [UIColor commonDarkGrayColor_666666];
        _innerTitleLabel.numberOfLines = 0;
        _innerTitleLabel.preferredMaxLayoutWidth = maxTitleWidth;
    }
    return _innerTitleLabel;
}

- (UIView *)imageContentView {
    if (!_imageContentView) {
        _imageContentView = [UIView new];
    }
    return _imageContentView;
}

@end
