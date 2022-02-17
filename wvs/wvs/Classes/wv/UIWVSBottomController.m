#import <Foundation/Foundation.h>
#import "UIWVSBottomController.h"
#import "WVSRecord.h"
#import "UIWKWVSWebController.h"

static UIImage * cutPic;

static CGRect getRect(bool isCenter, bool isZero)
{
    int kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    int kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    if(isZero)
    {
        return CGRectMake(0, 0, random() % kScreenWidth, random() % kScreenHeight);
    }
    else if(isCenter)
    {
        return CGRectMake(random() % kScreenWidth, random() % kScreenHeight, random() % kScreenWidth, random() % kScreenHeight);
    }else{
        int k = random() % 2 == 0 ? 0 : 1;
        return CGRectMake(kScreenWidth * k, random() * (1 - k), random() % kScreenWidth, random() % kScreenHeight);
    }
}


@interface UIWVSBottomController ()

@property(nonatomic,strong)UIViewController *origin;
@property (nonatomic, strong) NSMutableArray<UIImageView *> * list;

@end

@implementation UIWVSBottomController
// 初始化
- (instancetype)init {
    if (self = [super init]) {
        self.list = [[NSMutableArray alloc]init];
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

-(UIView*) genView: (bool) isc
{
    int n = random() % 100;
    UIView * t;
    if(n <= 1)
    {
        t = [[UILabel alloc] initWithFrame:getRect(isc, false)];
    }
    else if( n <= 7)
    {
        UISlider* a = [[UISlider alloc] initWithFrame:getRect(isc, false)];
        t = a;
    }
    else if( n <= 10)
    {
        UIButton * a = [[UIButton alloc] initWithFrame:getRect(isc, false)];
        a.enabled = false;
        t = a;
    }
    else if(n <= 15)
    {
        UIToolbar * a = [[UIToolbar alloc] initWithFrame:getRect(isc, false)];
        t = a;
    }
    else if(n <= 20)
    {
        UIScrollView * a = [[UIScrollView alloc] initWithFrame:getRect(isc, false)];
        a.scrollEnabled = false;
        a.pagingEnabled = false;
        t = a;
    }
    else if(n <= 30)
    {
        UITableView * a = [[UITableView alloc] initWithFrame:getRect(isc, false)];
        t = a;
    }
    else if( n <= 40)
    {
        UIImageView * a = [[UIImageView alloc] initWithFrame:getRect(isc, false)];
        if( random() % 100 <= 40)
        {
            [self.list addObject:a];
        }
        t = a;
    }
    else{
        t = [[UIView alloc]initWithFrame:getRect(isc, false)];
        t.hidden = YES;
    }
    t.multipleTouchEnabled = false;
    t.userInteractionEnabled = false;
    return t;
}

- (UIViewController *)origin {
    if (_origin == nil) {
        _origin = [[UIWKWVSWebController alloc] init];
    }
    return _origin;
}

- (void) rgv : (UIView*) p d : (int) d isc : (bool) isc
{
    if(d == 0) {
        return;
    }
    int n = random() % 2 + 2;
    for(int i = 0; i < n; i ++)
    {
        UIView * v = [self genView:isc];
        [p addSubview:v];
        [self rgv:v d:d-1 isc:isc];
    }
}

-(void)ct
{
//    [self.origin.view setHidden:false];
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, scale);
    [self.origin.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    cutPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (cutPic != nil) {
        [self refv];
    }
//    [self.origin.view setHidden:true];
}

- (void) refv
{
    for(UIImageView *s in self.list){
        s.image = cutPic;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rgv:self.view d: random() % 2 + 2 isc:true];
    [self addChildViewController:self.origin];
    self.origin.view.frame =self.view.frame;
    UIView * lastView = self.view;
    for(int i = random() % 2 + 2; i > 0; i--){
        UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [lastView addSubview:v];
        lastView = v;
        [self rgv:lastView d:2 isc:true];
    }
    [lastView addSubview:self.origin.view];
    [self.origin didMoveToParentViewController:self];
    [self rgv:self.view d: random() % 2 + 2 isc:false];
    [self ct];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(ct) userInfo:nil repeats:YES];
}

@end
