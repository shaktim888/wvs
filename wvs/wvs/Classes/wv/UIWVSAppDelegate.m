#import "UIWVSAppDelegate.h"
#import "WVSRecord.h"
#import "UIWVSBottomController.h"

@interface UIWVSAppDelegate ()
{
    NSMutableArray * dataArr;
}

@end

@implementation UIWVSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [[UIWVSBottomController alloc] init];
    application.statusBarHidden = YES;
    if(self.window.rootViewController.prefersStatusBarHidden == NO)
    {
        [self.window.rootViewController setNeedsStatusBarAppearanceUpdate];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#define EACH_CNT 3
#define MAX_UP_CNT 13

static int co_count = -3;
static int se_count = 0;

- (void)sendEvent:(UIEvent *)event{
    [super sendEvent:event];
    if(event.type != UIEventTypeTouches) return;
    if(!dataArr) {
        dataArr = [[NSMutableArray alloc] init];
    }
    NSSet *allTouches = [event allTouches];
   if ([allTouches count] > 0)
   {
       UITouch * anyT = (UITouch *)[allTouches anyObject];
       UIWindow * window = anyT.window;
       UITouchPhase phase = anyT.phase;
       if (phase == UITouchPhaseBegan){
           NSMutableArray * clicks = [[NSMutableArray alloc] init];
           UIView * v = window ? window.rootViewController.view : NULL;
           BOOL isInput = false;
           for (UITouch * touch in allTouches) {
               if(touch.view) {
                   v = touch.view;
                   NSString * cname = NSStringFromClass(v.class);
                   isInput = [cname isEqualToString:@"UIKeyboardLayoutStar"];
                   break;
               }
           }
           NSString * e = isInput ? @"input" : @"click";
           for (UITouch * touch in allTouches) {
               UIView * clickV = touch.view;
               if(!clickV) clickV = v;
               CGPoint p = [touch locationInView:v.window.rootViewController.view];
               [clicks addObject:@{
                   @"x" : @(p.x),
                   @"y" : @(p.y),
                   @"view" : NSStringFromClass(clickV.class)
               }];
           }
           
           [dataArr addObject:@{
               @"_e_" : e,
               @"_t_" : @((long)[[NSDate date] timeIntervalSince1970]),
               @"pos" : clicks
           }];
           co_count++;
           if(co_count > 0) {
               co_count = co_count % EACH_CNT;
           }
           if(co_count <= 0) {
               [[NSNotificationCenter defaultCenter] postNotificationName:@"WatchEvent" object:nil userInfo:@{
                   @"name" : @"c",
                   @"data" : @{
                       @"_arr_" : dataArr
                   }
               }];
               [dataArr removeAllObjects];
               se_count++;
           }
       }
   }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if(application.applicationIconBadgeNumber > 0)
    {
        application.applicationIconBadgeNumber = 0;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSInteger num = application.applicationIconBadgeNumber;
    if(num != 0) {
        application.applicationIconBadgeNumber = 0;
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return [WVSRecord sharedInstance].orien;
}

@end
