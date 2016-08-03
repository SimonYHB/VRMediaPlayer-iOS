#import <UIKit/UIKit.h>

@protocol GVRWidgetViewDelegate;

/** The enum of various widget display modes. */
typedef NS_ENUM(NSInteger, GVRWidgetDisplayMode) {
  // Widget is displayed embedded in other views.
  kGVRWidgetDisplayModeEmbedded = 1,
  // Widget is displayed in fullscreen mono mode.
  kGVRWidgetDisplayModeFullscreen,
  // Widget is displayed in fullscreen VR (stereo) mode.
  kGVRWidgetDisplayModeFullscreenVR,
};

/** Defines a base class for all widget views, that encapsulates common functionality. */
@interface GVRWidgetView : UIView

/** The delegate that is called when the widget view is loaded. */
@property(nonatomic, weak) id<GVRWidgetViewDelegate> delegate;

/** Displays a button that allows the user to transition to fullscreen mode. */
@property(nonatomic) BOOL enableFullscreenButton;

/** Displays a button that allows the user to transition to fullscreen VR mode. */
@property(nonatomic) BOOL enableCardboardButton;

@end

/** Defines a delegate for GVRWidgetView and its subclasses. */
@protocol GVRWidgetViewDelegate<NSObject>

@optional

/**
 * Called when the user taps the widget view. This corresponds to the Cardboard viewer's trigger
 * event.
 */
- (void)widgetViewDidTap:(GVRWidgetView *)widgetView;

/** Called when the widget view's display mode changes. See |GVRWidgetDisplayMode|. */
- (void)widgetView:(GVRWidgetView *)widgetView
    didChangeDisplayMode:(GVRWidgetDisplayMode)displayMode;

/** Called when the content is successfully loaded. */
- (void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content;

/** Called when there is an error loading content in the widget view. */
- (void)widgetView:(GVRWidgetView *)widgetView
    didFailToLoadContent:(id)content
        withErrorMessage:(NSString *)errorMessage;

@end
