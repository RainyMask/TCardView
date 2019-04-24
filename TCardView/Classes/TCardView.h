//
//  TCardView.h
//  TCardView_Example
//
//  Created by tao on 2019/4/19.
//  Copyright © 2019 1370254410@qq.com. All rights reserved.
//

#import "TCardFlow.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCardView : TCardFlow<TCardFlowDelegate, TCardFlowDataSource>

/** 图片 本地图片名称或者UIImage对象 */
@property(nonatomic, copy) NSArray *imageArr;

/**左右缩进 默认80*/
@property (nonatomic, assign) CGFloat padding;


@end

NS_ASSUME_NONNULL_END
