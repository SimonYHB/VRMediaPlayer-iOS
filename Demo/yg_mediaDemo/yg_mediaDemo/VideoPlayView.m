//
//  VideoPlayView.m
//  YG_MediaView
//
//  Created by apple on 16/6/06.
//  Copyright (c) 2016年 yg_Code. All rights reserved.
//

#import "VideoPlayView.h"
#import <GVRVideoView.h>
#import <objc/runtime.h>

@interface VideoPlayView()<GVRVideoViewDelegate,GVRWidgetViewDelegate>

//播放视图
@property (weak, nonatomic) IBOutlet GVRVideoView *videoPlayerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cardboardButton;

// 记录当前是否显示了工具栏
@property (assign, nonatomic, getter=isShowToolView) BOOL showToolView;
// 记录是否播放完成
@property (assign, nonatomic, getter=isFinish) BOOL finish;


#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)slider;
- (IBAction)startSlider;
- (IBAction)sliderValueChange;

@end

@implementation VideoPlayView




// 快速创建View的方法
+ (instancetype)videoPlayView
{
        return [[[NSBundle mainBundle] loadNibNamed:@"VideoPlayView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    
    [self configVideoPlayerView];
    self.toolView.alpha = 0;
    self.showToolView = NO;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    UIButton *button = self.videoPlayerView.subviews[2];
    [self.cardboardButton setImage:[button imageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.cardboardButton sizeToFit];
    
}


-(void)configVideoPlayerView{
    _videoPlayerView.delegate = self;
    //不使用原带的全屏
    //    _videoPlayerView.enableFullscreenButton = YES;
    _videoPlayerView.enableCardboardButton = YES;
    //隐藏原生按钮
    for (UIView *view in _videoPlayerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.alpha = 0;
        }
    }
    _videoPlayerView.backgroundColor = [UIColor whiteColor];
    [self.cardboardButton addTarget:self action:@selector(didTapCardboardButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

//点击carbBoard方法调用
-(void)didTapCardboardButton:(UIButton *)button{
    UIButton *cardboardButton = self.videoPlayerView.subviews[2];
    [cardboardButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 设置播放的视频
-(void)setPath:(NSString *)path{
    _path = path;
    //goole的视频要用kGVRVideoTypeStereoOverUnder类型播放,其他的用默认即可
    [_videoPlayerView loadFromUrl:[NSURL fileURLWithPath:path] ofType:kGVRVideoTypeStereoOverUnder];
}


// 暂停按钮的监听
- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.isFinish) {
            [self.videoPlayerView seekTo:0];
        }
        [self.videoPlayerView resume];
        
    } else {
        [self.videoPlayerView pause];
        
    }
}



// 切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(videoplayViewSwitchOrientation:)]) {
        [self.delegate videoplayViewSwitchOrientation:sender.selected];
    }
}
//结束滑动
- (IBAction)slider {
    [self.videoPlayerView resume];
}
//开始滑动
- (IBAction)startSlider {
    [self.videoPlayerView pause];
}
//滑动中
- (IBAction)sliderValueChange {
    NSTimeInterval currentTime = self.progressSlider.value;
    [self.videoPlayerView seekTo:currentTime];
    NSTimeInterval duration = self.videoPlayerView.duration;
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}

//将时间转换为特定格式字符串
- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

#pragma mark - 代理方法
//播放时调用
-(void)videoView:(GVRVideoView *)videoView didUpdatePosition:(NSTimeInterval)position{
    NSTimeInterval currentTimeInterval = position;
    // 1.更新时间
    self.timeLabel.text = [self stringWithCurrentTime:currentTimeInterval duration:self.videoPlayerView.duration];
    
    // 2.设置进度条的value
    self.progressSlider.value = currentTimeInterval ;
    if (position == self.videoPlayerView.duration) {
        self.finish = YES;
        self.playOrPauseBtn.selected = NO;
        
    }
}

//加载文件成功时调用
-(void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content{
    self.imageView.hidden = true;
    self.playOrPauseBtn.selected = YES;
    //    NSLog(@"%lf",self.videoPlayerView.duration);
    self.progressSlider.maximumValue = self.videoPlayerView.duration;
    self.progressSlider.minimumValue = 0.0;
}


-(void)widgetViewDidTap:(GVRWidgetView *)widgetView{
    //点击显示工具
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isShowToolView) {
            self.toolView.alpha = 0;
            self.showToolView = NO;
            self.cardboardButton.alpha = 0;
        } else {
            self.toolView.alpha = 1;
            self.showToolView = YES;
            self.cardboardButton.alpha = 1;
        }
    }];
}

////加载失败时调用
//-(void)widgetView:(GVRWidgetView *)widgetView didFailToLoadContent:(id)content withErrorMessage:(NSString *)errorMessage{
//    NSLog(@"加载内容失败");
//}

- (void)dealloc{
    _videoPlayerView.delegate = nil;
    //销毁时将资源释放
    [_videoPlayerView loadFromUrl:nil];
    NSLog(@"dealloc%@",NSStringFromClass(self.class));
}

@end
