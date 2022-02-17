//
//  main.m
//  wvs
//
//  Created by admin on 03/21/2019.
//  Copyright (c) 2019 admin. All rights reserved.
//

@import UIKit;
#import "WvsAppDelegate.h"
#import "WVS.h"

int main(int argc, char * argv[])
{
//    if([RCLCCheck check:@"cpk08A4f31W9F0iCivFpeLly-gzGzoHsz" idInfo:@"8k3sX8F6awnG9QS3zcm5X6st" dtStr:@"2091-01-01 05:20:59" seed:0])
//    {
//            @autoreleasepool {
//                return UIApplicationMain(argc, argv, nil, @"WvsAppDelegate");
//            }
//    }
//    else{
    [WVS setDev:YES];
    [WVS initWVSData:@"xyz" isL:false shw:false];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, @"WvsAppDelegate");
    }
//    }
    
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, @"WvsAppDelegate");
//    }
    
}
