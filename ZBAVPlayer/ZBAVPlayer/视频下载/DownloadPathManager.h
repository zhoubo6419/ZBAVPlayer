//
//  DownloadPathManager.h
//  DownloadDemo
//
//  Created by 周大波 on 16/4/2.
//  Copyright © 2016年 周大波.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DownloadPath [DownloadPathManager sharedDownloadPathManager]
#define MB (1024*1024.0)
// 下载模块分三个地方，第一个负责管理文件的存储位置。
// 第二个负责实现文件的下载，包括断点下载。
// 第三个负责掌控第二个模块的灵活使用。


@interface DownloadPathManager : NSObject
// 此处是第一个模块
@property (nonatomic, strong) NSString *alreadyDownloadPath; // 已经下载下来的数据存放的位置。
@property (nonatomic, retain) NSString *downloadedPlistPath; // 正在下载进度信息保存的路径
@property (nonatomic, retain) NSString *tempStr; // 临时文件路径

// 使用单例获取对象。
+(DownloadPathManager *)sharedDownloadPathManager;
// 判断正在下载的plist文件中是否存在该下载。
- (BOOL)existTaskWithUrl:(NSString *)str;



@end
