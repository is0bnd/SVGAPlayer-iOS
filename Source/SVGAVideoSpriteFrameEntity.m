//
//  SVGAVideoSpriteFrameEntity.m
//  SVGAPlayer
//
//  Created by 崔明辉 on 2017/2/20.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "SVGAVideoSpriteFrameEntity.h"
#import "SVGAVectorLayer.h"
#import "SVGABezierPath.h"
#import "Svga.pbobjc.h"

@interface SVGAVideoSpriteFrameEntity ()

@property (nonatomic, strong) SVGAVideoSpriteFrameEntity *previousFrame;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGAffineTransform transform;
@property (nonatomic, assign) CGRect layout;
@property (nonatomic, assign) CGFloat nx;
@property (nonatomic, assign) CGFloat ny;
@property (nonatomic, strong) NSString *clipPath;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) NSArray *shapes;
@property (nonatomic, assign) CGRect contentsCenter;

@end

@implementation SVGAVideoSpriteFrameEntity

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject {
    self = [super init];
    if (self) {
        _alpha = 0.0;
        _layout = CGRectZero;
        _transform = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
        if ([JSONObject isKindOfClass:[NSDictionary class]]) {
            NSNumber *alpha = JSONObject[@"alpha"];
            if ([alpha isKindOfClass:[NSNumber class]]) {
                _alpha = [alpha floatValue];
            }
            NSDictionary *layout = JSONObject[@"layout"];
            if ([layout isKindOfClass:[NSDictionary class]]) {
                NSNumber *x = layout[@"x"];
                NSNumber *y = layout[@"y"];
                NSNumber *width = layout[@"width"];
                NSNumber *height = layout[@"height"];
                if ([x isKindOfClass:[NSNumber class]] && [y isKindOfClass:[NSNumber class]] && [width isKindOfClass:[NSNumber class]] && [height isKindOfClass:[NSNumber class]]) {
                    _layout = CGRectMake(x.floatValue, y.floatValue, width.floatValue, height.floatValue);
                }
            }
            NSDictionary *transform = JSONObject[@"transform"];
            if ([transform isKindOfClass:[NSDictionary class]]) {
                NSNumber *a = transform[@"a"];
                NSNumber *b = transform[@"b"];
                NSNumber *c = transform[@"c"];
                NSNumber *d = transform[@"d"];
                NSNumber *tx = transform[@"tx"];
                NSNumber *ty = transform[@"ty"];
                if ([a isKindOfClass:[NSNumber class]] && [b isKindOfClass:[NSNumber class]] && [c isKindOfClass:[NSNumber class]] && [d isKindOfClass:[NSNumber class]] && [tx isKindOfClass:[NSNumber class]] && [ty isKindOfClass:[NSNumber class]]) {
                    _transform = CGAffineTransformMake(a.floatValue, b.floatValue, c.floatValue, d.floatValue, tx.floatValue, ty.floatValue);
                }
            }
            NSString *clipPath = JSONObject[@"clipPath"];
            if ([clipPath isKindOfClass:[NSString class]]) {
                self.clipPath = clipPath;
            }
            NSArray *shapes = JSONObject[@"shapes"];
            if ([shapes isKindOfClass:[NSArray class]]) {
                _shapes = shapes;
            }
        }
        CGFloat llx = _transform.a * _layout.origin.x + _transform.c * _layout.origin.y + _transform.tx;
        CGFloat lrx = _transform.a * (_layout.origin.x + _layout.size.width) + _transform.c * _layout.origin.y + _transform.tx;
        CGFloat lbx = _transform.a * _layout.origin.x + _transform.c * (_layout.origin.y + _layout.size.height) + _transform.tx;
        CGFloat rbx = _transform.a * (_layout.origin.x + _layout.size.width) + _transform.c * (_layout.origin.y + _layout.size.height) + _transform.tx;
        CGFloat lly = _transform.b * _layout.origin.x + _transform.d * _layout.origin.y + _transform.ty;
        CGFloat lry = _transform.b * (_layout.origin.x + _layout.size.width) + _transform.d * _layout.origin.y + _transform.ty;
        CGFloat lby = _transform.b * _layout.origin.x + _transform.d * (_layout.origin.y + _layout.size.height) + _transform.ty;
        CGFloat rby = _transform.b * (_layout.origin.x + _layout.size.width) + _transform.d * (_layout.origin.y + _layout.size.height) + _transform.ty;
        _nx = MIN(MIN(lbx,  rbx), MIN(llx, lrx));
        _ny = MIN(MIN(lby,  rby), MIN(lly, lry));
    }
    return self;
}

- (instancetype)initWithProtoObject:(SVGAProtoFrameEntity *)protoObject {
    self = [super init];
    if (self) {
        _alpha = 0.0;
        _layout = CGRectZero;
        _transform = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
        if ([protoObject isKindOfClass:[SVGAProtoFrameEntity class]]) {
            _alpha = protoObject.alpha;
            if (protoObject.hasLayout) {
                _layout = CGRectMake((CGFloat)protoObject.layout.x,
                                     (CGFloat)protoObject.layout.y,
                                     (CGFloat)protoObject.layout.width,
                                     (CGFloat)protoObject.layout.height);
            }
            if (protoObject.hasTransform) {
                _transform = CGAffineTransformMake((CGFloat)protoObject.transform.a,
                                                   (CGFloat)protoObject.transform.b,
                                                   (CGFloat)protoObject.transform.c,
                                                   (CGFloat)protoObject.transform.d,
                                                   (CGFloat)protoObject.transform.tx,
                                                   (CGFloat)protoObject.transform.ty);
            }
            if ([protoObject.clipPath isKindOfClass:[NSString class]] && protoObject.clipPath.length > 0) {
                self.clipPath = protoObject.clipPath;
            }
            if ([protoObject.shapesArray isKindOfClass:[NSArray class]]) {
                _shapes = [protoObject.shapesArray copy];
            }
        }
        CGFloat llx = _transform.a * _layout.origin.x + _transform.c * _layout.origin.y + _transform.tx;
        CGFloat lrx = _transform.a * (_layout.origin.x + _layout.size.width) + _transform.c * _layout.origin.y + _transform.tx;
        CGFloat lbx = _transform.a * _layout.origin.x + _transform.c * (_layout.origin.y + _layout.size.height) + _transform.tx;
        CGFloat rbx = _transform.a * (_layout.origin.x + _layout.size.width) + _transform.c * (_layout.origin.y + _layout.size.height) + _transform.tx;
        CGFloat lly = _transform.b * _layout.origin.x + _transform.d * _layout.origin.y + _transform.ty;
        CGFloat lry = _transform.b * (_layout.origin.x + _layout.size.width) + _transform.d * _layout.origin.y + _transform.ty;
        CGFloat lby = _transform.b * _layout.origin.x + _transform.d * (_layout.origin.y + _layout.size.height) + _transform.ty;
        CGFloat rby = _transform.b * (_layout.origin.x + _layout.size.width) + _transform.d * (_layout.origin.y + _layout.size.height) + _transform.ty;
        _nx = MIN(MIN(lbx,  rbx), MIN(llx, lrx));
        _ny = MIN(MIN(lby,  rby), MIN(lly, lry));
    }
    return self;
}

- (CALayer *)maskLayer {
    if (_maskLayer == nil && self.clipPath != nil) {
        SVGABezierPath *bezierPath = [[SVGABezierPath alloc] init];
        [bezierPath setValues:self.clipPath];
        _maskLayer = [bezierPath createLayer];
    }
    return _maskLayer;
}

- (void)scaleToSize:(CGSize)newSize oldSize: (CGSize)oldSize capInsets:(SVGACapInsets)insets {
    if (self.layout.size.width < 1 || self.layout.size.height < 1) { return; }
    CGFloat contentsCenterX = 0.0;
    CGFloat contentsCenterY = 0.0;
    CGFloat minX = CGRectGetMinX(self.layout) + self.nx;
    CGFloat maxX = CGRectGetMaxX(self.layout) + self.nx;
    if (minX < insets.horizontal && maxX > insets.horizontal) {
        contentsCenterX = (insets.horizontal - minX) / self.layout.size.width;
        CGFloat width = newSize.width - oldSize.width + self.layout.size.width;
        self.layout = CGRectMake(self.layout.origin.x, self.layout.origin.y, width, self.layout.size.height);
    } else if (minX >= insets.horizontal) {
        self.nx = newSize.width - oldSize.width + self.nx;
    } else {
        
    }
    
    CGFloat minY = CGRectGetMinY(self.layout) + self.ny;
    CGFloat maxY = CGRectGetMaxY(self.layout) + self.ny;
    if (minY < insets.vertical && maxY > insets.vertical) {
        contentsCenterY = (insets.vertical - minY) / self.layout.size.height;
        CGFloat height = newSize.height - oldSize.height + self.layout.size.height;
        self.layout = CGRectMake(self.layout.origin.x, self.layout.origin.y, self.layout.size.width, height);
    } else if (minY >= insets.vertical) {
        self.ny = newSize.height - oldSize.height + self.ny;
    } else {
        
    }
    
    if (contentsCenterX != 0 || contentsCenterY != 0) {
        CGFloat x = contentsCenterX ?: 1.0;
        CGFloat y = contentsCenterY ?: 1.0;
        CGFloat width = contentsCenterX == 0 ? 0.0 : 1.0 / self.layout.size.width;
        CGFloat height = contentsCenterY == 0 ? 0.0 : 1.0 / self.layout.size.height;
        self.contentsCenter = CGRectMake(x, y, width, height);
    }
}

@end
