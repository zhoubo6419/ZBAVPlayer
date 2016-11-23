//
//  DownloadController.m
//  ZBAVPlayer
//
//  Created by 周波 on 16/11/21.
//  Copyright © 2016年 周波. All rights reserved.
//

#import "DownloadController.h"
#import "MyTableViewCell.h"
#import "DownloadCenter.h"
#import "VideoplayCell.h"
#import "VideoPlayViewController.h"
#import "ZXVideo.h"
#import "Download.h"
#import "MBProgressHUD+Add.h"
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

@interface DownloadController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView; //下载的表示图
@property (nonatomic,copy) NSArray *taskArr;//正在下载的视频
@property (nonatomic,copy) NSArray *loadArr;//已经下载的视频
@property (nonatomic,copy) NSMutableArray *deleteArr;//删除按钮
@property (nonatomic,assign) BOOL isCompleteSelete;//是否是全选
@property (nonatomic,strong) UIView *Seleviews;//选中视图
@property (nonatomic,strong) UIView *envelopviews;//笼罩视图
@property (nonatomic,assign) NSInteger alreaydeletenums;//记录已经删除的数量

@end

@implementation DownloadController

//  此页面用来展示正在下载的内容和已经下载完成的项目
- (NSArray *)taskArr{
    return DDownloadCenter.taskArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _deleteArr = [NSMutableArray array];
    
    _myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_myTableView];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.rowHeight = 100;
    
    //设置导航栏上的按钮(删除按钮和取消)
    [self setNavitem];
    
    //设置选择视图
    [self setSeleviews];
    
    [_myTableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"downloadCell"];
    [_myTableView registerClass:[VideoplayCell class] forCellReuseIdentifier:@"VideoplayCell"];
    DDownloadCenter.reloadData = ^(){
        //[self.myTableView reloadData];
    };
    
    for (Download *task in self.taskArr) {//在下载的
        NSLog(@"%@",self.taskArr);
        NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:DownloadPath.downloadedPlistPath];
        NSMutableDictionary *dic = [plist objectForKey:task.urlString];
        if ([dic[@"state"] isEqualToString:@"loading"]) {
            if (task.isDownloading == YES) {
            }else{
                [task start];
            }
            task.date = [NSDate date];
        }
    }
    
    //已经下载的
    NSMutableArray *loadArray =  [DDownloadCenter finishedTasks];
    self.loadArr = loadArray.mutableCopy;
    
    //接受任务完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finshedTask:) name:@"finished" object:nil];
}

//设置导航栏上的按钮(删除按钮和取消)
- (void)setNavitem{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    button.tag = 11239440;
    [button setImage:[UIImage imageNamed:@"垃圾@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rubbishbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;


}

#pragma mark -  设置选择视图
- (void)setSeleviews{
    //
    _Seleviews = [[UIView alloc] initWithFrame:CGRectMake(0,kScreen_Height, kScreen_Width, 50)];
    _Seleviews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_Seleviews];
    
    //全选择按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 5, 80, 40);
    button.tag = 11247110;
    [button setTitle:@"全选" forState:UIControlStateNormal];
    [button setTitle:@"取消全选" forState:UIControlStateSelected];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Seleviewsbutton:) forControlEvents:UIControlEventTouchUpInside];
    [_Seleviews addSubview:button];
    
    //删除按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(kScreen_Width - 120, 5, 100, 40);
    button1.tag = 11247111;
    button1.layer.cornerRadius  = 8;
    [button1 setTitle:@"删除" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(Seleviewsbutton:) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:149.0/255.0 blue:225.0/255.0 alpha:1];
    [_Seleviews addSubview:button1];

    //笼罩视图
    _envelopviews = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width - 120, 5, 100, 40)];
    _envelopviews.backgroundColor  =[UIColor whiteColor];
    _envelopviews.alpha = 0.5;
    [_Seleviews addSubview:_envelopviews];
}

/**
 *  全选和取消全选按钮点击方法
 */
- (void)Seleviewsbutton:(UIButton *)button{
    
    if (button.tag == 11247110) {
        button.selected = !button.selected;
        if (button.selected == YES) {/*全选*/
            
            //添加到删除按钮
            for (int i = 0; i < self.taskArr.count + self.loadArr.count; i ++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [_myTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                [self.deleteArr addObject:@(i)];
            }
            //设置删除数量
            [self setDeletenums];
            _isCompleteSelete = YES;
            //移除笼罩视图
            [_envelopviews removeFromSuperview];

        }else{/*取消全选*/
            
            //移除标示图删除按钮
            for (int i = 0; i < self.taskArr.count + self.loadArr.count; i ++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            //移除删除按钮数组
            [self.deleteArr removeAllObjects];
            _isCompleteSelete = NO;
            //初始化
            [self selectinitialview];
            //添加笼罩视图
            [_Seleviews addSubview:_envelopviews];

        }
    }else if(button.tag == 11247111){//删除
        
        for (int i = 0 ; i < _deleteArr.count; i ++) {
            
            //取到url
            NSInteger nums = [_deleteArr[i] integerValue];//(选择的下标)
            NSString *videourl = @"";
            if (nums < self.taskArr.count) {
                
                Download *task = self.taskArr[nums];
                videourl = task.urlString;
                
                //发送删除下载任务的完成通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadfinshed" object:self];
            }else{
                
                NSDictionary *dic = self.loadArr[nums - self.taskArr.count];
                videourl = dic[@"httpAdd"];
            }
            
            [[DownloadCenter sharedDownloadCenter] deleteTaskWithUrl:videourl complete:^{
                _alreaydeletenums++;
                
                if (_alreaydeletenums == _deleteArr.count) {//全部的删除任务完成
                    //刷新数据
                    [self deleteAction];
                    
                    //调用取消按钮的方法
                    [self Cancel];
                    
                    NSLog(@"😁删除完成了");
                    
                }
            }];
        }
        
        
    }else{
        
    }
    
}


/**
 *  编辑和取消编辑按钮
 */
- (void)rubbishbutton:(UIButton *)button{
    //判断是否有可以编辑的
    if (self.taskArr.count + self.loadArr.count == 0) {
        [MBProgressHUD showError:@"请先添加下载任务或者视频数据" toView:self.view];
        return;
    }
    button.selected = !button.selected;
    if (button.selected == YES) {/*编辑的点击方法*/
        
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 30);

        //展示删除按钮
        if (_isCompleteSelete == NO&&_deleteArr.count == 0) {//笼罩
            [_envelopviews removeFromSuperview];
            [_Seleviews addSubview:_envelopviews];
        }
        [UIView animateWithDuration:0.5 animations:^{
           
            _Seleviews.frame = CGRectMake(0,kScreen_Height - 50, kScreen_Width, 50);
            
        }];

        _myTableView.allowsMultipleSelectionDuringEditing = YES;
        _myTableView.editing = !_myTableView.editing;

    }else{/*取消的点击方法*/
        
        [self Cancel];
    }
    

}

#pragma mark - 取消按钮的方法
- (void)Cancel{
    
    //导航栏的按钮
    UIButton *button = [self.navigationController.navigationBar viewWithTag:11239440];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"垃圾@2x.png"] forState:UIControlStateNormal];
    [button setTitle:@"" forState:UIControlStateNormal];
    
    //选择视图的初始化（按钮的状态的改变和选择数组的初始化）
    [_deleteArr removeAllObjects];
    //初始化_Seleviews
    [self selectinitialview];
    _isCompleteSelete = NO;//不是全选了
    //隐藏删除按钮
    [UIView animateWithDuration:0.5 animations:^{
        
        _Seleviews.frame = CGRectMake(0,kScreen_Height, kScreen_Width, 50);
        
    }];

    _myTableView.allowsMultipleSelectionDuringEditing = YES;
    _myTableView.editing = NO;
}


#pragma mark - 选择视图初始化（按钮状态的改变）
- (void)selectinitialview{
    
    UIButton *button = [_Seleviews viewWithTag:11247110];
    button.selected = NO;
    UIButton *button1 = [_Seleviews viewWithTag:11247111];
    [button1 setTitle:@"删除" forState:UIControlStateNormal];
    
}
#pragma mark - 删除按钮的状态（1，2，3...）
- (void)setDeletenums{
    if (_deleteArr > 0) {
        UIButton *button1 = [_Seleviews viewWithTag:11247111];
        [button1 setTitle:[NSString stringWithFormat:@"删除(%ld)",_deleteArr.count] forState:UIControlStateNormal];

    }
}

#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskArr.count + self.loadArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.taskArr.count > indexPath.row) {
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadCell" forIndexPath:indexPath];
        Download *task = self.taskArr[indexPath.row];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:DownloadPath.downloadedPlistPath];
        NSDictionary *taskDic = plist[task.urlString];
        task.loadingBlock = ^(long long current, float progress, float all, float writ, NSString *speed){
            cell.downloadProgressView.progress = progress;
            cell.downloadAlreadyDownloadLabel.text = [NSString stringWithFormat:@"%.1fMB", writ];
            cell.downloadTotalByteLabel.text = [NSString stringWithFormat:@"%.1fMB", all];
            cell.downloadSpeedLabel.text = speed;
        };
        cell.downloadNameLabel.text = [taskDic objectForKey:@"showName"];
        if (taskDic[@"already"]) {
            cell.downloadAlreadyDownloadLabel.text = [NSString stringWithFormat:@"%@MB", taskDic[@"already"]];
            cell.downloadTotalByteLabel.text = [NSString stringWithFormat:@"%@MB", taskDic[@"totalBytes"]];
            cell.downloadProgressView.progress = [taskDic[@"already"] floatValue]/[taskDic[@"totalBytes"] floatValue];
            cell.downloadSpeedLabel.text = @"0 KB/s";
        }else{
            
            cell.downloadAlreadyDownloadLabel.text = @"0MB";
            cell.downloadTotalByteLabel.text = @"∞MB";
            cell.downloadProgressView.progress = 0;
        }
        if ([taskDic[@"state"] isEqualToString:@"waiting"]) {
            [cell.downloadButton setTitle:@"暂停" forState:UIControlStateNormal];
        }else{
            [cell.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        }
        
        [cell.downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }else{
        
        VideoplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoplayCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *task = self.loadArr[indexPath.row - self.taskArr.count];
        [cell setTask:task];
        return cell;
    }
}

//选择你要对表进行处理的方式  默认是删除方式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (void)downloadAction:(UIButton *)sender{
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:DownloadPath.downloadedPlistPath];
    MyTableViewCell *cell = (MyTableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    Download *task = self.taskArr[indexPath.row];
    NSMutableDictionary *tempDic = [plist objectForKey:task.urlString];
    if ([[tempDic objectForKey:@"state"] isEqualToString:@"loading"]) {
        [tempDic setObject:@"waiting" forKey:@"state"];
        [plist setObject:tempDic forKey:task.urlString];
        [plist writeToFile:DownloadPath.downloadedPlistPath atomically:YES];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        cell.downloadSpeedLabel.text = @"0 KB/s";
        [DDownloadCenter suspendTask:task];
        [task cancel];
    }else{
        [tempDic setObject:@"loading" forKey:@"state"];
        [plist setObject:tempDic forKey:task.urlString];
        [plist writeToFile:DownloadPath.downloadedPlistPath atomically:YES];
        [sender setTitle:@"下载" forState:UIControlStateNormal];
        task.date = [NSDate date];
        [task start];
    }
    
}

//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (_myTableView.editing == YES) {//编辑状态
        [self.deleteArr removeObject:@(indexPath.row)];//（删除指定的量)
        
        if (self.deleteArr.count == 0) {//取消全选的效果
            //移除笼罩视图
            _isCompleteSelete = NO;
            //添加笼罩视图
            [_Seleviews addSubview:_envelopviews];
            [self selectinitialview];

        }else{
            
            //设置数量
            [self setDeletenums];
        }

    }
}

//选择的时候
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_myTableView.editing == YES) {//编辑状态
        //添加到删除数组
        [_deleteArr addObject:@(indexPath.row)];
        //移除笼罩视图
        [_envelopviews removeFromSuperview];
        [self setDeletenums];

        if (_deleteArr.count == self.taskArr.count + self.loadArr.count){
          
            //全选的效果
            UIButton *button = [_Seleviews viewWithTag:11247110];
            button.selected = YES;
            _isCompleteSelete = YES;

        }

        return;
    }
    if (indexPath.row >=  self.taskArr.count) {
//       
//        PlayController *vc = [[PlayController alloc] init];
//        NSDictionary *task = self.loadArr[indexPath.row - self.taskArr.count];
//        vc.videourl = task[@"saveName"];
//        [self.navigationController pushViewController:vc animated:YES];
        
        NSDictionary *task = self.loadArr[indexPath.row - self.taskArr.count];
        NSString *playurl = [NSString stringWithFormat:@"file:///%@/%@",DownloadPath.alreadyDownloadPath,task[@"saveName"]];
        NSURL *videoURL = [NSURL URLWithString:playurl];
        ZXVideo *video = [[ZXVideo alloc] init];
        video.playUrl = videoURL.absoluteString;
        video.title = task[@"saveName"];
        
        VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
        vc.video = video;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 接受通知的方法
- (void)finshedTask:(NSNotification *)notification{
    
    [self deleteAction];
}

#pragma mark - 删除完成的方法
- (void)deleteAction{
    //已经下载的
    NSMutableArray *loadArray =  [DDownloadCenter finishedTasks];
    self.taskArr = DDownloadCenter.taskArr;
    self.loadArr = loadArray.mutableCopy;
    [self.myTableView reloadData];

}

//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"downloadfinshed" object:nil];
}

@end
