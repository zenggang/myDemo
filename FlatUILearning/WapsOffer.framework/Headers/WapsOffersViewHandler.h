#import <UIKit/UIKit.h>
#import "WapsCallsWrapper.h"
#import "WapsOffersWebView.h"
#import "AppConnect.h"

typedef enum {
    WAPS_GROUPBUY,
    WAPS_SITE,
    WAPS_ARTICLES,
    WAPS_BBS,
    WAPS_OWNER_APPS
} WanpuMod;

@class WapsOffersWebView;

@interface WapsOffersViewHandler : NSObject {
    WapsOffersWebView *offersWebView_;
}

@property(nonatomic, retain) WapsOffersWebView *offersWebView;

- (void)removeOffersWebView;

+ (WapsOffersViewHandler *)sharedWapsOffersViewHandler;

+ (UIView *)showOffers;

+ (UIView *)showOffersWithURL:(NSString *)url;

+ (void)showOffers:(UIViewController *)vController;

+ (void)showFeedBack:(UIViewController *)vController;

+ (void)showOwnerApps:(UIViewController *)vController WanpuMod:(WanpuMod)mod;

@end


@interface WapsCallsWrapper (WapsOffersViewHandler)
- (UIView *)showOffersWithFrame:(CGRect)frame URL:(NSString *)url autoJudge:(BOOL)judge;

//
- (UIView *)showOffers;

- (UIView *)showOffersWhitURL:(NSString *)url View:(UIView *)baseView;

- (UIView *)showOffersWhitURL:(NSString *)url View:(UIView *)baseView showNavBar:(BOOL)flg;

- (void)showOffers:(UIViewController *)vController;

- (void)showOffers:(UIViewController *)vController showNavBar:(BOOL)visible;

- (void)showOffersWithURL:(NSString *)url_ Controller:(UIViewController *)vController showNavBar:(BOOL)visible;

- (void)showOffers:(UIViewController *)vController showNavBar:(BOOL)visible autoJudge:(BOOL)judge;

- (UIView *)showOffersWithSize:(CGSize)size;

- (void)showFeedBack:(UIViewController *)vController;

- (void)showOwnerApps:(UIViewController *)vController  WanpuMod:(WanpuMod)mod;

@end


@interface AppConnect (WapsOffersViewHandler)

#pragma mark -
#pragma mark offer主要调用方法

+ (void)showOffers:(UIViewController *)vController;

+ (UIView *)showOffersWithSize:(CGSize)size;

+ (UIView *)showOffers;

+ (UIView *)showOffersWithURL:(NSString *)url;

+ (UIView *)showOffersWithURL:(NSString *)url View:(UIView *)baseView;

+ (void)showOffersWithURL:(NSString *)url Controller:(UIViewController *)vController showNavBar:(BOOL)visible;

+ (void)showOffers:(UIViewController *)vController showNavBar:(BOOL)visible;

+ (void)showOffers:(UIViewController *)vController showNavBar:(BOOL)visible autoJudge:(BOOL)judge;

+ (void)showFeedBack:(UIViewController *)vController;

+ (void)showAppList:(UIViewController *)vController;

+ (void)showAppSite:(UIViewController *)vController;

+ (void)showAppBBS:(UIViewController *)vController;

+ (void)showAppArticle:(UIViewController *)vController;

@end