//
//  ICActionSheetView.m
//  ICome
//
//  Created by zhangrongwu on 16/6/21.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICActionSheetView.h"
static const CGFloat KSignHeight = 60.f;
static const CGFloat KSectionMariginHeight = 8.f;
static const NSTimeInterval KanimationDurationTime = 0.3;
//static const CGFloat KNaviHeight = 64.0f;
static NSString *identifier = @"ICActionSheetCell";
@interface ICActionSheetView ()<UITableViewDataSource,UITableViewDelegate> {
    CGFloat _height;
    NSString *_selectedString;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSources;
@property (nonatomic,strong)UIView *bgView;
@end

@implementation ICActionSheetView

- (instancetype)initWithTitles:(NSArray *)titleArray delegate:(id<ICActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
{
    _height = KSectionMariginHeight;
    if (titleArray) {
        _height += KSignHeight * titleArray.count;
        [self.dataSources addObject:titleArray];
    }
    if (cancelButtonTitle) {
        _height += KSignHeight;
        [self.dataSources addObject:@[cancelButtonTitle]];
    }
    if (iPhoneX) {
        _height += HEIGHT_HOMEBAR;
    }
    self.delegate = delegate;
    if (self = [super init]) {
        self.frame = CGRectMake(0, APP_Frame_Height, App_Frame_Width, _height);
        [self addSubview:self.tableView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title Titles:(NSArray *)titleArray delegate:(id<ICActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
{
    _height = KSectionMariginHeight;
    _title = title;
    if (titleArray) {
        _height += KSignHeight * titleArray.count;
        [self.dataSources addObject:titleArray];
    }
    if (cancelButtonTitle) {
        _height += KSignHeight;
        [self.dataSources addObject:@[cancelButtonTitle]];
    }
    if(![ICTools stringEmpty:title])
    {
        _height += KSignHeight;
    }
    
    if (iPhoneX) {
        _height += HEIGHT_HOMEBAR;
    }
    self.delegate = delegate;
    if (self = [super init]) {
        self.frame = CGRectMake(0, APP_Frame_Height, App_Frame_Width, _height);
        [self addSubview:self.tableView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


- (void)updateConstraints
{
    WEAKSELF;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSources[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(![ICTools stringEmpty:self.title] && section == 0){
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.tableView.width, KSignHeight)];
        [labelTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        labelTitle.textColor = ICRGB(0x333333);
        labelTitle.text = self.title;
        labelTitle.backgroundColor = [UIColor whiteColor];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        return labelTitle;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (iPhoneX && section == 1) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 60)];
        footer.backgroundColor = [UIColor whiteColor];
        return footer;
    }return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:18]];
    cell.titleLabel.textColor = self.otherButtonTextColor;
    cell.titleLabel.text = self.dataSources[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0? [ICTools stringEmpty:self.title] ? CGFLOAT_MIN:KSignHeight:KSectionMariginHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 1? iPhoneX ? HEIGHT_HOMEBAR:0:0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedString = self.dataSources[indexPath.section][indexPath.row];
    if (indexPath.section == 1) {
        if ([self.delegate respondsToSelector:@selector(ActionSheetViewCancel:)]) {
            [self.delegate ActionSheetViewCancel:self];
        }
        [self touchPopViewWithIndex:indexPath.row + [[self.dataSources firstObject] count]];
    }else if ([self.delegate respondsToSelector:@selector(ActionSheetView:clickedButtonAtIndex:)] && indexPath.section == 0) {
        [self.delegate ActionSheetView:self clickedButtonAtIndex:indexPath.row];
        [self touchPopViewWithIndex:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - public Func
- (void)showInView:(UIView *)view
{
    if ([self.delegate respondsToSelector:@selector(willPresentActionSheetView:)]) {
        [self.delegate willPresentActionSheetView:self];
    }
    
    [view addSubview:self.bgView];
    
    WEAKSELF
    [UIView animateWithDuration:KanimationDurationTime animations:^{
        [view addSubview:weakSelf];
        weakSelf.frame = CGRectMake(0, APP_Frame_Height - weakSelf.height, App_Frame_Width, weakSelf.height);
    }completion:^(BOOL finished) {
        if ([weakSelf.delegate respondsToSelector:@selector(didPresentActionSheetView:)]) {
            [weakSelf.delegate didPresentActionSheetView:weakSelf];
        }
    }];
}

#pragma mark - pravite funs
- (void)touchPopViewTap:(UIGestureRecognizer *)ges
{
    NSInteger index = 0;
    index += [[self.dataSources firstObject] count];
    if (self.dataSources.count == 2) {
        index += [[self.dataSources lastObject] count];
    }
    
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf touchPopViewWithIndex:index];
    });
}

- (void)touchPopViewWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(actionSheetView:willDismissWithButtonIndex:)]) {
        [self.delegate actionSheetView:self willDismissWithButtonIndex:index];
    }
    
    WEAKSELF
    [UIView animateWithDuration:KanimationDurationTime animations:^{
        weakSelf.frame = CGRectMake(0, APP_Frame_Height, App_Frame_Width, weakSelf.height);
    } completion:^(BOOL finished) {
        [weakSelf.bgView removeFromSuperview];
        [weakSelf removeFromSuperview];
        if ([weakSelf.delegate respondsToSelector:@selector(actionSheetView:didDismissWithButtonIndex:)]) {
            [weakSelf.delegate actionSheetView:weakSelf didDismissWithButtonIndex:index];
        }
    }];
}

#pragma mark - setter and getter
- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor
{
    _cancelButtonTextColor = cancelButtonTextColor;
}

- (void)setOtherButtonTextColor:(UIColor *)otherButtonTextColor
{
    _otherButtonTextColor = otherButtonTextColor;
}

- (NSString *)selectedTitle
{
    return _selectedString;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = KSignHeight;
        [_tableView registerClass:[ICActionSheetCell class] forCellReuseIdentifier:identifier];
        _tableView.sectionFooterHeight = 0.f;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]){
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.7;
        _bgView.frame = [UIScreen mainScreen].bounds;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPopViewTap:)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
@end

@implementation ICActionSheetCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    WEAKSELF;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView);
    }];
    [super updateConstraints];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ICTEXTFONT_T1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
