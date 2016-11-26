//
//  LoadingType.h
//  ZBAVPlayer
//
//  Created by 周波 on 16/11/25.
//  Copyright © 2016年 周波. All rights reserved.
//

#import <UIKit/UIKit.h>
///按钮的回调方法
typedef void(^ButtonActionBlock)(BOOL isSuccess,NSInteger tags);
@interface LoadingType : UIView
/**
 * YES是视频成功，NO是加载失败
 */
@property (nonatomic,assign)BOOL isSuccess;
@property (nonatomic,copy)ButtonActionBlock loadBlock;
@property (nonatomic,strong)UIButton *Errorcontroll;//重新播放
@property (nonatomic,strong)UIButton  *Delebutton;//删除按钮
@property (nonatomic,strong)UIButton  *Nextbutton;//学习下一个按钮
@property (nonatomic,strong)UIButton  *repeatbutton;//重播
@property (nonatomic,strong)UILabel  *titlelabel;//播放结束

///重新布局
- (void)setloutviews;
///加载
- (void)setLoadActionBlock:(ButtonActionBlock)block;
@end
