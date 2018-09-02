//
//  MsgEmojiInputView.h
//  Titans
//
//  Created by Wythe Zhou on 1/21/15.
//  Copyright (c) 2015 Remon Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MsgEmojiInputViewDelegate <NSObject>

- (void)MsgEmojiInputViewDelegate_SendMessage;

@end

@interface MsgEmojiInputView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    NSArray *_emojiArray;
    
    NSInteger _cellCol;             // cell 的列数
    NSInteger _cellRow;             // cell 的行数
    NSInteger _cellPerPageCount;    // 每页 cell 的个数
    
    NSInteger _pageCount;           // 表情总页数
    
    // View
    UIScrollView *_scrollView;      // ScrollView
    UIPageControl *_pageControl;    // PageControl
    NSMutableArray *_arrCollectionViews;   // Collection View 的数组
    UICollectionViewFlowLayout *_flowLayout;    // Collection View 的 FlowLayout
}

@property (nonatomic, weak) id <UIKeyInput> delegateKeyInput;                   // 键盘的 delegate
@property (nonatomic, weak) id <MsgEmojiInputViewDelegate> delegateMsgSend;     // 发送消息的 delegate

@end
