//
//  Carousel.h
//  Carousel
//
//  Created by Sergey Yuzepovich on 09.12.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarouselDatasource <NSObject>
-(UIView*)viewAtIndex:(NSUInteger)index;
-(NSUInteger)numberOfItems;
@end


@interface Carousel : UIScrollView <UIScrollViewDelegate>
@property (weak) id<CarouselDatasource> dataSource;
@end
