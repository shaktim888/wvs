#import "UIWKWVSWebController.h"
#import <WebKit/WebKit.h>
#import "WVSRecord.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//// WKWebView 内存不释放的问题解决
//@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>
//
////WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
//@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
//
//- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
//
//@end
//@implementation WeakWebViewScriptMessageDelegate
//
//- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
//    self = [super init];
//    if (self) {
//        _scriptDelegate = scriptDelegate;
//    }
//    return self;
//}
//
//#pragma mark - WKScriptMessageHandler
////遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
////通过接收JS传出消息的name进行捕捉的回调方法
//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//
//    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
//        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
//    }
//}
//
//@end

@interface UIWKWVSWebController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;

@end

@implementation UIWKWVSWebController

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return nil;
}

#pragma mark - 初始化wkWebView


- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
        _wkConfig.mediaPlaybackRequiresUserAction = NO;
        _wkConfig.preferences.minimumFontSize = 9.0;
        _wkConfig.selectionGranularity = YES;
        [_wkConfig.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        [_wkConfig setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
//        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];

        // 禁止放大缩小
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
        
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [wkUController addUserScript:wkUScript];
        
        _wkConfig.userContentController = wkUController;
    }
    return _wkConfig;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        // 防止内存飙升
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
        //自己添加的，原文没有提到。
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
        //自己添加的，原文没有提到。
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 * 1024
//                                                                diskCapacity:0
//                                                                    diskPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"URLCache"]];
//        [NSURLCache setSharedURLCache:sharedCache];
        
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:self.wkConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.delegate = self;
        _wkWebView.scrollView.bounces = false;
        _wkWebView.scrollView.scrollEnabled = false;
        _wkWebView.scrollView.panGestureRecognizer.enabled = false;
        _wkWebView.UIDelegate = self;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.3;
        [_wkWebView addGestureRecognizer:longPress];
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

#pragma mark - GestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self closeLauchView];
    [self.wkWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [self.wkWebView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
}

- (void)loadURL :(NSString*) url {
    NSURL *nurl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nurl];
    [self.wkWebView loadRequest:request];
}

- (void)loadFileURL :(NSString*) url base:(NSString*) base {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSURL *fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", base, url]];
        NSURL *folderURL = [NSURL fileURLWithPath:base];
        [self.wkWebView loadFileURL:fileURL allowingReadAccessToURL:folderURL];
    } else {
        NSURL *fileUrl = [NSURL fileURLWithPath:base];
        fileUrl = [self fileURLForBuggyWKWebView8:fileUrl];
        NSURL *realUrl = [NSURL fileURLWithPath:[fileUrl.path stringByAppendingString:[NSString stringWithFormat:@"/%@", url]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:realUrl];
        [self.wkWebView loadRequest:request];
    }
}

- (void)dealloc {


}

+ (UIEdgeInsets)safeAreaInset:(UIView *)view {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets edgeInsets = [self.class safeAreaInset:self.view];
    [self doResize:edgeInsets];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏：YES,  显示：NO,  Animation:动画效果
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)doResize: (UIEdgeInsets) edgeInsets
{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    CGRect newFrame;
    if([WVSRecord sharedInstance].full) {
        newFrame = CGRectMake(0, 0, width, height);
    }else{
        newFrame = CGRectMake(edgeInsets.left, edgeInsets.top, width - edgeInsets.right - edgeInsets.left, height - edgeInsets.bottom - edgeInsets.top);
    }
    if (!CGRectEqualToRect(self.wkWebView.frame, newFrame)) {
        self.wkWebView.frame = newFrame;
    }
}

//将文件copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    
    // Create "/temp" directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *temDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    
    // Files in "/temp" load flawlesly :)
    return dstURL;
}


- (void)viewDidLoad {
    [self showLaunchView];
    [super viewDidLoad];
#ifdef LOCAL_SERVER
    [self loadURL:[WVSRecord sharedInstance].ui];
#else
    [self loadFileURL:[WVSRecord sharedInstance].ui  base:[WVSRecord sharedInstance].base];
#endif
    
}


@end
