#import <UIKit/UIKit.h>

typedef enum{
	WAPSOPullRefreshPulling = 0,
    WAPSOPullRefreshNormal,
    WAPSOPullRefreshLoading,
} WAPSPullRefreshState;

@protocol WAPSRefreshTableHeaderDelegate;
@interface WapsRefreshTableHeaderView : UIView {
	
	id _delegate;
	WAPSPullRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
	

}

@property(nonatomic,assign) id <WAPSRefreshTableHeaderDelegate> delegate;

- (void)refreshLastUpdatedDate;

- (void)setState:(WAPSPullRefreshState)aState;

- (void)refreshViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshViewDidEndDraggingWithButton:(UIScrollView *)scrollView;         //给刷新按钮调用
- (void)refreshViewDataDidFinishedLoading:(UIScrollView *)scrollView;
- (void)showLoading:(UIScrollView *)scrollView;

@end
@protocol WAPSRefreshTableHeaderDelegate
- (void)loadWithDidTrigger:(WapsRefreshTableHeaderView *)view;
- (BOOL)isDataLoading:(WapsRefreshTableHeaderView *)view;
@optional
- (NSDate*)dataSourceLastUpdated:(WapsRefreshTableHeaderView *)view;
@end
