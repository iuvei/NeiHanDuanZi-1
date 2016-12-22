//
//  VideoPlayView.m
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "VideoPlayView.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayView ()

@property (nonatomic,strong)AVPlayer *player;//播放器
@property (nonatomic,strong)AVPlayerItem *playerItem;//播放器属性对象
@property (nonatomic,strong)AVPlayerLayer *playerLayer;//播放器需要的layer
@property (nonatomic,assign)BOOL isDragSlider;//是否拖动Slider
//底部BottomView
@property (nonatomic,strong)UIButton *fullScreenButton;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIProgressView *progressView;
@property (nonatomic,strong)UISlider *slider;
@property (nonatomic,strong)UILabel *nowLabel;
@property (nonatomic,strong)UILabel *remainLabel;
//是否全屏
@property (nonatomic,assign)BOOL isFullScreen;
//定时器 自动消失view
@property (nonatomic,strong)NSTimer *autoDismissTimer;
//是否是第一次播放
@property (nonatomic, assign) BOOL isFirstPlay;

@property (nonatomic,strong)UIImageView *imgView;

@end

@implementation VideoPlayView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isFullScreen = NO;
    _isFirstPlay = YES;
}

#pragma mark --播放视频、放大窗口--
- (IBAction)playAction:(UIButton *)sender {

    if (_isFirstPlay) {
        
//        _imgView = [[UIImageView alloc] initWithFrame:self.bgImage.frame];
//        _imgView.backgroundColor = [UIColor redColor];
//        [self.bgImage insertSubview:_imgView atIndex:0];
//        [self addSubview:_imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        self.bgImage.userInteractionEnabled = YES;
        [self.bgImage addGestureRecognizer:tap];
        [self initUI];
        //初始化播放器item
        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.urlString]];
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        //初始化播放器的layer
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        //设置layer的frame
        self.playerLayer.frame = self.bgImage.bounds;
        //设置layer的填充属性 和UIImageView的填充属性类似
        self.playerLayer.videoGravity = AVLayerVideoGravityResize;
        //把layer加到view上
        [self.bgImage.layer insertSublayer:self.playerLayer atIndex:0];

        //监听播放器状态变化
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        //监听缓存大小
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        //旋转屏幕通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        [self.shadowView setHidden:YES];
        
        [sender setImage:[UIImage imageNamed:@"play_press"] forState:UIControlStateNormal];
        [self.player play];
        _isFirstPlay = NO;
    }
    else {
        //0.0默认为暂停或则停止状态
        if (self.player.rate != 1.0f) {
            
            [sender setImage:[UIImage imageNamed:@"play_press"] forState:UIControlStateNormal];
            
            [self.player play];
        }
        else {
            
            [sender setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            
            [self.player pause];
        }
    }
}
//屏幕旋转
- (void)onDeviceOrientationChange {
    
    UIDeviceOrientation orientation =[UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            
            [self toCell];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在右");
            
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在左");
            
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        default:
            break;
    }
}

- (void)initUI {
    
    //底部栏
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.bgImage addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.bgImage).with.offset(0);
        make.right.equalTo(self.bgImage).with.offset(0);
        make.bottom.equalTo(self.bgImage).with.offset(0);
        make.height.mas_equalTo(35);
    }];
    
    //底部全屏按钮
    self.fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"video_minimization"] forState:UIControlStateNormal];
    [self.fullScreenButton addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.fullScreenButton];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.bottomView).with.offset(-5);
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //底部进度条
    self.slider = [[UISlider alloc] init];
    self.slider.minimumValue = 0.0;
    self.slider.minimumTrackTintColor = RLCommonBgColor;
    self.slider.maximumTrackTintColor = [UIColor clearColor];
    self.slider.value = 0.0;
    [self.slider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderDragValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderTapValueChange:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapSlider = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSlider:)];
    [self.slider addGestureRecognizer:tapSlider];
    [self.bottomView addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.bottomView).with.offset(45);
        make.right.equalTo(self.bottomView).with.offset(-80);
        make.centerY.equalTo(self.bottomView);
    }];
    
    //底部缓存进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.trackTintColor = [UIColor lightGrayColor];
    [self.bottomView addSubview:self.progressView];
    [self.progressView setProgress:0.0 animated:NO];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.slider).with.offset(0);
        make.right.equalTo(self.slider);
        make.height.mas_equalTo(2);
        make.centerY.equalTo(self.slider).with.offset(1);
        
    }];
    [self.bottomView sendSubviewToBack:self.progressView];
    
    //底部左侧时间轴
    self.nowLabel = [UILabel new];
    self.nowLabel.textColor = [UIColor whiteColor];
    self.nowLabel.font = [UIFont systemFontOfSize:13];
    self.nowLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:self.nowLabel];
    [self.nowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bottomView.mas_left).with.offset(5);
        make.right.equalTo(self.slider.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.centerY.equalTo(self.bottomView);
    }];
    
    //底部右侧时间轴
    self.remainLabel = [UILabel new];
    self.remainLabel.textColor = [UIColor whiteColor];
    self.remainLabel.font = [UIFont systemFontOfSize:13];
    self.remainLabel.textAlignment = NSTextAlignmentRight;
    [self.bottomView addSubview:self.remainLabel];
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.slider.mas_right).with.offset(0);
        make.right.equalTo(self.bottomView.mas_right).with.offset(-35);
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.centerY.equalTo(self.bottomView);
    }];
    
}

- (IBAction)expandAction:(UIButton *)sender {
    NSLog(@"expand");
}

#pragma mark --slider 的更改--
//拖拽的时候调用 这个时候不更新视频进度
- (void)sliderDragValueChange:(UISlider *)slider {
    
    self.isDragSlider = YES;
    
}
//点击调用 或者拖拽完毕的时候调用
- (void)sliderTapValueChange:(UISlider *)slider {
    
    self.isDragSlider = NO;
    // CMTimeMake(帧数（slider.value * timeScale）, 帧/sec)
    // 直接用秒来获取CMTime
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, self.playerItem.currentTime.timescale)];
}

//点击事件的slider
- (void)touchSlider:(UITapGestureRecognizer *)tap {
    
    //根据点击的坐标计算对应的比例
    CGPoint touch = [tap locationInView:self.slider];
    CGFloat scale = touch.x/self.slider.bounds.size.width;
    self.slider.value = CMTimeGetSeconds(self.playerItem.duration) * scale;
    [self.player seekToTime:CMTimeMakeWithSeconds(self.slider.value, self.playerItem.currentTime.timescale)];
    /* indicates the current rate of playback; 0.0 means "stopped", 1.0 means "play at the natural rate of the current item" */
    if (self.player.rate != 1) {
        
        [self.playBtn setImage:[UIImage imageNamed:@"play_press"] forState:UIControlStateNormal];
        
        [self.player play];
    }
}

#pragma mark --单击手势--
- (void)singleTap:(UITapGestureRecognizer *)tap {
    
    self.playBtn.alpha = 1.0;
    //和即时搜索一样，删除之前未执行的操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoDismissView:) object:nil];
    
    //这里点击会隐藏对应的view，那么之前的定时还开着，如果不关掉，就可能重复
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
    
    self.autoDismissTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(autoDismissView:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
    
    [UIView animateWithDuration:1.0 animations:^{
       
        
        
        if (self.bottomView.alpha == 1) {
//            self.playBtn.alpha = 0;
            self.bottomView.alpha = 0;
        }
        else if (self.bottomView.alpha == 0) {
            self.bottomView.alpha = 1.0f;
            
        }
    }];
}

//监听播放器的变化属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerItemStatus statues = [change[NSKeyValueChangeNewKey] integerValue];
        switch (statues) {
            case AVPlayerItemStatusReadyToPlay:
                
                //最大值直接用sec，以前都是
                //CMTimeMake(帧数(slider.value*timeScale),帧/sec)
                self.slider.maximumValue = CMTimeGetSeconds(self.playerItem.duration);
                [self initTimer];
                
                
                //启动定时器 5秒自动隐藏
                if (!self.autoDismissTimer) {
                    
                    self.autoDismissTimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(autoDismissView:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
                }
                break;
            case AVPlayerItemStatusFailed:
                
                break;
                
            default:
                break;
        }
    }
    //监听缓存进度的属性
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        //计算缓存进度
        NSTimeInterval timeInterVal = [self availableDuration];
        //获取总长度
        CMTime duration = self.playerItem.duration;
        
        CGFloat durationTime = CMTimeGetSeconds(duration);
        //监听到了给进度条赋值
        [self.progressView setProgress:timeInterVal/durationTime animated:NO];
        
    }
}

#pragma mark --自动隐藏bottom--
- (void)autoDismissView:(NSTimer *)timer {
    
    if (self.player.rate == 0) {
        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.playBtn.alpha = 0;
//        }];
        //暂停状态就不隐藏
    }
    else if (self.player.rate == 1) {
        
        [UIView animateWithDuration:3 animations:^{
            
            self.playBtn.alpha = 0;
        }];
        
        if (self.bottomView.alpha == 1) {
            
            [UIView animateWithDuration:3 animations:^{
        
                self.bottomView.alpha = 0;
                
                
            }];
        }
    }
}
//全屏显示
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation {
    

    //        移除先前的
    
    //        self.bgImage.transform = CGAffineTransformIdentity;
    //        self.bgImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.bgImage removeFromSuperview];
    
    self.bgImage.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
    
   
    
    //初始化
    self.bgImage.transform = CGAffineTransformIdentity;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        self.bgImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        self.bgImage.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    //改变self的frame
    self.bgImage.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
     //layer的方向宽和高对调
    self.playerLayer.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
    
    //remark 约束
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(ScreenWidth-50);
        make.left.equalTo(self.bgImage).with.offset(0);
        make.width.mas_equalTo(ScreenHeight);
        
    }];
    
    [self.nowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider.mas_left).with.offset(0);
        make.top.equalTo(self.slider.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [self.remainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider.mas_right).with.offset(0);
        make.top.equalTo(self.slider.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    //加到window上面
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgImage];
}

//缩小到cell
- (void)toCell {
    //先移除
    [self.bgImage removeFromSuperview];
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5f animations:^{
        
        weakSelf.bgImage.transform = CGAffineTransformIdentity;
        weakSelf.bgImage.frame = self.bounds;
        weakSelf.playerLayer.frame = self.bounds;
        //再添加到view上
        [weakSelf addSubview:weakSelf.bgImage];
        
        // remark约束
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(0);
            make.right.equalTo(weakSelf).with.offset(0);
            make.height.mas_equalTo(50);
            make.bottom.equalTo(weakSelf).with.offset(0);
        }];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark --点击全屏--
- (void)clickFullScreen:(UIButton *)button {
    
    if (!self.isFullScreen) {

        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        
        [self.fullScreenButton setImage:[UIImage imageNamed:@"video_fullscreen"] forState:UIControlStateNormal];
    }
    else {
        
        [self toCell];
        [self.fullScreenButton setImage:[UIImage imageNamed:@"video_minimization"] forState:UIControlStateNormal];
    }
    self.isFullScreen = !self.isFullScreen;
}

//计算缓冲进度
- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];//获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);//开始的点
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);//已缓存的时间点
    NSTimeInterval result = startSeconds + durationSeconds;//计算缓冲总进度
    
    return result;
}

//调用player的对象进行UI更新
- (void)initTimer {
    
    //player的定时器
    __weak typeof(self)weakSelf = self;
    //每秒更新一次UI Slider
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //当前时间
        CGFloat nowTime = CMTimeGetSeconds(weakSelf.playerItem.currentTime);
        //总时间
        CGFloat duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        //sec 转换成时间点
        weakSelf.nowLabel.text = [weakSelf convertToTime:nowTime];
        weakSelf.remainLabel.text = [weakSelf convertToTime:duration];
        
        //不是拖拽中的话更新UI
        if (!weakSelf.isDragSlider) {
            
            weakSelf.slider.value = CMTimeGetSeconds(weakSelf.playerItem.currentTime);
        }
    }];
}

//sec转换成指定的格式
- (NSString *)convertToTime:(CGFloat)time {
    //初始化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //根据是否大于1H，进行格式赋值
    if (time >= 3600) {
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    else {
        [formatter setDateFormat:@"mm:ss"];
    }
    //秒数转换成NSDate类型
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    //date转字符串
    return [formatter stringFromDate:date];
}


@end
