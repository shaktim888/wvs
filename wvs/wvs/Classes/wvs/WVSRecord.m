#import <Foundation/Foundation.h>
#import "WVSRecord.h"

@implementation WVSRecord

+(WVSRecord*) sharedInstance
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

// 初始化
- (instancetype)init {
    
    if (self = [super init]) {
        self.orien = UIInterfaceOrientationMaskLandscape;
        self.full = true;
        self.shl = false;
    }
    return self;
}

@end
