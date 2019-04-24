
#import "TCardFlow.h"

@interface TCardFlow ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong)  UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *visibleCells;
@property (nonatomic, strong) NSMutableArray *reusableCells;

//cells  timerPage   lastCursor  pageCount  visibleRange 三组
@property (nonatomic, strong) NSMutableArray *cells;
/** 自动轮播用于滚动的位置 */
@property (nonatomic, assign) NSInteger timerPage;
/** 上一次offset的位置 */
@property (nonatomic, assign) NSInteger lastCursor;
/** 实际渲染页数 */
@property (nonatomic, assign) NSInteger pageCount;
/** 渲染范围 */
@property (nonatomic, assign) NSRange visibleRange;

#pragma mark -

/** 数据数目 */
@property (nonatomic, assign) NSInteger count;
/** 当前下标 */
@property (nonatomic, assign) NSInteger currentIndex;
/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;
/** 尺寸 */
@property (nonatomic, assign) CGSize pageSize;
/** 拖拽*/
@property (nonatomic, assign) BOOL isDragging;

@end

@implementation TCardFlow


#pragma mark -
#pragma mark Override Methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}


#pragma mark -
#pragma mark Private Methods
- (void)initialize{
    _direction = TCardFlowDirectionRow;
    _minimumPageAlpha = .5f;
    self.leftRightMargin = 20.f;
    self.topBottomMargin = 30.f;
    _isCarousel = YES;
    _isOpenAutoScroll = YES;
    _autoTime = 3.f;
    _isEditing = NO;
    
    _count = 0;
    _pageCount = 0;
    _currentIndex = -1;
    _visibleRange = NSMakeRange(0, 0);
    

    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 65, self.frame.size.width, 8)];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.hidesForSinglePage = NO;
    }
    return _pageControl;
}

- (NSMutableArray *)visibleCells {
    if (!_visibleCells) {
        _visibleCells = [NSMutableArray arrayWithCapacity:3];
    }
    return _visibleCells;
}

- (NSMutableArray *)reusableCells {
    if (!_reusableCells) {
        _reusableCells = [NSMutableArray arrayWithCapacity:1];
    }
    return _reusableCells;
}

- (NSMutableArray *)cells {
    if (!_cells) {
        _cells = [NSMutableArray arrayWithCapacity:1];
    }
    return _cells;
}

- (TCardCell *)dequeueReusableCell {
    TCardCell *cell = [_reusableCells lastObject];
    if (cell) {
        [_reusableCells removeLastObject];
    }
    return cell;
}

- (void)removeCellAtIndex:(NSInteger)index{
    TCardCell *cell = [_cells objectAtIndex:index];
    if ((NSObject *)cell != [NSNull null]) {
        [_cells replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (void)fillCellsWithNull {
    [_cells removeAllObjects];
    for (NSInteger i = 0; i < _pageCount; i ++) {
        [self.cells addObject:[NSNull null]];
    }
}

- (void)startTimer {
    if (_count > 1 && _isCarousel && _isOpenAutoScroll) {
        if (!_timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:_autoTime target:self selector:@selector(autoPlay) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)stopTimer {
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)setLeftRightMargin:(CGFloat)leftRightMargin {
    _leftRightMargin = leftRightMargin * 0.5;
}

- (void)setTopBottomMargin:(CGFloat)topBottomMargin {
    _topBottomMargin = topBottomMargin * 0.5;
}

//轮播
- (void)autoPlay {
    if (_direction == TCardFlowDirectionRow) {
        [_scrollView setContentOffset:CGPointMake(_pageSize.width * ++self.timerPage , 0) animated:YES];
    } else {
        [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * ++self.timerPage ) animated:YES];
    }
}

//根据偏移量计算位置
- (NSInteger)currentCursor:(CGPoint)offset {
    NSInteger cursor = 1;
    if (_direction == TCardFlowDirectionRow) {
        cursor = (NSInteger)round(offset.x / _pageSize.width);
    } else {
        cursor = (NSInteger)round(offset.y / _pageSize.height);
    }
    return cursor;
}

//设置cell
- (TCardCell *)setPageAtIndex:(NSInteger)pageIndex {
    
    NSParameterAssert(pageIndex >= 0 && pageIndex < [_cells count]);

    TCardCell *cell = [_dataSource flowView:self cellForPageAtIndex:pageIndex % _count];
    
    NSAssert(cell != nil, @"datasource must not return nil");
    
    [_cells replaceObjectAtIndex:pageIndex withObject:cell];
    [cell setSubviewsWithSuperViewBounds:CGRectMake(0, 0, _pageSize.width, _pageSize.height)];
    if (_direction == TCardFlowDirectionRow) {
        cell.frame = CGRectMake(_pageSize.width * pageIndex, 0, _pageSize.width, _pageSize.height);
    } else {
        cell.frame = CGRectMake(0, _pageSize.height * pageIndex, _pageSize.width, _pageSize.height);
    }
    if (!cell.superview) {
        [_scrollView addSubview:cell];
    }
    
    if (pageIndex == _visibleRange.location + 2 && _count > 1 && _isEditing) {
        cell.deleteBtn.hidden = NO;
    } else {
        cell.deleteBtn.hidden = YES;
    }
    
    return cell;
}

//根据偏移量加载cell
- (void)refreshVisibaleCell:(CGPoint)offset {
    
    NSInteger index = 0;
    if (_direction == TCardFlowDirectionRow) {
        index = (NSInteger)round(offset.x / _pageSize.width);
    } else {
        index = (NSInteger)round(offset.y / _pageSize.height);
    }
    
    //可见页分别向前向后扩展2个，提高效率  n-2  n-1  0  1  2  共5个
    //endIndex = startIndex + 4; [startIndex, endIndex]
    NSInteger startIndex = index - 2;
    if (startIndex < 0) {
        startIndex = _count + (index - 2);
    }
    
    self.visibleRange = NSMakeRange(startIndex < 0 ? 0 : startIndex, 5);
    
    
    [self.reusableCells addObjectsFromArray:self.visibleCells];
    [self.visibleCells removeAllObjects];
    
    for (NSInteger i = 0; i < _cells.count; i ++) {
        if (i >= startIndex && i < startIndex + 5) {
            TCardCell *cell = [self setPageAtIndex:i];
            [self.visibleCells addObject:cell];
        } else {
            [self removeCellAtIndex:i];
        }
    }
}

//根据偏移量渲染透明度和x缩放效果
- (void)refreshVisibleCellAppearance:(CGPoint)offset {
    
    //无需调整透明度和缩放
    if (_minimumPageAlpha == 1.0 && _leftRightMargin == 0 && _topBottomMargin == 0) {
        return;
    }
    
    if (_direction == TCardFlowDirectionRow) {
        
        for (NSInteger i = _visibleRange.location; i < _visibleRange.location + _visibleRange.length && i < _cells.count; i ++) {
            TCardCell *cell = [_cells objectAtIndex:i];
            //没有缩小情况下的Frame
            CGRect originCellFrame = CGRectMake(_pageSize.width * i, 0, _pageSize.width, _pageSize.height);
            CGFloat delta = fabs(cell.frame.origin.x - offset.x);
            //逐渐滑动的过程
            if (delta < _pageSize.width) {
                CGFloat proportion = delta / _pageSize.width;
                CGFloat leftRightInset = _leftRightMargin * proportion;
                CGFloat topBottomInset = _topBottomMargin * proportion;
                cell.coverView.alpha = _minimumPageAlpha * proportion;
                cell.layer.transform = CATransform3DMakeScale((_pageSize.width-leftRightInset*2)/_pageSize.width,(_pageSize.height-topBottomInset*2)/_pageSize.height, 1.0);
                cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(topBottomInset, leftRightInset, topBottomInset, leftRightInset));
            } else {
                cell.coverView.alpha = _minimumPageAlpha;
                cell.layer.transform = CATransform3DMakeScale((_pageSize.width-_leftRightMargin*2)/_pageSize.width, (_pageSize.height-_topBottomMargin*2)/_pageSize.height, 1.0);
                cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(_topBottomMargin, _leftRightMargin, _topBottomMargin, _leftRightMargin));
            }
        }

    } else {
        
        for (NSInteger i = _visibleRange.location; i < _visibleRange.location + _visibleRange.length && i < _cells.count; i ++) {
            TCardCell *cell = [_cells objectAtIndex:i];
            CGRect originCellFrame = CGRectMake(0, _pageSize.height * i, _pageSize.width, _pageSize.height);
            CGFloat delta = fabs(cell.frame.origin.y - offset.y);
            if (delta < _pageSize.height) {
                CGFloat proportion = delta / _pageSize.height;
                CGFloat leftRightInset = _leftRightMargin * proportion;
                CGFloat topBottomInset = _topBottomMargin * proportion;
                cell.coverView.alpha = _minimumPageAlpha * proportion;
                cell.layer.transform = CATransform3DMakeScale((_pageSize.width-leftRightInset*2)/_pageSize.width,(_pageSize.height-topBottomInset*2) / _pageSize.height, 1.0);
                cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(topBottomInset, leftRightInset, topBottomInset, leftRightInset));
            } else {
                cell.coverView.alpha = _minimumPageAlpha;
                cell.layer.transform = CATransform3DMakeScale((_pageSize.width-_leftRightMargin*2)/_pageSize.width, (_pageSize.height-_topBottomMargin*2)/_pageSize.height, 1.0);
                cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(self.topBottomMargin, self.leftRightMargin, self.topBottomMargin, self.leftRightMargin));
            }
        }
    }
}


#pragma mark -
#pragma mark  API
- (void)reloadData {
    
    [self stopTimer];
    
    //重新设置数量
    NSInteger pages = [_dataSource numberOfPagesInFlowView:self];
    if (pages < 1) {
        return;
    }
    
    //移除所有self.scrollView的子控件
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[TCardCell class]]) {
            [view removeFromSuperview];
        }
    }

    //初始化
    if (pages == 1) {
        _isCarousel = NO;
    }
    _count = pages;
    _pageCount = _isCarousel ? pages * 3 : pages;
    _pageControl.numberOfPages = pages;
    _visibleRange = NSMakeRange(0, 0);
    _lastCursor = -1;
    [_reusableCells removeAllObjects];
    [_visibleCells removeAllObjects];
    [self fillCellsWithNull];
    
    //重新设置尺寸
    if (_delegate && [_delegate respondsToSelector:@selector(sizeForPageInFlowView:)]) {
        _pageSize = [_delegate sizeForPageInFlowView:self];
    } else {
        CGFloat itemWidth = self.bounds.size.width - 4 * _leftRightMargin;
        _pageSize = CGSizeMake(itemWidth, itemWidth * 9 / 16);
    }
    _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
    _scrollView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    //初始位置
    if (_direction == TCardFlowDirectionRow) {
        _scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount, 0);
        [_scrollView setContentOffset: _isCarousel ? CGPointMake(_pageSize.width * _count, 0) : CGPointZero animated:NO];
        self.timerPage = _count;
    } else {
        _scrollView.contentSize = CGSizeMake(0, _pageSize.height * _pageCount);
        [_scrollView setContentOffset: _isCarousel ? CGPointMake(0, _pageSize.height * _count) : CGPointZero animated:NO];
        self.timerPage = _count;
    }
    
//    [self.reusableCells addObjectsFromArray:self.visibleCells];
//    [self.visibleCells removeAllObjects];
    
    [self refreshVisibaleCell:_scrollView.contentOffset];
    [self refreshVisibleCellAppearance: _scrollView.contentOffset];
    [self startTimer];
}




- (void)scrollToCell:(NSUInteger)index {
    if (index < 0 || index >= _count) {
        return;
    }
    
    [self stopTimer];
    
    if (_isCarousel) {
        self.timerPage = index + _count;
    } else {
        self.timerPage = index;
    }
    
    if (_direction == TCardFlowDirectionRow) {
        [_scrollView setContentOffset:CGPointMake(_pageSize.width * _timerPage, 0) animated:NO];
    } else {
        [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * _timerPage) animated:NO];
    }
    
    [self startTimer];
}

#pragma mark -
#pragma mark hitTest
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (_visibleRange.location + 2 < _cells.count && _isEditing) {
        TCardCell *cell = [_cells objectAtIndex:_visibleRange.location + 2];
        CGPoint btnPoint = [self convertPoint:point toView:cell.deleteBtn];
        
        if ([cell.deleteBtn pointInside:btnPoint withEvent:event]) {
            return [cell.deleteBtn hitTest:btnPoint withEvent:event];
        }
    }
    
    return _scrollView;
}


#pragma mark -
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_count == 0) { return; }
    
    NSInteger cursor = [self currentCursor:scrollView.contentOffset];
    NSInteger index = cursor % _count;
    
    if (cursor == _lastCursor) {
        if (!_isCarousel || (_isCarousel && (cursor >= _count && cursor < 2 * _count))) {
            [self refreshVisibleCellAppearance: _scrollView.contentOffset];
            return;
        }
    }
    
    //轮播的边界处理
    if (_isCarousel) {
        if (_direction == TCardFlowDirectionRow) {
            if (cursor >= _count * 2 ) {
                if (_isDragging) {
                    NSInteger offset = (NSInteger)scrollView.contentOffset.x % (NSInteger)_pageSize.width;
                    [scrollView setContentOffset:CGPointMake(_pageSize.width * (_count - 1) + offset, 0) animated:NO];
                } else {
                    [scrollView setContentOffset:CGPointMake(_pageSize.width * _count, 0) animated:NO];
                }
                self.timerPage = _count;
            }
            else if (cursor < _count) {
                if (_isDragging) {
                    NSInteger offset = (NSInteger)scrollView.contentOffset.x % (NSInteger)_pageSize.width;
                    [scrollView setContentOffset:CGPointMake(_pageSize.width * (_count * 2 - 1) + offset, 0) animated:NO];
                } else {
                    [scrollView setContentOffset:CGPointMake(_pageSize.width * (_count * 2 - 1), 0) animated:NO];
                }
                self.timerPage = 2 * _count;
            }
        } else {
            if (cursor >= _count * 2) {
                if (_isDragging) {
                    NSInteger offset = (NSInteger)scrollView.contentOffset.y % (NSInteger)_pageSize.height;
                    [scrollView setContentOffset:CGPointMake(0, _pageSize.height * (_count - 1) + offset) animated:NO];
                } else {
                    [scrollView setContentOffset:CGPointMake(0, _pageSize.height * _count) animated:NO];
                }
                self.timerPage = _count;
            }
            else if (cursor < _count) {
                if (_isDragging) {
                    NSInteger offset = (NSInteger)scrollView.contentOffset.y % (NSInteger)_pageSize.height;
                    [scrollView setContentOffset:CGPointMake(0, _pageSize.height * (_count * 2 - 1) + offset) animated:NO];
                } else {
                    [scrollView setContentOffset:CGPointMake(0, _pageSize.height * (_count * 2 - 1)) animated:NO];
                }
                self.timerPage = 2 * _count;
            }
        }
    }
    
    //加载cell
    [self refreshVisibaleCell:_scrollView.contentOffset];
    [self refreshVisibleCellAppearance: _scrollView.contentOffset];
    
    //下标
    if (_delegate && [_delegate respondsToSelector:@selector(flowView:didScrollAtIndex:)] && index != _currentIndex) {
        [_delegate flowView:self didScrollAtIndex:index];
    }
    _pageControl.currentPage = index;
    _currentIndex = index;
    _lastCursor = cursor;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
    _isDragging = YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
    _isDragging = NO;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger cursor = [self currentCursor:scrollView.contentOffset];
    self.timerPage = cursor;
}

#pragma mark -
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self stopTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _scrollView.delegate = nil;
}

@end
