//
//  ICAVPlayer.h
//  ICome
//
//  Created by zhangrongwu on 16/7/6.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnnDynamicHeader.h"
@class ICAVPlayer;
@protocol ICAVPlayerDelegate <NSObject>

@optional

-(void)closePlayerViewAction;

@end




/// Single picture's info.
@interface ICAVPlayerGroupItem : NSObject
@property (nonatomic, strong) UIView *thumbView; ///< thumb image, used for animation position calculation
@property (nonatomic, strong) NSURL *largeImageURL;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *fileKey;
@property (nonatomic, strong) UIImage *oglImage;
@end



@interface ICAVPlayer : UIView
@property (nonatomic, readonly) NSArray *groupItems; ///< Array<ICAVPlayerGroupItem>
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, assign) BOOL blurEffectBackground; ///< Default is YES
/**
 *  播放器player
 */
@property (nonatomic, strong)AVPlayer       *player;
/**
 * playerLayer
 */
@property (nonatomic, strong)AVPlayerLayer  *playerLayer;
/**
 * 播放器的代理
 */
@property (nonatomic, weak)id <ICAVPlayerDelegate> delegate;
/**
 *  当前播放的item
 */
@property (nonatomic, strong)AVPlayerItem   *playerItem;

- (instancetype)initWithGroupItems:(NSArray *)groupItems;

/**
 *  show player view
 *
 *  @param fromView    cell 中的videoImageView 必须给
 *  @param toContainer 播放器需显示的view  为nil则 默认给个App_RootCtr.view
 *  @param animated    动画
 */
- (void)presentFromVideoView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

@end
