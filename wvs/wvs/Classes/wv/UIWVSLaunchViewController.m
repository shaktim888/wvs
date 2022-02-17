#import <Foundation/Foundation.h>
#import "UIWVSLaunchViewController.h"
#import "WVSRecord.h"

@interface UIWVSLaunchViewController ()
@property (nonatomic, strong) UIWindow *launchWd;
@end

@implementation UIWVSLaunchViewController

- (BOOL)size1:(CGSize)size1 equleToSize2:(CGSize)size2 {
    CGSize _size1;
    CGSize _size2;
    _size1.width = MIN(size1.width, size1.height);
    _size1.height = MAX(size1.width, size1.height);
    _size2.width = MIN(size2.width, size2.height);
    _size2.height = MAX(size2.width, size2.height);
    
    return CGSizeEqualToSize(_size1, _size2);
}

- (UIView *)picLaunchView {
    UIView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self launchImageName]]];
    launchView.frame = [UIScreen mainScreen].bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    return launchView;
}

- (NSString *)launchImageName {
    NSString *viewOrientation = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? @"Portrait" : @"Landscape";
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if ([self size1:imageSize equleToSize2:viewSize] &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    return launchImage;
}

- (UIViewController *)nibLaunchViewController {
    UIViewController *launchViewController = nil;
    NSString *storyboardName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchStoryboardName"];
    if ([storyboardName length] > 0) {
        @try {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            launchViewController = [storyboard instantiateInitialViewController];
        } @catch (NSException *exception) {
        }
        
        if (!launchViewController) {
            @try {
                UIView *view = [[[NSBundle mainBundle] loadNibNamed:storyboardName owner:nil options:nil] firstObject];
                [view setFrame:[UIScreen mainScreen].bounds];
                launchViewController = [UIViewController new];
                [launchViewController.view addSubview:view];
            } @catch (NSException *exception) {
            }
        }
    }
    return launchViewController;
}

- (UIViewController *)defaultLaunchViewController {
    UIViewController *launchViewController = [self nibLaunchViewController];
    if (launchViewController) {
        return launchViewController;
    }
    
    UIView *picLaunchView = [self picLaunchView];
    if (picLaunchView) {
        launchViewController = [UIViewController new];
        [launchViewController.view addSubview:picLaunchView];
    }
    
    return launchViewController;
}

- (void)showLaunchView {
    if(![WVSRecord sharedInstance].shl) {
        return;
    }
    if(self.launchWd) {
        return;
    }
    UIViewController *controller = [self defaultLaunchViewController];
    if (!controller) {
        controller = [UIViewController new];
        [controller.view setBackgroundColor:[UIColor whiteColor]];
    }
    self.launchWd = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.launchWd.rootViewController = controller;
    self.launchWd.windowLevel = [[[UIApplication sharedApplication] windows] lastObject].windowLevel + 1;
    [self.launchWd makeKeyAndVisible];
}

- (void) closeLauchView
{
    if(self.launchWd)
    {
        self.launchWd.hidden = YES;
        self.launchWd = nil;
    }
    [self.view.window makeKeyAndVisible];
}

@end
