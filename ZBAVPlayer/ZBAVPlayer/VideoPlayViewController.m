//
//  VideoPlayViewController.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/29.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "ZXVideoPlayerController.h"
#import "ZXVideo.h"

@interface VideoPlayViewController ()

@property (nonatomic, strong) ZXVideoPlayerController *videoController;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 400, 140, 100);
    [button setTitle:@"重新打开播放" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(managebutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(180, 400, 140, 100);
    [button1 setTitle:@"返回上一个界面" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(managebutton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];

    
    [self playVideo];
}

- (void)playVideo
{
    if (!self.videoController) {
        //kZXVideoPlayerOriginalHeight
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kZXVideoPlayerOriginalWidth,200)];
        
        __weak typeof(self) weakSelf = self;
        self.videoController.videoPlayerGoBackBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
            [strongSelf.videoController.view removeFromSuperview];
            strongSelf.videoController = nil;

        };
        
        self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
            NSLog(@"切换为竖屏模式");
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            NSLog(@"切换为全屏模式");
            
        };
        
        [self.videoController showInView: self.view];
    }
    
    self.videoController.video = self.video;
}


//重新播放
- (void)managebutton:(UIButton *)button{
    
    [self playVideo];
}

- (void)managebutton1:(UIButton *)button{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];

    
}

@end
