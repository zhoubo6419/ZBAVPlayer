//
//  AppDelegate.h
//  ZBAVPlayer
//
//  Created by 周波 on 16/11/21.
//  Copyright © 2016年 周波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

