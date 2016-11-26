//
//  LoadingType.m
//  ZBAVPlayer
//
//  Created by 周波 on 16/11/25.
//  Copyright © 2016年 周波. All rights reserved.
//

#import "LoadingType.h"

@interface LoadingType()

@end

@implementation LoadingType

- (UIButton *)Errorcontroll{
    if (!_Errorcontroll) {
        _Errorcontroll = [UIButton buttonWithType:UIButtonTypeCustom];
        _Errorcontroll.frame = CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height - 100);
        _Errorcontroll.tag = 11251100;
        [_Errorcontroll setTitle:@"加载失败，请重新加载" forState:UIControlStateNormal];
        [_Errorcontroll setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_Errorcontroll addTarget:self action:@selector(loadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Errorcontroll;
}
- (UIButton *)Delebutton{
    if (!_Delebutton) {
        _Delebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _Delebutton.frame = CGRectMake(10, 5, 30, 30) ;
        _Delebutton.tag = 11251101;
        [_Delebutton setImage:[UIImage imageNamed:@"删除@2x"] forState:UIControlStateNormal];
        [_Delebutton addTarget:self action:@selector(loadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Delebutton;
}
- (UIButton *)Nextbutton{
    if (!_Nextbutton) {
        _Nextbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _Nextbutton.frame = CGRectMake(100 , 70, self.bounds.size.width - 200, 40) ;
        _Nextbutton.tag = 11251200;
        _Nextbutton.backgroundColor = [UIColor orangeColor];
        _Nextbutton.layer.cornerRadius = 8;
        [_Nextbutton setTitle:@"学习下一个" forState:UIControlStateNormal];
        [_Nextbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_Nextbutton addTarget:self action:@selector(loadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Nextbutton;
}

- (UIButton *)repeatbutton{
    if (!_repeatbutton) {
        _repeatbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _repeatbutton.frame = CGRectMake(100 , 120,  self.bounds.size.width - 200, 40) ;
        _repeatbutton.tag = 11251201;
        _repeatbutton.backgroundColor = [UIColor clearColor];
        _repeatbutton.layer.borderColor = [UIColor orangeColor].CGColor;
        _repeatbutton.layer.borderWidth = 1;
        _repeatbutton.layer.cornerRadius = 8;
        [_repeatbutton setTitle:@"重播" forState:UIControlStateNormal];
        [_repeatbutton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_repeatbutton addTarget:self action:@selector(loadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatbutton;
}


- (UILabel *)titlelabel{
    
    if (!_titlelabel) {
        
        _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 40)];
        _titlelabel.textColor = [UIColor lightGrayColor];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        _titlelabel.font = [UIFont systemFontOfSize:15];
        _titlelabel.text = @"当前视频播放结束";
    }
    return _titlelabel;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        //创建视图
        [self setUI];
        
    }
    return self;
}

- (void)setUI{
    
    [self addSubview:self.Delebutton];
    [self addSubview:self.titlelabel];
    [self addSubview:self.Nextbutton];
    [self addSubview:self.repeatbutton];
    [self addSubview:self.Errorcontroll];

}
- (void)setloutviews{
    
    _Errorcontroll.frame = CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height - 100);
    _Nextbutton.frame = CGRectMake(100 , 70, self.bounds.size.width - 200, 40) ;
    _repeatbutton.frame = CGRectMake(100 , 120,  self.bounds.size.width - 200, 40) ;
    _titlelabel.frame = CGRectMake(0, 20, self.bounds.size.width, 40);


}

- (void)setLoadActionBlock:(ButtonActionBlock)block{
    self.loadBlock = block;
}



- (void)loadButtonAction:(UIButton *)button{
    self.loadBlock(_isSuccess,button.tag);
}
@end
