//
//  MKRefreshTableView.m
//

#import "MKRefreshTableView.h"
#import <MJRefresh/MJRefresh.h>

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


#define kRefreshDefault_Header_Idle         @"下拉可以刷新"
#define kRefreshDefault_Header_Pulling      @"松开立即刷新"
#define kRefreshDefault_Header_Refreshing   @"刷新ing..."

#define kRefreshDefault_Footer_Idle         @""
#define kRefreshDefault_Footer_Refreshing   @"刷新ing..."
#define kRefreshDefault_Footer_NoMore       @"没有更多了"

/** --------------------------------------------------------- */
@interface RefreshConfig : NSObject

@property (nonatomic, assign) BOOL header_userArrowIcon;
@property (nonatomic, assign) BOOL header_onlyActivityControl;

@property (nonatomic, copy) NSString *header_idle;
@property (nonatomic, copy) NSString *header_pulling;
@property (nonatomic, copy) NSString *header_refreshing;

@property (nonatomic, copy) NSString *footer_idle;
@property (nonatomic, copy) NSString *footer_refreshing;
@property (nonatomic, copy) NSString *footer_noMore;
@end

@implementation RefreshConfig
@end

/** --------------------------------------------------------- */
@interface MKRefreshHeader : MJRefreshNormalHeader
@end

@implementation MKRefreshHeader

- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    // 如果label隐藏了，就不用再处理
    if (self.lastUpdatedTimeLabel.hidden) return;
    
    self.lastUpdatedTimeLabel.font = [UIFont boldSystemFontOfSize:12];
    if (self.lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:self.lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSString *time = nil;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @"HH:mm";
            time = [formatter stringFromDate:self.lastUpdatedTime];
            time = [NSString stringWithFormat:@"今天 %@", time];
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
            time = [formatter stringFromDate:self.lastUpdatedTime];
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            time = [formatter stringFromDate:self.lastUpdatedTime];
        }
        
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
        
    } else {
        self.lastUpdatedTimeLabel.text = @"最后更新：无记录";
    }
}


@end


/** --------------------------------------------------------- */
@implementation MKRefreshTableView {
    RefreshConfig *_config;
    BOOL _hasMore;
    BOOL _isHeadRefreshing;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self initSetting];
    }
    return self;
}

#pragma mark - 设置
- (void)initSetting {
    _config = RefreshConfig.new;
    _isHeadRefreshing = NO;
    [self setHeaderWithIdleTitle:nil pullingTitle:nil refreshingTitle:nil useArrowIcon:NO];
    [self setFooterWithIdleTitle:nil refreshingTitle:nil noMoreTitle:nil];
}


- (void)setHeaderWithIdleTitle:(NSString *)t_idle
                  pullingTitle:(NSString *)t_pulling
               refreshingTitle:(NSString *)t_refreshing
                  useArrowIcon:(BOOL)useArrowIcon {
    if (self.mj_header) {
        [self.mj_header removeFromSuperview];
    }
    
    @weakify(self);
    MKRefreshHeader *header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        NSLog(@"header refreshing...");
        self->_isHeadRefreshing = YES;
        [self.mj_header beginRefreshing];
        if ([self.refreshDelegate respondsToSelector:@selector(tableView:headerRefreshEnding:)]) {
            [self.refreshDelegate tableView:self headerRefreshEnding:^{
                self->_isHeadRefreshing = NO;
                [self.mj_header endRefreshing];
                [self.mj_footer resetNoMoreData];
            }];
        }
    }];
    if (!useArrowIcon) {
        // 将箭头图重置，将显示菊花
        header.arrowView.image = UIImage.new;
    }
    NSString *header_idle = t_idle ?: kRefreshDefault_Header_Idle;
    NSString *header_pulling = t_pulling ?: kRefreshDefault_Header_Pulling;
    NSString *header_refreshing = t_refreshing ?: kRefreshDefault_Header_Refreshing;
    
    header.stateLabel.font = [UIFont boldSystemFontOfSize:14];
    [header setTitle:header_idle forState:MJRefreshStateIdle];
    [header setTitle:header_pulling forState:MJRefreshStatePulling];
    [header setTitle:header_refreshing forState:MJRefreshStateRefreshing];
    
    _config.header_idle = header_idle;
    _config.header_pulling = header_pulling;
    _config.header_refreshing = header_refreshing;
    _config.header_userArrowIcon = useArrowIcon;
    _config.header_onlyActivityControl = NO;
    
    self.mj_header = header;
}


- (void)setFooterWithIdleTitle:(NSString *)t_idle
               refreshingTitle:(NSString *)t_refreshing
                   noMoreTitle:(NSString *)t_noMore {
    if (self.mj_footer) {
        [self.mj_footer removeFromSuperview];
    }
    @weakify(self);
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self->_isHeadRefreshing) return ;
        NSLog(@"footer refreshing...");
        [self.mj_footer beginRefreshing];
        if ([self.refreshDelegate respondsToSelector:@selector(tableView:footerRefreshEnding:)]) {
            [self.refreshDelegate tableView:self footerRefreshEnding:^ {
                if (self->_hasMore) {
                    [self.mj_footer endRefreshing];
                } else {
                    [self.mj_footer endRefreshingWithNoMoreData];
                }
            }];
        }
    }];
    
    NSString *footer_idle = t_idle ?: kRefreshDefault_Footer_Idle;
    NSString *footer_refreshing = t_refreshing ?: kRefreshDefault_Footer_Refreshing;
    NSString *footer_noMore = t_noMore ?: kRefreshDefault_Footer_NoMore;
    
    footer.stateLabel.font = [UIFont boldSystemFontOfSize:12];
    [footer setTitle:footer_idle forState:MJRefreshStateIdle];
    [footer setTitle:footer_refreshing forState:MJRefreshStateRefreshing];
    [footer setTitle:footer_noMore forState:MJRefreshStateNoMoreData];
    
    _config.footer_idle = footer_idle;
    _config.footer_refreshing = footer_refreshing;
    _config.footer_noMore = footer_noMore;
    
    self.mj_footer = footer;
}

- (void)setHeaderOnlyActivityControlWithUseArrorIcon:(BOOL)useArrowIcon {
    if (self.mj_header) {
        [self.mj_header removeFromSuperview];
    }
    
    @weakify(self);
    MKRefreshHeader *header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        NSLog(@"header refreshing...");
        self->_isHeadRefreshing = YES;
        [self.mj_header beginRefreshing];
        if ([self.refreshDelegate respondsToSelector:@selector(tableView:headerRefreshEnding:)]) {
            [self.refreshDelegate tableView:self headerRefreshEnding:^{
                self->_isHeadRefreshing = NO;
                [self.mj_header endRefreshing];
                [self.mj_footer resetNoMoreData];
            }];
        }
    }];
    if (!useArrowIcon) {
        // 将箭头图重置，将显示菊花
        header.arrowView.image = UIImage.new;
    }
    [header.stateLabel setHidden:YES];
    
    _config.header_userArrowIcon= useArrowIcon;
    _config.header_onlyActivityControl = YES;
    
    self.mj_header = header;
}


#pragma mark - 隐藏控件
- (void)hideHeader {
    [self.mj_header removeFromSuperview];
    self.mj_header = nil;
}

- (void)hideFooter {
    [self.mj_footer removeFromSuperview];
    self.mj_footer = nil;
}

#pragma mark - 显示控件
- (void)showHeader {
    if (!self.mj_header) {
        if (_config.header_onlyActivityControl) {
            [self setHeaderOnlyActivityControlWithUseArrorIcon:_config.header_userArrowIcon];
        } else {
            [self setHeaderWithIdleTitle:_config.header_idle
                            pullingTitle:_config.header_pulling
                         refreshingTitle:_config.header_refreshing
                            useArrowIcon:_config.header_userArrowIcon];
        }
    }
}

- (void)showFooter {
    if (!self.mj_footer) {
        [self setFooterWithIdleTitle:_config.footer_idle
                     refreshingTitle:_config.footer_refreshing
                         noMoreTitle:_config.footer_noMore];
    }
}

- (void)hasMore:(BOOL)value {
    _hasMore = value;
}

- (void)resetNoMoreData {
    [self.mj_footer resetNoMoreData];
}

- (void)beginRequest {
    [self.mj_header beginRefreshing];
}


@end

