//
//  VideoplayCell.m
//  ZBAVPlayer
//
//  Created by 周波 on 16/11/22.
//  Copyright © 2016年 周波. All rights reserved.
//

#import "VideoplayCell.h"
#import <AVFoundation/AVFoundation.h>
#import "DownloadPathManager.h"
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

@implementation VideoplayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self setUI];
    }
    return self;
}

//创建视图
- (void)setUI{
   
    //图片
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
    [self.contentView addSubview:_imageview];
    //添加视频播放的按钮
    
    //保存的视频名字
    _namelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, kScreen_Width - 110, 40)];
    _namelabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_namelabel];
}

//已经下载完成的任务
- (void)setTask:(NSDictionary *)task{
    //视频名字
    _namelabel.text = task[@"saveName"];
    
    //视频的图片（拼接图片）
    NSString *filepath =  [NSString stringWithFormat:@"%@/%@",[DownloadPathManager sharedDownloadPathManager].alreadyDownloadPath,_namelabel.text];
    UIImage  *image =  [self getImage:filepath];
    _imageview.image = image;
}

 - (UIImage *)getImage:(NSString *)videoURL

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
    
    
    
}

@end
