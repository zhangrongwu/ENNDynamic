//
//  ICUploadPhotoCollectionViewCell.h
//  ICome
//
//  Created by zhangrongwu on 16/4/18.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICUploadPhotoCollectionViewCell;
@protocol ICUploadPhotoCollectionViewCellDelegate <NSObject>
@optional
-(void)didClickCanclelButtonInCell:(ICUploadPhotoCollectionViewCell *)cell;
@end
@interface ICUploadPhotoCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UIButton *imageViewBtn;
@property(nonatomic, strong) UIButton *canclelBtn;
@property(nonatomic, strong) UIImage *image;

@property (nonatomic, strong)CAShapeLayer *progressLayer;

@property (nonatomic, weak)id <ICUploadPhotoCollectionViewCellDelegate> delegate;

@end
