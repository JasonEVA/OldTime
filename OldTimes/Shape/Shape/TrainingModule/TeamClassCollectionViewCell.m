//
//  TeamClassCollectionViewCell.m
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TeamClassCollectionViewCell.h"
#import "TeamClassView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface TeamClassCollectionViewCell()
@property (nonatomic, strong)  TeamClassView  *teamClassView; // <##>
@end
@implementation TeamClassCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.teamClassView];
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self.teamClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}
- (TeamClassView *)teamClassView {
    if (!_teamClassView) {
        _teamClassView = [[TeamClassView alloc] init];
    }
    return _teamClassView;
}
@end
