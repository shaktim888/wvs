#ifndef WVSRecord_h
#define WVSRecord_h

#define LOCAL_PORT 26633

@interface WVSRecord : NSObject
+(WVSRecord*) sharedInstance;

@property (nonatomic, readwrite) UIInterfaceOrientationMask orien;
@property (nonatomic, readwrite, copy) NSString * ui;
@property (nonatomic, readwrite, copy) NSString * base;
@property (nonatomic) BOOL full;
@property (nonatomic) BOOL shl;

@end
#endif /* WVSRecord_h */
