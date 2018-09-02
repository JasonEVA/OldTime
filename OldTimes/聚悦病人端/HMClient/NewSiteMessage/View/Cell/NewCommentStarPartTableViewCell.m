//
//  NewCommentStarPartTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/3/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewCommentStarPartTableViewCell.h"
#import "NewFiveStarSelectView.h"
#import "NewCommentEvaluateTagModel.h"

@interface NewCommentStarPartTableViewCell ()
@property (nonatomic, strong) NewFiveStarSelectView *lastView; //最后一个VIEW

@end

@implementation NewCommentStarPartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view = [UIView new];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.greaterThanOrEqualTo(@160);
        }];
    }
    return self;
}
#pragma mark -private method
- (void)configElements {
}


#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithArray:(NSArray <NewCommentEvaluateTagModel *>*)array {
    if (array && array.count) {
        
        if (self.contentView.subviews.count) {
            [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NewFiveStarSelectView class]]) {
                    [obj removeFromSuperview];
                    self.lastView = nil;
                }
            }];
        }
        
        [array enumerateObjectsUsingBlock:^(NewCommentEvaluateTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NewFiveStarSelectView *fiveStarView = [[NewFiveStarSelectView alloc] initWithName:obj.target];
            [fiveStarView setTag:obj.targetId.integerValue];
            if (obj.score) {
                [fiveStarView starDisenable];
                [fiveStarView changeStarStatus:obj.score - 1];
            }
            [fiveStarView getStarCountWithBlock:^(NSInteger starCount) {
                obj.score = starCount;
            }];
            [self.contentView addSubview:fiveStarView];
            
            [fiveStarView mas_makeConstraints:^(MASConstraintMaker *make) {
                self.lastView ? make.top.equalTo(self.lastView.mas_bottom).offset(17):make.top.equalTo(self.contentView).offset(30);
                make.centerX.equalTo(self.contentView);
            }];
            self.lastView = fiveStarView;
            
        }];
        
        [self.lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-40);
        }];
    }
}
#pragma mark - init UI




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
