#import <Foundation/Foundation.h>
#import "WapsCoreFetcherHandler.h"


@interface WapsService :WapsCoreFetcherHandler <WapsWebFetcherDelegate> {
    NSTimer *_timer;
}

@property (nonatomic, retain) NSTimer *timer;

- (id)initRequestWithDelegate:(id <WapsFetchResponseDelegate>)aDelegate andRequestTag:(int)aTag;

+ (WapsService *)sharedWapsService;

+ (void)saveAppInfo:(NSURLRequest *)request;

+ (void)saveAppScheme:(NSString *)appScheme Name:(NSString *)name ID:(NSString *)id;

- (void)schemeScan;

@end
