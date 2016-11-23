//
//  DownloadPathManager.m
//  DownloadDemo
//
//  Created by 周大波 on 16/4/2.
//  Copyright © 2016年 周大波.com. All rights reserved.
//

#import "DownloadPathManager.h"

@implementation DownloadPathManager

// 获取管理器
+ (DownloadPathManager *)sharedDownloadPathManager{
    static DownloadPathManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadPathManager alloc] init];
    });
    return manager;
}
// 懒加载获取几个地址路径
// 已经下载的路径
- (NSString *)alreadyDownloadPath{
    if (_alreadyDownloadPath == nil) {
        _alreadyDownloadPath = [NSString stringWithFormat:@"%@/Library/%@/", NSHomeDirectory(),@"ESTVideo"];
        // 在相应的路径创建对应的文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:_alreadyDownloadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _alreadyDownloadPath;
}

// 已经下载的plist文件路径
- (NSString *)downloadedPlistPath{
    if (_downloadedPlistPath == nil) {
        NSString *record = [NSString stringWithFormat:@"%@/Library/ESTVideo/",NSHomeDirectory()];
        _downloadedPlistPath = [record stringByAppendingString:@"Download.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:record]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:record withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:_downloadedPlistPath]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            // 在相应的路径创建plist文件
            [dic writeToFile:_downloadedPlistPath atomically:YES];
        }
        
    }
    return _downloadedPlistPath;
}

// 判断本地的Download.plist文件中是否存在该下载
- (BOOL)existTaskWithUrl:(NSString *)str{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:self.downloadedPlistPath];
    if ([dic objectForKey:str]) {
        return YES;
    }
    return NO;
}
// 临时文件夹
- (NSString *)tempStr{
    return [NSString stringWithFormat:@"%@/%@/", NSHomeDirectory(), @"tmp"];
}



@end



