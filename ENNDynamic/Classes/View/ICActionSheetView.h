//
//  ICActionSheetView.h
//  ICome
//
//  Created by zhangrongwu on 16/6/21.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICActionSheetView;

@protocol ICActionSheetViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)ActionSheetView:(ICActionSheetView *)actionSheetView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)ActionSheetViewCancel:(ICActionSheetView *)actionSheetView;

- (void)willPresentActionSheetView:(ICActionSheetView *)actionSheetView;
// before animation and showing view
- (void)didPresentActionSheetView:(ICActionSheetView *)actionSheetView;  // after animation

- (void)actionSheetView:(ICActionSheetView *)actionSheetView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)actionSheetView:(ICActionSheetView *)actionSheetView didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end

@interface ICActionSheetView : UIView
- (instancetype)initWithTitles:(NSArray *)titleArray delegate:(id<ICActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;

- (instancetype)initWithTitle:(NSString *)title Titles:(NSArray *)titleArray delegate:(id<ICActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)showInView:(UIView *)view;

@property(nonatomic,weak)id<ICActionSheetViewDelegate> delegate;


/**
 * title
 */
@property(nonatomic,copy,readonly)NSString *title;

/**
 * clicks location title
 */
@property(nonatomic,copy,readonly)NSString *selectedTitle;

/**
 * cancel button title color
 */
@property(nonatomic,strong)UIColor *cancelButtonTextColor;

/**
 * other button title color
 */
@property(nonatomic,strong)UIColor *otherButtonTextColor;





@end

@interface ICActionSheetCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLabel;

@end
