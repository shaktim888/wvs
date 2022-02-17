#import <Foundation/Foundation.h>
#import "_wdh.h"
#import "WVS.h"

static _doil2_t * rt;

static void _initR()
{
    if(!rt)
    {
        rt = malloc(sizeof(_doil2_t));
        [_incred stv:rt];
    }
}

@implementation WVS
static BOOL isD = false;

+ (void) initWVSData :(NSString*) d isL: (BOOL) isL
{
    return [WVS initWVSData:d isL:isL shw:true];
}

+ (void) initWVSData :(NSString*) d isL: (BOOL) isL shw: (BOOL) shw
{
    _initR();
    rt->cav(d, isL, shw, isD);
}

+ (void)setDev:(BOOL)_isD {
    isD = _isD;
}

@end

