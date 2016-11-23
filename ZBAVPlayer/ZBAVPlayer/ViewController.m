//
//  ViewController.m
//  ZBAVPlayer
//
//  Created by 周波 on 16/11/21.
//  Copyright © 2016年 周波. All rights reserved.
//

#import "ViewController.h"
#import "VideoCell.h"
#import "DownloadController.h"
#import "PurchaseCarAnimationTool.h"
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableviews;//标示图
@property (nonatomic,copy) NSArray *dataArray;//下载的视频url数组
@property (nonatomic,copy)NSString *cellid;//单元格的cellid
@property (nonatomic,strong)UILabel *numlabel;//下载数量的label
@property (nonatomic,copy) NSMutableArray *imageArray;//下载的视频url数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 
     问题：在看视频的时候会去缓存，如果缓存成功（缓存到临时文件）移动门到沙盒里面，没有完成的话删除，但是这个时候如果去点击下载了，如何处理，我的解决办法是以缓存完成后判断沙盒里面是否有这个文件，如何有的话就不存放了没有的就存放， 同时下载的时候注意一定要判断系统内是否有这个文件（一定是完整的），所以在下载要判断这个文件是否下载完成了。  【还有的不合理的地方：缓存快要完成后但是下载才刚开始的情况，如何这个时候直接删除的话会造成很大的性能消耗，要做一个替换的方法，这个暂时没有做，如何有好的办法的话可以添加进来】
     */
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:61.0/255.0 green:167.0/255.0 blue:252.0/255.0 alpha:1];
    self.title  = @"视频下载";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavitem];
    
    //创建标示图
    _cellid = @"cellid1";
    _dataArray = @[
                   @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                   @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                   @"http://baobab.wdjcdn.com/14525705791193.mp4",
                   @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                   @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                   @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
                   @"http://baobab.wdjcdn.com/14564977406580.mp4",
                   @"http://baobab.wdjcdn.com/1456316686552The.mp4",
                   @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                   @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                   @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                   @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                   @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                   @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                   @"http://baobab.wdjcdn.com/1456653443902B.mp4",
                   @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    _imageArray = [NSMutableArray array];
    
    _tableviews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    _tableviews.delegate = self;
    _tableviews.dataSource = self;
    _tableviews.rowHeight = 130;
    [_tableviews registerClass:[VideoCell class] forCellReuseIdentifier:_cellid];
    [self.view addSubview:_tableviews];
    
    //接受任务完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finshedTask:) name:@"finished" object:nil];
    //接受删除的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finshedTask:) name:@"downloadfinshed" object:nil];
    
}

#pragma maerk - 设置导航栏的按钮
- (void)setNavitem{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"视频管理@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(managebutton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    //创建展示的label
    _numlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, -10, 20, 20)];
    _numlabel.textColor = [UIColor whiteColor];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loadnums"]) {
        NSInteger nums = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"loadnums"] integerValue];
        if (nums > 0) {
            _numlabel.hidden = NO;
        }else{
            _numlabel.hidden = YES;
        }
        _numlabel.text = [NSString stringWithFormat:@"%ld",nums];
        
    }else{
        _numlabel.hidden = YES;

    }
    _numlabel.font = [UIFont systemFontOfSize:15];
    _numlabel.textAlignment = NSTextAlignmentCenter;
    _numlabel.backgroundColor = [UIColor redColor];
    _numlabel.layer.cornerRadius = 10;
    _numlabel.clipsToBounds = YES;
    [view addSubview:_numlabel];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellid];
    if (cell == nil) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath;
    if (_imageArray.count > indexPath.row) {
        cell.videoimage = _imageArray[indexPath.row];
    }
    [cell setVideourl:_dataArray[indexPath.row]];
    if (cell.videoimage != nil) {
        //图片
        if (_imageArray.count > indexPath.row) {
            
            
        }else{
            
            [_imageArray addObject:cell.videoimage];
            
        }

    }
//    [cell setReturnImageblock:^(UIImage *image, NSIndexPath *index) {//获取到图片
//        //图片
//        if (_imageArray.count > index.row) {
//
//        }else{
//            
//            [_imageArray addObject:image];
//        }
//        
//    }];
    [cell setTheLoadBlock:^(UIImageView *imageview) {//下载
        CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
        //获取当前cell 相对于self.view 当前的坐标
        rect.origin.y = rect.origin.y - [tableView contentOffset].y;
        CGRect imageViewRect = imageview.frame;
        imageViewRect.origin.y = rect.origin.y+imageViewRect.origin.y;
        [[PurchaseCarAnimationTool shareTool]startAnimationandView:imageview andRect:imageViewRect andFinisnRect:CGPointMake(ScreenWidth - 50, 20) andFinishBlock:^(BOOL finisn){
            //改变
            NSInteger num = [_numlabel.text integerValue];
            num ++;
            [[NSUserDefaults standardUserDefaults] setObject:@(num) forKey:@"loadnums"];
            if (num >= 1) {
                
                _numlabel.hidden = NO;
            }
            _numlabel.text = [NSString stringWithFormat:@"%ld",num];
        }];
    }];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lable= [[ UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.01)];
    return lable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - 视频按钮的点击方法
- (void)managebutton:(UIButton *)button{
    
    //到下在管理界面
    DownloadController *downvc = [[DownloadController alloc] init];
    [self.navigationController pushViewController:downvc animated:YES];
    
}

#pragma mark - 任务完成的回调
- (void)finshedTask:(NSNotification *)notification{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loadnums"]) {
        NSInteger nums = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"loadnums"] integerValue];
        nums --;
        [[NSUserDefaults standardUserDefaults] setObject:@(nums) forKey:@"loadnums"];
        if (nums > 0) {
            _numlabel.hidden = NO;
        }else{
            _numlabel.hidden = YES;
        }
        _numlabel.text = [NSString stringWithFormat:@"%ld",nums];
        
    }else{
        _numlabel.hidden = YES;
        
    }

}
@end
