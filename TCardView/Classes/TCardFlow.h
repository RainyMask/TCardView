
#import <UIKit/UIKit.h>
#import "TCardCell.h"


@protocol TCardFlowDataSource;
@protocol TCardFlowDelegate;


typedef NS_ENUM(NSUInteger, TCardFlowDirection) {
    TCardFlowDirectionRow = 0,
    TCardFlowDirectionColumn
};


@interface TCardFlow : UIView<UIScrollViewDelegate>

@property (nonatomic, assign)   id <TCardFlowDataSource> dataSource;
@property (nonatomic, assign)   id <TCardFlowDelegate>   delegate;

/** 默认为横向 */
@property (nonatomic, assign) TCardFlowDirection direction;
/** 非当前页的透明比例 */
@property (nonatomic, assign) CGFloat minimumPageAlpha;
/** 左右间距,默认20 */
@property (nonatomic, assign) CGFloat leftRightMargin;
/** 上下间距,默认30  */
@property (nonatomic, assign) CGFloat topBottomMargin;
/** 是否开启无限轮播,默认为开启 */
@property (nonatomic, assign) BOOL isCarousel;
/** 是否开启自动滚动,默认为开启 */
@property (nonatomic, assign) BOOL isOpenAutoScroll;
/** 自动切换视图的时间,默认是3.0 */
@property (nonatomic, assign) CGFloat autoTime;
/** 可编译状态,默认不可编辑*/
@property (nonatomic, assign) BOOL isEditing;

/** 刷新视图(数据和尺寸更新) */
- (void)reloadData;

/** 滚动到指定的位置 */
- (void)scrollToCell:(NSUInteger)index;

/** 可重用cell */
- (TCardCell *)dequeueReusableCell;

@end



@protocol TCardFlowDataSource <NSObject>

/** 设置显示数量*/
- (NSInteger)numberOfPagesInFlowView:(TCardFlow *)flowView;
/** 设置显示视图 */
- (TCardCell *)flowView:(TCardFlow *)flowView cellForPageAtIndex:(NSInteger)index;

@end


@protocol  TCardFlowDelegate<NSObject>

@optional
/** 当前显示cell的Size(中间cell) */
- (CGSize)sizeForPageInFlowView:(TCardFlow *)flowView;
/** 滚动到某个cell */
- (void)flowView:(TCardFlow *)flowView didScrollAtIndex:(NSInteger)index;

@end



