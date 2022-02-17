#import <Foundation/Foundation.h>
#import "_strObf.h"


static _inc_dec_tools_t * vto;
// 下面的转码和解码是改过的。并不是原生的base64
// 全局常量定义
static const char * base64char = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const char padding_char = '=';

static char * base64_encode(const unsigned char * sourcedata)
{
    int i=0, j=0;
    unsigned char trans_index=0;    // 索引是8位，但是高两位都为0
    const int datalength = strlen((const char*)sourcedata);
    int length = datalength / 3;
    datalength % 3 > 0 ? length++ : 0 ;
    char * base64 = (char *)malloc(sizeof(char) * length * 4 + 1);
    for (; i < datalength; i += 3){
        // 每三个一组，进行编码
        // 要编码的数字的第一个
        trans_index = ((((sourcedata[i] + 1) % 128) >> 2) & 0x3f);
        base64[j++] = base64char[(int)trans_index];
        // 第二个
        trans_index = ((((sourcedata[i] + 1) % 128) << 4) & 0x30);
        if (i + 1 < datalength){
            trans_index |= ((((sourcedata[i + 1] + 1) % 128) >> 4) & 0x0f);
            base64[j++] = base64char[(int)trans_index];
        }else{
            base64[j++] = base64char[(int)trans_index];
            base64[j++] = padding_char;
            base64[j++] = padding_char;
            break;   // 超出总长度，可以直接break
        }
        // 第三个
        trans_index = ((((sourcedata[i + 1] + 1) % 128) << 2) & 0x3c);
        if (i + 2 < datalength){ // 有的话需要编码2个
            trans_index |= ((((sourcedata[i + 2] + 1) % 128) >> 6) & 0x03);
            base64[j++] = base64char[(int)trans_index];
            
            trans_index = ((sourcedata[i + 2] + 1) % 128) & 0x3f;
            base64[j++] = base64char[(int)trans_index];
        }
        else{
            base64[j++] = base64char[(int)trans_index];
            
            base64[j++] = padding_char;
            
            break;
        }
    }
    
    base64[j] = '\0';
    
    return base64;
}

static int num_strchr(const char *str, char c) //
{
    const char *pindex = strchr(str, c);
    if (NULL == pindex){
        return -1;
    }
    return pindex - str;
}

static char * base64_decode(const char * base64)
{
    const int datalength = strlen((const char*)base64);
    int length = datalength / 4;
    char * dedata = (char *)malloc(sizeof(char) * length * 3 + 1);
    int i = 0, j=0;
    int trans[4] = {0,0,0,0};
    for (;base64[i]!='\0';i+=4){
        // 每四个一组，译码成三个字符
        trans[0] = num_strchr(base64char, base64[i]);
        trans[1] = num_strchr(base64char, base64[i+1]);
        // 1/3
        dedata[j++] = ((trans[0] << 2) & 0xfc) | ((trans[1]>>4) & 0x03);
        dedata[j - 1] = (dedata[j - 1] + 127) % 128;
        if (base64[i+2] == '='){
            continue;
        }
        else{
            trans[2] = num_strchr(base64char, base64[i + 2]);
        }
        // 2/3
        dedata[j++] = ((trans[1] << 4) & 0xf0) | ((trans[2] >> 2) & 0x0f);
        dedata[j - 1] = (dedata[j - 1] + 127) % 128;
        if (base64[i + 3] == '='){
            continue;
        }
        else{
            trans[3] = num_strchr(base64char, base64[i + 3]);
        }
        
        // 3/3
        dedata[j++] = ((trans[2] << 6) & 0xc0) | (trans[3] & 0x3f);
        dedata[j - 1] = (dedata[j - 1] + 127) % 128;
    }
    
    dedata[j] = '\0';
    
    return dedata;
}

static NSString * _encodeNS(NSString* in)
{
    return [NSString stringWithCString:base64_encode([in UTF8String]) encoding:NSUTF8StringEncoding];
}

static NSString * _decodeNS(NSString * o)
{
    return [NSString stringWithCString:base64_decode([o UTF8String]) encoding:NSUTF8StringEncoding];
}

static NSString * _R(NSArray * str_a, NSArray * arr){
    NSString * str = [str_a componentsJoinedByString:@""];
    NSString * ret = @"";
    for(int i = 0; i < [arr count]; i++){
        ret = [ret stringByAppendingString:@" "];
        int intString = [[arr objectAtIndex:i] intValue] - 1;
        NSString *news = [str substringWithRange:NSMakeRange(intString, 1)];
        NSRange range = NSMakeRange(i, 1);
        ret = [ret stringByReplacingCharactersInRange:range withString:news];
    }
    return ret;
}

static void _init_str_tools()
{
    vto->decode64 = _decodeNS;
    vto->encode64 = _encodeNS;
    vto->revertStr = _R;
}
@implementation _set_str_tools

+(void) stt : (void *) p{
    vto = (_inc_dec_tools_t*)p;
    _init_str_tools();
}

@end

