//
//  SVGACapInsets.h
//  SVGAPlayer
//
//  Created by 王帅成 on 2024/11/7.
//  Copyright © 2024 UED Center. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

struct SVGACapInsets {
    CGFloat horizontal;
    CGFloat vertical;
};
typedef struct CF_BOXABLE SVGACapInsets SVGACapInsets;

CG_INLINE SVGACapInsets
SVGACapInsetsMake(CGFloat horizontal, CGFloat vertical)
{
    SVGACapInsets insets;
    insets.horizontal = horizontal;
    insets.vertical = vertical;
    return insets;
}

NS_ASSUME_NONNULL_END
