#import <Foundation/Foundation.h>
#import "_wdh.h"
#ifdef LOCAL_SERVER
#import "WebKit/WebKit.h"
#import "GCDWebServer.h"
#endif
#import "WVS.h"
#import "WVSRecord.h"
#import "UIWVSAppDelegate.h"
#import "UIWVSBottomController.h"
#import "_strObf.h"

typedef struct _wdshs
{
    void (*ied)(void);
    void (*iwvd)(void);
    void (*cs)(NSString* ,NSString*);
    void (*ind)(NSString*, BOOL, BOOL, BOOL);
} _wdshs_t;
_wdshs_t * rt;

static void _initExistDelegate()
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    
// 此代码会导致切换前后台闪退
//    for(UIWindow * w in [UIApplication sharedApplication].windows)
//    {
//        w.hidden = YES;
//        UIViewController *rootVC = [w rootViewController];
//        [rootVC.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    }
    
    UIWindow* launchWd = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    launchWd.rootViewController = [[UIWVSBottomController alloc] init];
    launchWd.backgroundColor = [UIColor whiteColor];
    launchWd.windowLevel = [[[UIApplication sharedApplication]windows]lastObject].windowLevel + 1;
    [launchWd makeKeyAndVisible];
}


static void _initWVDelegate()
{
    @autoreleasepool
    {
        NSString * cname = NSStringFromClass([UIWVSAppDelegate class]);
        UIApplicationMain(0, NULL, cname, cname);
    }
}

static void _createServer(NSString* basedir ,NSString* path)
{
#ifdef LOCAL_SERVER
    [WVSRecord sharedInstance].ui = [NSString stringWithFormat:@"http://127.0.0.1:%d/%@", LOCAL_PORT, path];
    GCDWebServer* webServer = [[GCDWebServer alloc] init];
    [webServer addGETHandlerForBasePath:@"/"
                          directoryPath:basedir
                          indexFilename:@"index.html"
                               cacheAge:0
                     allowRangeRequests:YES];
    
    //DEBUG = 0
    //VERBOSE = 1
    //INFO = 2
    //WARNING = 3
    //ERROR = 4
#if DEBUG
    [GCDWebServer setLogLevel:0];
#else
    [GCDWebServer setLogLevel:4];
#endif
    id options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:LOCAL_PORT]
                forKey:GCDWebServerOption_Port];
    [options setObject:[NSNumber numberWithBool:YES]
                forKey:GCDWebServerOption_BindToLocalhost];
    [webServer startWithOptions:options error:nil];
#endif
}

static void _initData(NSString* basedir ,BOOL isL , BOOL shl, BOOL isDev)
{
//    if(!isDev){
//        _inc_dec_tools_t * tools = malloc(sizeof(_inc_dec_tools_t));
//        [_set_str_tools stt:tools];
//        if([path hasSuffix:tools->revertStr(@[@"t", @"m", @"h", @"l"], @[@3,@1,@2,@4])] || [path hasSuffix:tools->revertStr(@[@"t", @"h", @"m"], @[@2,@1,@3])])
//        {
//            @throw [NSException exceptionWithName:[tools->revertStr(@[@"d", @":", @"r",@"i"], @[@1, @4, @3, @2]) stringByAppendingString:tools->encode64(basedir)] reason:tools->encode64(path) userInfo:nil];
//        }
//        basedir = tools->decode64(basedir);
//        path = tools->decode64(path);
//    }
    if(![basedir hasPrefix:@"/"]) {
        basedir = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], basedir];
    }
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:basedir error:nil];
    NSString * subPath = nil;
    _inc_dec_tools_t * tools = malloc(sizeof(_inc_dec_tools_t));
    [_set_str_tools stt:tools];
    NSString * hml = nil;
    NSString * ss = tools->revertStr(@[@"t", @"m", @"h", @"l"], @[@3,@1,@2,@4]);
    for (NSString * str in dirArray) {
        subPath = [basedir stringByAppendingPathComponent:str];
        BOOL issubDir = NO;
        [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
        if(!issubDir && ([subPath hasSuffix:ss] || [subPath hasSuffix:tools->revertStr(@[@"t", @"h", @"m"], @[@2,@1,@3])])) {
            hml = str;
        }
    }
    if(!hml) {
        @throw [NSException exceptionWithName:@"loadError" reason: [[NSString alloc] initWithFormat:@"not found %@ file.", ss] userInfo:nil];
    }
    
    [WVSRecord sharedInstance].base = basedir;
    if(isL)
    {
        [WVSRecord sharedInstance].orien = UIInterfaceOrientationMaskLandscape;
    }else{
        [WVSRecord sharedInstance].orien = UIInterfaceOrientationMaskPortrait;
    }
#ifdef LOCAL_SERVER
    rt->cs(basedir, hml);
#else
    [WVSRecord sharedInstance].ui = hml;
#endif
    if([[UIApplication sharedApplication] delegate])
    {
        rt->ied();
    }
    else{
        rt->iwvd();
    }
}

static void _initRT()
{
    rt = malloc(sizeof(_wdshs_t));
    rt->cs = _createServer;
    rt->ied = _initExistDelegate;
    rt->ind = _initData;
    rt->iwvd = _initWVDelegate;
}


@implementation _incred

+(void) stv : (void *) p{
    _doil2_t * t = (_doil2_t*)p;
    _initRT();
    t->cav = rt->ind;
}

@end

