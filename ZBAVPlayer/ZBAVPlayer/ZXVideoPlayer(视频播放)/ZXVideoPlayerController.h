//
//  ZXVideoPlayerController.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXVideo.h"
#import "ZXVideoPlayerControlView.h"

@protocol LoadingTypeDelegate <NSObject>
///关闭播放视图
- (void)setClose;
///下一个视频
- (void)setNext;
//重新播放
- (void)setagain;
@end

@import MediaPlayer;

#define kZXVideoPlayerOriginalWidth  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define kZXVideoPlayerOriginalHeight (kZXVideoPlayerOriginalWidth * (11.0 / 16.0))

@interface ZXVideoPlayerController : MPMoviePlayerController

@property (nonatomic, assign) CGRect frame;
/// video model
@property (nonatomic, strong, readwrite) ZXVideo *video;
/// 竖屏模式下点击返回
@property (nonatomic, copy) void(^videoPlayerGoBackBlock)(void);
/// 将要切换到竖屏模式
@property (nonatomic, copy) void(^videoPlayerWillChangeToOriginalScreenModeBlock)();
/// 将要切换到全屏模式
@property (nonatomic, copy) void(^videoPlayerWillChangeToFullScreenModeBlock)();
/// 播放器视图
@property (nonatomic, strong) ZXVideoPlayerControlView *videoControl;
///开始播放的图片
@property (nonatomic,assign)NSTimeInterval starttime;
///加载成功或者失败的视图
@property (nonatomic,strong)LoadingType *loadtype;
///LoadingType代理者
@property (nonatomic,strong)id <LoadingTypeDelegate> delegete;
- (instancetype)initWithFrame:(CGRect)frame;
/// 展示播放器
- (void)showInView:(UIView *)view;

@end
