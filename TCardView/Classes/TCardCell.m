
#import "TCardCell.h"

@implementation TCardCell {
    NSInteger _index;
}


- (instancetype)initWithIndex:(NSInteger)index {
    if (self = [super init]) {
        
        _index = index;
        
        //view
        [self addSubview:self.shadowView];
        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
        [self addSubview:self.deleteBtn];
        
        //点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}



- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:self.bounds];
        _shadowView.userInteractionEnabled = YES;
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 7);
        _shadowView.layer.shadowRadius = 5;
        _shadowView.layer.shadowOpacity = 0.8f;
    }
    return _shadowView;
}

- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _mainImageView.userInteractionEnabled = YES;
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImageView.layer.masksToBounds = YES;
    }
    return _mainImageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0;
    }
    return _coverView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(0, 0, 35, 35);
        _deleteBtn.center = CGPointZero;
        
        UIImage *image = [self bundleForImage:@"delete"];
        [_deleteBtn setImage:image forState:UIControlStateNormal];
        [_deleteBtn setImage:image forState:UIControlStateHighlighted];
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}


- (UIImage *)bundleForImage:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TCardView" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *imgName = [NSString stringWithFormat:@"%@@%ldx.png", name, (long)[[UIScreen mainScreen] scale]];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:imgName ofType:nil]];
}


- (void)singleTapAction:(UITapGestureRecognizer *)sender {
    if (self.clickBlock) {
        self.clickBlock(_index, self);
    }
}

- (void)deleteAction {
    if (self.deleteBlock) {
        self.deleteBlock(_index);
    }
}

- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    
    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    
    self.mainImageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
    self.shadowView.frame = superViewBounds;
}


@end
