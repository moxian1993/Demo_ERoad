//
//  MKRefreshTableView.h
//

#import <UIKit/UIKit.h>
@class MKRefreshTableView;
@protocol MKRefreshTableViewDelegate <NSObject>

@optional
/** 下拉/上拉代理, 用什么就实现什么 */
- (void)tableView:(MKRefreshTableView *)tableView headerRefreshEnding:(void(^)(void))refreshEnding;
- (void)tableView:(MKRefreshTableView *)tableView footerRefreshEnding:(void(^)(void))refreshEnding;

@end


@interface MKRefreshTableView : UITableView <UIScrollViewDelegate>
@property (nonatomic, weak) id <MKRefreshTableViewDelegate> refreshDelegate;

/** 隐藏(remove)/显示(init)控件 */
- (void)showHeader;
- (void)showFooter;
- (void)hideHeader;
- (void)hideFooter;

/** 重置footer没有更多的状态 */
- (void)resetNoMoreData;

/** 自定义header */
- (void)setHeaderWithIdleTitle:(NSString *)t_idle
                  pullingTitle:(NSString *)t_pulling
               refreshingTitle:(NSString *)t_refreshing
                  useArrowIcon:(BOOL)useArrowIcon;

/** 自定义footer */
- (void)setFooterWithIdleTitle:(NSString *)t_idle
               refreshingTitle:(NSString *)t_refreshing
                   noMoreTitle:(NSString *)t_noMore;

/** 设置仅有菊花转动的header */
- (void)setHeaderOnlyActivityControlWithUseArrorIcon:(BOOL)useArrowIcon;

/** 在下拉刷新时告诉控件是否还有数据, 写在footer代理中 */
- (void)hasMore:(BOOL)value;

/** header动画开始,并执行header代理 */
- (void)beginRequest;

@end
