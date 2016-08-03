//
//  VideoPlayView.h
//  YG_MediaView
//
//  Created by apple on 16/6/06.
//  Copyright (c) 2016年 yg_Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoPlayViewDelegate <NSObject>

@optional
- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

@end

@interface VideoPlayView : UIView

+ (instancetype)videoPlayView;

@property (weak, nonatomic) id<VideoPlayViewDelegate> delegate;

//@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, copy) NSString *path;

@end
