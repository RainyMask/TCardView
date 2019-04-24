
#import <UIKit/UIKit.h>

@interface TCardCell : UIView

/** 阴影 */
@property(nonatomic, strong) UIView   *shadowView;
/** 图片 */
@property (nonatomic, strong) UIImageView *mainImageView;
/** 改变透明度 */
@property (nonatomic, strong) UIView *coverView;
/** 删除按钮  */
@property(nonatomic, strong) UIButton   *deleteBtn;


/**点击回调*/
@property (nonatomic, copy) void (^clickBlock)(NSInteger index, TCardCell *cell);

/**删除按钮回调*/
@property (nonatomic, copy) void (^deleteBlock)(NSInteger index);



/**初始化方法*/
- (instancetype)initWithIndex:(NSInteger)index;


- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds;

@end
