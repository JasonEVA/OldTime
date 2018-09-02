//
//  ATStaticOutsideModel.m
//  Clock
//
//  Created by Dariel on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATStaticOutsideModel.h"

@implementation ATStaticOutsideModel

- (CGFloat)cellHeight {
    
    if ( !_cellHeight ) {
    
        if ([self.Remark isEqualToString:@""]) {
            
            CGFloat textHeight = [self heightForString:self.Location width:175 fontSize:14];
            _cellHeight = 14+15+15+textHeight+15;
        }else {
            CGFloat localTextHeight = [self heightForString:self.Location width:175 fontSize:14];
            CGFloat remaketextHeight = [self heightForString:self.Remark width:175 fontSize:14];
            
            _cellHeight = 14+15+15+localTextHeight+15+remaketextHeight+15;
        }
    }
    return _cellHeight;
}

- (CGFloat)heightForString:(NSString *)text width:(CGFloat )width fontSize:(CGFloat)fontSize{
    
    NSDictionary *textAttrs =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize textMaxSize = CGSizeMake(width, MAXFLOAT);
    CGFloat textH = [text boundingRectWithSize:textMaxSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:textAttrs context:nil].size.height;
    return textH;
}


@end
