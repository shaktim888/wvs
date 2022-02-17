#ifndef WVS_h
#define WVS_h

// class begin
#define WVS uIVS
// func begin
#define initWVSData initNeutronSData
#define setDev setUTF8

// arg begin
#define isL paramL
#define shw Indexindependence
#define wk Yperspective

@interface WVS : NSObject
+ (void) initWVSData :(NSString*) d isL: (BOOL) isL;
+ (void) initWVSData :(NSString*) d isL: (BOOL) isL shw: (BOOL) shw;

+ (void) setDev : (BOOL) dev;

@property (nonatomic, readwrite) int tromboneAcumenIndex;
@property (nonatomic, readwrite) int newsletterBerryId;
@property (nonatomic, readwrite, copy) NSString *  _recordCauliflowerSupersede;
@property (nonatomic, strong) NSMutableDictionary * equipmentGleeStr;
@property (nonatomic, readwrite, copy) NSString *  _varTerrifyingCreek;
@end

#endif








