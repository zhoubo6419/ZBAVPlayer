//
//  VideoplayCell.h
//  ZBAVPlayer
//
//  Created by 周波 on 16/11/22.
//  Copyright © 2016年 周波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Download.h"
@interface VideoplayCell : UITableViewCell

@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UILabel  *namelabel;
@property(nonatomic,strong)NSDictionary *task;
@end
