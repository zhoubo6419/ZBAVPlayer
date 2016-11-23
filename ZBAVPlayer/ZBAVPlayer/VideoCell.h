//
//  VideoCell.h
//  ZBAVPlayer
//
//  Created by 周波 on 16/11/21.
//  Copyright © 2016年 周波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^clickloadBlock)(UIImageView *imageview);
typedef void(^returnimageBlock)(UIImage *image,NSIndexPath *index);

@interface VideoCell : UITableViewCell
/**
 * 视频链接
 */
@property (nonatomic,copy) NSString *videourl;
/**
 * 视频的名字
 */
@property (nonatomic,copy) NSString *videoname;

@property (nonatomic,copy) clickloadBlock clickblock;
@property (nonatomic,copy) returnimageBlock imageBlock;
@property (nonatomic,copy) UIImage *videoimage;//视频的图片
@property (nonatomic,strong) NSIndexPath *index;

- (void)setTheLoadBlock:(clickloadBlock)block;
- (void)setReturnImageblock:(returnimageBlock)block;
@end
