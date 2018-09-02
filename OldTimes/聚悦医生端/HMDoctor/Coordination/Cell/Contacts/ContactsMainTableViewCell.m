//
//  ContactsMainTableViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ContactsMainTableViewCell.h"
#import "ContactCellAdapter.h"
#import "CoordinationContactTableViewCell.h"
#import "ContactInfoModel.h"

@interface ContactsMainTableViewCell()<ATTableViewAdapterDelegate>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  ContactCellAdapter  *adapter; // <##>
@property (nonatomic, strong)  NSMutableArray  *dataSource; // <##>
@property (nonatomic, copy)  selectContactBlock  selectBlock; // <##>
@end

@implementation ContactsMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configElements];
    }
    return self;
}

- (void)configElements {
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)configContactCellData:(NSArray *)contactsData selectable:(BOOL)selectable singleSelect:(BOOL)singleSelect tag:(NSInteger)tag selectedContact:(selectContactBlock)block {
    self.tag = tag;
    self.adapter.adapterArray = [contactsData mutableCopy];
    self.adapter.singleSelect = singleSelect;

    if (selectable != self.selectable) {
        self.selectable = selectable;
        self.adapter.selectable = selectable;
    }
    if (!self.selectBlock) {
        self.selectBlock = block;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(ContactsMainTableViewCellDelegateCallBack_clickedWithInnerCellData:indexPath:)]) {
        [self.delegate ContactsMainTableViewCellDelegateCallBack_clickedWithInnerCellData:cellData indexPath:indexPath];
    }
    ContactInfoModel *model = (ContactInfoModel *)cellData;
    if (self.selectable && !model.nonSelectable) {
        self.selectBlock(cellData,self.tag);
    }
}

#pragma mark - Init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 60;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
//        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CoordinationContactTableViewCell class] forCellReuseIdentifier:[CoordinationContactTableViewCell at_identifier]];
    }
    return _tableView;
}

- (ContactCellAdapter *)adapter {
    if (!_adapter) {
        _adapter = [ContactCellAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.selectable = self.selectable;
    }
    return _adapter;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
