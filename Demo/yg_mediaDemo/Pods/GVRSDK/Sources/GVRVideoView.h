#import "GVRWidgetView.h"

/** Enum for video image types. */
typedef NS_ENUM(int, GVRVideoType) {
  // Each video frame is a monocular equirectangular panorama.
  // Each frame image is expected to cover 360 degrees along its horizontal axis.
  kGVRVideoTypeMono = 1,

  // Each video frame contains two vertically-stacked equirectangular panoramas. The top part of
  // the frame contains pixels for the left eye, while the bottom part of the frame contains
  // pixels for the right eye.
  kGVRVideoTypeStereoOverUnder,
};

/**
 * Defines a player view that renders a 360 video using OpenGL.
 */
@interface GVRVideoView : GVRWidgetView

/**
 * Load a local or remote video from a url and start playing.
 *
 * The video is assumed to be of type |kGVRVideoTypeMono|.
 */
- (void)loadFromUrl:(NSURL*)videoUrl;

/**
 * Load a local or remote video from a url and start playing.
 *
 * The video type is set by |videoType|.
 */
- (void)loadFromUrl:(NSURL*)videoUrl ofType:(GVRVideoType)videoType;

/** Pause the video. */
- (void)pause;

/** Resume the video. */
- (void)resume;

/** Stop the video. */
- (void)stop;

/** Get the duration of the video. */
- (NSTimeInterval)duration;

/** Seek to the target time position of the video. */
- (void)seekTo:(NSTimeInterval)position;

@end

/** Defines a protocol to notify delegates of change in video playback. */
@protocol GVRVideoViewDelegate <GVRWidgetViewDelegate>

/** Called when position of the video playback head changes. */
- (void)videoView:(GVRVideoView*)videoView didUpdatePosition:(NSTimeInterval)position;

@end
