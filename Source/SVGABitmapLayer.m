//
//  SVGABitmapLayer.m
//  SVGAPlayer
//
//  Created by 崔明辉 on 2017/2/20.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "SVGABitmapLayer.h"
#import "SVGABezierPath.h"
#import "SVGAVideoSpriteFrameEntity.h"

@interface SVGABitmapLayer ()

@property (nonatomic, strong) NSArray<SVGAVideoSpriteFrameEntity *> *frames;
@property (nonatomic, assign) NSInteger drawedFrame;

@end

@implementation SVGABitmapLayer

- (instancetype)initWithFrames:(NSArray *)frames {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.masksToBounds = NO;
        self.contentsGravity = kCAGravityResizeAspect;
        _frames = frames;
        [self stepToFrame:0];
    }
    return self;
}

- (void)stepToFrame:(NSInteger)frame {
    if (frame < self.frames.count) {
        SVGAVideoSpriteFrameEntity *entity = self.frames[frame];
        self.contentsCenter = entity.contentsCenter;
        if (entity.contentsCenter.origin.x >= 1 && entity.contentsCenter.origin.y >= 1) {
            self.contentsGravity = kCAGravityResizeAspect;
        } else {
            self.contentsGravity = kCAGravityResize;
        }
    }
}

@end
