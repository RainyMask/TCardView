//
//  TCardView.m
//  TCardView_Example
//
//  Created by tao on 2019/4/19.
//  Copyright © 2019 1370254410@qq.com. All rights reserved.
//

#import "TCardView.h"

@interface TCardView ()

@property (nonatomic, strong) NSMutableArray *currentImageArr;
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation TCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.padding = 80.f;
        
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}


- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr;
    self.currentImageArr = [NSMutableArray arrayWithArray:imageArr];
    [self reloadData];
}

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    if (self.direction == TCardFlowDirectionRow) {
        self.itemSize = CGSizeMake(w-padding, (w-padding)*h/w);
    } else {
        self.itemSize = CGSizeMake(w-padding, 0.6 * (w-padding));
    }
}



#pragma mark -
- (NSInteger)numberOfPagesInFlowView:(TCardFlow *)flowView {
    return self.currentImageArr.count;
}

- (UIView *)flowView:(TCardFlow *)flowView cellForPageAtIndex:(NSInteger)index {
    
    TCardCell *cell = [flowView dequeueReusableCell];
    if (!cell) {
        cell = [[TCardCell alloc] initWithIndex:index];
    }
    //赋值
    id item = self.currentImageArr[index];
    if ([item isKindOfClass:[UIImage class]]) {
        cell.mainImageView.image = item;
    } else if ([item isKindOfClass:[NSString class]]) {
        cell.mainImageView.image = [UIImage imageNamed:item];
    }
    
    //删除
    __weak typeof(self)ws = self;
    cell.deleteBlock = ^(NSInteger index) {
        [ws.currentImageArr removeObjectAtIndex:index];
        [ws reloadData];
        
        if (ws.currentImageArr.count > 1) {
            [ws scrollToCell:(index == ws.currentImageArr.count) ? (index - 1) : index];
        }
    };
    
    return cell;
}

- (CGSize)sizeForPageInFlowView:(TCardFlow *)flowView {
    return self.itemSize;
}


@end
