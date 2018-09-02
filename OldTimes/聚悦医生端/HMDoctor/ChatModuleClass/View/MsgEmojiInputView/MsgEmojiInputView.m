//
//  MsgEmojiInputView.m
//  Titans
//
//  Created by Wythe Zhou on 1/21/15.
//  Copyright (c) 2015 Remon Lv. All rights reserved.
//

#import "MsgEmojiInputView.h"
#import "MsgEmojiCollectionViewCell.h"
#import "MsgEmojiBackspaceCollectionViewCell.h"
#import "QuickCreateManager.h"

#define COLLECTION_CELL_INDENTIFER  @"MsgEmojiInputCollectionViewCell"
#define COLLECTION_CELL_BACKSPACE_INDENTIFER  @"MsgEmojiInputCollectionViewCellBackspace"

#define INPUTVIEW_HEIGHT            216

// 底部栏
#define BOTTOM_BAR_HEIGHT           36

#define BOTTOM_SEND_BTN_WIDTH       64
#define BOTTOM_SEND_BTN_FONT        16
#define BOTTOM_SEND_BTN_BG_COLOR    [UIColor colorWithRed:0.23f green:0.51f blue:0.98f alpha:1.0f]

// 分页控制器
#define PAGECONTROL_HEIGHT          22

// 表情所在的 CollectionView
#define COLLECTIONVIEW_HEIGHT       (INPUTVIEW_HEIGHT - BOTTOM_BAR_HEIGHT - PAGECONTROL_HEIGHT) // 158

#define COLLECTION_CELL_ROW         3

// 单个表情 Cell 的 CollectionView
#define COLLECTION_CELL_WIDTH       40
#define COLLECTION_CELL_X_NUM_4     7
#define COLLECTION_CELL_X_NUM_4_7   8
#define COLLECTION_CELL_X_NUM_5_5   9

#define PREPARE_PAGE_NUMBER         5

// 键盘高度
// 320 216
// 375 216
// 414 216
// 320 / 7 = 45
// 45 * 8 = 360
// 45 * 9 = 405
// 45 * 3 = 135

@implementation MsgEmojiInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor commonBackgroundColor];
//        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self initEmojiArray];
        // 一共只需要三个 collectionView
        self.arrCollectionViews = [NSMutableArray arrayWithCapacity:PREPARE_PAGE_NUMBER];
        for (NSUInteger i = 0; i < 5; i++)
        {
            [self.arrCollectionViews addObject:[NSNull null]];
        }
        
        // 计算 Emoji 的表情数量等，获得必要的行、列、页数信息
        [self JWinitCountData];
        // 创建 ScrollView 并配置好 Delegate 这些，并且配置好分页
        [self JWinitScrollView];
        [self JWinitBottomBar];
        
        for (NSInteger i = 0; i < (PREPARE_PAGE_NUMBER) / 2; i++)
        {
            [self JWloadScrollViewWithPage:i];
        }
    }
    return self;
}

- (void)initEmojiArray
{
    self.emojiArray = @[@"😄", @"😊", @"😃", @"☺", @"😉", @"😍", @"😘", @"😚", @"😳", @"😌", @"😁", @"😜", @"😝", @"😒", @"😏", @"😓", @"😔", @"😞", @"😖", @"😥", @"😰", @"😨", @"😣", @"😢", @"😭", @"😂", @"😲", @"😱", @"😠", @"😡", @"😪", @"😷", @"👿", @"❤", @"💔", @"✨", @"🌟", @"💢", @"💤", @"💨", @"💦", @"🎶", @"🔥", @"💩", @"👍", @"👎", @"👌", @"✊", @"✌", @"👋", @"🙏", @"👆", @"👇", @"👉", @"👈", @"☝", @"👏", @"💪", @"👄", @"👂", @"👀", @"👃", @"👻", @"🎅", @"🎃", @"🎄", @"🎁", @"♠", @"♥", @"♣", @"♦", @"👙", @"🎀", @"💎", @"☕", @"🍎", @"🍉", @"🍎", @"🐶", @"🐷", @"🐦"];
    
//    _emojiArray = @[@"😄", @"😊", @"😃", @"☺", @"😉", @"😍", @"😘", @"😚", @"😳", @"😌", @"😁", @"😜", @"😝", @"😒", @"😏", @"😓", @"😔", @"😞", @"😖", @"😥", @"😰", @"😨", @"😣", @"😢", @"😭", @"😂", @"😲", @"😱", @"😠", @"😡", @"😪", @"😷", @"👿", @"👽", @"💛", @"💙", @"💜", @"💗", @"💚", @"❤", @"💔", @"💓", @"💘", @"✨", @"🌟", @"💢", @"❕", @"❔", @"💤", @"💨", @"💦", @"🎶", @"🎵", @"🔥", @"💩", @"👍", @"👎", @"👌", @"👊", @"✊", @"✌", @"👋", @"✋", @"👐", @"👆", @"👇", @"👉", @"👈", @"🙌", @"🙏", @"☝", @"👏", @"💪", @"🚶", @"🏃", @"👫", @"💃", @"👯", @"🙆", @"🙅", @"💁", @"🙇", @"💏", @"💑", @"💆", @"💇", @"💅", @"👦", @"👧", @"👩", @"👨", @"👶", @"👵", @"👴", @"👱", @"👲", @"👳", @"👷", @"👮", @"👼", @"👸", @"💂", @"💀", @"👣", @"💋", @"👄", @"👂", @"👀", @"👃", @"🎍", @"💝", @"🎎", @"🎒", @"🎓", @"🎏", @"🎆", @"🎇", @"🎐", @"🎑", @"🎃", @"👻", @"🎅", @"🎄", @"🎁", @"🔔", @"🎉", @"🎈", @"💿", @"📀", @"📷", @"🎥", @"💻", @"📺", @"📱", @"📠", @"☎", @"💽", @"📼", @"🔊", @"📢", @"📣", @"📻", @"📡", @"➿", @"🔍", @"🔓", @"🔒", @"🔑", @"✂", @"🔨", @"💡", @"📲", @"📩", @"📫", @"📮", @"🛀", @"🚽", @"💺", @"💰", @"🔱", @"🚬", @"💣", @"🔫", @"💊", @"💉", @"🏈", @"🏀", @"⚽", @"⚾", @"🎾", @"⛳", @"🎱", @"🏊", @"🏄", @"🎿", @"♠", @"♥", @"♣", @"♦", @"🏆", @"👾", @"🎯", @"🀄", @"🎬", @"📝", @"📖", @"🎨", @"🎤", @"🎧", @"🎺", @"🎷", @"🎸", @"〽", @"👟", @"👡", @"👠", @"👢", @"👕", @"👔", @"👗", @"👘", @"👙", @"🎀", @"🎩", @"👑", @"👒", @"🌂", @"💼", @"👜", @"💄", @"💍", @"💎", @"☕", @"🍵", @"🍺", @"🍻", @"🍸", @"🍶", @"🍴", @"🍔", @"🍟", @"🍝", @"🍛", @"🍱", @"🍣", @"🍙", @"🍘", @"🍚", @"🍜", @"🍲", @"🍞", @"🍳", @"🍢", @"🍡", @"🍦", @"🍧", @"🎂", @"🍰", @"🍎", @"🍊", @"🍉", @"🍓", @"🍆", @"🍅", @"☀", @"☔", @"☁", @"⛄", @"🌙", @"⚡", @"🌀", @"🌊", @"🐱", @"🐶", @"🐭", @"🐹", @"🐰", @"🐺", @"🐸", @"🐯", @"🐨", @"🐻", @"🐷", @"🐮", @"🐗", @"🐵", @"🐒", @"🐴", @"🐎", @"🐫", @"🐑", @"🐘", @"🐍", @"🐦", @"🐤", @"🐔", @"🐧", @"🐛", @"🐙", @"🐠", @"🐟", @"🐳", @"🐬", @"💐", @"🌸", @"🌷", @"🍀", @"🌹", @"🌻", @"🌺", @"🍁", @"🍃", @"🍂", @"🌴", @"🌵", @"🌾", @"🐚", @"1⃣", @"2⃣", @"3⃣", @"4⃣", @"5⃣", @"6⃣", @"7⃣", @"8⃣", @"9⃣", @"0⃣", @"#⃣", @"⬆", @"⬇", @"⬅", @"➡", @"↗", @"↖", @"↘", @"↙", @"◀", @"▶", @"⏪", @"⏩", @"🆗", @"🆕", @"🔝", @"🆙", @"🆒", @"🎦", @"🈁", @"📶", @"🈵", @"🈳", @"🉐", @"🈹", @"🈯", @"🈺", @"🈶", @"🈚", @"🈷", @"🈸", @"🈂", @"🚻", @"🚹", @"🚺", @"🚼", @"🚭", @"🅿", @"♿", @"🚇", @"🚾", @"㊙", @"㊗", @"🔞", @"🆔", @"✳", @"✴", @"💟", @"🆚", @"📳", @"📴", @"💹", @"💱", @"♈", @"♉", @"♊", @"♋", @"♌", @"♍", @"♎", @"♏", @"♐", @"♑", @"♒", @"♓", @"⛎", @"🔯", @"🅰", @"🅱", @"🆎", @"🅾", @"🔲", @"🔴", @"🔳", @"🕛", @"🕐", @"🕑", @"🕒", @"🕓", @"🕔", @"🕕", @"🕖", @"🕗", @"🕘", @"🕙", @"🕚", @"⭕", @"❌", @"©", @"®", @"™", @"🏠", @"🏫", @"🏢", @"🏣", @"🏥", @"🏦", @"🏪", @"🏩", @"🏨", @"💒", @"⛪", @"🏬", @"🌇", @"🌆", @"🏧", @"🏯", @"🏰", @"⛺", @"🏭", @"🗼", @"🗻", @"🌄", @"🌅", @"🌃", @"🗽", @"🌈", @"🎡", @"⛲", @"🎢", @"🚢", @"🚤", @"⛵", @"✈", @"🚀", @"🚲", @"🚙", @"🚗", @"🚕", @"🚌", @"🚓", @"🚒", @"🚑", @"🚚", @"🚃", @"🚉", @"🚄", @"🚅", @"🎫", @"⛽", @"🚥", @"⚠", @"🚧", @"🔰", @"🎰", @"🚏", @"💈", @"♨", @"🏁", @"🎌", @"🇯🇵", @"🇰🇷", @"🇨🇳", @"🇺🇸", @"🇫🇷", @"🇪🇸", @"🇮🇹", @"🇷🇺", @"🇬🇧", @"🇩🇪"];
};

// 初始化数字信息
- (void)JWinitCountData
{
    self.cellRow = COLLECTION_CELL_ROW;
    self.cellCol = [self getCollectionCol];
    self.cellPerPageCount = self.cellRow * self.cellCol;
    
    // 取临近最大整数
    NSInteger pageCount = self.emojiArray.count / (self.cellPerPageCount - 1);
    if (self.emojiArray.count % (self.cellPerPageCount - 1) != 0)
    {
        pageCount++;
    }
    self.pageCount = pageCount;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(COLLECTION_CELL_WIDTH, COLLECTION_CELL_WIDTH)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = (COLLECTIONVIEW_HEIGHT - COLLECTION_CELL_WIDTH * self.cellRow) / (self.cellRow + 1);
    flowLayout.minimumInteritemSpacing = (self.frame.size.width - COLLECTION_CELL_WIDTH * self.cellCol) / (self.cellCol + 2);
    flowLayout.sectionInset = UIEdgeInsetsMake(flowLayout.minimumLineSpacing, flowLayout.minimumInteritemSpacing, flowLayout.minimumLineSpacing, flowLayout.minimumInteritemSpacing);
    self.flowLayout = flowLayout;
}

- (void)JWinitScrollView
{
    [self addSubview:self.scrollView];

    [self addSubview:self.pageControl];
}

- (void)JWinitBottomBar
{
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, INPUTVIEW_HEIGHT - BOTTOM_BAR_HEIGHT, self.frame.size.width, BOTTOM_BAR_HEIGHT)];
    bottomBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomBar];
    CGRect frame = CGRectMake(self.frame.size.width - BOTTOM_SEND_BTN_WIDTH, 0, BOTTOM_SEND_BTN_WIDTH, BOTTOM_BAR_HEIGHT);
    UIButton *sendButton = [[UIButton alloc] initWithFrame:frame];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:BOTTOM_SEND_BTN_FONT]];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setBackgroundColor:BOTTOM_SEND_BTN_BG_COLOR];
    
    [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:sendButton];
}

- (void)inputString:(NSString *)string
{
    if ([self.delegateKeyInput respondsToSelector:@selector(insertText:)])
    {
        [self.delegateKeyInput insertText:string];
    }
}

- (void)keyboardBackspace
{
    if ([self.delegateKeyInput respondsToSelector:@selector(deleteBackward)])
    {
        [self.delegateKeyInput deleteBackward];
    }
}

- (void)sendMessage
{
    if ([self.delegateMsgSend respondsToSelector:@selector(MsgEmojiInputViewDelegate_SendMessage)])
    {
        [self.delegateMsgSend MsgEmojiInputViewDelegate_SendMessage];
    }
}

- (NSInteger)getCollectionCol
{
    if (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON)
    {
        return COLLECTION_CELL_X_NUM_5_5;
    }
    else if (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON)
    {
        return COLLECTION_CELL_X_NUM_4_7;
    }
    else
    {
        return COLLECTION_CELL_X_NUM_4;
    }
}

// 给 ScrollView 填充数据
- (void)JWloadScrollViewWithPage:(NSUInteger)page
{
    // 已经是 U，所以不会出现负数
    if (page >= self.pageCount)
    {
        return;
    }
    
    // 如果需要的话换掉占位符
    // 只有 几 个 collectionView 所以循环重复使用
    UICollectionView *collectionView = self.arrCollectionViews[page % PREPARE_PAGE_NUMBER];
    if ((NSNull *)collectionView == [NSNull null])
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = self.scrollView.frame.size.width * page;
        frame.origin.y = 0;
        collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.flowLayout];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [self.scrollView addSubview:collectionView];
        
        [collectionView registerClass:[MsgEmojiCollectionViewCell class] forCellWithReuseIdentifier:COLLECTION_CELL_INDENTIFER];
        [collectionView registerClass:[MsgEmojiBackspaceCollectionViewCell class] forCellWithReuseIdentifier:COLLECTION_CELL_BACKSPACE_INDENTIFER];
        collectionView.backgroundColor = [UIColor commonBackgroundColor];
        
        [self.arrCollectionViews replaceObjectAtIndex:page % PREPARE_PAGE_NUMBER withObject:collectionView];
    }
    else
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = self.scrollView.frame.size.width * page;
        frame.origin.y = 0;
        collectionView.frame = frame;
        [collectionView reloadData];
    }

    // 标记 tag 用来显示的时候返回数据用
    collectionView.tag = page;
    // 加载新的数据
//    [collectionView reloadData];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // 装载上一页、本页、下一页（如果已经装载就自动适配）
    for (NSInteger i = 0; i < PREPARE_PAGE_NUMBER; i++)
    {
        [self JWloadScrollViewWithPage:page + i - (PREPARE_PAGE_NUMBER + 1) / 2];
    }
}

#pragma mark - UICollectionView Delegate & Data Source

//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    // 取临近最大整数
//    NSInteger sectionCount = _emojiArray.count / _cellPerPageCount;
//    if (_emojiArray.count % _cellPerPageCount != 0)
//    {
//        sectionCount++;
//    }
//    return sectionCount;
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellPerPageCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = COLLECTION_CELL_INDENTIFER;
    static NSString *cellBackSpaceIdentifier = COLLECTION_CELL_BACKSPACE_INDENTIFER;
    
    // 不是最后一颗删除键
    if (indexPath.row < self.cellPerPageCount - 1) {
        MsgEmojiCollectionViewCell *cell = (MsgEmojiCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        NSInteger index = collectionView.tag * (self.cellPerPageCount - 1) + indexPath.row;
        // 如果没有超出范围
        if (index < self.emojiArray.count)
        {
            [cell.titleLabel setText:self.emojiArray[index]];
        }
        else
        {
            [cell.titleLabel setText:@""];
        }
        return cell;
    }
    else
    {
        MsgEmojiBackspaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellBackSpaceIdentifier forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *collectionViewCell = [collectionView cellForItemAtIndexPath:indexPath];
//    collectionViewCell.backgroundColor = [UIColor lightGrayColor];
    // 不是最后一颗删除键
    if (indexPath.row < self.cellPerPageCount - 1)
    {
        NSInteger index = collectionView.tag * (self.cellPerPageCount - 1) + indexPath.row;
        // 如果没有超出范围
        if (index < self.emojiArray.count)
        {
            [self inputString:self.emojiArray[index]];
        }
        else
        {
        }
    }
    else
    {
        [self keyboardBackspace];
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *collectionViewCell = [collectionView cellForItemAtIndexPath:indexPath];
//    collectionViewCell.backgroundColor = [UIColor clearColor];
//}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, COLLECTIONVIEW_HEIGHT)];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * self.pageCount, COLLECTIONVIEW_HEIGHT);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, COLLECTIONVIEW_HEIGHT, self.frame.size.width, PAGECONTROL_HEIGHT)];
        _pageControl.numberOfPages = self.pageCount;
        _pageControl.currentPage = 0;
        
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.userInteractionEnabled = NO;

    }
    return _pageControl;
}

@end
