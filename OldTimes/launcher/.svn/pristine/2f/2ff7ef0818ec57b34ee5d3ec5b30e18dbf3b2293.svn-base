//
//  NewApplyAtttachmentTableviewCell.m
//  launcher
//
//  Created by Dee on 16/8/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyAtttachmentTableviewCell.h"
#import "UIFont+Util.h"
#import "ApplicationAttachmentModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AttachmentUtil.h"
#import "Category.h"
#import <Masonry.h>

static BOOL isFile = NO;
static CGFloat const kApplicationAttachmentCellMaxTitleWidth = 50;
static CGFloat const kApplicationAttachmentCellFileIconHeight = 64;
static CGFloat const kApplicationAttachmentCellFileNameLabelLeftMargin = 10;
static CGFloat const kApplicationAttachmentCellFileNameLabelRightMargin = -10;

@interface NewApplyAtttachmentTableviewCell ()

@property(nonatomic, strong) UILabel  *innerTitleLabel;

@property(nonatomic, strong) UIView  *imageContenView;

@property(nonatomic, strong) UILabel  *fileNameLabel;

@property (nonatomic, copy) void (^clickBlock)(NSUInteger);

@end


@implementation NewApplyAtttachmentTableviewCell

+ (NSString *)identifier {return NSStringFromClass([self class]);}

+ (CGFloat)heightForCellWithImages:(NSArray *)images {
    if (images.count == 1) {
        ApplicationAttachmentModel *image = [images firstObject];
        
        
        if ([image thumbnailPath])
        {
            isFile = NO;
        } else if (![AttachmentUtil isImage:image.title]) {
            isFile = YES;
        } else {
            isFile = NO;
        }
        
    }
    
    return [self heightForCellWithImageCount:images.count accessoryMode:NO];
}

+ (CGFloat)heightForCellWithImageCount:(NSUInteger)count accessoryMode:(BOOL)accessoryMode {
    if (!count) {
        return 44;
    } else if (isFile && count <= 2) {
        return kApplicationAttachmentCellFileIconHeight;
    } else {
        BOOL hasNextLine = count % 3;
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        NSInteger line = count / 3 + (hasNextLine ? 1 : 0);
        return 20 + (screenWidth - 80 - (accessoryMode ? 30 : 0)) *line / 3 + 20;
        
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - interfaceMethod
- (void)clickToSeeImage:(void (^)(NSUInteger))clickBlock {
    self.clickBlock = clickBlock;
}

- (void)setTitleLabelText:(NSString *)text
{
    self.innerTitleLabel.text = text;
}

- (void)setImages:(NSArray *)images {
    NSArray *reversedSubViews = [[[self.imageContenView subviews] reverseObjectEnumerator] allObjects];
    [reversedSubViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    static NSInteger colouns = 3;
    
    UIImageView *lastView = nil;
    for (NSInteger index = 0 ;index < images.count; index++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        ApplicationAttachmentModel *image = [images objectAtIndex:index];
        if ([image thumbnailPath])
        {
            imageView.image = [image thumbnail];
            isFile = NO;
        } else if (![AttachmentUtil isImage:image.title]) {
            //修复未知文件时的显示问题
            UIImage *fileImage = [AttachmentUtil attachmentIconFromFileName:image.title];
            if (!fileImage) {
                fileImage = [UIImage imageNamed:@"file_icon_unknown"];
            }
            imageView.image = fileImage;
            isFile = YES;
        } else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[[image path] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]] placeholderImage:[UIImage imageNamed:@"image_placeholder_loading"]];
            isFile = NO;
        }
        
        [self.imageContenView addSubview:imageView];
        
        NSInteger row = index / colouns;
        NSInteger col = index % colouns;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(imageView.mas_height);
            if (!row && !col) {
                // 第一块
                make.top.left.equalTo(self.imageContenView);
            }
            else if (row &&!col) {
                make.top.equalTo(lastView.mas_bottom).offset(10);
                make.left.equalTo(self.imageContenView);
            } else {
                make.left.equalTo(lastView.mas_right).offset(10);
                make.top.equalTo(lastView);
                if (col == 2) {
                    // 最后一块
                    make.right.equalTo(self.imageContenView);
                }
            }
            
            make.width.lessThanOrEqualTo(self.imageContenView).dividedBy(3);
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
            make.bottom.equalTo(self.imageContenView);
        }];
    }
}

#pragma mark - privateMethod
- (void)initComponents
{
    [self.contentView addSubview:self.innerTitleLabel];
    [self.contentView addSubview:self.imageContenView];
    [self.innerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        //        make.bottom.lessThanOrEqualTo(self.contentView).offset(-5);
    }];
    
    [self.imageContenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(75);
        make.top.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)configureFileNameLabelWhileIsFile:(BOOL)isFile withFileImageView:(UIImageView *)imageView {
    if (!imageView) {
        return;
    }
    if (!isFile) {
        return;
    }
    
    [self.imageContenView addSubview:self.fileNameLabel];
    [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).offset(kApplicationAttachmentCellFileNameLabelLeftMargin);
        make.right.equalTo(self.imageContenView).offset(kApplicationAttachmentCellFileNameLabelRightMargin);
        
    }];
    
    self.fileNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSeeImageGesture:)];
    [self.fileNameLabel addGestureRecognizer:tapGesture];
    
}

#pragma mark - button Click
- (void)clickToSeeImageGesture:(UITapGestureRecognizer *)gesture {
    UIView *clickedView = gesture.view;
    if (self.clickBlock) {
        self.clickBlock(clickedView.tag);
    }
}

- (UILabel *)titleLabel {
    return self.innerTitleLabel;
}


#pragma mark - setterAndGetter
- (UILabel *)innerTitleLabel
{
    if (!_innerTitleLabel) {
        _innerTitleLabel = [[UILabel alloc] init];
        _innerTitleLabel.font = [UIFont mtc_font_28];
        _innerTitleLabel.textColor = [UIColor blackColor];
        _innerTitleLabel.numberOfLines = 0;
        _innerTitleLabel.preferredMaxLayoutWidth = 50;
    }
    return _innerTitleLabel;
}

- (UIView *)imageContenView
{
    if (!_imageContenView) {
        _imageContenView = [[UIView alloc] init];
    }
    return _imageContenView;
}

- (UILabel *)fileNameLabel
{
    if (!_fileNameLabel) {
        _fileNameLabel = [[UILabel alloc] init];
    }
    return _fileNameLabel;
}
@end

