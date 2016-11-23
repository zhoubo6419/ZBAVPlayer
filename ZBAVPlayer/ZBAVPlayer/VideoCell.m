//
//  VideoCell.m
//  ZBAVPlayer
//
//  Created by 周波 on 16/11/21.
//  Copyright © 2016年 周波. All rights reserved.
//

#import "VideoCell.h"
#import "DownloadCenter.h"
#import "MBProgressHUD+Add.h"
#import "UIView+Viewcontroll.h"
#import "ZXVideo.h"
#import "VideoPlayViewController.h"

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
@implementation VideoCell{
    UIImageView *_imageview;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
     //创建子视图
        
        [self setUI];
    }
    return self;
}

//创建子视图
- (void)setUI{
    
    //图片的视图
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 120, 120)];
    _imageview.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_imageview];
    
    //下载的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreen_Width - 50, (130 - 40)/2 , 40, 40);
    [button setImage:[UIImage imageNamed:@"下载@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    //在线播放的按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(140, (130 - 40)/2 , 40, 40);
    [button1 setImage:[UIImage imageNamed:@"在线播放@2x"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button1];

    
}
/**
 * 下载按钮的办法
 */
- (void)loadAction:(UIButton *)button{
    
 // 添加到下载任务里面去
        [DDownloadCenter addTaskSaveName:[NSString stringWithFormat:@"测试%ld",_index.row] urlStr:_videourl flag:@"标签" duration:@"接口" backType:^(DownloadBackType type) {
        if (type == Finish) {
            
            
            self.clickblock(_imageview);
            
        }else{
            
            [MBProgressHUD showError:@"任务存在了" toView:self.contentView.viewcontroller.view];
        }
    }];

    
}

#pragma mark - 在线播放按钮
- (void)playAction:(UIButton *)button{
   
    ZXVideo *video = [[ZXVideo alloc] init];
    video.playUrl = _videourl;
    if (_videoname == nil) {
        
        video.title = @"";

    }else{
        video.title = _videoname;
    }
    
    VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
    vc.video = video;
    vc.hidesBottomBarWhenPushed = YES;
    [self.contentView.viewcontroller.navigationController pushViewController:vc animated:YES];


}

- (void)setTheLoadBlock:(clickloadBlock)block{
    self.clickblock = block;
}
- (void)setReturnImageblock:(returnimageBlock)block{
    self.imageBlock = block;
}

- (void)setVideourl:(NSString *)videourl{
    _videourl = videourl;
    if (_videoimage == nil) {
        
        UIImage *image = [self getVideoPreViewImage:[NSURL URLWithString:_videourl]];
        _imageview.image = image;
        _videoimage = image;
//        self.imageBlock(image,_index);
        
        
    }else{
        
        _imageview.image = _videoimage;
  
    }
}

/**
 *  获取视频的图片
 */

- (UIImage*) getVideoPreViewImage:(NSURL*)url{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return img;
}


@end
