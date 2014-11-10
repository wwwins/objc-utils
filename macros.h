// Some useful preprocessor macros in objc
// Device info
#define IS_IPAD                                    ([[[UIDevice currentDevice] model] rangeOfString:@"iphone"].location == NSNotFound)
#define IS_IPHONE                                  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5                                (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)


// System version
// if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.1") {
//  ios >= 6.1.3
// }
#define SYSTEM_VERSION_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// APP version
#define APP_VERSION                                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_BUILD_DATE                             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]


// Color
// UIColorFromRGB(0x7C7C7C);
// UIColorFromRGBA(0x7C7C7CFF);
#define UIColorFromRGB(rgbValue)                   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue)                  [UIColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbValue & 0xFF00) >> 8 ))/255.0 alpha:((float)((rgbValue & 0xFF))/255.0)]

// Random color by RGB or HSB
#define UIColorFromRandomRGB                       [UIColor colorWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:1.0]
#define UIColorFromRandomHSB                       [UIColor colorWithHue:arc4random()%256/256.0 saturation:(arc4random()%128/256.0)+0.5 brightness:(arc4random()%128/256.0)+0.5 alpha:1.0]


// Notifications
#define addEventListener(id,s,n,o)                 [[NSNotificationCenter defaultCenter] addObserver:id selector:s name:n object:o]
#define removeEventListener(id,n,o)                [[NSNotificationCenter defaultCenter] removeObserver:id name:n object:o]
#define removeAllEventListener(id)                 [[NSNotificationCenter defaultCenter] removeObserver:id]
#define dispatchEvent(n,o)                         [[NSNotificationCenter defaultCenter] postNotificationName:n object:o]
#define dispatchEventWithData(n,o,d)               [[NSNotificationCenter defaultCenter] postNotificationName:n object:o userInfo:d]


// Utils
// append(@"hello ", @"world");
#define APPEND(a,b)                                [a stringByAppendingString:b]

// open url in safari
#define OPEN_URL(v)                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:v]];

// set UIView position and size
#define CGRECT_MAKE_XY(o,x,y)                      CGRectMake(x, y, o.size.width, o.size.height)
#define CGRECT_MAKE_WH(o,w,h)                      CGRectMake(o.origin.x, o.origin.y, w, h)
#define VIEW_X_Y(view,x,y)                         view.frame = CGRECT_MAKE_XY(view.frame, x, y)
#define VIEW_W_H(view,w,h)                         view.frame = CGRECT_MAKE_WH(view.frame, w, h)

// Log
// trace("foo");
#if DEBUG == 1
#define trace(c,...)                               NSLog((@"[Line %s:%d] " c), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define trace(...)
#endif

// Google analytics v2
#if GA_2
#define myTracker_sendView(v)                      id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];\
                                                                             [tracker sendView:v];

#define myTracker_sendEvent(c,a)                   id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];\
                                                                             [tracker sendEventWithCategory:c \
                                                                                      withAction:a \
                                                                                      withLabel:nil \
                                                                                      withValue:nil];
#endif

// Google analytics v3
#if GA_3
#define myTracker_sendView(v)                      id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];\
                                                                             [tracker set:kGAIScreenName value:(v)];\
                                                                             [tracker send:[[GAIDictionaryBuilder createAppView]  build]];

#define myTracker_sendEvent(c,a)                   id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];\
                                                                             [tracker send:[[GAIDictionaryBuilder createEventWithCategory:(c)\
                                                                                      action:(a) \
                                                                                      label:nil \
                                                                                      value:nil] build]];
#endif
