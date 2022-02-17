#ifndef _strObf_h
#define _strObf_h

typedef struct _inc_dec_tools
{
    NSString* (*encode64)(NSString*);
    NSString* (*decode64)(NSString*);
    NSString* (*revertStr)(NSArray*, NSArray*);
} _inc_dec_tools_t;

@interface _set_str_tools : NSObject
+(void) stt : (void *) ptr;
@end

#endif /* _strObf_h */
